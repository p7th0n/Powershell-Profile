# PowerShell profile

This is my PowerShell 7 profile.

## Getting started

* This repo is the `CurrentUser` profile source for PowerShell 7+, but it doesn't live inside the
  OneDrive-synced profile folder itself - Windows won't allow that folder to be replaced with a
  symlink. Instead the repo lives at `C:\Users\<you>\Documents\Powershell`, and the OneDrive-synced
  `Documents2\PowerShell` folder (where `$PROFILE` actually resolves) is populated with per-file
  symlinks back into it. See [PowerShell Symlink Fix](https://claude.ai/artifact/SMGS1tnE3RAz5gbb1fzsdW)
  for why and how. Clone this repo somewhere outside OneDrive and symlink its contents into place,
  or cherry-pick pieces into your own profile.
* Windows PowerShell 5.1 is a separate profile tree
  (`$env:USERPROFILE\Documents\WindowsPowerShell`) and is not covered by this repo.
* Script execution policy is set to `RemoteSigned` via `powershell.config.json` in this repo -
  no manual `Set-ExecutionPolicy` needed after cloning.
* The profile loads in two stages: `profile.ps1` (`CurrentUserAllHosts`) runs first for every
  host and holds everything shared; `Microsoft.PowerShell_profile.ps1` (console) and
  `Microsoft.VSCode_profile.ps1` (VS Code) run after it and hold only what's specific to that
  host.
* [Approved Verbs for PowerShell Commands](https://docs.microsoft.com/en-us/powershell/developer/cmdlet/approved-verbs-for-windows-powershell-commands)

## Modules and tools

Modules actually imported by this profile (`Modules/`, gitignored except for the two written
for this repo):

* [posh-git](https://github.com/dahlbyk/posh-git) - prompt/tab-completion for git
* [posh-docker](https://github.com/samneirinck/posh-docker) - tab-completion for docker
* `PSReadLine` - ships with PowerShell; imported explicitly for the history/key-handler config
* `Get-ChildItemColor` (this repo, `Modules/Get-ChildItemColor/`) - colorized `ls`/`dir`
* `Send-ToDrafts` (this repo, `Modules/Send-ToDrafts/`)

```powershell
# install the PSGallery ones
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module posh-git, posh-docker
```

External tools the profile shells out to, all guarded with `Get-Command`/`Test-Path` so a
missing one doesn't break the whole profile: [oh-my-posh](https://ohmyposh.dev/) (prompt theming,
standalone binary - not a PowerShell module), [zoxide](https://github.com/ajeetdsouza/zoxide)
(`z`/`zi`), [fzf](https://github.com/junegunn/fzf), [yazi](https://yazi-rs.github.io/) (`y`),
[rbenv-for-Windows](https://github.com/godfat/rbenv-for-Windows), and the Chocolatey PowerShell
profile helper if Chocolatey is installed.

## Contribute

* Provide feedback or suggestions.
