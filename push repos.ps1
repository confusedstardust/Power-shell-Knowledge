
$folders = Get-ChildItem -Directory
Write-Host $folders
foreach($folder in $folders){
    cd $folder
    git remote set-url origin           myGitRepoUrl
	$branchlist= git branch -a
	$branchlists=$branchlist[2..($branchlist.Count-1)]
      foreach($branch in $branchlists){
                  #local branch
                  $localbranch= $branch.Trim().Trimstart("remotes").Trimstart('/').Trimstart("origin").Trimstart('/')
                  write-host "local:"$localbranch
                  #remote branch
                  $remotebranch= $branch.Trim().Trimstart("remotes").Trimstart('/')
                  write-host "remote:"$remotebranch
                  #Pull remote branch records to local branches
                  git checkout -b $localbranch $remotebranch
            }
   git push --all origin
   cd ..
}
      


ping 127.1 -n 6 >nul	
