﻿# ---------------------------------------------------------------------------
# Author: Keith Hill
# Desc:   Infrastructure for applying prompt themes.  Prompt themes affect
#         the PowerShell prompt string and optionally the host's window
#         title and a startup message.
# Date:   Nov 07, 2009
# Site:   http://pscx.codeplex.com
# Usage:  In your Pscx.UserPreferences.ps1 file, set the prompt theme to one
#         of: Modern, WinXP or Jachym.
# ---------------------------------------------------------------------------
Set-StrictMode -Version 2.0

$Theme = @{
	# Host RawUI Colors	
	HostBackgroundColor   = $null
	HostForegroundColor   = $null
	
	PromptBackgroundColor = $null
	PromptForegroundColor = $null	
	
	#Host Private Data Colors
	PrivateData = @{
		ErrorForegroundColor    = $null  # Console = Red,      ISE = #FFFF0000
		ErrorBackgroundColor    = $null  # Console = Black,    ISE = #00FFFFFF
		WarningForegroundColor  = $null  # Console = Yellow,   ISE = #FFFF8C00
		WarningBackgroundColor  = $null  # Console = Black,    ISE = #00FFFFFF
		DebugForegroundColor    = $null  # Console = Yellow,   ISE = #FF0000FF
		DebugBackgroundColor    = $null  # Console = Black,    ISE = #00FFFFFF
		VerboseForegroundColor  = $null  # Console = Yellow,   ISE = #FF0000FF
		VerboseBackgroundColor  = $null  # Console = Black,    ISE = #00FFFFFF
		ProgressForegroundColor = $null  # Console = Yellow,   ISE = <not defined>
		ProgressBackgroundColor = $null  # Console = DarkCyan, ISE = <not defined>	
	}
	
	# Behavior (ie scriptblocks)
	PromptScriptBlock            = $null 
	StartupMessageScriptBlock    = $null
	UpdateWindowTitleScriptBlock = $null
}

# ---------------------------------------------------------------------------
# Updates the host's window title
# ---------------------------------------------------------------------------
function Update-HostWindowTitle
{
	if (!$Theme.UpdateWindowTitleScriptBlock) { return }
	
	if ($Theme.UpdateWindowTitleScriptBlock -is [scriptblock])
	{
		$title = & $Theme.UpdateWindowTitleScriptBlock
	}
	else
	{
		$title = "$($Theme.UpdateWindowTitleScriptBlock)"
	}

	$OFS = ''
	$Host.UI.RawUI.WindowTitle = "$title"	
}

# ---------------------------------------------------------------------------
# Writes the startup message
# ---------------------------------------------------------------------------
function Write-StartupMessage
{
	if (!$Theme.StartupMessageScriptBlock) { return }
	
	if ($Theme.StartupMessageScriptBlock -is [scriptblock])
	{
		$message = & $Theme.StartupMessageScriptBlock
	}
	else
	{
		$message = "$($Theme.StartupMessageScriptBlock)"
	}
	
    if (!$Pscx:Preferences['ShowModuleLoadDetails'])
    {
		Clear-Host
	}
			
	if ($message) 
	{
		$foreColor = $Host.UI.RawUI.ForegroundColor
		
		if ($Host.Name -eq 'ConsoleHost')
		{
			if ($Theme.PromptForegroundColor)
			{
				$foreColor = $Theme.PromptForegroundColor
			}
		}
		
		Write-Host $message -ForegroundColor $foreColor
	}
}

# ---------------------------------------------------------------------------
# Writes the prompt string directly to the host
# ---------------------------------------------------------------------------
function Write-Prompt($Id)
{
	# Default prompt
	$prompt = "PS $(Get-Location)>"	
	if ($Theme.PromptScriptBlock -is [scriptblock])
	{
		$OFS = ''
		$prompt = "$(& $Theme.PromptScriptBlock $Id)"	
	}
	elseif ($Theme.PromptScriptBlock -is [string])
	{
		$prompt = $Theme.PromptScriptBlock
	}
	
	if ($Host.Name -eq 'ConsoleHost')
	{
		if ($Host.UI.RawUI.CursorPosition.X -ne 0)
		{
			Write-Host
		}	
		
		$foreColor = $Host.UI.RawUI.ForegroundColor
		if ($Theme.PromptForegroundColor)
		{
			$foreColor = $Theme.PromptForegroundColor
		}

		$backColor = $Host.UI.RawUI.BackgroundColor
		if ($Theme.PromptBackgroundColor)
		{
			$backColor = $Theme.PromptBackgroundColor
		}
				
		Write-Host $prompt -NoNewLine -ForegroundColor $foreColor -BackgroundColor $backColor
	}
	else
	{
		# For any other host besides powershell.exe, just return the prompt string
		$prompt
	}
}

