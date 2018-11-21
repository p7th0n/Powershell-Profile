<#
.SYNOPSIS
   Send clipboard to Drafts app. 
.DESCRIPTION
    Long description
.EXAMPLE
    Copy text to clipboard & run Send-ClipboardToDrafts 
.INPUTS
    Clipboard text. 
.OUTPUTS
    Creates a randomly named text file in the designated DropBox folder -- ~\Dropbox\drafts by default.
.NOTES
    General notes
.COMPONENT
     Send-ToDrafts
#>
function Send-ClipboardToDrafts {
    [CmdletBinding(DefaultParameterSetName = 'Parameter Set 1',
        SupportsShouldProcess = $true,
        PositionalBinding = $false,
        HelpUri = 'http://www.microsoft.com/',
        ConfirmImpact = 'Medium')]
    [Alias()]
    [OutputType([String])]
    Param (
    )
    
    begin {
    }
    
    process {
        if ($pscmdlet.ShouldProcess("Target", "Operation")) {
            $randomFilename = [System.IO.Path]::GetRandomFileName()
            $draftFile = $draftsFolder + $randomFilename

            Write-Host "# clipboard:`n" 
            Get-Clipboard | Out-String
            $content = Get-Clipboard | Out-String
            $content -replace "`r`n", "`n" | set-content -path $draftFile -Encoding UTF8 -NoNewline
        }
    }
    
    end {
    }
}
