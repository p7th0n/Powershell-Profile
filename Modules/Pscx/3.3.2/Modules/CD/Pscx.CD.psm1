#---------------------------------------------------------------------------
# Author: Keith Hill
# Desc:   Module that replaces the regular CD function with one that handles
#         history and backward/forward navigation using - and +.
#         as ..[.]*.
# Date:   Nov 18, 2006
# Site:   http://pscx.codeplex.com
#---------------------------------------------------------------------------
#requires -Version 3
Set-StrictMode -Version Latest

$backwardStack = new-object System.Collections.ArrayList
$forewardStack = new-object System.Collections.ArrayList

# When the module removed, set the cd alias back to something reasonable.
# We could use the original cd alias but most of the time it's going to be set to Set-Location.
# And you may have loaded another module in between stashing the "original" cd alias that
# modifies the cd alias.  So setting it back to the "original" may not be the right thing to
# do anyway.
$ExecutionContext.SessionState.Module.OnRemove = {
    Set-Alias cd Set-Location -Scope Global -Option AllScope -Force
}.GetNewClosure()

# We are going to replace the PowerShell default "cd" alias with the CD function defined below.
Set-Alias cd Pscx\Set-LocationEx -Force -Scope Global -Option AllScope -Description "PSCX alias"

<#
.SYNOPSIS
    CD function that tracks location history allowing easy navigation to previous locations.
.DESCRIPTION
    CD function that tracks location history allowing easy navigation to previous locations.
    CD maintains a backward and forward stack mechanism that can be navigated using "cd -"
    to go backwards in the stack and "cd +" to go forwards in the stack.  Executing "cd"
    without any parameters will display the current stack history. By default, the new location
    is echo'd to the host.  If you want to suppress this set the preference variable in your
    profile e.g. $Pscx:Preferences['CD_EchoNewLocation'] = $false
.PARAMETER Path
    The path to change location to.
.PARAMETER LiteralPath
    The literal path to change location to.  This path can contain wildcard characters that
    do not need to be escaped.
.PARAMETER PassThru
    If the PassThru switch is specified the object passed into the CD function is also output
    from the function.  This allows the next pipeline stage to also operate on the object.
.PARAMETER UnboundArguments
    This parameter accumulates all the additional arguments and concatenates them to the Path
    or LiteralPath parameter using a space separator.  This allows you to cd to some paths containing
    spaces without having to quote the path e.g. 'cd c:\program files'.  Note that this doesn't always
    work.  For example, this following won't work: 'cd c:\program files (x86)'.  This fails because
    PowerShell tries to evaluate the contents of the expression '(x86)' which isn't a valid command name.
.PARAMETER UseTransaction
    Includes the command in the active transaction. This parameter is valid only when a transaction
    is in progress. For more information, see about_Transactions.  This parameter is not supported
    in PowerShell Core.
.EXAMPLE
    C:\PS> cd $pshome; cd -; cd +
    This example changes location to the PowerShell install dir, then back to the original
    location, than forward again to the PowerShell install dir.
.EXAMPLE
    C:\PS> cd ....
    This example changes location up two levels from the current path.  You can use an arbitrary
    number of periods to indicate how many levels you want to go up.  A single period "." indicates
    the current location.  Two periods ".." indicate the current location's parent.  Three periods "..."
    indicates the current location's parent's parent and so on.
.EXAMPLE
    C:\PS> cd
    Executing CD without any parameters will cause it to display the current stack contents.
.EXAMPLE
    C:\PS> cd -0
    Changes location to the very first (0th index) location in the stack. Execute CD without any parameters
    to see all the paths, then execute CD -<number> to change location to that path.
.EXAMPLE
    C:\PS> $profile | cd
    This example will change location to the parent location of $profile.
.NOTES
    This is a PSCX function.