# ---------------------------------------------------------------------------
# The replacment prompt function
# ---------------------------------------------------------------------------
function Prompt
{
	$id = 0
	$histItem = Get-History -Count 1
	if ($histItem)
	{
		$id = $histItem.Id
	}
	
	if ($id -eq 0)
	{
		Write-StartupMessage
	}
	
	Write-Prompt ($id + 1)
	Update-HostWindowTitle
	return ' ' # If you don't return anything PowerShell gives you PS>
}

# ---------------------------------------------------------------------------
# Load the specified theme (default is Modern)
# ---------------------------------------------------------------------------
$themeName = $Pscx:Preferences.PromptTheme
$themePath = "$PSScriptRoot\Themes\$themeName.ps1"
if (!(Test-Path $themePath))
{
    Write-Warning "Theme '$themeName' not found, defaulting to Modern theme"
    $themePath = "$PSScriptRoot\Themes\Modern.ps1"
}
Write-Verbose "Applying prompt theme '$themeName'"
& $themePath $Theme

# ---------------------------------------------------------------------------
# Initialize host colors and window title
# ---------------------------------------------------------------------------
if ($Host.Name -eq 'ConsoleHost')
{
    if ($Theme.HostForegroundColor)
    {
	    $Host.UI.RawUI.ForegroundColor = $Theme.HostForegroundColor
    }
    if ($Theme.HostBackgroundColor)
    {
	    $Host.UI.RawUI.BackgroundColor           = $Theme.HostBackgroundColor
	    $Host.PrivateData.ErrorBackgroundColor   = $Theme.HostBackgroundColor
	    $Host.PrivateData.WarningBackgroundColor = $Theme.HostBackgroundColor
	    $Host.PrivateData.DebugBackgroundColor   = $Theme.HostBackgroundColor
	    $Host.PrivateData.VerboseBackgroundColor = $Theme.HostBackgroundColor
    }	
    foreach ($key in $Theme.PrivateData.Keys)
    {
	    if ($Theme.PrivateData.$key)
	    {
		    $Host.PrivateData.$key = $Theme.PrivateData.$key
	    }
    }    
}
	
# Update window title if a scriptblock has been provided
Update-HostWindowTitle

