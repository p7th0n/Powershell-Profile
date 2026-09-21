# ############################# CurrentUserAllHosts
# Runs before Microsoft.PowerShell_profile.ps1 (console) and Microsoft.VSCode_profile.ps1
# (VS Code) for every PowerShell 7 host. Anything genuinely shared between those two files
# belongs here instead of being duplicated in both - see powershell_config_issues.md 3.3.

Import-Module posh-git
Import-Module posh-docker

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
#     Get-ChildItem -Path $path | Sort-Object | Format-Wide
     eza -l -h --git --icons $path
 }

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}
