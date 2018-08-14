
Import-Module posh-docker
Import-Module Get-ChildItemColor

if ($host.name -eq "ConsoleHost")
{
    Import-Module PSReadline
}

$GitPromptSettings.DefaultPromptSuffix = '`n$(''>'' * ($nestedPromptLevel + 1)) '
$GitPromptSettings.DefaultPromptPrefix = '[$(hostname)] '
$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true

Set-Alias ls Get-ChildItemColor -option AllScope -Force
# Set-Alias ll Get-ChildItem -option AllScope -Force | Format-Wide

Set-Alias dir Get-ChildItemColor -option AllScope -Force
Set-Alias which gcm
Set-Alias type Get-Content -option AllScope -Force

Import-Module "C:\Users\Dave\Documents\WindowsPowerShell\Modules\posh-git\0.7.3\posh-git"
Set-Alias ssh-agent "C:\Windows\System32\OpenSSH\ssh-agent.exe"
Set-Alias ssh-add "C:\Windows\System32\OpenSSH\ssh-add.exe"
Start-SshAgent -Quiet


function mkdir($foldername) { 
    New-Item -ItemType Directory -Path $foldername
}

function ll() {
    Get-ChildItem | Format-Wide
}

function Remove-Service($service) {
    Get-WmiObject -Class Win32_Service -Filter "Name='$service'"
    Write-Host 'Service: ' + $service
    $service.delete()
}

# $a = (Get-Host).UI.RawUI
# $a.BackgroundColor = $bc
# $a.ForegroundColor = $fc 

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
