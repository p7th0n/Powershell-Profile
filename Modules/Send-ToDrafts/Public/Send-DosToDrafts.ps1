<#
.SYNOPSIS
    Wrap output from CMD or PowerShell on Windows and send to Drafts app.
.DESCRIPTION
    Long description
.EXAMPLE
    Send-DosToDrafts tasklist
.EXAMPLE
    Send-DosToDrafts Get-ChildItem | Sort-Object -Property LastWriteTime
.INPUTS
    CMD or PowerShell commands.
.OUTPUTS
   Creates a randomly named text file in the designated DropBox folder -- ~\Dropbox\drafts by default. 
.NOTES
    General notes
.COMPONENT
    Send-ToDrafts 
#>
function Send-DosToDrafts {
    [CmdletBinding(DefaultParameterSetName = 'Parameter Set 1',
        SupportsShouldProcess = $true,
        PositionalBinding = $false,
        HelpUri = 'http://www.microsoft.com/',
        ConfirmImpact = 'Medium')]
    [Alias()]
    [OutputType([String])]
    Param (
        # Valid CMD or PowerShell commands
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $false,
            ValueFromRemainingArguments = $true, 
            ParameterSetName = 'Parameter Set 1')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $wrappedCommand
    )
    
    begin {
        $isPipelined = ($MyInvocation.PipelinePosition -gt 1)
        if ($isPipelined) {
            # handle piped command
            $cmd = $MyInvocation.Line.Substring(0, $MyInvocation.Line.LastIndexOf("|"))
            $result = Invoke-Expression $cmd
        }
        else {
            # handle command line arguments
            $cmd = $MyInvocation.Line.Substring($MyInvocation.Line.IndexOf(" ")).Trim()
            $result = Invoke-Expression $cmd
        }
    }
    
    process {
        if ($isPipelined) {
            # handle piped command
        } else {
            # handle command line arguments
        }
    }
    
    end {
        $randomFilename = [System.IO.Path]::GetRandomFileName()
        $draftFile = $draftsFolder + $randomFilename
        $result *> $draftFile

        $content = Get-Content -raw -path $draftFile
        if ((($content.trim()).Length -eq 0) -or ($content[0..14] -eq "System.Object[]")) {
            $content = $result | Out-String
        }
        do {
            $error.Clear()
            try {
                # Write-Host "  #### writing content"
                $content -replace "`r`n", "`n" | set-content -path $draftFile -Encoding UTF8 -NoNewline
            }
            catch {
                # Write-Host "    **** Error: " $_.Exception.Message
            } 
            finally {
                # Write-Host "    **** error: " $error.Count
            }
            Start-Sleep -s 1
        } until ($error.Count -eq 0)
    }
}
