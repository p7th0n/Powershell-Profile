
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

function mkdir($foldername) { 
    New-Item -ItemType Directory -Path $foldername
}

function ll() {
    Get-ChildItem | Format-Wide
}
