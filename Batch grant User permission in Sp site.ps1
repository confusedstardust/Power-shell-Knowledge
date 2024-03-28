#批量增加用户的script，忘记当初为啥写了俩

#Script 1
$excel=new-object -com excel.application
$wb=$excel.workbooks.open("C:\mypath.xlsx")
$sheet=$wb.Worksheets.Item(1)
$rowval=1
Connect-PnPOnline -Url "my SP Site"
do{
Add-PnPGroupMember -LoginName $sheet.Cells.Item($rowval,1).value() -Group $sheet.Cells.Item($rowval,2).value()
$rowval++
}while($sheet.Cells.Item($rowval,1).value() -ne $null)





#Script 2
Connect-PnPOnline -Url "My SP site"
 foreach($Row in Import-Csv '.\current.csv'){
 try{
 #log $Row.Column1
 Add-PnPGroupMember -LoginName $Row.Column1 -Group $Row.Column2.ToString()

 echo $Row.Column1
 	}catch{
 Write-Host "An error occurred:"   Write-Host $_
 	}
 }
 #try { NonsenseString } catch {   Write-Host "An error occurred:"   Write-Host $_ }
 
