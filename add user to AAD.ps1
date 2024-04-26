param(
    #[Parameter(Mandatory = $true, HelpMessage = "Enter TenantId")][String]$TenantId,
    [Parameter(Mandatory = $true, HelpMessage = "Enter Group's ObjectId")][String]$GroupId,
    [Parameter(Mandatory = $true, HelpMessage = "Enter User List Path")][String]$FilePath,
    [Parameter(Mandatory = $true, HelpMessage = "Enter Mode")]
    [ValidateSet("Add", "Remove")]
    [String]$Mode,
    [Parameter(Mandatory = $true, HelpMessage = "Enter one of the following options: ObjectID,Email,MailNickname")]
    [ValidateSet("ObjectID", "Mail", "MailNickname")]
    [String]$Option
)

function ProcessUser($userId) {
    if ($Mode -eq 'Remove') {
        Remove-AzureADGroupMember -ObjectId $GroupId -MemberId $userId
    }
    elseif ($Mode -eq 'Add') {
        Add-AzureADGroupMember -ObjectId $GroupId -RefObjectId $userId
    }
    Write-Host "The user $userId has been $Mode-ed"
}

$TenantId = 'type tenantID'
#connect to AzureAD
Connect-AzureAD -TenantId $TenantId

#get user list 
$userList = Get-Content -Path $FilePath


#batch add to group 
if ($Option -eq 'ObjectID') {
    foreach ($user in $userList) {
    ProcessUser $user
    }
}
else {
    foreach ($user in $userList) {
        $userObjectId =(Get-AzureADUser -Filter "$Option eq '$user'").ObjectId
        ProcessUser $userObjectId
    }
}
Write-Host "------Done------"
