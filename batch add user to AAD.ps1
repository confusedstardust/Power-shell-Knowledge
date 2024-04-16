param(
    [Parameter(Mandatory = $true, HelpMessage = "Enter TenantId")][String]$TenantId,
    [Parameter(Mandatory = $true, HelpMessage = "Enter Group's ObjectId")][String]$GroupId,
    [Parameter(Mandatory = $true, HelpMessage = "Enter User List Path")][String]$FilePath,
    [Parameter(Mandatory = $true, HelpMessage = "Enter one of the following options: ObjectID, Email, useMailNickname")]
    [ValidateSet("ObjectID", "Email", "MailNickname")]
    [String]$Option
)
#connect to AzureAD
Connect-AzureAD -TenantId $TenantId

#get user list 
$userList = Get-Content -Path $FilePath

Write-Host $Option
#batch add to group 
if ($Option -eq 'ObjectID') {
    foreach ($user in $userList) {
        Add-AzureADGroupMember -ObjectId $GroupId -RefObjectId $user
        Write-Host "the user $user has been added"
    }
}
else {
    foreach ($user in $userList) {
        $userObjectId = (Get-AzureADUser -Filter "$Option eq '$user'").ObjectId
        Add-AzureADGroupMember -ObjectId $GroupId -RefObjectId $userObjectId
        Write-Host "the user $user has been added"
    }
}
