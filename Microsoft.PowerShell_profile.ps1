# ############################# rbenv for Windows
$env:RBENV_ROOT = "C:\usr\local\ruby-on-windows"

# Not easy to download on Github?
# Use a custom mirror!
# $env:RBENV_USE_MIRROR = "https://abc.com/abc-<version>"

if (Test-Path -LiteralPath "$env:RBENV_ROOT\rbenv\bin\rbenv.ps1") {
    & "$env:RBENV_ROOT\rbenv\bin\rbenv.ps1" init
}

# ############################# Aliases
Set-Alias pbpaste Get-Clipboard
Set-Alias pbcopy Set-Clipboard

Set-Alias lzd lazydocker

Set-Alias k komorebic

Set-Alias v nvim

# Set-Alias ssh-agent "C:\Windows\System32\OpenSSH\ssh-agent.exe"
# Set-Alias ssh-add "C:\Windows\System32\OpenSSH\ssh-add.exe"
# Start-SshAgent -Quiet

function Get-PublicIp() {
 <#
  .SYNOPSIS
  Get public IP address
  http://woshub.com/get-external-ip-powershell/

  .EXAMPLE
  Get-PublicIp
#>
  (Invoke-Webrequest https://ipinfo.io/ip).content
}

# unix top
function top {
    while ($true) {
        Get-Process | Sort-Object -Descending CPU | Select-Object -First 15 | Format-Table -AutoSize
        Start-Sleep -Seconds 1
        Clear-Host
    }
}

function touch {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Path)
    foreach ($p in $Path) {
        if (Test-Path -LiteralPath $p) {
            (Get-Item -LiteralPath $p).LastWriteTime = Get-Date
        } else {
            New-Item -ItemType File -Path $p | Out-Null
        }
    }
}

# ############################# Function to Restart a Process
function Restart-Process {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name
    )

    try {
        $proc = Get-Process -Name $Name -ErrorAction Stop
        $path = $proc.Path

        Write-Host "Stopping process: $Name"
        $proc | Stop-Process -Force

        Write-Host "Starting process: $Name"
        Start-Process -FilePath $path

        Write-Host "Process restarted successfully"
    } catch {
        Write-Error "Failed to restart process: $_"
    }
}

# ############################# start starship prompt
$env:STARSHIP_CONFIG = "$HOME\.config\starship\starship.toml"
Invoke-Expression (&starship init powershell)

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# WezTerm Integration
$env:WEZTERM_SHELL_INTEGRATION = "1"

if (Get-Command open-webui -ErrorAction SilentlyContinue) {
    $scriptblock = {
        param($wordToComplete, $commandAst, $cursorPosition)
        try {
            $Env:_OPEN_WEBUI_COMPLETE = "complete_powershell"
            $Env:_TYPER_COMPLETE_ARGS = $commandAst.ToString()
            $Env:_TYPER_COMPLETE_WORD_TO_COMPLETE = $wordToComplete
            open-webui | ForEach-Object {
                $commandArray = $_ -Split ":::"
                $command = $commandArray[0]
                $helpString = $commandArray[1]
                [System.Management.Automation.CompletionResult]::new(
                    $command, $command, 'ParameterValue', $helpString)
            }
        } finally {
            $Env:_OPEN_WEBUI_COMPLETE = ""
            $Env:_TYPER_COMPLETE_ARGS = ""
            $Env:_TYPER_COMPLETE_WORD_TO_COMPLETE = ""
        }
    }
    Register-ArgumentCompleter -Native -CommandName open-webui -ScriptBlock $scriptblock
}

# ===================
# Yazi
$Env:YAZI_FILE_ONE = "C:\Program Files\Git\usr\bin\file.exe"
$Env:YAZI_CONFIG_HOME = "$Env:USERPROFILE\.config\yazi"
function y {
	if (-not (Get-Command yazi.exe -ErrorAction SilentlyContinue)) {
		Write-Error "yazi is not installed or not on PATH."
		return
	}
	$tmp = (New-TemporaryFile).FullName
	try {
		yazi.exe @args --cwd-file="$tmp"
		$cwd = Get-Content -Path $tmp -Encoding UTF8
		if ($cwd -and $cwd -ne $PWD.Path -and (Test-Path -LiteralPath $cwd -PathType Container)) {
			Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
		}
	} finally {
		Remove-Item -Path $tmp -ErrorAction SilentlyContinue
	}
}
