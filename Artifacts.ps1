#列出某个feed下所有artifacts，然后migration到另一个feed去，分成了三个script，但其实一个script就能搞定
#------------------step 1:获取到所有的artifacts，然后write到一个文件去
$artifacts = 'my feed'
$filePath = ".\nuget_packages.txt"

if (Test-Path $filePath) {
    Remove-Item $filePath -Force
}

Write-Host "List package start..."

nuget list -Source $artifacts -allversions > $filePath

Write-Host "List package end."


#-------------------step 2:从一个txt文件获取到artifacts名字，然后把每个版本都下载下来
$packagelist= Get-Content .\nuget_packages.txt
$artifacts = 'my feed's url'

foreach ($singleline in $packagelist) {
    $package=$singleline.Split(' ')

    $packagename= $package[0]
    $packageversion= $package[1]

    Write-Host $packagename $packageversion

    nuget install $packagename -Version $packageversion -OutputDirectory .\Package -Source $artifacts
}


#------------Step 3：把artifacts publish 到另一个feed
$artifacts = '目标 feed'
$packagelist= Get-ChildItem .\Package | ForEach-Object -Process{
    if($_ -is [System.IO.DirectoryInfo])
    {
        Write-Host($_.name);
        $filepath= '.\PackageLDS\'+$_.name+'\'+$_.name+'.nupkg'
        Write-Host($filepath)
        nuget push $filepath -Source "目标feed" -ApiKey [自己生成]
}
