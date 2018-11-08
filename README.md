# Powershell profile

This is my Powershell profile.

## Getting Started

* Installation process: clone or copy to $env:USERPROFILE\Documents\WindowsPowerShell.  Or just cherry pick pieces.

```powershell

# run as administrator

Set-ExecutionPolicy RemoteSigned

```

* Software dependencies: Windows 10, 8 or 7
* Read about Posh-Git if you are a Git user -- [GitHub](https://github.com/dahlbyk/posh-git), [Better Git with PowerShell - You've been Haacked](https://haacked.com/archive/2011/12/13/better-git-with-powershell.aspx/)
* The Profile is a good place for command line aliases for commands not included in Powershell. Examples are like Windows cmd commands, shortened commands to save on typing.
* For longer aliases or commands, Powershell functions work well.  Look at **Remove-Service** in the Profile for an example of a _missing_ Powershell command.
* Keep in mind -- if the Profile gets too bloated Powershell start up is slow. Running _ngen.ps1_ can shorten the PowerShell startup as well as other dotNet apps.
* [Approved Verbs for PowerShell Commands](https://docs.microsoft.com/en-us/powershell/developer/cmdlet/approved-verbs-for-windows-powershell-commands)

## Modules

```powershell

# run Get-InstalledModule for a list of installed modules

Get-InstalledModule

# ######## sample output ########
#
# Version              Name                                Repository           Description
# -------              ----                                ----------           -----------
# 1.0.1.2              newtonsoft.json                     PSGallery            Serialize/Deserialize Json
# 2.0.223              oh-my-posh                          PSGallery            Theming capabilities
# 1.1.7.2              PackageManagement                   PSGallery            PackageManagement
# 0.7.1                posh-docker                         PSGallery            Powershell tab completion
# 0.7.3                posh-git                            PSGallery            Provides prompt with Git status
# 1.6.6                PowerShellGet                       PSGallery            PowerShell module with commands
#

# run Set-PSRepository to trust PSGallery

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

# run Install-Module to install the modules

Install-Module posh-git

# run to update modules

Update-Module PowerShellGet

```

* [PowerShellGet - GitHub](https://github.com/PowerShell/PowerShellGet), [PowerShellGet - Powershell Gallery](https://www.powershellgallery.com/packages/PowerShellGet/1.6.7)
* [newtonsoft.json - Powershell Gallery](https://www.powershellgallery.com/packages/newtonsoft.json/1.0.1/Content/newtonsoft.json.psm1)
* [oh-my-posh - GitHub](https://github.com/JanDeDobbeleer/oh-my-posh)
* [posh-docker - GitHub](https://github.com/samneirinck/posh-docker), [posh-docker - Powershell Gallery](https://www.powershellgallery.com/packages/posh-docker/0.6.0)
* [posh-git - GitHub](https://github.com/dahlbyk/posh-git), [posh-git - Powershell Gallery](https://www.powershellgallery.com/packages/posh-git/0.7.1)

## Contribute

* Provide feedback or suggestions.
