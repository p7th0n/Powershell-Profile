# posh-git is imported once via profile.ps1 (CurrentUserAllHosts), which runs before this file.
# Import-Module "C:\Users\Dave\Documents\WindowsPowerShell\Modules\posh-git\0.7.3\posh-git"
Import-Module posh-docker

#Import-Module oh-my-posh
# oh-my-posh.exe init pwsh | Invoke-Expression
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    $ompTheme = Join-Path $env:POSH_THEMES_PATH "catppuccin_mocha.omp.json"
    if (Test-Path -LiteralPath $ompTheme) {
        oh-my-posh init pwsh --config $ompTheme | Invoke-Expression
    } else {
        oh-my-posh init pwsh | Invoke-Expression
    }
}

Import-Module Get-ChildItemColor
# Import-Module PSReadLine
Import-Module Send-ToDrafts
# Import-Module Convertto-UnixLF

if ($host.name -eq "ConsoleHost")
{
    Import-Module PSReadline
}

# ############################# PSReadLine
Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
Set-PSReadLineOption -MaximumHistoryCount 4000
# history substring search
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Tab completion
Set-PSReadlineKeyHandler -Chord 'Shift+Tab' -Function Complete
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Catppuccin Mocha fzf colors: https://github.com/catppuccin/fzf/
$ENV:FZF_DEFAULT_OPTS = @"
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
--color=selected-bg:#494d64
--color=border:#6c7086,label:#cdd6f4
"@

# ############################# rbenv for Windows
$env:RBENV_ROOT = "C:\usr\local\ruby-on-windows"

# Not easy to download on Github?
# Use a custom mirror!
# $env:RBENV_USE_MIRROR = "https://abc.com/abc-<version>"

& "$env:RBENV_ROOT\rbenv\bin\rbenv.ps1" init

$PSDefaultParameterValues['*:Encoding'] = 'utf8'

# ############################# Aliases
Set-Alias ls Get-ChildItemColor -option AllScope -Force

Set-Alias dir Get-ChildItemColor -option AllScope -Force
Set-Alias which gcm
Set-Alias type Get-Content -option AllScope -Force

Set-Alias pbpaste Get-Clipboard
Set-Alias pbcopy Set-Clipboard

Set-Alias lzd lazydocker

Set-Alias k komorebic

Set-Alias v nvim

# Set-Alias ssh-agent "C:\Windows\System32\OpenSSH\ssh-agent.exe"
# Set-Alias ssh-add "C:\Windows\System32\OpenSSH\ssh-add.exe"
# Start-SshAgent -Quiet

# ############################# Function Alias for mkdir
function mkdir($foldername) { 
    New-Item -ItemType Directory -Path $foldername
}

# ############################# Function Alias for wide format directory list
function ll($path) {
    Get-ChildItem -Path $path | Sort-Object | Format-Wide
}

# $a = (Get-Host).UI.RawUI
# $a.BackgroundColor = $bc
# $a.ForegroundColor = $fc 

function dos2unix([String]$glob) {
<#
  .SYNOPSIS
  Implement Unix utility dos2unix in PowerShell
  https://github.com/PowerShell/Win32-OpenSSH/wiki/Dos2Unix---Text-file-format-converters

  .EXAMPLE
  dos2unix *.org
#>
  Get-ChildItem $glob | ForEach-Object { $x = get-content -raw -path $_.fullname; $x -replace "`r`n","`n" | set-content -path $_.fullname -Encoding UTF8 -NoNewline}
}

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
function Measure-Command2 ([ScriptBlock]$Expression, [int]$Samples = 1, [Switch]$Silent, [Switch]$Long) {
<#
.SYNOPSIS
  Runs the given script block and returns the execution duration.
  Discovered on StackOverflow. http://stackoverflow.com/questions/3513650/timing-a-commands-execution-in-powershell
  
.EXAMPLE
  Measure-Command2 { ping -n 1 google.com }
#>
  $timings = @()
  do {
    $sw = New-Object Diagnostics.Stopwatch
    if ($Silent) {
      $sw.Start()
      $null = & $Expression
      $sw.Stop()
      Write-Host "." -NoNewLine
    }
    else {
      $sw.Start()
      & $Expression
      $sw.Stop()
    }
    $timings += $sw.Elapsed
    
    $Samples--
  }
  while ($Samples -gt 0)
  
  Write-Host
  
  $stats = $timings | Measure-Object -Average -Minimum -Maximum -Property Ticks
  
  # Print the full timespan if the $Long switch was given.
  if ($Long) {  
    Write-Host "Avg: $((New-Object System.TimeSpan $stats.Average).ToString())"
    Write-Host "Min: $((New-Object System.TimeSpan $stats.Minimum).ToString())"
    Write-Host "Max: $((New-Object System.TimeSpan $stats.Maximum).ToString())"
  }
  else {
    # Otherwise just print the milliseconds which is easier to read.
    Write-Host "Avg: $((New-Object System.TimeSpan $stats.Average).TotalMilliseconds)ms"
    Write-Host "Min: $((New-Object System.TimeSpan $stats.Minimum).TotalMilliseconds)ms"
    Write-Host "Max: $((New-Object System.TimeSpan $stats.Maximum).TotalMilliseconds)ms"
  }
}

Set-Alias time Measure-Command2

# unix top
function top {
  
 While(1) {ps | sort -des cpu | select -f 15 | ft -a; sleep 1; cls}
}

function touch {

 New-Item -ItemType File -Path $args[0]

}

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
Import-Module "$ChocolateyProfile"
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

# ############################# start startship prompt
# Invoke-Expression (&starship init powershell)

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# WezTerm Integration
$env:WEZTERM_SHELL_INTEGRATION = "1"

$scriptblock = {
    param($wordToComplete, $commandAst, $cursorPosition)
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
    $Env:_OPEN_WEBUI_COMPLETE = ""
    $Env:_TYPER_COMPLETE_ARGS = ""
    $Env:_TYPER_COMPLETE_WORD_TO_COMPLETE = ""
}
Register-ArgumentCompleter -Native -CommandName open-webui -ScriptBlock $scriptblock

# ===================
# Yazi
$Env:YAZI_FILE_ONE = "C:\Program Files\Git\usr\bin\file.exe"
$Env:YAZI_CONFIG_HOME = "$Env:USERPROFILE\.config\yazi"
function y {
	$tmp = (New-TemporaryFile).FullName
	yazi.exe @args --cwd-file="$tmp"
	$cwd = Get-Content -Path $tmp -Encoding UTF8
	if ($cwd -and $cwd -ne $PWD.Path -and (Test-Path -LiteralPath $cwd -PathType Container)) {
		Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
	}
	Remove-Item -Path $tmp
}

