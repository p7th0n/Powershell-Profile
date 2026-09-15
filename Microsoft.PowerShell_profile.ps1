Import-Module posh-git
# Import-Module "C:\Users\Dave\Documents\WindowsPowerShell\Modules\posh-git\0.7.3\posh-git"
Import-Module posh-docker

#Import-Module oh-my-posh
# oh-my-posh.exe init pwsh | Invoke-Expression
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\catppuccin_mocha.omp.json" | Invoke-Expression

Import-Module Get-ChildItemColor
# Import-Module PSReadLine
Import-Module Send-ToDrafts
# Import-Module Convertto-UnixLF

if ($host.name -eq "ConsoleHost")
{
    Import-Module PSReadline
}

# ############################# Fix Code Windows\System32\OpenSSH\ssh-agent
chcp 1252

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

# ############################# Powershell Prompt
$GitPromptSettings.DefaultPromptSuffix = '`n$(''>'' * ($nestedPromptLevel + 1)) '
$GitPromptSettings.DefaultPromptPrefix = '[$(hostname)] '
$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true

# Set-Theme Paradox
# Set-Theme Powerline
# Set-Theme catppuccin_mocha
# Set-PoshPrompt -Theme "catppuccin_mocha"

$GitPromptSettings.DefaultForegroundColor = 'Black'
# Hide your username@domain when not in a virtual machine for the Agnoster, Fish, Honukai, Paradox and Sorin themes:

# Modified from the official Catppuccin fzf configuration at: https://github.com/catppuccin/fzf/
$ENV:FZF_DEFAULT_OPTS = @"
--color=bg+:$($Flavor.Surface0),bg:$($Flavor.Base),spinner:$($Flavor.Rosewater)
--color=hl:$($Flavor.Red),fg:$($Flavor.Text),header:$($Flavor.Red)
--color=info:$($Flavor.Mauve),pointer:$($Flavor.Rosewater),marker:$($Flavor.Rosewater)
--color=fg+:$($Flavor.Text),prompt:$($Flavor.Mauve),hl+:$($Flavor.Red)
--color=border:$($Flavor.Surface2)
"@

# ############################# rbenv for Windows
$env:RBENV_ROOT = "C:\usr\local\ruby-on-windows"

# Not easy to download on Github?
# Use a custom mirror!
# $env:RBENV_USE_MIRROR = "https://abc.com/abc-<version>"

& "$env:RBENV_ROOT\rbenv\bin\rbenv.ps1" init

$PSDefaultParameterValues['*:Encoding'] = 'utf8'

$DefaultUser = 'Dave'

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