Export-ModuleMember -Function Prompt
# SIG # Begin signature block
# MIIfVQYJKoZIhvcNAQcCoIIfRjCCH0ICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUWIQ3h7X/Xx4K+daJqTEVI7Tq
# HgqgghqHMIIGbzCCBVegAwIBAgIQA4uW8HDZ4h5VpUJnkuHIOjANBgkqhkiG9w0B
# AQUFADBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBBc3N1cmVk
# IElEIENBLTEwHhcNMTIwNDA0MDAwMDAwWhcNMTMwNDE4MDAwMDAwWjBHMQswCQYD
# VQQGEwJVUzERMA8GA1UEChMIRGlnaUNlcnQxJTAjBgNVBAMTHERpZ2lDZXJ0IFRp
# bWVzdGFtcCBSZXNwb25kZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDGf7tj+/F8Q0mIJnRfituiDBM1pYivqtEwyjPdo9B2gRXW1tvhNC0FIG/BofQX
# Z7dN3iETYE4Jcq1XXniQO7XMLc15uGLZTzHc0cmMCAv8teTgJ+mn7ra9Depw8wXb
# 82jr+D8RM3kkwHsqfFKdphzOZB/GcvgUnE0R2KJDQXK6DqO+r9L9eNxHlRdwbJwg
# wav5YWPmj5mAc7b+njHfTb/hvE+LgfzFqEM7GyQoZ8no89SRywWpFs++42Pf6oKh
# qIXcBBDsREA0NxnNMHF82j0Ctqh3sH2D3WQIE3ome/SXN8uxb9wuMn3Y07/HiIEP
# kUkd8WPenFhtjzUmWSnGwHTPAgMBAAGjggM6MIIDNjAOBgNVHQ8BAf8EBAMCB4Aw
# DAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDCCAcQGA1UdIASC
# AbswggG3MIIBswYJYIZIAYb9bAcBMIIBpDA6BggrBgEFBQcCARYuaHR0cDovL3d3
# dy5kaWdpY2VydC5jb20vc3NsLWNwcy1yZXBvc2l0b3J5Lmh0bTCCAWQGCCsGAQUF
# BwICMIIBVh6CAVIAQQBuAHkAIAB1AHMAZQAgAG8AZgAgAHQAaABpAHMAIABDAGUA
# cgB0AGkAZgBpAGMAYQB0AGUAIABjAG8AbgBzAHQAaQB0AHUAdABlAHMAIABhAGMA
# YwBlAHAAdABhAG4AYwBlACAAbwBmACAAdABoAGUAIABEAGkAZwBpAEMAZQByAHQA
# IABDAFAALwBDAFAAUwAgAGEAbgBkACAAdABoAGUAIABSAGUAbAB5AGkAbgBnACAA
# UABhAHIAdAB5ACAAQQBnAHIAZQBlAG0AZQBuAHQAIAB3AGgAaQBjAGgAIABsAGkA
# bQBpAHQAIABsAGkAYQBiAGkAbABpAHQAeQAgAGEAbgBkACAAYQByAGUAIABpAG4A
# YwBvAHIAcABvAHIAYQB0AGUAZAAgAGgAZQByAGUAaQBuACAAYgB5ACAAcgBlAGYA
# ZQByAGUAbgBjAGUALjAfBgNVHSMEGDAWgBQVABIrE5iymQftHt+ivlcNK2cCzTAd
# BgNVHQ4EFgQUJqoP9EMNo5gXpV8S9PiSjqnkhDQwdwYIKwYBBQUHAQEEazBpMCQG
# CCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQQYIKwYBBQUHMAKG
# NWh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRENB
# LTEuY3J0MH0GA1UdHwR2MHQwOKA2oDSGMmh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNv
# bS9EaWdpQ2VydEFzc3VyZWRJRENBLTEuY3JsMDigNqA0hjJodHRwOi8vY3JsNC5k
# aWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURDQS0xLmNybDANBgkqhkiG9w0B
# AQUFAAOCAQEAvCT5g9lmKeYy6GdDbzfLaXlHl4tifmnDitXp13GcjqH52v4k498m
# bK/g0s0vxJ8yYdB2zERcy+WPvXhnhhPiummK15cnfj2EE1YzDr992ekBaoxuvz/P
# MZivhUgRXB+7ycJvKsrFxZUSDFM4GS+1lwp+hrOVPNxBZqWZyZVXrYq0xWzxFjOb
# vvA8rWBrH0YPdskbgkNe3R2oNWZtNV8hcTOgHArLRWmJmaX05mCs7ksBKGyRlK+/
# +fLFWOptzeUAtDnjsEWFuzG2wym3BFDg7gbFFOlvzmv8m7wkfR2H3aiObVCUNeZ8
# AB4TB5nkYujEj7p75UsZu62Y9rXC8YkgGDCCBpswggWDoAMCAQICEAoVPQh11uMo
# zhH2mVCPvBEwDQYJKoZIhvcNAQEFBQAwbzELMAkGA1UEBhMCVVMxFTATBgNVBAoT
# DERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEuMCwGA1UE
# AxMlRGlnaUNlcnQgQXNzdXJlZCBJRCBDb2RlIFNpZ25pbmcgQ0EtMTAeFw0xMjA5
# MTEwMDAwMDBaFw0xMzA5MTgxMjAwMDBaMGcxCzAJBgNVBAYTAlVTMQswCQYDVQQI
# EwJDTzEVMBMGA1UEBxMMRm9ydCBDb2xsaW5zMRkwFwYDVQQKExA2TDYgU29mdHdh
# cmUgTExDMRkwFwYDVQQDExA2TDYgU29mdHdhcmUgTExDMIIBIjANBgkqhkiG9w0B
# AQEFAAOCAQ8AMIIBCgKCAQEAvtSuQar5tMsJw1RaGhLz9ECpar95hZ4d0dHivIK2
# maFz8QQeSJbqQbouzWJWfgvncWIhfZs9wyJjCdHbW7xVSmK/GPI+mfTky66lP99W
# dfV6gY0WkBYkFvzTQ0s/P9+qS1PEfAb8CFZYx3Ti8GVSUVSS87/TZm1SS+lnCg4m
# Rlp+BM9FDaK8IA/UjUjl277qmVnfvB35ey4I81421hsl5uJsZ5ZB+C9PFvkIzhR4
# Eo7o7R13Erjiryran/aJb77YgjRueC+EZ8rCx+kDq5TsLAzYZQwfgaKXpFlvXdiF
# vdFD6Hf6j4QonmtwG1RDYS5Vp1O/d2y/aunhKW3Wr94kywIDAQABo4IDOTCCAzUw
# HwYDVR0jBBgwFoAUe2jOKarAF75JeuHlP9an90WPNTIwHQYDVR0OBBYEFPNABKbs
# Aid4soPC5f6eM7TdDs50MA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEF
# BQcDAzBzBgNVHR8EbDBqMDOgMaAvhi1odHRwOi8vY3JsMy5kaWdpY2VydC5jb20v
# YXNzdXJlZC1jcy0yMDExYS5jcmwwM6AxoC+GLWh0dHA6Ly9jcmw0LmRpZ2ljZXJ0
# LmNvbS9hc3N1cmVkLWNzLTIwMTFhLmNybDCCAcQGA1UdIASCAbswggG3MIIBswYJ
# YIZIAYb9bAMBMIIBpDA6BggrBgEFBQcCARYuaHR0cDovL3d3dy5kaWdpY2VydC5j
# b20vc3NsLWNwcy1yZXBvc2l0b3J5Lmh0bTCCAWQGCCsGAQUFBwICMIIBVh6CAVIA
# QQBuAHkAIAB1AHMAZQAgAG8AZgAgAHQAaABpAHMAIABDAGUAcgB0AGkAZgBpAGMA
# YQB0AGUAIABjAG8AbgBzAHQAaQB0AHUAdABlAHMAIABhAGMAYwBlAHAAdABhAG4A
# YwBlACAAbwBmACAAdABoAGUAIABEAGkAZwBpAEMAZQByAHQAIABDAFAALwBDAFAA
# UwAgAGEAbgBkACAAdABoAGUAIABSAGUAbAB5AGkAbgBnACAAUABhAHIAdAB5ACAA
# QQBnAHIAZQBlAG0AZQBuAHQAIAB3AGgAaQBjAGgAIABsAGkAbQBpAHQAIABsAGkA
# YQBiAGkAbABpAHQAeQAgAGEAbgBkACAAYQByAGUAIABpAG4AYwBvAHIAcABvAHIA
# YQB0AGUAZAAgAGgAZQByAGUAaQBuACAAYgB5ACAAcgBlAGYAZQByAGUAbgBjAGUA
# LjCBggYIKwYBBQUHAQEEdjB0MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdp
# Y2VydC5jb20wTAYIKwYBBQUHMAKGQGh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNv
# bS9EaWdpQ2VydEFzc3VyZWRJRENvZGVTaWduaW5nQ0EtMS5jcnQwDAYDVR0TAQH/
# BAIwADANBgkqhkiG9w0BAQUFAAOCAQEAIK6UA1qKXKbv5fphePINxEahQyZCLaFY
# OO+Q2jcrnrXofOGqZOLz/M33cJErAOyZQvKANOKybsMlpzmkQpP8jJsNRXuDmEOl
# bilUkwssxSTHeLfKgfRbB5RMi7RhvWyzhoC+FELHI+99VDJAQzWYwokAsSHohUPj
# QsEn6sI2ITvxOKgZKurzzFTmFberEA55RoszUKRcP9E0aW6L94ysSpVmzcJxY8ZE
# ny91ACmlHCSzxjrON/nlikzFtDTRlLr//dAm/XPXNlpEA1gIqS4zqUapRyFP/VhW
# NgHsjMdwIHpRAgpLPkvobG+TMHobi2IqkzSt5SrrDVcaH7t+RpKlLTCCBqAwggWI
# oAMCAQICEAf0c2+v70CKH2ZA8mXRCsEwDQYJKoZIhvcNAQEFBQAwZTELMAkGA1UE
# BhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2lj
# ZXJ0LmNvbTEkMCIGA1UEAxMbRGlnaUNlcnQgQXNzdXJlZCBJRCBSb290IENBMB4X
# DTExMDIxMDEyMDAwMFoXDTI2MDIxMDEyMDAwMFowbzELMAkGA1UEBhMCVVMxFTAT
# BgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEu
# MCwGA1UEAxMlRGlnaUNlcnQgQXNzdXJlZCBJRCBDb2RlIFNpZ25pbmcgQ0EtMTCC
# ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJx8+aCPCsqJS1OaPOwZIn8M
# y/dIRNA/Im6aT/rO38bTJJH/qFKT53L48UaGlMWrF/R4f8t6vpAmHHxTL+WD57tq
# BSjMoBcRSxgg87e98tzLuIZARR9P+TmY0zvrb2mkXAEusWbpprjcBt6ujWL+RCeC
# qQPD/uYmC5NJceU4bU7+gFxnd7XVb2ZklGu7iElo2NH0fiHB5sUeyeCWuAmV+Uue
# rswxvWpaQqfEBUd9YCvZoV29+1aT7xv8cvnfPjL93SosMkbaXmO80LjLTBA1/FBf
# rENEfP6ERFC0jCo9dAz0eotyS+BWtRO2Y+k/Tkkj5wYW8CWrAfgoQebH1GQ7XasC
# AwEAAaOCA0AwggM8MA4GA1UdDwEB/wQEAwIBBjATBgNVHSUEDDAKBggrBgEFBQcD
# AzCCAcMGA1UdIASCAbowggG2MIIBsgYIYIZIAYb9bAMwggGkMDoGCCsGAQUFBwIB
# Fi5odHRwOi8vd3d3LmRpZ2ljZXJ0LmNvbS9zc2wtY3BzLXJlcG9zaXRvcnkuaHRt
# MIIBZAYIKwYBBQUHAgIwggFWHoIBUgBBAG4AeQAgAHUAcwBlACAAbwBmACAAdABo
# AGkAcwAgAEMAZQByAHQAaQBmAGkAYwBhAHQAZQAgAGMAbwBuAHMAdABpAHQAdQB0
# AGUAcwAgAGEAYwBjAGUAcAB0AGEAbgBjAGUAIABvAGYAIAB0AGgAZQAgAEQAaQBn
# AGkAQwBlAHIAdAAgAEMAUAAvAEMAUABTACAAYQBuAGQAIAB0AGgAZQAgAFIAZQBs
# AHkAaQBuAGcAIABQAGEAcgB0AHkAIABBAGcAcgBlAGUAbQBlAG4AdAAgAHcAaABp
# AGMAaAAgAGwAaQBtAGkAdAAgAGwAaQBhAGIAaQBsAGkAdAB5ACAAYQBuAGQAIABh
# AHIAZQAgAGkAbgBjAG8AcgBwAG8AcgBhAHQAZQBkACAAaABlAHIAZQBpAG4AIABi
# AHkAIAByAGUAZgBlAHIAZQBuAGMAZQAuMA8GA1UdEwEB/wQFMAMBAf8weQYIKwYB
# BQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20w
# QwYIKwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2Vy
# dEFzc3VyZWRJRFJvb3RDQS5jcnQwgYEGA1UdHwR6MHgwOqA4oDaGNGh0dHA6Ly9j
# cmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwOqA4
# oDaGNGh0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJv
# b3RDQS5jcmwwHQYDVR0OBBYEFHtozimqwBe+SXrh5T/Wp/dFjzUyMB8GA1UdIwQY
# MBaAFEXroq/0ksuCMS1Ri6enIZ3zbcgPMA0GCSqGSIb3DQEBBQUAA4IBAQCPJ3L2
# XadkkG25JWDGsBetHvmd7qFQgoTHKlU1rBhCuzbY3lPwkie/M1WvSlq4OA3r9OQ4
# DY38RegRPAw1V69KXHlBV94JpA8RkxA6fG40gz3xb/l0H4sRKsqbsO/TgJJEQ9El
# yTkyITHnKYLKxEGIyAeBp/1bIRd+HbqpY2jIctHil1lyQubYp7a6sy7JZK2TwuHl
# eKm36bs9MZKa3pGJJgoLXj5Oz2HrWmxkBT57q3+mWN0elcdeW8phnTR1pOUHSPhM
# 0k88EjW7XxFljf1yueiXIKUxh77LAx/LAzlu97I7OJV9cEW4VvWAcoEETIBzoK0t
# OfUCyOSF1TskL7NsMIIGzTCCBbWgAwIBAgIQBv35A5YDreoACus/J7u6GzANBgkq
# hkiG9w0BAQUFADBlMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5j
# MRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBB
# c3N1cmVkIElEIFJvb3QgQ0EwHhcNMDYxMTEwMDAwMDAwWhcNMjExMTEwMDAwMDAw
# WjBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQL
# ExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBBc3N1cmVkIElE
# IENBLTEwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDogi2Z+crCQpWl
# gHNAcNKeVlRcqcTSQQaPyTP8TUWRXIGf7Syc+BZZ3561JBXCmLm0d0ncicQK2q/L
# XmvtrbBxMevPOkAMRk2T7It6NggDqww0/hhJgv7HxzFIgHweog+SDlDJxofrNj/Y
# MMP/pvf7os1vcyP+rFYFkPAyIRaJxnCI+QWXfaPHQ90C6Ds97bFBo+0/vtuVSMTu
# HrPyvAwrmdDGXRJCgeGDboJzPyZLFJCuWWYKxI2+0s4Grq2Eb0iEm09AufFM8q+Y
# +/bOQF1c9qjxL6/siSLyaxhlscFzrdfx2M8eCnRcQrhofrfVdwonVnwPYqQ/MhRg
# lf0HBKIJAgMBAAGjggN6MIIDdjAOBgNVHQ8BAf8EBAMCAYYwOwYDVR0lBDQwMgYI
# KwYBBQUHAwEGCCsGAQUFBwMCBggrBgEFBQcDAwYIKwYBBQUHAwQGCCsGAQUFBwMI
# MIIB0gYDVR0gBIIByTCCAcUwggG0BgpghkgBhv1sAAEEMIIBpDA6BggrBgEFBQcC
# ARYuaHR0cDovL3d3dy5kaWdpY2VydC5jb20vc3NsLWNwcy1yZXBvc2l0b3J5Lmh0
# bTCCAWQGCCsGAQUFBwICMIIBVh6CAVIAQQBuAHkAIAB1AHMAZQAgAG8AZgAgAHQA
# aABpAHMAIABDAGUAcgB0AGkAZgBpAGMAYQB0AGUAIABjAG8AbgBzAHQAaQB0AHUA
# dABlAHMAIABhAGMAYwBlAHAAdABhAG4AYwBlACAAbwBmACAAdABoAGUAIABEAGkA
# ZwBpAEMAZQByAHQAIABDAFAALwBDAFAAUwAgAGEAbgBkACAAdABoAGUAIABSAGUA
# bAB5AGkAbgBnACAAUABhAHIAdAB5ACAAQQBnAHIAZQBlAG0AZQBuAHQAIAB3AGgA
# aQBjAGgAIABsAGkAbQBpAHQAIABsAGkAYQBiAGkAbABpAHQAeQAgAGEAbgBkACAA
# YQByAGUAIABpAG4AYwBvAHIAcABvAHIAYQB0AGUAZAAgAGgAZQByAGUAaQBuACAA
# YgB5ACAAcgBlAGYAZQByAGUAbgBjAGUALjALBglghkgBhv1sAxUwEgYDVR0TAQH/
# BAgwBgEB/wIBADB5BggrBgEFBQcBAQRtMGswJAYIKwYBBQUHMAGGGGh0dHA6Ly9v
# Y3NwLmRpZ2ljZXJ0LmNvbTBDBggrBgEFBQcwAoY3aHR0cDovL2NhY2VydHMuZGln
# aWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNydDCBgQYDVR0fBHow
# eDA6oDigNoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJl
# ZElEUm9vdENBLmNybDA6oDigNoY0aHR0cDovL2NybDQuZGlnaWNlcnQuY29tL0Rp
# Z2lDZXJ0QXNzdXJlZElEUm9vdENBLmNybDAdBgNVHQ4EFgQUFQASKxOYspkH7R7f
# or5XDStnAs0wHwYDVR0jBBgwFoAUReuir/SSy4IxLVGLp6chnfNtyA8wDQYJKoZI
# hvcNAQEFBQADggEBAEZQPsm3KCSnOB22WymvUs9S6TFHq1Zce9UNC0Gz7+x1H3Q4
# 8rJcYaKclcNQ5IK5I9G6OoZyrTh4rHVdFxc0ckeFlFbR67s2hHfMJKXzBBlVqefj
# 56tizfuLLZDCwNK1lL1eT7EF0g49GqkUW6aGMWKoqDPkmzmnxPXOHXh2lCVz5Cqr
# z5x2S+1fwksW5EtwTACJHvzFebxMElf+X+EevAJdqP77BzhPDcZdkbkPZ0XN1oPt
# 55INjbFpjE/7WeAjD9KqrgB87pxCDs+R1ye3Fu4Pw718CqDuLAhVhSK46xgaTfwq
# Ia1JMYNHlXdx3LEbS0scEJx3FMGdTy9alQgpECYxggQ4MIIENAIBATCBgzBvMQsw
# CQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cu
# ZGlnaWNlcnQuY29tMS4wLAYDVQQDEyVEaWdpQ2VydCBBc3N1cmVkIElEIENvZGUg
# U2lnbmluZyBDQS0xAhAKFT0IddbjKM4R9plQj7wRMAkGBSsOAwIaBQCgeDAYBgor
# BgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEE
# MBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBTu
# SL8u3ehmO40vBXsJE5qdUddDKzANBgkqhkiG9w0BAQEFAASCAQBGxSkriHkQoD6W
# B7hnhanpvx+AsD1JkkRsRWdLGRQ46mwU3K3QuZDBmeTUgzge6qm3WHtRUt9bzb0+
# KdxVuB1a2FugSHW673srHUe408ALap8NfGxTDiZDKDMG9QwJgP5TJvEID5RFWztS
# iQSKuuSV1I/GtmD2bmN0xg4qoXSN/IGD/vA2sQS7bVvdli/SnNH6RdURQcovq/sW
# PN2DQNukPcsxJo/cVzVzUH3/lTW1YugIEoaHXu48FPJOKjGC2IFfb1AR1yFc9Cp3
# 7yjsG0umPEPfEyCgPgW9bknozF2dKOHjS5GjSw4gnfxmd+Xj8hJeTHGUGVQ461HU
# haRk7S0noYICDzCCAgsGCSqGSIb3DQEJBjGCAfwwggH4AgEBMHYwYjELMAkGA1UE
# BhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2lj
# ZXJ0LmNvbTEhMB8GA1UEAxMYRGlnaUNlcnQgQXNzdXJlZCBJRCBDQS0xAhADi5bw
# cNniHlWlQmeS4cg6MAkGBSsOAwIaBQCgXTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
# AQcBMBwGCSqGSIb3DQEJBTEPFw0xMjA5MTYwMTMwMThaMCMGCSqGSIb3DQEJBDEW
# BBR4GX0j97Bowmku3VtkTGNHSXH5jzANBgkqhkiG9w0BAQEFAASCAQAJBcYeiqA0
# eGTz5XpIZ/jyNy5ODEqO3Zb44omM5tuU0oAeDnWBGcS2vswl/W0kmvK1rKR9uk2K
# knDTvkdPMD1QcpNYKmHGv6/1liGHWyu9QBGxNa34Vnsz7DH7NQVUTpZkqHI3xVcG
# uII4P37DLTRihTtFh0QwCg0Qj9p/0sihDUsVZTQAkwnf5cWMk4AenwqFeLDH4dBu
# OO6TKZUxuHfJ3r4uUdJZ6IcNAZ2Vy5k7v2WR8aeLGKpzWcVx3QTUfvgLImmT7/o6
# ykg0Ids2ikxmPnbeQY3f71ZR+UCbjdoOCIxNDCi2PwoKxbDmtn7RlcKCBkCkM4z1
# pzWM7aHQrI/Z
# SIG # End signature block
