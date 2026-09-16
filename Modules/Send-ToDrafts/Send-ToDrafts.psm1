<#
.SYNOPSIS
    Wrap output from PowerShell or clipboard text on Windows and send to Drafts app.
.DESCRIPTION
    Long description
.EXAMPLE
    Send-DosToDrafts tasklist
.EXAMPLE
    Send-DosToDrafts Get-ChildItem | Sort-Object -Property LastWriteTime
.EXAMPLE
    Send-ClipboardToDrafts  # Send clipboard text.
.INPUTS
    PowerShell commands or clipboard text.
.OUTPUTS
   Creates a randomly named text file in the designated DropBox folder -- ~\Dropbox\drafts by default. 
.NOTES
    General notes
.COMPONENT
    Send-ToDrafts 
#>


$functionFolders = @('Public', 'Internal', 'Classes')
ForEach ($folder in $functionFolders)
{
    $folderPath = Join-Path -Path $PSScriptRoot -ChildPath $folder
    If (Test-Path -Path $folderPath)
    {
        Write-Verbose -Message "Importing from $folder"
        $functions = Get-ChildItem -Path $folderPath -Filter '*.ps1' 
        ForEach ($function in $functions)
        {
            Write-Verbose -Message "  Importing $($function.BaseName)"
            . $($function.FullName)
        }
    }    
}
$publicFunctions = (Get-ChildItem -Path "$PSScriptRoot\Public" -Filter '*.ps1').BaseName
Export-ModuleMember -Function $publicFunctions

# define variables

$draftsFolder = "~\Dropbox\drafts\"

Export-ModuleMember -Variable draftsFolder