# ############################# Function for Removing a Service
function Remove-Service($service) {
    Get-WmiObject -Class Win32_Service -Filter "Name='$service'"
    Write-Host 'Service: ' + $service
    $service.delete()
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


# Path to the patterns directory
$patternsPath = Join-Path $HOME ".config/fabric/patterns"
foreach ($patternDir in Get-ChildItem -Path $patternsPath -Directory) {
    $patternName = $patternDir.Name

    # Dynamically define a function for each pattern
    $functionDefinition = @"

function $patternName {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = `$true)]
        [string] `$InputObject,

        [Parameter(ValueFromRemainingArguments = `$true)]
        [String[]] `$patternArgs
    )

    begin {
        # Initialize an array to collect pipeline input
        `$collector = @()
    }

    process {
        # Collect pipeline input objects
        if (`$InputObject) {
            `$collector += `$InputObject
        }
    }

    end {
        # Join all pipeline input into a single string, separated by newlines
        `$pipelineContent = `$collector -join "`n"

        # If there's pipeline input, include it in the call to fabric
        if (`$pipelineContent) {
            `$pipelineContent | fabric --pattern $patternName `$patternArgs
        } else {
            # No pipeline input; just call fabric with the additional args
            fabric --pattern $patternName `$patternArgs
        }
    }
}
"@
    # Add the function to the current session
    Invoke-Expression $functionDefinition
}

# Define the 'yt' function as well
function yt {
    [CmdletBinding()]
    param(
        [Parameter()]
        [Alias("timestamps")]
        [switch]$t,

        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [string]$videoLink
    )

    begin {
        $transcriptFlag = "--transcript"
        if ($t) {
            $transcriptFlag = "--transcript-with-timestamps"
        }
    }

    process {
        if (-not $videoLink) {
            Write-Error "Usage: yt [-t | --timestamps] youtube-link"
            return
        }
    }

    end {
        if ($videoLink) {
            # Execute and allow output to flow through the pipeline
            fabric -y $videoLink $transcriptFlag
        }
    }
}

function fpat {
fabric --listpatterns | fzf | ForEach-Object { 
    if ($_ -ne $null) { 
        $_ 
    }
}
}

# =============================================================================
#
# Utility functions for zoxide.
#

# Call zoxide binary, returning the output as UTF-8.
function global:__zoxide_bin {
    $encoding = [Console]::OutputEncoding
    try {
        [Console]::OutputEncoding = [System.Text.Utf8Encoding]::new()
        $result = zoxide @args
        return $result
    } finally {
        [Console]::OutputEncoding = $encoding
    }
}

# pwd based on zoxide's format.
function global:__zoxide_pwd {
    $cwd = Get-Location
    if ($cwd.Provider.Name -eq "FileSystem") {
        $cwd.ProviderPath
    }
}

# cd + custom logic based on the value of _ZO_ECHO.
function global:__zoxide_cd($dir, $literal) {
    $dir = if ($literal) {
        Set-Location -LiteralPath $dir -Passthru -ErrorAction Stop
    } else {
        if ($dir -eq '-' -and ($PSVersionTable.PSVersion -lt 6.1)) {
            Write-Error "cd - is not supported below PowerShell 6.1. Please upgrade your version of PowerShell."
        }
        elseif ($dir -eq '+' -and ($PSVersionTable.PSVersion -lt 6.2)) {
            Write-Error "cd + is not supported below PowerShell 6.2. Please upgrade your version of PowerShell."
        }
        else {
            Set-Location -Path $dir -Passthru -ErrorAction Stop
        }
    }
}

# =============================================================================
#
# Hook configuration for zoxide.
#

# Hook to add new entries to the database.
$global:__zoxide_oldpwd = __zoxide_pwd
function global:__zoxide_hook {
    $result = __zoxide_pwd
    if ($result -ne $global:__zoxide_oldpwd) {
        if ($null -ne $result) {
            zoxide add -- $result
        }
        $global:__zoxide_oldpwd = $result
    }
}

# Initialize hook.
$global:__zoxide_hooked = (Get-Variable __zoxide_hooked -ErrorAction SilentlyContinue -ValueOnly)
if ($global:__zoxide_hooked -ne 1) {
    $global:__zoxide_hooked = 1
    $global:__zoxide_prompt_old = $function:prompt

    function global:prompt {
        if ($null -ne $__zoxide_prompt_old) {
            & $__zoxide_prompt_old
        }
        $null = __zoxide_hook
    }
}

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

# Jump to a directory using only keywords.
function global:__zoxide_z {
    if ($args.Length -eq 0) {
        __zoxide_cd ~ $true
    }
    elseif ($args.Length -eq 1 -and ($args[0] -eq '-' -or $args[0] -eq '+')) {
        __zoxide_cd $args[0] $false
    }
    elseif ($args.Length -eq 1 -and (Test-Path $args[0] -PathType Container)) {
        __zoxide_cd $args[0] $true
    }
    else {
        $result = __zoxide_pwd
        if ($null -ne $result) {
            $result = __zoxide_bin query --exclude $result -- @args
        }
        else {
            $result = __zoxide_bin query -- @args
        }
        if ($LASTEXITCODE -eq 0) {
            __zoxide_cd $result $true
        }
    }
}

# Jump to a directory using interactive search.
function global:__zoxide_zi {
    $result = __zoxide_bin query -i -- @args
    if ($LASTEXITCODE -eq 0) {
        __zoxide_cd $result $true
    }
}

# =============================================================================
#
# Commands for zoxide. Disable these using --no-cmd.
#

Set-Alias -Name z -Value __zoxide_z -Option AllScope -Scope Global -Force
Set-Alias -Name zi -Value __zoxide_zi -Option AllScope -Scope Global -Force

# =============================================================================
#
# To initialize zoxide, add this to your configuration (find it by running
# `echo $profile` in PowerShell):
#
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# WezTerm Integration
$env:WEZTERM_SHELL_INTEGRATION = "1"

Import-Module PSReadLine
Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
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

