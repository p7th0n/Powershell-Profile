

function Send-ClipboardToDrafts() {
    $randomFilename = [System.IO.Path]::GetRandomFileName()
    $draftFile = "~\Dropbox\drafts\" + $randomFilename
    $d2u = "dos2unix " + $draftFile
    # $cmd = $Args -join " "

    Write-Host '# clipboard:`n ' Get-Clipboard "`n"
    Get-Clipboard *> $draftFile
    Invoke-Expression $d2u
}