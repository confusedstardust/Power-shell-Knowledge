#记录一些之前用过的PnP方法


#connect to SP site
$password = (ConvertTo-SecureString -AsPlainText '{type my password}' -Force)
Connect-PnPOnline -Url "type my SP site"-ClientId  -CertificatePath 'C:mypath\MyCompanyName.pfx' -CertificatePassword $password  -Tenant 'my tenant'

#-------------------------------把某用户加入某个组或加成collectionadmin
Add-PnPUserToGroup -LoginName "xxxemail.com" -Identity "xxxMembers"
Add-PnPSiteCollectionAdmin -Owners "xxxemail.com"

#把某个list改hidden状态
Set-PnPList -Identity "xxxlist" -Hidden $false

 #-----------------------------链接到aad查用户
 Connect-AzureAD
 Get-AzureADUser -ObjectId "xxxemail.com"


 #------------------------------批量查询json中的user在不在aad脚本，用于update
$modifiedJson
$jsonContent = Get-Content -Path .\peopleDatachange.json
$jsonObject = $jsonContent | ConvertFrom-Json
foreach ($item in $jsonObject) {
try{
    $user=$item.Login
    $info=Get-AzureADUser -Filter "mailNickname eq '$user'"
    $item.Login=$user
    $item.DisplayName=$info.DisplayName
    $item.UserPrincipalName=$info.UserPrincipalName
    
    }catch{
    Write-Host $_
    } 
}
$jsonObject|ConvertTo-Json  -Depth 1|Out-File -FilePath ./jsonqq.json


#----------------给SharePoint Site 加一个Appcatalog的list 用于在某个SP站点部署webpart
Add-PnPSiteCollectionAppCatalog 

#----------------copy文件到某站点
Copy-PnPFile -SourceUrl "sites/mysiteName/Site Pages/Home1.aspx" -TargetUrl "sites/another site/Site Pages" 


#----------------得出每个SharePoint的group都有多少人
$users = Get-PnPUser
$userCount = $users.Count
Write-Host "User Count: $userCount"

 #-------------删除文件
$urlaa="/sites/my site/xxxx.xlsx"
$File = Get-PnPFile -Url $urlaa
Write-Host $File.Author.Email
Set-PnPFileCheckedOut -Url $urlaa 
Remove-PnPFile -ServerRelativeUrl $urlaa -Force

#-------------导出list或者library
Get-PnPSiteTemplate -Out teammember.xml -ListsToExtract "my list name" -Handlers Lists
#-------------导入
Invoke-PnPSiteTemplate -Path teammember.xml
