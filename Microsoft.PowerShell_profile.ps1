Import-Module posh-git
# Import-Module "C:\Users\Dave\Documents\WindowsPowerShell\Modules\posh-git\0.7.3\posh-git"
Import-Module posh-docker
Import-Module oh-my-posh
Import-Module Get-ChildItemColor
Import-Module PSReadLine

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

# ############################# Powershell Prompt
$GitPromptSettings.DefaultPromptSuffix = '`n$(''>'' * ($nestedPromptLevel + 1)) '
$GitPromptSettings.DefaultPromptPrefix = '[$(hostname)] '
$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true

Set-Theme Paradox
# Set-Theme Powerline
$GitPromptSettings.DefaultForegroundColor = 'Black'
# Hide your username@domain when not in a virtual machine for the Agnoster, Fish, Honukai, Paradox and Sorin themes:
$DefaultUser = 'Dave'

# ############################# Aliases
Set-Alias ls Get-ChildItemColor -option AllScope -Force

Set-Alias dir Get-ChildItemColor -option AllScope -Force
Set-Alias which gcm
Set-Alias type Get-Content -option AllScope -Force

Set-Alias ssh-agent "C:\Windows\System32\OpenSSH\ssh-agent.exe"
Set-Alias ssh-add "C:\Windows\System32\OpenSSH\ssh-add.exe"
Start-SshAgent -Quiet


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
  Get-ChildItem $glob | ForEach-Object { $x = get-content -raw -path $_.fullname; $x -replace "`r`n","`n" | set-content -path $_.fullname }
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
