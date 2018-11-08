

function Send-DosToDrafts() {
    $randomFilename = [System.IO.Path]::GetRandomFileName()
    $draftFile = "~\Dropbox\drafts\" + $randomFilename
    $cmd = $Args -join " "
    $d2u = "dos2unix " + $draftFile

    Write-Host '# command: ' $cmd "`n"
    Write-Host '# command: ' $cmd "`n" *> $draftFile
    Invoke-Expression $cmd
    Invoke-Expression $cmd *>> $draftFile
    do {
       try {
        Invoke-Expression $d2u
       }
       catch {
        # error
       } 
    } until ($error.Count -eq 0)
}