#>
function Set-LocationEx
{
    [CmdletBinding(DefaultParameterSetName='Path')]
    param(
        [Parameter(Position=0, ParameterSetName='Path', ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $Path,

        [Parameter(Position=0, ParameterSetName='LiteralPath', ValueFromPipelineByPropertyName=$true)]
        [Alias("PSPath")]
        [string]
        $LiteralPath,

        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]
        $UnboundArguments,

        [Parameter()]
        [switch]
        $PassThru,

        [Parameter()]
        [switch]
        $UseTransaction
    )

    Begin
    {
        Set-StrictMode -Version Latest

        # String resources
        Import-LocalizedData -BindingVariable msgTbl -FileName Messages

        $ExtraArgs = @{}
        if (($PSVersionTable.PSVersion.Major -lt 6) -or ($PSVersionTable.PSEdition -eq 'Desktop'))
        {
            $ExtraArgs['UseTransaction'] = $UseTransaction
        }

        function SetLocationImpl($path, [switch]$IsLiteralPath)
        {
            if ($pscmdlet.ParameterSetName -eq 'LiteralPath' -or $IsLiteralPath)
            {
                Write-Debug "Setting location to literal path: '$path'"
                Set-Location -LiteralPath $path @ExtraArgs
            }
            else
            {
                Write-Debug "Setting location to path: '$path'"
                Set-Location $path @ExtraArgs
            }

            if ($PassThru)
            {
                Write-Output $ExecutionContext.SessionState.Path.CurrentLocation
            }
            else
            {
                # If not passing thru, then check for user options of other info to display.
                if ($Pscx:Preferences['CD_GetChildItem'])
                {
                    Get-ChildItem
                }
                elseif ($Pscx:Preferences['CD_EchoNewLocation'])
                {
                    Write-Host $ExecutionContext.SessionState.Path.CurrentLocation
                }
            }
        }
    }

    Process
    {
        if ($pscmdlet.ParameterSetName -eq 'Path')
        {
            Write-Debug "Path parameter received: '$Path'"
            $aPath = $Path
        }
        else
        {
            Write-Debug "LiteralPath parameter received: '$LiteralPath'"
            $aPath = $LiteralPath
        }

        if ($UnboundArguments -and $UnboundArguments.Count -gt 0)
        {
            $OFS=','
            Write-Debug "Appending unbound arguments to path: '$UnboundArguments'"
            $aPath = $aPath + " " + ($UnboundArguments -join ' ')
        }

        # If no input, dump contents of backward and foreward stacks
        if (!$aPath)
        {
            # Command to dump the backward & foreward stacks
            ""
            "     # Directory Stack:"
            "   --- ----------------"
            if ($backwardStack.Count -ge 0)
            {
                for ($i = 0; $i -lt $backwardStack.Count; $i++)
                {
                    "   {0,3} {1}" -f $i, $backwardStack[$i]
                }
            }

            "-> {0,3} {1}" -f $i++,$ExecutionContext.SessionState.Path.CurrentLocation

            if ($forewardStack.Count -ge 0)
            {
                $ndx = $i
                for ($i = 0; $i -lt $forewardStack.Count; $i++)
                {
                    "   {0,3} {1}" -f ($ndx+$i), $forewardStack[$i]
                }
            }
            ""
            return
        }

        Write-Debug "Processing arg: '$aPath'"

        $currentPathInfo = $ExecutionContext.SessionState.Path.CurrentLocation

        # Expand ..[.]+ out to ..\..[\..]+
        if ($aPath -like "*...*")
        {
            $regex = [regex]"\.\.\."
            while ($regex.IsMatch($aPath))
            {
                $aPath = $regex.Replace($aPath, "..$([System.IO.Path]::DirectorySeparatorChar)..")
            }
        }

        if ($aPath -eq "-")
        {
            if ($backwardStack.Count -eq 0)
            {
                Write-Warning $msgTbl.BackStackEmpty
            }
            else
            {
                $lastNdx = $backwardStack.Count - 1
                $prevPath = $backwardStack[$lastNdx]
                SetLocationImpl $prevPath -IsLiteralPath
                [void]$forewardStack.Insert(0, $currentPathInfo.Path)
                $backwardStack.RemoveAt($lastNdx)
            }
        }
        elseif ($aPath -eq "+")
        {
            if ($forewardStack.Count -eq 0)
            {
                Write-Warning $msgTbl.ForeStackEmpty
            }
            else
            {
                $nextPath = $forewardStack[0]
                SetLocationImpl $nextPath -IsLiteralPath
                [void]$backwardStack.Add($currentPathInfo.Path)
                $forewardStack.RemoveAt(0)
            }
        }
        elseif ($aPath -like "-[0-9]*")
        {
            [int]$num = $aPath.replace("-","")
            $backstackSize = $backwardStack.Count
            $forestackSize = $forewardStack.Count
            if ($num -eq $backstackSize)
            {
                Write-Host "`n$($msgTbl.GoingToTheSameDir)`n"
            }
            elseif ($num -lt $backstackSize)
            {
                $selectedPath = $backwardStack[$num]
                SetLocationImpl $selectedPath -IsLiteralPath
                [void]$forewardStack.Insert(0, $currentPathInfo.Path)
                $backwardStack.RemoveAt($num)

                [int]$ndx = $num
                [int]$count = $backwardStack.Count - $ndx
                if ($count -gt 0)
                {
                    $itemsToMove = $backwardStack.GetRange($ndx, $count)
                    $forewardStack.InsertRange(0, $itemsToMove)
                    $backwardStack.RemoveRange($ndx, $count)
                }
            }
            elseif (($num -gt $backstackSize) -and ($num -lt ($backstackSize + 1 + $forestackSize)))
            {
                [int]$ndx = $num - ($backstackSize + 1)
                $selectedPath = $forewardStack[$ndx]
                SetLocationImpl $selectedPath -IsLiteralPath
                [void]$backwardStack.Add($currentPathInfo.Path)
                $forewardStack.RemoveAt($ndx)

                [int]$count = $ndx
                if ($count -gt 0)
                {
                    $itemsToMove = $forewardStack.GetRange(0, $count)
                    $backwardStack.InsertRange(($backwardStack.Count), $itemsToMove)
                    $forewardStack.RemoveRange(0, $count)
                }
            }
            else
            {
                Write-Warning ($msgTbl.NumOutOfRangeF1 -f $num)
            }
        }
        else
        {
            $driveName = ''
            if ($ExecutionContext.SessionState.Path.IsPSAbsolute($aPath, [ref]$driveName) -and
                !(Test-Path -LiteralPath $aPath -PathType Container))
            {
                # File or a non-existant path - handle the case of "cd $profile" when the profile script doesn't exist
                $aPath = Split-Path $aPath -Parent
                Write-Debug "Path is not a container, attempting to set location to parent: '$aPath'"
            }

            SetLocationImpl $aPath

            $forewardStack.Clear()

            # Don't add the same path twice in a row
            if ($backwardStack.Count -gt 0)
            {
                $newPathInfo = $ExecutionContext.SessionState.Path.CurrentLocation
                if (($currentPathInfo.Provider     -eq $newPathInfo.Provider) -and
                    ($currentPathInfo.ProviderPath -eq $newPathInfo.ProviderPath))
                {
                    return
                }
            }
            [void]$backwardStack.Add($currentPathInfo.Path)
        }
    }
}

# SIG # Begin signature block
# MIIccgYJKoZIhvcNAQcCoIIcYzCCHF8CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUrVICM2wAh/lV7QeNWUaYcK6i
# ei2gghehMIIFKjCCBBKgAwIBAgIQBLQS3h09OUqqdSKUe3ftPjANBgkqhkiG9w0B
# AQsFADByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFz
# c3VyZWQgSUQgQ29kZSBTaWduaW5nIENBMB4XDTE2MTAxMjAwMDAwMFoXDTE5MTAx
# NzEyMDAwMFowZzELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAkNPMRUwEwYDVQQHEwxG
# b3J0IENvbGxpbnMxGTAXBgNVBAoTEDZMNiBTb2Z0d2FyZSBMTEMxGTAXBgNVBAMT
# EDZMNiBTb2Z0d2FyZSBMTEMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDDHT8E4dIiat1nGhayMJznISOTlfF48p2a7FNvIFG2ccoScZXJj53TmVkAF74J
# vFNld8ooNVig5BoqeO/Qq6MogKGLBl2gIaruHYwgll79z6aIsRJc6e9TjacIJZtr
# AUGGBg+5hl9fDygpfLQ3x0xEyTPbKcpDimc9MB5LSgclOwLXZflaEVqHvtHFDd3H
# FmuMtSS3ryhH8DrTglZNjYSbYTDBKVfq+J40Vzs5qhS86NiO2bZb+YVMQpDoZ6Yd
# EgXlOE6t4BHRoNX2r1VvnlUpwUnanRLkpGSq9nWmZF/YIUM13Zv7ceLwtnh8KrxI
# kaRr0kmYcJfv69kBI6e2Ezf5AgMBAAGjggHFMIIBwTAfBgNVHSMEGDAWgBRaxLl7
# KgqjpepxA8Bg+S32ZXUOWDAdBgNVHQ4EFgQU3UkpEeo3RgECtRdGHPkvZ6VK9PMw
# DgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMHcGA1UdHwRwMG4w
# NaAzoDGGL2h0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9zaGEyLWFzc3VyZWQtY3Mt
# ZzEuY3JsMDWgM6Axhi9odHRwOi8vY3JsNC5kaWdpY2VydC5jb20vc2hhMi1hc3N1
# cmVkLWNzLWcxLmNybDBMBgNVHSAERTBDMDcGCWCGSAGG/WwDATAqMCgGCCsGAQUF
# BwIBFhxodHRwczovL3d3dy5kaWdpY2VydC5jb20vQ1BTMAgGBmeBDAEEATCBhAYI
# KwYBBQUHAQEEeDB2MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5j
# b20wTgYIKwYBBQUHMAKGQmh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdp
# Q2VydFNIQTJBc3N1cmVkSURDb2RlU2lnbmluZ0NBLmNydDAMBgNVHRMBAf8EAjAA
# MA0GCSqGSIb3DQEBCwUAA4IBAQB7bGUp27a8g3rslXsg8vJ5kSdoay0XAiJqRlZW
# J7yN89iw9Pf+KJaApRaGnG/DPpNz/KFDm3XOSeimCDAxWfJJiUjpClZGOA06BYUg
# +UmF1/3AuTkUaFPig5ZgwabS9Cc3JKg1ue6kHFYerTncA1Axcw/TkVemZayUdi1w
# gfMz01YYQ1Dr0LormXLC3br4kxlYY3vWmBMSgjYgiTNH+FkEMOcFEDFgGXLKUpyS
# tr2G+1UPgGhlNf4b/51Ul736M5L+tbkLYp4rO7WG5ojb+HOMHwEm/YiaK1V5QBii
# mQYYY7RQJ34sRORnWDH2MJbvrTNoQQoaDgT2u2bAaEc6RKYBMIIFMDCCBBigAwIB
# AgIQBAkYG1/Vu2Z1U0O1b5VQCDANBgkqhkiG9w0BAQsFADBlMQswCQYDVQQGEwJV
# UzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQu
# Y29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVkIElEIFJvb3QgQ0EwHhcNMTMx
# MDIyMTIwMDAwWhcNMjgxMDIyMTIwMDAwWjByMQswCQYDVQQGEwJVUzEVMBMGA1UE
# ChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYD
# VQQDEyhEaWdpQ2VydCBTSEEyIEFzc3VyZWQgSUQgQ29kZSBTaWduaW5nIENBMIIB
# IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA+NOzHH8OEa9ndwfTCzFJGc/Q
# +0WZsTrbRPV/5aid2zLXcep2nQUut4/6kkPApfmJ1DcZ17aq8JyGpdglrA55KDp+
# 6dFn08b7KSfH03sjlOSRI5aQd4L5oYQjZhJUM1B0sSgmuyRpwsJS8hRniolF1C2h
# o+mILCCVrhxKhwjfDPXiTWAYvqrEsq5wMWYzcT6scKKrzn/pfMuSoeU7MRzP6vIK
# 5Fe7SrXpdOYr/mzLfnQ5Ng2Q7+S1TqSp6moKq4TzrGdOtcT3jNEgJSPrCGQ+UpbB
# 8g8S9MWOD8Gi6CxR93O8vYWxYoNzQYIH5DiLanMg0A9kczyen6Yzqf0Z3yWT0QID
# AQABo4IBzTCCAckwEgYDVR0TAQH/BAgwBgEB/wIBADAOBgNVHQ8BAf8EBAMCAYYw
# EwYDVR0lBAwwCgYIKwYBBQUHAwMweQYIKwYBBQUHAQEEbTBrMCQGCCsGAQUFBzAB
# hhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9j
# YWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcnQw
# gYEGA1UdHwR6MHgwOqA4oDaGNGh0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9EaWdp
# Q2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2lj
# ZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwTwYDVR0gBEgwRjA4
# BgpghkgBhv1sAAIEMCowKAYIKwYBBQUHAgEWHGh0dHBzOi8vd3d3LmRpZ2ljZXJ0
# LmNvbS9DUFMwCgYIYIZIAYb9bAMwHQYDVR0OBBYEFFrEuXsqCqOl6nEDwGD5LfZl
# dQ5YMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6enIZ3zbcgPMA0GCSqGSIb3DQEB
# CwUAA4IBAQA+7A1aJLPzItEVyCx8JSl2qB1dHC06GsTvMGHXfgtg/cM9D8Svi/3v
# Kt8gVTew4fbRknUPUbRupY5a4l4kgU4QpO4/cY5jDhNLrddfRHnzNhQGivecRk5c
# /5CxGwcOkRX7uq+1UcKNJK4kxscnKqEpKBo6cSgCPC6Ro8AlEeKcFEehemhor5un
# XCBc2XGxDI+7qPjFEmifz0DLQESlE/DmZAwlCEIysjaKJAL+L3J+HNdJRZboWR3p
# +nRka7LrZkPas7CM1ekN3fYBIM6ZMWM9CBoYs4GbT8aTEAb8B4H6i9r5gkn3Ym6h
# U/oSlBiFLpKR6mhsRDKyZqHnGKSaZFHvMIIGajCCBVKgAwIBAgIQAwGaAjr/WLFr
# 1tXq5hfwZjANBgkqhkiG9w0BAQUFADBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMM
# RGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQD
# ExhEaWdpQ2VydCBBc3N1cmVkIElEIENBLTEwHhcNMTQxMDIyMDAwMDAwWhcNMjQx
# MDIyMDAwMDAwWjBHMQswCQYDVQQGEwJVUzERMA8GA1UEChMIRGlnaUNlcnQxJTAj
# BgNVBAMTHERpZ2lDZXJ0IFRpbWVzdGFtcCBSZXNwb25kZXIwggEiMA0GCSqGSIb3
# DQEBAQUAA4IBDwAwggEKAoIBAQCjZF38fLPggjXg4PbGKuZJdTvMbuBTqZ8fZFnm
# fGt/a4ydVfiS457VWmNbAklQ2YPOb2bu3cuF6V+l+dSHdIhEOxnJ5fWRn8YUOawk
# 6qhLLJGJzF4o9GS2ULf1ErNzlgpno75hn67z/RJ4dQ6mWxT9RSOOhkRVfRiGBYxV
# h3lIRvfKDo2n3k5f4qi2LVkCYYhhchhoubh87ubnNC8xd4EwH7s2AY3vJ+P3mvBM
# MWSN4+v6GYeofs/sjAw2W3rBerh4x8kGLkYQyI3oBGDbvHN0+k7Y/qpA8bLOcEaD
# 6dpAoVk62RUJV5lWMJPzyWHM0AjMa+xiQpGsAsDvpPCJEY93AgMBAAGjggM1MIID
# MTAOBgNVHQ8BAf8EBAMCB4AwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggr
# BgEFBQcDCDCCAb8GA1UdIASCAbYwggGyMIIBoQYJYIZIAYb9bAcBMIIBkjAoBggr
# BgEFBQcCARYcaHR0cHM6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzCCAWQGCCsGAQUF
# BwICMIIBVh6CAVIAQQBuAHkAIAB1AHMAZQAgAG8AZgAgAHQAaABpAHMAIABDAGUA
# cgB0AGkAZgBpAGMAYQB0AGUAIABjAG8AbgBzAHQAaQB0AHUAdABlAHMAIABhAGMA
# YwBlAHAAdABhAG4AYwBlACAAbwBmACAAdABoAGUAIABEAGkAZwBpAEMAZQByAHQA
# IABDAFAALwBDAFAAUwAgAGEAbgBkACAAdABoAGUAIABSAGUAbAB5AGkAbgBnACAA
# UABhAHIAdAB5ACAAQQBnAHIAZQBlAG0AZQBuAHQAIAB3AGgAaQBjAGgAIABsAGkA
# bQBpAHQAIABsAGkAYQBiAGkAbABpAHQAeQAgAGEAbgBkACAAYQByAGUAIABpAG4A
# YwBvAHIAcABvAHIAYQB0AGUAZAAgAGgAZQByAGUAaQBuACAAYgB5ACAAcgBlAGYA
# ZQByAGUAbgBjAGUALjALBglghkgBhv1sAxUwHwYDVR0jBBgwFoAUFQASKxOYspkH
# 7R7for5XDStnAs0wHQYDVR0OBBYEFGFaTSS2STKdSip5GoNL9B6Jwcp9MH0GA1Ud
# HwR2MHQwOKA2oDSGMmh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFz
# c3VyZWRJRENBLTEuY3JsMDigNqA0hjJodHRwOi8vY3JsNC5kaWdpY2VydC5jb20v
# RGlnaUNlcnRBc3N1cmVkSURDQS0xLmNybDB3BggrBgEFBQcBAQRrMGkwJAYIKwYB
# BQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBBBggrBgEFBQcwAoY1aHR0
# cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEQ0EtMS5j
# cnQwDQYJKoZIhvcNAQEFBQADggEBAJ0lfhszTbImgVybhs4jIA+Ah+WI//+x1Gos
# Me06FxlxF82pG7xaFjkAneNshORaQPveBgGMN/qbsZ0kfv4gpFetW7easGAm6mlX
# IV00Lx9xsIOUGQVrNZAQoHuXx/Y/5+IRQaa9YtnwJz04HShvOlIJ8OxwYtNiS7Dg
# c6aSwNOOMdgv420XEwbu5AO2FKvzj0OncZ0h3RTKFV2SQdr5D4HRmXQNJsQOfxu1
# 9aDxxncGKBXp2JPlVRbwuwqrHNtcSCdmyKOLChzlldquxC5ZoGHd2vNtomHpigtt
# 7BIYvfdVVEADkitrwlHCCkivsNRu4PQUCjob4489yq9qjXvc2EQwggbNMIIFtaAD
# AgECAhAG/fkDlgOt6gAK6z8nu7obMA0GCSqGSIb3DQEBBQUAMGUxCzAJBgNVBAYT
# AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2Vy
# dC5jb20xJDAiBgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0w
# NjExMTAwMDAwMDBaFw0yMTExMTAwMDAwMDBaMGIxCzAJBgNVBAYTAlVTMRUwEwYD
# VQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAf
# BgNVBAMTGERpZ2lDZXJ0IEFzc3VyZWQgSUQgQ0EtMTCCASIwDQYJKoZIhvcNAQEB
# BQADggEPADCCAQoCggEBAOiCLZn5ysJClaWAc0Bw0p5WVFypxNJBBo/JM/xNRZFc
# gZ/tLJz4FlnfnrUkFcKYubR3SdyJxArar8tea+2tsHEx6886QAxGTZPsi3o2CAOr
# DDT+GEmC/sfHMUiAfB6iD5IOUMnGh+s2P9gww/+m9/uizW9zI/6sVgWQ8DIhFonG
# cIj5BZd9o8dD3QLoOz3tsUGj7T++25VIxO4es/K8DCuZ0MZdEkKB4YNugnM/JksU
# kK5ZZgrEjb7SzgaurYRvSISbT0C58Uzyr5j79s5AXVz2qPEvr+yJIvJrGGWxwXOt
# 1/HYzx4KdFxCuGh+t9V3CidWfA9ipD8yFGCV/QcEogkCAwEAAaOCA3owggN2MA4G
# A1UdDwEB/wQEAwIBhjA7BgNVHSUENDAyBggrBgEFBQcDAQYIKwYBBQUHAwIGCCsG
# AQUFBwMDBggrBgEFBQcDBAYIKwYBBQUHAwgwggHSBgNVHSAEggHJMIIBxTCCAbQG
# CmCGSAGG/WwAAQQwggGkMDoGCCsGAQUFBwIBFi5odHRwOi8vd3d3LmRpZ2ljZXJ0
# LmNvbS9zc2wtY3BzLXJlcG9zaXRvcnkuaHRtMIIBZAYIKwYBBQUHAgIwggFWHoIB
# UgBBAG4AeQAgAHUAcwBlACAAbwBmACAAdABoAGkAcwAgAEMAZQByAHQAaQBmAGkA
# YwBhAHQAZQAgAGMAbwBuAHMAdABpAHQAdQB0AGUAcwAgAGEAYwBjAGUAcAB0AGEA
# bgBjAGUAIABvAGYAIAB0AGgAZQAgAEQAaQBnAGkAQwBlAHIAdAAgAEMAUAAvAEMA
# UABTACAAYQBuAGQAIAB0AGgAZQAgAFIAZQBsAHkAaQBuAGcAIABQAGEAcgB0AHkA
# IABBAGcAcgBlAGUAbQBlAG4AdAAgAHcAaABpAGMAaAAgAGwAaQBtAGkAdAAgAGwA
# aQBhAGIAaQBsAGkAdAB5ACAAYQBuAGQAIABhAHIAZQAgAGkAbgBjAG8AcgBwAG8A
# cgBhAHQAZQBkACAAaABlAHIAZQBpAG4AIABiAHkAIAByAGUAZgBlAHIAZQBuAGMA
# ZQAuMAsGCWCGSAGG/WwDFTASBgNVHRMBAf8ECDAGAQH/AgEAMHkGCCsGAQUFBwEB
# BG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEMGCCsG
# AQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1
# cmVkSURSb290Q0EuY3J0MIGBBgNVHR8EejB4MDqgOKA2hjRodHRwOi8vY3JsMy5k
# aWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3JsMDqgOKA2hjRo
# dHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0Eu
# Y3JsMB0GA1UdDgQWBBQVABIrE5iymQftHt+ivlcNK2cCzTAfBgNVHSMEGDAWgBRF
# 66Kv9JLLgjEtUYunpyGd823IDzANBgkqhkiG9w0BAQUFAAOCAQEARlA+ybcoJKc4
# HbZbKa9Sz1LpMUerVlx71Q0LQbPv7HUfdDjyslxhopyVw1Dkgrkj0bo6hnKtOHis
# dV0XFzRyR4WUVtHruzaEd8wkpfMEGVWp5+Pnq2LN+4stkMLA0rWUvV5PsQXSDj0a
# qRRbpoYxYqioM+SbOafE9c4deHaUJXPkKqvPnHZL7V/CSxbkS3BMAIke/MV5vEwS
# V/5f4R68Al2o/vsHOE8Nxl2RuQ9nRc3Wg+3nkg2NsWmMT/tZ4CMP0qquAHzunEIO
# z5HXJ7cW7g/DvXwKoO4sCFWFIrjrGBpN/CohrUkxg0eVd3HcsRtLSxwQnHcUwZ1P
# L1qVCCkQJjGCBDswggQ3AgEBMIGGMHIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxE
# aWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xMTAvBgNVBAMT
# KERpZ2lDZXJ0IFNIQTIgQXNzdXJlZCBJRCBDb2RlIFNpZ25pbmcgQ0ECEAS0Et4d
# PTlKqnUilHt37T4wCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKEC
# gAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwG
# CisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFAQHzKTmEP88ZsNTchKR9a2/oTun
# MA0GCSqGSIb3DQEBAQUABIIBADR6dUFhIOj5rQLMjdnLplmoBhgcOaaENkEPR3FR
# 5iA14+8bWEzf6tPydk3S5j+iMSvJPj7h9FgHvVJG/cwcJu0yz6uR0tWA5qfZD+P0
# Cdu6/GR4EtZl9aqfMcjeGzi5Jd0J8XRYxDQxhZYOf+fOhqrqWSB9CNirFbV0aFuA
# LRXMhUjzcPFG1nnQsWYikUz1u/NK90iyMyYs9xOERpXqVi7OFGb1vLkQXHC351u5
# TYilwHBCs25vUX2wvNfas6krGyF/tchCEq/kwxlw5KvB+ZQs3ob1Wosby4AoRh8Z
# 4TXQrbBt7yeg5QlFDQc26T+K8dp/L9V3vkKC5Xo+eGKQsYqhggIPMIICCwYJKoZI
# hvcNAQkGMYIB/DCCAfgCAQEwdjBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGln
# aUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhE
# aWdpQ2VydCBBc3N1cmVkIElEIENBLTECEAMBmgI6/1ixa9bV6uYX8GYwCQYFKw4D
# AhoFAKBdMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8X
# DTE4MDExNzAyNDYzNVowIwYJKoZIhvcNAQkEMRYEFGevDVAp5sRSuUeFKU8SBZR4
# g7IJMA0GCSqGSIb3DQEBAQUABIIBAJyiwhzG3jY4g9VBauEbvAJtxrUppwEkH7gC
# 4rG0OghSQxuTFOCr2XEqbMxszwpkFubp+K9rs1YktgRbWzAKSRHEQx7D8sZwzZdh
# UDCRoRdjkoJKkrztvofz+a0GSdSLt6+pwGG4iVR0SCIGD2CgAFDPqWDdx+XRkaQR
# cnRQuEM2yxM2ziwXrNxkf06jSXnyrf6CT75nald0BlWDhHe+KfCuLDv/Ef7nTeLa
# 1ey5qxK+B874qAgWKWOzvKdxzoJM4bXCmi0MzbO06vksGlObTsqvDEqHtbNEccyZ
# 6pasZXDeUjhcZCV/xQ8F9eooh5yisTalByc5jostL2JlFk4pp+k=
# SIG # End signature block
