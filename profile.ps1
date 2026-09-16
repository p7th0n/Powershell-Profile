# ############################# CurrentUserAllHosts
# Runs before Microsoft.PowerShell_profile.ps1 (console) and Microsoft.VSCode_profile.ps1
# (VS Code) for every PowerShell 7 host. Anything genuinely shared between those two files
# belongs here instead of being duplicated in both - see powershell_config_issues.md 3.3.

Import-Module posh-git
Import-Module posh-docker

if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    $ompTheme = Join-Path $env:POSH_THEMES_PATH "catppuccin_mocha.omp.json"
    if (Test-Path -LiteralPath $ompTheme) {
        oh-my-posh init pwsh --config $ompTheme | Invoke-Expression
    } else {
        oh-my-posh init pwsh | Invoke-Expression
    }
}

Import-Module Get-ChildItemColor
Import-Module Send-ToDrafts

Import-Module PSReadLine -ErrorAction SilentlyContinue

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

$PSDefaultParameterValues['*:Encoding'] = 'utf8'

# ############################# Aliases
Set-Alias ls Get-ChildItemColor -option AllScope -Force
Set-Alias dir Get-ChildItemColor -option AllScope -Force
Set-Alias which gcm
Set-Alias type Get-Content -option AllScope -Force

# ############################# Function Alias for wide format directory list
function ll($path) {
    Get-ChildItem -Path $path | Sort-Object | Format-Wide
}

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

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}
