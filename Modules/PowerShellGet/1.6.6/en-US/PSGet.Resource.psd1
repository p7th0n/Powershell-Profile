#########################################################################################
#
# Copyright (c) Microsoft Corporation. All rights reserved.
#
# Localized PSGet.Resource.psd1
#
#########################################################################################

ConvertFrom-StringData @'
###PSLOC
        InstallModulewhatIfMessage=Version '{1}' of module '{0}'
        InstallScriptwhatIfMessage=Version '{1}' of script '{0}'
        UpdateModulewhatIfMessage=Version '__OLDVERSION__' of module '{0}', updating to version '{1}'
        UpdateScriptwhatIfMessage=Version '__OLDVERSION__' of script '{0}', updating to version '{1}'
        PublishModulewhatIfMessage=Version '{0}' of module '{1}'
        PublishScriptwhatIfMessage=Version '{0}' of script '{1}'
        NewScriptFileInfowhatIfMessage=Creating the '{0}' PowerShell Script file
        UpdateScriptFileInfowhatIfMessage=Updating the '{0}' PowerShell Script file
        NameShouldNotContainWildcardCharacters=The specified name '{0}' should not contain any wildcard characters, please correct it and try again.
        AllVersionsCannotBeUsedWithOtherVersionParameters=You cannot use the parameter AllVersions with RequiredVersion, MinimumVersion or MaximumVersion in the same command.
        VersionRangeAndRequiredVersionCannotBeSpecifiedTogether=You cannot use the parameters RequiredVersion and either MinimumVersion or MaximumVersion in the same command. Specify only one of these parameters in your command.
        RequiredVersionAllowedOnlyWithSingleModuleName=The RequiredVersion parameter is allowed only when a single module name is specified as the value of the Name parameter, without any wildcard characters.
        MinimumVersionIsGreaterThanMaximumVersion=The specified MinimumVersion '{0}' is greater than the specified MaximumVersion '{1}'.
        AllowPrereleaseRequiredToUsePrereleaseStringInVersion=The '-AllowPrerelease' parameter must be specified when using the Prerelease string in MinimumVersion, MaximumVersion, or RequiredVersion. 
        InstallModuleNeedsCurrentUserScopeParameterForNonAdminUser=Administrator rights are required to install modules in '{0}'. Log on to the computer with an account that has Administrator rights, and then try again, or install '{1}' by adding "-Scope CurrentUser" to your command. You can also try running the Windows PowerShell session with elevated rights (Run as Administrator).
        InstallScriptNeedsCurrentUserScopeParameterForNonAdminUser=Administrator rights are required to install scripts in '{0}'. Log on to the computer with an account that has Administrator rights, and then try again, or install '{1}' by adding "-Scope CurrentUser" to your command. You can also try running the Windows PowerShell session with elevated rights (Run as Administrator).
        AdministratorRightsNeededOrSpecifyCurrentUserScope=Administrator rights are required to install or update. Log on to the computer with an account that has Administrator rights, and then try again, or install by adding "-Scope CurrentUser" to your command. You can also try running the Windows PowerShell session with elevated rights (Run as Administrator).
        VersionParametersAreAllowedOnlyWithSingleName=The RequiredVersion, MinimumVersion, MaximumVersion, AllVersions or AllowPrerelease parameters are allowed only when you specify a single name as the value of the Name parameter, without any wildcard characters.
        PathIsNotADirectory=The specified path '{0}' is not a valid directory.
        ModuleAlreadyInstalled=Version '{0}' of module '{1}' is already installed at '{2}'. To delete version '{3}' and install version '{4}', run Install-Module, and add the -Force parameter.
        ScriptAlreadyInstalled=Version '{0}' of script '{1}' is already installed at '{2}'. To delete version '{3}' and install version '{4}', run Install-Script, and add the -Force parameter.
        CommandAlreadyAvailable=A command with name '{0}' is already available on this system. This script '{0}' may override the existing command. If you still want to install this script '{0}', use -Force parameter.
        ModuleAlreadyInstalledSxS=Version '{0}' of module '{1}' is already installed at '{2}'. To install version '{3}', run Install-Module and add the -Force parameter, this command will install version '{5}' side-by-side with version '{4}'.
        ModuleAlreadyInstalledVerbose=Version '{0}' of module '{1}' is already installed at '{2}'.
        ScriptAlreadyInstalledVerbose=Version '{0}' of script '{1}' is already installed at '{2}'.
        ModuleWithRequiredVersionAlreadyInstalled=Version '{0}' of module '{1}' is already installed at '{2}'. To reinstall this version '{3}', run Install-Module or Updated-Module cmdlet with the -Force parameter.
        InvalidPSModule=The module '{0}' cannot be installed or updated because it is not a properly-formed module.
        InvalidPowerShellScriptFile=The script '{0}' cannot be installed or updated because it is not a properly-formed script.
        InvalidAuthenticodeSignature=The module '{0}' cannot be installed or updated because the Authenticode signature for the file '{1}' is not valid.
        ModuleNotInstalledOnThisMachine=Module '{0}' was not updated because no valid module was found in the module directory. Verify that the module is located in the folder specified by $env:PSModulePath.
        ScriptNotInstalledOnThisMachine=Script '{0}' was not updated because no valid script was found in the script directories '{1}' and '{2}'.
        AdminPrivilegesRequiredForUpdate=Module '{0}' (installed at'{1}') cannot be updated because Administrator rights are required to change that directory. Log on to the computer with an account that has Administrator rights, and then try again. You can also try running the Windows PowerShell session with elevated rights (Run as Administrator).
        AdminPrivilegesRequiredForScriptUpdate=Script '{0}' (installed at'{1}') cannot be updated because Administrator rights are required to change that script. Log on to the computer with an account that has Administrator rights, and then try again. You can also try running the Windows PowerShell session with elevated rights (Run as Administrator).
        ModuleNotInstalledUsingPowerShellGet=Module '{0}' was not installed by using Install-Module, so it cannot be updated.
        ScriptNotInstalledUsingPowerShellGet=Script '{0}' was not installed by using Install-Script, so it cannot be updated.
        DownloadingModuleFromGallery=Downloading module '{0}' with version '{1}' from the repository '{2}'.
        DownloadingScriptFromGallery=Downloading script '{0}' with version '{1}' from the repository '{2}'.
        NoUpdateAvailable=No updates were found for module '{0}'.
        NoScriptUpdateAvailable=No updates were found for module '{0}'.
        FoundModuleUpdate=An update for the module '{0}' was found with version '{1}'.
        FoundScriptUpdate=An update for the script '{0}' was found with version '{1}'.
        InvalidPSModuleDuringUpdate= Module '{0}' was not updated because the module in the repository '{1}' is not a valid Windows PowerShell module.
        ModuleGotUpdated=Module '{0}' has been updated successfully.
        TestingModuleInUse=Testing if the module to update is in use.
        ModuleDestination= The specified module will be installed in '{0}'.
        ScriptDestination= The specified script will be installed in '{0}' and its dependent modules will be installed in '{1}'.
        ModuleIsInUse=Module '{0}' is in currently in use or you don't have the required permissions.
        ModuleInstalledSuccessfully=Module '{0}' was installed successfully to path '{1}'.
        ModuleSavedSuccessfully=Module '{0}' was saved successfully to path '{1}'.
        ScriptInstalledSuccessfully=Script '{0}' was installed successfully to path '{1}'.
        ScriptSavedSuccessfully=Script '{0}' was saved successfully to path '{1}'.
        CheckingForModuleUpdate= Checking for updates for module '{0}'.
        CheckingForScriptUpdate= Checking for updates for script '{0}'.
        ModuleInUseWithProcessDetails=The version '{0}' of module '{1}' is currently in use. Retry the operation after closing the following applications: '{2}'.
        ModuleVersionInUse=The version '{0}' of module '{1}' is currently in use. Retry the operation after closing the applications.
        ModuleNotAvailableLocally=The specified module '{0}' was not published because no module with that name was found in any module directory.
        InvalidModulePathToPublish=The specified module with path '{0}' was not published because no valid module was found with that path.
        ModuleWithRequiredVersionNotAvailableLocally= The specified module '{0}' with version '{1}' was not published because no module with that name and version was found in any module directory.        
        AmbiguousModuleName=Modules with the name '{0}' are available under multiple paths. Add the -RequiredVersion parameter or the -Path parameter to specify the module to publish.
        AmbiguousModulePath=Multiple versions are available under the specified module path '{0}'. Specify the full path to the module to be published.
        PublishModuleLocation=Module '{0}' was found in '{1}'.
        InvalidModuleToPublish=Module '{0}' cannot be published because it does not have a module manifest file. Run New-ModuleManifest -Path <PathName> to create a module manifest with metadata before publishing.
        MissingRequiredManifestKeys=Module '{0}' cannot be published because it is missing required metadata. Verify that the module manifest specifies Description and Author.
        InvalidCharactersInPrereleaseString=The Prerelease string '{0}' contains invalid characters. Please ensure that only characters 'a-zA-Z0-9' and possibly hyphen ('-') at the beginning are in the Prerelease string.
        IncorrectVersionPartsCountForPrereleaseStringUsage=Version '{0}' must have exactly 3 parts for a Prerelease string to be used.
        ModuleVersionShouldBeGreaterThanGalleryVersion=Module '{0}' with version '{1}' cannot be published. The version must exceed the current version '{2}' that exists in the repository '{3}', or you must specify -Force.
        ModuleVersionIsAlreadyAvailableInTheGallery=The module '{0}' with version '{1}' cannot be published as the current version '{2}' is already available in the repository '{3}'.
        CouldNotInstallNuGetProvider=NuGet provider is required to interact with NuGet-based repositories. Please ensure that '{0}' or newer version of NuGet provider is installed.
        CouldNotInstallNuGetExe=NuGet.exe version '{0}' or newer, or dotnet command version '{1}' or newer is required to interact with NuGet-based repositories. Please ensure that NuGet.exe or dotnet command is available under one of the paths specified in PATH environment variable value.
        CouldNotUpgradeNuGetExe=NuGet.exe version '{0}' or newer, or dotnet command version '{1}' or newer is required to interact with NuGet-based repositories. Please ensure that required version of NuGet.exe or dotnet command is available under one of the paths specified in PATH environment variable value.
        CouldNotFindDotnetCommand=For publish operations, dotnet command version '{0}' or newer is required to interact with the NuGet-based repositories. Please ensure that dotnet command version '{0}' or newer is installed and available under one of the paths specified in PATH environment variable value. You can also install the dotnet command by following the instructions specified at '{1}'.
        CouldNotInstallNuGetBinaries2=PowerShellGet requires NuGet.exe (or dotnet command) and NuGet provider version '{0}' or newer to interact with the NuGet-based repositories. Please ensure that '{0}' or newer version of NuGet provider is installed and NuGet.exe (or dotnet command) is available under one of the paths specified in PATH environment variable value.        
        InstallNugetBinariesUpgradeShouldContinueQuery=This version of PowerShellGet requires minimum version '{0}' of NuGet.exe and minimum version '{1}' of NuGet provider to publish an item to NuGet-based repositories. The NuGet provider must be available in '{2}' or '{3}'. You can also install the NuGet provider by running 'Install-PackageProvider -Name NuGet -MinimumVersion {0} -Force'. NuGet.exe must be available in '{4}' or '{5}', or under one of the paths specified in PATH environment variable value. NuGet.exe can be downloaded from https://aka.ms/psget-nugetexe. For more information, see https://go.microsoft.com/fwlink/?linkid=875534. Do you want PowerShellGet to upgrade NuGet.exe to the latest version and install the NuGet provider now?
        InstallNuGetBinariesShouldContinueQuery=This version of PowerShellGet requires minimum version '{0}' of NuGet.exe and minimum version '{1}' of NuGet provider to publish an item to NuGet-based repositories. The NuGet provider must be available in '{3}' or '{3}'. You can also install the NuGet provider by running 'Install-PackageProvider -Name NuGet -MinimumVersion {0} -Force'. NuGet.exe must be available in '{4}' or '{5}', or under one of the paths specified in PATH environment variable value. NuGet.exe can be downloaded from https://aka.ms/psget-nugetexe. For more information, see https://go.microsoft.com/fwlink/?linkid=875534. Do you want PowerShellGet to install both the latest NuGet.exe and NuGet provider now?
        InstallNugetExeUpgradeShouldContinueQuery=This version of PowerShellGet requires minimum version '{0}' of NuGet.exe to publish an item to the NuGet-based repositories. NuGet.exe must be available in '{1}' or '{2}', or under one of the paths specified in PATH environment variable value. NuGet.exe can be downloaded from https://aka.ms/psget-nugetexe. For more information, see https://aka.ms/installing-powershellget . Do you want PowerShellGet to upgrade to the latest version of NuGet.exe now?
        InstallNuGetExeShouldContinueQuery=This version of PowerShellGet requires minimum version '{0}' of NuGet.exe to publish an item to the NuGet-based repositories. NuGet.exe must be available in '{1}' or '{2}', or under one of the paths specified in PATH environment variable value. NuGet.exe can be downloaded from https://aka.ms/psget-nugetexe. For more information, see https://aka.ms/installing-powershellget . Do you want PowerShellGet to install the latest version of NuGet.exe now?
        InstallNuGetProviderShouldContinueQuery=This version of PowerShellGet requires minimum version '{0}' of NuGet provider to publish an item to NuGet-based repositories. The NuGet provider must be available in '{1}' or '{2}'. You can also install the NuGet provider by running 'Install-PackageProvider -Name NuGet -MinimumVersion {0} -Force'. Do you want PowerShellGet to install and import the NuGet provider now?
        InstallNuGetBinariesUpgradeShouldContinueCaption=NuGet.exe upgrade and NuGet provider installation are required to continue
        InstallNuGetBinariesShouldContinueCaption=NuGet.exe and NuGet provider installation are required to continue
        InstallNuGetExeUpgradeShouldContinueCaption=NuGet.exe upgrade is required to continue
        InstallNuGetExeShouldContinueCaption=NuGet.exe is required to continue
        InstallNuGetProviderShouldContinueCaption=NuGet provider is required to continue
        DownloadingNugetExe=Installing NuGet.exe.
        DownloadingNugetProvider=Installing NuGet provider.        
        ModuleNotFound=Module '{0}' was not found.
        NoMatchFound=No match was found for the specified search criteria and module names '{0}'.
        NoMatchFoundForScriptName=No match was found for the specified search criteria and script names '{0}'.
        FailedToCreateCompressedModule=Failed to generate the compressed file for module '{0}'.
        FailedToPublish=Failed to publish module '{0}': '{1}'.
        PublishedSuccessfully=Successfully published module '{0}' to the module publish location '{1}'. Please allow few minutes for '{2}' to show up in the search results.
        InvalidWebUri=The specified Uri '{0}' for parameter '{1}' is an invalid Web Uri. Please ensure that it meets the Web Uri requirements.
        RepositoryAlreadyRegistered=The repository could not be registered because there exists a registered repository with Name '{0}' and SourceLocation '{1}'. To register another repository with Name '{2}', please unregister the existing repository using the Unregister-PSRepository cmdlet.
        RepositoryToBeUnregisteredNotFound=The repository '{0}' was not removed because no repository was found with that name. Please run Get-PSRepository and ensure that a repository of that name is present.
        RepositoryCannotBeUnregistered=The specified repository '{0}' cannot be unregistered.
        RepositoryNotFound=No repository with the name '{0}' was found.
        PSGalleryNotFound=Unable to find repository '{0}'. Use Get-PSRepository to see all available repositories. Try again after specifying a valid repository name. You can use 'Register-PSRepository -Default' to register the PSGallery repository.
        ParameterIsNotAllowedWithPSGallery=The PSGallery repository has pre-defined locations. The '{0}' parameter is not allowed, try again after removing the '{0}' parameter.
        UseDefaultParameterSetOnRegisterPSRepository=Use 'Register-PSRepository -Default' to register the PSGallery repository.
        RepositoryNameContainsWildCards=The repository name '{0}' should not have wildcards, correct it and try again.
        InvalidRepository=The specified repository '{0}' is not a valid registered repository name. Please ensure that '{1}' is a registered repository.
        RepositoryRegistered=Successfully registered the repository '{0}' with source location '{1}'.
        RepositoryUnregistered=Successfully unregistered the repository '{0}'.
        PSGalleryPublishLocationIsMissing=The specified repository '{0}' does not have a valid PublishLocation. Retry after setting the PublishLocation for repository '{1}' to a valid NuGet publishing endpoint using the Set-PSRepository cmdlet.
        PSRepositoryScriptPublishLocationIsMissing=The specified repository '{0}' does not have a valid ScriptPublishLocation. Retry after setting the ScriptPublishLocation for repository '{1}' to a valid NuGet publishing endpoint using the Set-PSRepository cmdlet.
        ScriptSourceLocationIsMissing=The specified repository '{0}' does not have a valid ScriptSourceLocation. Retry after setting the ScriptSourceLocation for repository '{0}' to a valid NuGet endpoint for scripts using the Set-PSRepository cmdlet.
        PublishModuleSupportsOnlyNuGetBasedPublishLocations=Publish-Module only supports the NuGet-based publish locations. The PublishLocation '{0}' of the repository '{1}' is not a NuGet-based publish location. Retry after setting the PublishLocation for repository '{1}' to a valid NuGet publishing endpoint using the Set-PSRepository cmdlet.        
        PublishScriptSupportsOnlyNuGetBasedPublishLocations=Publish-Script only supports the NuGet-based publish locations. The ScriptPublishLocation '{0}' of the repository '{1}' is not a NuGet-based publish location. Retry after setting the ScriptPublishLocation for repository '{1}' to a valid NuGet publishing endpoint using the Set-PSRepository cmdlet.
        DynamicParameterHelpMessage=The dynamic parameter '{0}' is required for Find-Module and Install-Module when using the PackageManagement provider '{1}' and source location '{2}'. Please enter your value for the '{3}' dynamic parameter:
        ProviderApiDebugMessage=In PowerShellGet Provider - '{0}'.
        ModuleUninstallNotSupported=Module uninstallation is not supported. To remove a module, please delete the module folder.
        FastPackageReference=The FastPackageReference is '{0}'.
        PackageManagementProviderIsNotAvailable=The specified PackageManagement provider '{0}' is not available.
        SpecifiedSourceName=Using the specified source names : '{0}'.
        SpecifiedLocationAndOGP=The specified Location is '{0}' and PackageManagementProvider is '{1}'.
        NoSourceNameIsSpecified=The -Repository parameter was not specified.  PowerShellGet will use all of the registered repositories.
        GettingPackageManagementProviderObject=Getting the provider object for the PackageManagement Provider '{0}'.        
        InvalidInputObjectValue=Invalid value is specified for InputObject parameter.
        SpecifiedInstallationScope=The installation scope is specified to be '{0}'.
        SourceLocationValueForPSGalleryCannotBeChanged=The SourceLocation value for the PSGallery repository can not be changed.
        PublishLocationValueForPSGalleryCannotBeChanged=The PublishLocation value for the PSGallery repository can not be changed.
        SpecifiedProviderName=The specified PackageManagement provider name '{0}'.
        ProviderNameNotSpecified=User did not specify the PackageManagement provider name, trying with the provider name '{0}'.
        SpecifiedProviderNotAvailable=The specified PackageManagement provider '{0}' is not available.        
        SpecifiedProviderDoesnotSupportPSModules=The specified PackageManagement Provider '{0}' does not support PowerShell Modules. PackageManagement Providers must support the 'supports-powershell-modules' feature.
        PollingPackageManagementProvidersForLocation=Polling available PackageManagement Providers to find one that can support the specified source location '{0}'.
        PollingSingleProviderForLocation=Resolving the source location '{0}' with PackageManagement Provider '{1}'.
        FoundProviderForLocation=The PackageManagement provider '{0}' supports the source location '{1}'.
        SpecifiedLocationCannotBeRegistered=The specified location '{0}' cannot be registered.
        RepositoryDetails=Repository details, Name = '{0}', Location = '{1}'; IsTrusted = '{2}'; IsRegistered = '{3}'.
        NotSupportedPowerShellGetFormatVersion=The specified module '{0}' with PowerShellGetFormatVersion '{1}' is not supported by the current version of PowerShellGet. Get the latest version of the PowerShellGet module to install this module, '{2}'.
        NotSupportedPowerShellGetFormatVersionScripts=The specified script '{0}' with PowerShellGetFormatVersion '{1}' is not supported by the current version of PowerShellGet. Get the latest version of the PowerShellGet module to install this script, '{2}'.
        PathNotFound=Cannot find the path '{0}' because it does not exist.
        ModuleIsNotTrusted=Untrusted module '{0}'.        
        ScriptIsNotTrusted=Untrusted script '{0}'.
        SkippedModuleDependency=Because dependent module '{0}' was skipped in the module dependencies list, users might not know how to install it.        
        MissingExternallyManagedModuleDependency=The externally managed, dependent module '{0}' is not installed on this computer. To use the current module '{1}', ensure that its dependent module '{2}' is installed.        
        ExternallyManagedModuleDependencyIsInstalled=The externally managed, dependent module '{0}' is already installed on this computer.        
        ScriptMissingExternallyManagedModuleDependency=The externally managed, dependent module '{0}' is not installed on this computer. To use the current script '{1}', ensure that its dependent module '{2}' is installed.        
        ScriptMissingExternallyManagedScriptDependency=The externally managed, dependent module '{0}' is not installed on this computer. To use the current script '{1}', ensure that its dependent script '{2}' is installed.
        ScriptExternallyManagedScriptDependencyIsInstalled=The externally managed, dependent script '{0}' is already installed on this computer.        
        UnableToResolveModuleDependency=PowerShellGet cannot resolve the module dependency '{0}' of the module '{1}' on the repository '{2}'. Verify that the dependent module '{3}' is available in the repository '{4}'. If this dependent module '{5}' is managed externally, add it to the ExternalModuleDependencies entry in the PSData section of the module manifest.
        FindingModuleDependencies=Finding module dependencies for version '{1}' of the module '{0}' from repository '{2}'.
        InstallingDependencyModule=Installing the dependency module '{0}' with version '{1}' for the module '{2}'.
        InstallingDependencyScript=Installing the dependency script '{0}' with version '{1}' for the script '{2}'.
        SavingDependencyModule=Saving the dependency module '{0}' with version '{1}' for the module '{2}'.
        SavingDependencyScript=Saving the dependency script '{0}' with version '{1}' for the script '{2}'.
        ModuleUninstallationSucceeded=Successfully uninstalled the module '{0}' from module base '{1}'.
        ScriptUninstallationSucceeded=Successfully uninstalled the script '{0}' from script base '{1}'.
        AdminPrivilegesRequiredForUninstall=You cannot uninstall the module '{0}' from '{1}' because Administrator rights are required to uninstall from that folder. Log on to the computer with an account that has Administrator rights, and then try again. You can also try running the Windows PowerShell session with elevated rights (Run as Administrator).
        AdminPrivilegesRequiredForScriptUninstall=You cannot uninstall the script '{0}' from '{1}' because Administrator rights are required to uninstall from that folder. Log on to the computer with an account that has Administrator rights, and then try again. You can also try running the Windows PowerShell session with elevated rights (Run as Administrator).
        ModuleUninstallationNotPossibleAsItIsNotInstalledUsingPowerShellGet=Module '{0}' was not installed on this computer by using either the PowerShellGet cmdlets or the PowerShellGet provider, so it cannot be uninstalled.
        ScriptUninstallationNotPossibleAsItIsNotInstalledUsingPowerShellGet=Script '{0}' was not installed on this computer by using either the PowerShellGet cmdlets or the PowerShellGet provider, so it cannot be uninstalled.
        UnableToUninstallModuleVersion=The module '{0}' of version '{1}' in module base folder '{2}' was installed without side-by-side version support. Some versions are installed in this module base with side-by-side version support. Uninstall other versions of this module before uninstalling the most current version.
        UnableToUninstallAsOtherModulesNeedThisModule=The module '{0}' of version '{1}' in module base folder '{2}' cannot be uninstalled, because one or more other modules '{3}' are dependent on this module. Uninstall the modules that depend on this module before uninstalling module '{4}'.
        UnableToUninstallAsOtherScriptsNeedThisScript=The script '{0}' of version '{1}' in script base folder '{2}' cannot be uninstalled, because one or more other scripts '{3}' are dependent on this script. Uninstall the scripts that depend on this script before uninstalling script '{4}'.
        RepositoryIsNotTrusted=Untrusted repository
        QueryInstallUntrustedPackage=You are installing the modules from an untrusted repository. If you trust this repository, change its InstallationPolicy value by running the Set-PSRepository cmdlet. Are you sure you want to install the modules from '{1}'?
        QueryInstallUntrustedScriptPackage=You are installing the scripts from an untrusted repository. If you trust this repository, change its InstallationPolicy value by running the Set-PSRepository cmdlet. Are you sure you want to install the scripts from '{1}'?
        QuerySaveUntrustedPackage=You are downloading the modules from an untrusted repository. If you trust this repository, change its InstallationPolicy value by running the Set-PSRepository cmdlet. Are you sure you want to download the modules from '{1}'?
        QuerySaveUntrustedScriptPackage=You are downloading the scripts from an untrusted repository. If you trust this repository, change its InstallationPolicy value by running the Set-PSRepository cmdlet. Are you sure you want to download the scripts from '{1}'?
        SourceNotFound=Unable to find repository '{0}'. Use Get-PSRepository to see all available repositories.
        PSGalleryApiV2Deprecated=PowerShell Gallery v2 has been deprecated.  Please run 'Update-Module -Name PowerShellGet' to update to PowerShell Gallery v3.  For more information, please visit our website at 'https://www.powershellgallery.com'.
        PSGalleryApiV2Discontinued=PowerShell Gallery v2 has been discontinued.  Please run 'Update-Module -Name PowerShellGet' to update to PowerShell Gallery v3.  For more information, please visit our website at 'https://www.powershellgallery.com'.
        PowerShellGalleryUnavailable=PowerShell Gallery is currently unavailable.  Please try again later.
        PowerShellGetModuleIsNotInstalledProperly=The PowerShellGet module was not installed properly. Be sure that only one instance or version of the PowerShellGet module is installed in the path '{0}'.
        PowerShelLGetModuleGotUpdated=The PowerShellGet module was updated successfully. Restart the process to use the updated version of the PowerShellGet module.
        TagsShouldBeIncludedInManifestFile=Tags are now supported in the module manifest file (.psd1). Update the module manifest file of module '{0}' in '{1}' with the newest tag changes. You can run Update-ModuleManifest -Tags to update the manifest with tags.
        ReleaseNotesShouldBeIncludedInManifestFile=ReleaseNotes is now supported in the module manifest file (.psd1). Update the module manifest file of module '{0}' in '{1}' with the newest ReleaseNotes changes. You can run Update-ModuleManifest -ReleaseNotes to update the manifest with ReleaseNotes.
        LicenseUriShouldBeIncludedInManifestFile=LicenseUri is now supported in the module manifest file (.psd1). Update the module manifest file of module '{0}' with the newest LicenseUri changes. You can run Update-ModuleManifest -LicenseUri to update the manifest with LicenseUri.
        IconUriShouldBeIncludedInManifestFile=IconUri is now supported in the module manifest file (.psd1). Update the module manifest file of module '{0}' in '{1}' with the newest IconUri changes. You can run Update-ModuleManifest -IconUri to update the manifest with IconUri.
        ProjectUriShouldBeIncludedInManifestFile=ProjectUri is now supported in the module manifest file (.psd1). Update the module manifest file of module '{0}' in '{1}' with the newest ProjectUri changes. You can run Update-ModuleManifest -ProjectUri to update the manifest with ProjectUri.
        ShouldIncludeFunctionsToExport=This module '{0}' has exported functions. As a best practice, include exported functions in the module manifest file(.psd1). You can run Update-ModuleManifest -FunctionsToExport to update the manifest with ExportedFunctions field.
        ShouldIncludeCmdletsToExport=This module '{0}' has exported cmdlets. As a best practice, include exported cmdlets in the module manifest file(.psd1). You can run Update-ModuleManifest -CmdletsToExport to update the manifest with ExportedCmdlets field.
        ShouldIncludeDscResourcesToExport=This module '{0}' has exported DscResources. As a best practice, include exported DSC resources in the module manifest file(.psd1). If your PowerShell version is higher than 5.0, run Update-ModuleManifest -DscResourcesToExport to update the manifest with ExportedDscResources field.
        UpdateModuleManifestPathCannotFound=Cannot load the manifest file '{0}' properly. Please specify the correct manifest path.
        UpdatedModuleManifestNotValid=Cannot update the manifest file '{0}' because the manifest is not valid. Verify that the manifest file is valid, and then try again.'{1}'
        ExportedDscResourcesNotSupportedOnLowerPowerShellVersion=The ExportedDscResources property is not supported in module manifests on PowerShell versions that are older than 5.0. Remove the value for the parameter 'DscResourcesToExport', and then try again.
        CompatiblePSEditionsNotSupportedOnLowerPowerShellVersion=The CompatiblePSEditions property is not supported in module manifests on PowerShell versions that are older than 5.1. Remove the value for the parameter 'CompatiblePSEditions', and then try again.
        ExternalModuleDependenciesNotSpecifiedInRequiredOrNestedModules='{0}' is listed in ExternalModuleDependencies, but it is not found in either the RequiredModules or NestedModules properties. Verify that this module is required for ExternalModuleDependencies, and then add it to NestedModules or RequiredModules.
        TestModuleManifestFail=Cannot update the manifest properly. '{0}'
        PackageManagementProvidersNotInModuleBaseFolder=PackageManagementProvider '{0}' is not found in the module base '{1}'. Verify that the PackageManagementProvider specified is within the module base.
        UpdateManifestContentMessage=Update manifest file with new contents:
        InvalidPackageManagementProviderValue=The PackageManagementProvider value cannot be '{0}'. Valid values for provider names include '{1}', and the default value for this parameter is '{2}'.
        PowerShellGetUpdateIsNotSupportedOnLowerPSVersions=Self update of the PowerShellGet module is supported only in PowerShell 5.0 and newer releases. It is not supported in PowerShell 3.0 or 4.0.
        ScriptVersionShouldBeGreaterThanGalleryVersion=Script '{0}' with version '{1}' cannot be published. The version must exceed the current version '{2}' that exists in the repository '{3}', or you must specify -Force.
        ScriptVersionIsAlreadyAvailableInTheGallery=The script '{0}' with version '{1}' cannot be published as the current version '{2}' is already available in the repository '{3}'.
        ScriptPrereleaseStringShouldBeGreaterThanGalleryPrereleaseString=Script '{0}' with version '{1}' and prerelease '{2}' cannot be published. The prerelease string must exceed the current prerelease string '{3}' that exists in the repository '{4}', or you must specify -Force.
        ScriptParseError=The specified script file '{0}' has parse errors, try again after fixing the parse errors.
        InvalidScriptToPublish=Script file '{0}' cannot be published because it does not have the required script metadata. Run Update-ScriptFileInfo -Path '{1}' to add the script metadata.
        FailedToCreateCompressedScript=Failed to generate the compressed file for script '{0}'.
        FailedToPublishScript=Failed to publish script '{0}': '{1}'.
        PublishedScriptSuccessfully=Successfully published script '{0}' to the publish location '{1}'. Please allow few minutes for '{2}' to show up in the search results.
        UnableToResolveScriptDependency=PowerShellGet cannot resolve the {0} dependency '{1}' of the script '{2}' on the repository '{3}'. Verify that the dependent {0} '{1}' is available in the repository '{3}'. If this dependent {0} '{1}' is managed externally, add it to the '{4}' entry in the script metadata.
        InvalidVersion=Cannot convert value '{0}' to type 'System.Version'. 
        InvalidGuid=Cannot convert value '{0}' to type 'System.Guid'.
        InvalidParameterValue=The specified value '{0}' for the parameter '{1}' is invalid. Ensure that it does not contain '<#' or '#>'.
        MissingPSScriptInfo=PSScriptInfo is not specified in the script file '{0}'. You can use the Update-ScriptFileInfo with -Force or New-ScriptFileInfo cmdlet to add the PSScriptInfo to the script file.
        MissingRequiredPSScriptInfoProperties=Script '{0}' is missing required metadata properties. Verify that the script file has Version, Guid, Description and Author properties. You can use the Update-ScriptFileInfo or New-ScriptFileInfo cmdlet to add or update the PSScriptInfo to the script file.
        SkippedScriptDependency=Because dependent script '{0}' was skipped in the script dependencies list, users might not know how to install it.
        SourceLocationPathsForModulesAndScriptsShouldBeEqual=SourceLocation '{0}' and ScriptSourceLocation '{1}' should be same for SMB Share or Local directory based repositories.
        SourceLocationUrisForModulesAndScriptsShouldBeDifferent=SourceLocation '{0}' and ScriptSourceLocation '{1}' should not be same for URI based repositories.
        PublishLocationPathsForModulesAndScriptsShouldBeEqual=PublishLocation '{0}' and ScriptPublishLocation '{1}' should be same for SMB Share or Local directory based repositories.
        SpecifiedNameIsAlearyUsed=The specified name '{0}' is already used for a different item on the specified repository '{1}'. Run '{2} -Name {0} -Repository {1}' to check whether the specified name '{0}' is already taken.
        InvalidScriptFilePath=The script file path '{0}' is not valid. The value of the Path argument must resolve to a single file that has a '.ps1' extension. Change the value of the Path argument to point to a valid ps1 file, and then try again.
        NuGetApiKeyIsRequiredForNuGetBasedGalleryService=NuGetApiKey is required for publishing a module or script file to the specified repository '{0}' whose publish location is '{1}'. Try again after specifying a valid value for the NuGetApiKey parameter. To get your API key, view your profile page.
        ScriptFileExist=The specified script file '{0}' already exists.
        InvalidEnvironmentVariableName=The specified environment variable name '{0}' exceeded the allowed limit of '{1}' characters.
        PublishLocation=Publish Location:'{0}'.
        ScriptPATHPromptCaption=PATH Environment Variable Change
        ScriptPATHPromptQuery=Your system has not been configured with a default script installation path yet, which means you can only run a script by specifying the full path to the script file. This action places the script into the folder '{0}', and adds that folder to your PATH environment variable. Do you want to add the script installation path '{0}' to the PATH environment variable?
        AddedScopePathToProcessSpecificPATHVariable=Added scripts installation location '{0}' for '{1}' scope to process specific PATH environment variable.
        AddedScopePathToPATHVariable=Added scripts installation location '{0}' for '{1}' scope to PATH environment variable. 
        FilePathInFileListNotWithinModuleBase=Path '{0}' defined in FileList is not within module base '{1}'. Provide the correct FileList parameters and then try again.
        ManifestFileReadWritePermissionDenied=The current user does not have read-write permissions for the file:'{0}'. Check the file permissions and then try again.
        MissingTheRequiredPathOrPassThruParameter=The Path or PassThru parameter is required for creating the script file info. A new script file will be created with the script file info when the Path parameter is specified. Script file info will be returned if the PassThru parameter is specified. Try again after specifying the required parameter.
        DescriptionParameterIsMissingForAddingTheScriptFileInfo=Description parameter is missing for adding the metadata to the script file. Try again after specifying the description.
        UnableToAddPSScriptInfo=Unable to add PSScriptInfo to the script file '{0}'. You can use the New-ScriptFileInfo cmdlet to add the metadata to the existing script file.
        RegisterVSTSFeedAsNuGetPackageSource=Publishing to a VSTS package management feed '{0}' requires it to be registered as a NuGet package source. Retry after adding this source '{0}' as NuGet package source by following the instructions specified at '{1}'        
        InvalidModuleAuthenticodeSignature=The module '{0}' cannot be installed or updated because the authenticode signature of the file '{1}' is not valid.
        InvalidCatalogSignature=The module '{0}' cannot be installed because the catalog signature in '{1}' does not match the hash generated from the module.
        AuthenticodeIssuerMismatch=Authenticode issuer '{0}' of the new module '{1}' with version '{2}' from root certificate authority '{3}' is not matching with the authenticode issuer '{4}' of the previously-installed module '{5}' with version '{6}' from root certificate authority '{7}'. If you still want to install or update, use -SkipPublisherCheck parameter.
        ModuleCommandAlreadyAvailable=The following commands are already available on this system:'{0}'. This module '{1}' may override the existing commands. If you still want to install this module '{1}', use -AllowClobber parameter.
        CatalogFileFound=Found the catalog file '{0}' in the module '{1}' contents.        
        CatalogFileNotFoundInAvailableModule=Catalog file '{0}' is not found in the contents of the previously-installed module '{1}' with the same name.
        CatalogFileNotFoundInNewModule=Catalog file '{0}' is not found in the contents of the module '{1}' being installed.
        ValidAuthenticodeSignature=Valid authenticode signature found in the catalog file '{0}' for the module '{1}'.
        ValidAuthenticodeSignatureInFile=Valid authenticode signature found in the file '{0}' for the module '{1}'.
        ValidatingCatalogSignature=Validating the '{0}' module files for catalog signing using the catalog file '{1}'.
        AuthenticodeIssuerMatch=Authenticode issuer '{0}' of the new module '{1}' with version '{2}' matches with the authenticode issuer '{3}' of the previously-installed module '{4}' with version '{5}'.
        ValidCatalogSignature=The catalog signature in '{0}' of the module '{1}' is valid and matches with the hash generated from the module contents.
        SkippingPublisherCheck=Skipping the Publisher check for the version '{0}' of module '{1}'.
        SourceModuleDetailsForPublisherValidation=For publisher validation, using the previously-installed module '{0}' with version '{1}' under '{2}' with publisher name '{3}' from root certificate authority '{4}'. Is this module signed by Microsoft: '{5}'.
        NewModuleVersionDetailsForPublisherValidation=For publisher validation, current module '{0}' with version '{1}' with publisher name '{2}' from root certificate authority '{3}'. Is this module signed by Microsoft: '{4}'.
        PublishersMatch=Publisher '{0}' of the new module '{1}' with version '{2}' matches with the publisher '{3}' of the previously-installed module '{4}' with version '{5}'. Both versions are signed with a Microsoft root certificate.        
        PublishersMismatch=A Microsoft-signed module named '{0}' with version '{1}' that was previously installed conflicts with the new module '{2}' from publisher '{3}' with version '{4}'. Installing the new module may result in system instability. If you still want to install or update, use -SkipPublisherCheck parameter.
        ModuleIsNotCatalogSigned=The version '{0}' of the module '{1}' being installed is not catalog signed. Ensure that the version '{0}' of the module '{1}' has the catalog file '{2}' and signed with the same publisher '{3}' as the previously-installed module '{1}' with version '{4}' under the directory '{5}'. If you still want to install or update, use -SkipPublisherCheck parameter.
        SentEnvironmentVariableChangeMessage=Successfully broadcasted the Environment variable changes.
        UnableToSendEnvironmentVariableChangeMessage=Error in broadcasting the Environment variable changes.
        LicenseUriNotSpecified='LicenseUri' is not specified. 'LicenseUri' must be provided when user license acceptance is required.
        LicenseTxtNotFound=License.txt not Found. License.txt must be provided when user license acceptance is required.
        LicenseTxtEmpty=License.txt is empty.
        requireLicenseAcceptanceNotSupported=Require License Acceptance is not supported on Format version '{0}'.
        AcceptanceLicenseQuery=Do you accept the license terms for module '{0}'.
        ForceAcceptLicense=License Acceptance is required for module '{0}'. Please specify '-AcceptLicense' to perform this operation.
        InvalidValueBoolean=The specified value '{0}' for the parameter '{1}' is invalid. It should be $true or $false.
        UserDeclinedLicenseAcceptance=User declined license acceptance.
        AcceptLicense=License Acceptance
        RequiredScriptVersion=REQUIREDSCRIPTS: Required version of script '{0}' is '{1}'.
        RequiredScriptVersoinFormat=<ScriptName>, <ScriptName>:<MinimumVersion>, <ScriptName>:[<RequiredVersion>], <ScriptName>:[<MinimumVersion>,<MaximumVersion>], <ScriptName>:[,<MaximumVersion>]
        FailedToParseRequiredScripts=Cannot parse REQUIREDSCRIPTS '{0}'. Acceptable formats are: '{1}'.
        FailedToParseRequiredScriptsVersion=Version format error: {0}, '{1}'. Acceptable formats are: '{2}'. 
        PublishersMismatchAsWarning=Module '{0}' version '{1}' published by '{2}' will be superceded by version '{3}' published by '{4}'. If you do not trust the new publisher, uninstall the module.
###PSLOC
'@
# SIG # Begin signature block
# MIIdhwYJKoZIhvcNAQcCoIIdeDCCHXQCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU2f9a4HnRErE1oLhj2pIJsm6t
# tyCgghhVMIIEwzCCA6ugAwIBAgITMwAAAMvZUgZTvz4qWQAAAAAAyzANBgkqhkiG
# 9w0BAQUFADB3MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4G
# A1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSEw
# HwYDVQQDExhNaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EwHhcNMTYwOTA3MTc1ODU1
# WhcNMTgwOTA3MTc1ODU1WjCBszELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjENMAsGA1UECxMETU9QUjEnMCUGA1UECxMebkNpcGhlciBEU0UgRVNO
# OjU4NDctRjc2MS00RjcwMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBT
# ZXJ2aWNlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAum1PI6z8Uk7O
# jh+jHA7qkPtqGl+g9Ol0qKYBPtGxZ7SgIuZrXcfSVifUjgXwk+0q9TQFSiD+/b5L
# akoaE7Onwvh5GKjFrZH4Ymu8lwmIQBFCa5liePRTnVQybA/c18S/8AhhXn7t3/QL
# gh27vP7FnFy3lDYiVoEhxM40kv6vM0OuiBlFTxwWfBWzwHDem0cAw99IgtE4Ufac
# ftfmmIVMazRTlX1M1SLYTHo0u5yaOiU1ac1i2q/K30PewG+997QJHkpC6umA9XwH
# r4emFX3hqAChAO/fHrd3bRM0OMNH2sAFYTz41jH0D7ojyeRiRgMi+wAUtL1u+WTa
# 3RQ3NOF7VQIDAQABo4IBCTCCAQUwHQYDVR0OBBYEFJjHnFnzwMDY0qoqcv3dfXL2
# PD/mMB8GA1UdIwQYMBaAFCM0+NlSRnAK7UD7dvuzK7DDNbMPMFQGA1UdHwRNMEsw
# SaBHoEWGQ2h0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3Rz
# L01pY3Jvc29mdFRpbWVTdGFtcFBDQS5jcmwwWAYIKwYBBQUHAQEETDBKMEgGCCsG
# AQUFBzAChjxodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY3Jv
# c29mdFRpbWVTdGFtcFBDQS5jcnQwEwYDVR0lBAwwCgYIKwYBBQUHAwgwDQYJKoZI
# hvcNAQEFBQADggEBAEsgBVRD0msYysh0uEFNws3dDP5riqpVsamGJpWCMlJGNl4+
# LX4JIv283MTsCU37LaNIbGjhTuSi4ifVyvs73xsicr4tPiGK7IYBRthKL/3tEjeM
# /mGWSfY2rZRgSwUKbPIGVz1IgHaOm089sb6Q6yC4EkEOAxTrhBS/4SZeTM2RuT0o
# 8rFtffWR4sW8SrpgvRQuz28WAu2wDZ3XTTvAmiF+cjumrx6fA8UaLhYG6LWvJZT6
# zrlsZ8DcTZMwZLnw6tKSiqvb6gvIcyDTcVj25GRul3yzLfgsmLWGTRN7woCSGzfd
# gykqBndYo4OS6E0ssxjPR8zJw0DbhJjvUMtJ/egwggYBMIID6aADAgECAhMzAAAA
# xOmJ+HqBUOn/AAAAAADEMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTEwHhcNMTcwODExMjAyMDI0WhcNMTgwODExMjAyMDI0WjB0
# MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVk
# bW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
# AoIBAQCIirgkwwePmoB5FfwmYPxyiCz69KOXiJZGt6PLX4kvOjMuHpF4+nypH4IB
# tXrLGrwDykbrxZn3+wQd8oUK/yJuofJnPcUnGOUoH/UElEFj7OO6FYztE5o13jhw
# VG877K1FCTBJwb6PMJkMy3bJ93OVFnfRi7uUxwiFIO0eqDXxccLgdABLitLckevW
# eP6N+q1giD29uR+uYpe/xYSxkK7WryvTVPs12s1xkuYe/+xxa8t/CHZ04BBRSNTx
# AMhITKMHNeVZDf18nMjmWuOF9daaDx+OpuSEF8HWyp8dAcf9SKcTkjOXIUgy+MIk
# ogCyvlPKg24pW4HvOG6A87vsEwvrAgMBAAGjggGAMIIBfDAfBgNVHSUEGDAWBgor
# BgEEAYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUy9ZihM9gOer/Z8Jc0si7q7fD
# E5gwUgYDVR0RBEswSaRHMEUxDTALBgNVBAsTBE1PUFIxNDAyBgNVBAUTKzIzMDAx
# MitjODA0YjVlYS00OWI0LTQyMzgtODM2Mi1kODUxZmEyMjU0ZmMwHwYDVR0jBBgw
# FoAUSG5k5VAF04KqFzc3IrVtqMp1ApUwVAYDVR0fBE0wSzBJoEegRYZDaHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jcmwvTWljQ29kU2lnUENBMjAxMV8y
# MDExLTA3LTA4LmNybDBhBggrBgEFBQcBAQRVMFMwUQYIKwYBBQUHMAKGRWh0dHA6
# Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY2VydHMvTWljQ29kU2lnUENBMjAx
# MV8yMDExLTA3LTA4LmNydDAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBCwUAA4IC
# AQAGFh/bV8JQyCNPolF41+34/c291cDx+RtW7VPIaUcF1cTL7OL8mVuVXxE4KMAF
# RRPgmnmIvGar27vrAlUjtz0jeEFtrvjxAFqUmYoczAmV0JocRDCppRbHukdb9Ss0
# i5+PWDfDThyvIsoQzdiCEKk18K4iyI8kpoGL3ycc5GYdiT4u/1cDTcFug6Ay67Sz
# L1BWXQaxFYzIHWO3cwzj1nomDyqWRacygz6WPldJdyOJ/rEQx4rlCBVRxStaMVs5
# apaopIhrlihv8cSu6r1FF8xiToG1VBpHjpilbcBuJ8b4Jx/I7SCpC7HxzgualOJq
# nWmDoTbXbSD+hdX/w7iXNgn+PRTBmBSpwIbM74LBq1UkQxi1SIV4htD50p0/GdkU
# ieeNn2gkiGg7qceATibnCCFMY/2ckxVNM7VWYE/XSrk4jv8u3bFfpENryXjPsbtr
# j4Nsh3Kq6qX7n90a1jn8ZMltPgjlfIOxrbyjunvPllakeljLEkdi0iHv/DzEMQv3
# Lz5kpTdvYFA/t0SQT6ALi75+WPbHZ4dh256YxMiMy29H4cAulO2x9rAwbexqSajp
# lnbIvQjE/jv1rnM3BrJWzxnUu/WUyocc8oBqAU+2G4Fzs9NbIj86WBjfiO5nxEmn
# L9wliz1e0Ow0RJEdvJEMdoI+78TYLaEEAo5I+e/dAs8DojCCBgcwggPvoAMCAQIC
# CmEWaDQAAAAAABwwDQYJKoZIhvcNAQEFBQAwXzETMBEGCgmSJomT8ixkARkWA2Nv
# bTEZMBcGCgmSJomT8ixkARkWCW1pY3Jvc29mdDEtMCsGA1UEAxMkTWljcm9zb2Z0
# IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5MB4XDTA3MDQwMzEyNTMwOVoXDTIx
# MDQwMzEzMDMwOVowdzELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjEhMB8GA1UEAxMYTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBMIIBIjANBgkqhkiG
# 9w0BAQEFAAOCAQ8AMIIBCgKCAQEAn6Fssd/bSJIqfGsuGeG94uPFmVEjUK3O3RhO
# JA/u0afRTK10MCAR6wfVVJUVSZQbQpKumFwwJtoAa+h7veyJBw/3DgSY8InMH8sz
# JIed8vRnHCz8e+eIHernTqOhwSNTyo36Rc8J0F6v0LBCBKL5pmyTZ9co3EZTsIbQ
# 5ShGLieshk9VUgzkAyz7apCQMG6H81kwnfp+1pez6CGXfvjSE/MIt1NtUrRFkJ9I
# AEpHZhEnKWaol+TTBoFKovmEpxFHFAmCn4TtVXj+AZodUAiFABAwRu233iNGu8Qt
# VJ+vHnhBMXfMm987g5OhYQK1HQ2x/PebsgHOIktU//kFw8IgCwIDAQABo4IBqzCC
# AacwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUIzT42VJGcArtQPt2+7MrsMM1
# sw8wCwYDVR0PBAQDAgGGMBAGCSsGAQQBgjcVAQQDAgEAMIGYBgNVHSMEgZAwgY2A
# FA6sgmBAVieX5SUT/CrhClOVWeSkoWOkYTBfMRMwEQYKCZImiZPyLGQBGRYDY29t
# MRkwFwYKCZImiZPyLGQBGRYJbWljcm9zb2Z0MS0wKwYDVQQDEyRNaWNyb3NvZnQg
# Um9vdCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHmCEHmtFqFKoKWtTHNY9AcTLmUwUAYD
# VR0fBEkwRzBFoEOgQYY/aHR0cDovL2NybC5taWNyb3NvZnQuY29tL3BraS9jcmwv
# cHJvZHVjdHMvbWljcm9zb2Z0cm9vdGNlcnQuY3JsMFQGCCsGAQUFBwEBBEgwRjBE
# BggrBgEFBQcwAoY4aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9N
# aWNyb3NvZnRSb290Q2VydC5jcnQwEwYDVR0lBAwwCgYIKwYBBQUHAwgwDQYJKoZI
# hvcNAQEFBQADggIBABCXisNcA0Q23em0rXfbznlRTQGxLnRxW20ME6vOvnuPuC7U
# EqKMbWK4VwLLTiATUJndekDiV7uvWJoc4R0Bhqy7ePKL0Ow7Ae7ivo8KBciNSOLw
# UxXdT6uS5OeNatWAweaU8gYvhQPpkSokInD79vzkeJkuDfcH4nC8GE6djmsKcpW4
# oTmcZy3FUQ7qYlw/FpiLID/iBxoy+cwxSnYxPStyC8jqcD3/hQoT38IKYY7w17gX
# 606Lf8U1K16jv+u8fQtCe9RTciHuMMq7eGVcWwEXChQO0toUmPU8uWZYsy0v5/mF
# hsxRVuidcJRsrDlM1PZ5v6oYemIp76KbKTQGdxpiyT0ebR+C8AvHLLvPQ7Pl+ex9
# teOkqHQ1uE7FcSMSJnYLPFKMcVpGQxS8s7OwTWfIn0L/gHkhgJ4VMGboQhJeGsie
# IiHQQ+kr6bv0SMws1NgygEwmKkgkX1rqVu+m3pmdyjpvvYEndAYR7nYhv5uCwSdU
# trFqPYmhdmG0bqETpr+qR/ASb/2KMmyy/t9RyIwjyWa9nR2HEmQCPS2vWY+45CHl
# tbDKY7R4VAXUQS5QrJSwpXirs6CWdRrZkocTdSIvMqgIbqBbjCW/oO+EyiHW6x5P
# yZruSeD3AWVviQt9yGnI5m7qp5fOMSn/DsVbXNhNG6HY+i+ePy5VFmvJE6P9MIIH
# ejCCBWKgAwIBAgIKYQ6Q0gAAAAAAAzANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UE
# BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
# BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0
# IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5IDIwMTEwHhcNMTEwNzA4MjA1OTA5
# WhcNMjYwNzA4MjEwOTA5WjB+MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGlu
# Z3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
# cmF0aW9uMSgwJgYDVQQDEx9NaWNyb3NvZnQgQ29kZSBTaWduaW5nIFBDQSAyMDEx
# MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAq/D6chAcLq3YbqqCEE00
# uvK2WCGfQhsqa+laUKq4BjgaBEm6f8MMHt03a8YS2AvwOMKZBrDIOdUBFDFC04kN
# eWSHfpRgJGyvnkmc6Whe0t+bU7IKLMOv2akrrnoJr9eWWcpgGgXpZnboMlImEi/n
# qwhQz7NEt13YxC4Ddato88tt8zpcoRb0RrrgOGSsbmQ1eKagYw8t00CT+OPeBw3V
# XHmlSSnnDb6gE3e+lD3v++MrWhAfTVYoonpy4BI6t0le2O3tQ5GD2Xuye4Yb2T6x
# jF3oiU+EGvKhL1nkkDstrjNYxbc+/jLTswM9sbKvkjh+0p2ALPVOVpEhNSXDOW5k
# f1O6nA+tGSOEy/S6A4aN91/w0FK/jJSHvMAhdCVfGCi2zCcoOCWYOUo2z3yxkq4c
# I6epZuxhH2rhKEmdX4jiJV3TIUs+UsS1Vz8kA/DRelsv1SPjcF0PUUZ3s/gA4bys
# AoJf28AVs70b1FVL5zmhD+kjSbwYuER8ReTBw3J64HLnJN+/RpnF78IcV9uDjexN
# STCnq47f7Fufr/zdsGbiwZeBe+3W7UvnSSmnEyimp31ngOaKYnhfsi+E11ecXL93
# KCjx7W3DKI8sj0A3T8HhhUSJxAlMxdSlQy90lfdu+HggWCwTXWCVmj5PM4TasIgX
# 3p5O9JawvEagbJjS4NaIjAsCAwEAAaOCAe0wggHpMBAGCSsGAQQBgjcVAQQDAgEA
# MB0GA1UdDgQWBBRIbmTlUAXTgqoXNzcitW2oynUClTAZBgkrBgEEAYI3FAIEDB4K
# AFMAdQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSME
# GDAWgBRyLToCMZBDuRQFTuHqp8cx0SOJNDBaBgNVHR8EUzBRME+gTaBLhklodHRw
# Oi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJB
# dXQyMDExXzIwMTFfMDNfMjIuY3JsMF4GCCsGAQUFBwEBBFIwUDBOBggrBgEFBQcw
# AoZCaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJB
# dXQyMDExXzIwMTFfMDNfMjIuY3J0MIGfBgNVHSAEgZcwgZQwgZEGCSsGAQQBgjcu
# AzCBgzA/BggrBgEFBQcCARYzaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9w
# cy9kb2NzL3ByaW1hcnljcHMuaHRtMEAGCCsGAQUFBwICMDQeMiAdAEwAZQBnAGEA
# bABfAHAAbwBsAGkAYwB5AF8AcwB0AGEAdABlAG0AZQBuAHQALiAdMA0GCSqGSIb3
# DQEBCwUAA4ICAQBn8oalmOBUeRou09h0ZyKbC5YR4WOSmUKWfdJ5DJDBZV8uLD74
# w3LRbYP+vj/oCso7v0epo/Np22O/IjWll11lhJB9i0ZQVdgMknzSGksc8zxCi1LQ
# sP1r4z4HLimb5j0bpdS1HXeUOeLpZMlEPXh6I/MTfaaQdION9MsmAkYqwooQu6Sp
# BQyb7Wj6aC6VoCo/KmtYSWMfCWluWpiW5IP0wI/zRive/DvQvTXvbiWu5a8n7dDd
# 8w6vmSiXmE0OPQvyCInWH8MyGOLwxS3OW560STkKxgrCxq2u5bLZ2xWIUUVYODJx
# Jxp/sfQn+N4sOiBpmLJZiWhub6e3dMNABQamASooPoI/E01mC8CzTfXhj38cbxV9
# Rad25UAqZaPDXVJihsMdYzaXht/a8/jyFqGaJ+HNpZfQ7l1jQeNbB5yHPgZ3BtEG
# sXUfFL5hYbXw3MYbBL7fQccOKO7eZS/sl/ahXJbYANahRr1Z85elCUtIEJmAH9AA
# KcWxm6U/RXceNcbSoqKfenoi+kiVH6v7RyOA9Z74v2u3S5fi63V4GuzqN5l5GEv/
# 1rMjaHXmr/r8i+sLgOppO6/8MO0ETI7f33VtY5E90Z1WTk+/gFcioXgRMiF670EK
# sT/7qMykXcGhiJtXcVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCBJww
# ggSYAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
# DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24x
# KDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAADE
# 6Yn4eoFQ6f8AAAAAAMQwCQYFKw4DAhoFAKCBsDAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0B
# CQQxFgQUhc03jPjY3xo3z92BHlhzW4RjR5AwUAYKKwYBBAGCNwIBDDFCMECgFoAU
# AFAAbwB3AGUAcgBTAGgAZQBsAGyhJoAkaHR0cDovL3d3dy5taWNyb3NvZnQuY29t
# L1Bvd2VyU2hlbGwgMA0GCSqGSIb3DQEBAQUABIIBABMZJgXGJgLRYMEVAHh8DYhg
# p7ZhOfdXLDDtoC/ogxbvZPVVSxckvfw7RmdArTvmmZJNm7xb6CvNBN/8Z/pTgiLY
# KLY3hmSls224bkMoisMbTQ660GA7yTjc6qEjMH/IY6zfcPIwZ+W7x6FtIgekmvTi
# O8KeBRfRn7dUEmdEyCCJJ+XE6InJS2J9PWXUJwomhaWrtAhu3bfd1hUuz5d0MMKa
# pm6x0StPjr3f5mmCI5Tt6Tbjbn1w03BhcMPOX4apsc2e+BtcthVAMO2Xg+YEx2p9
# SigcEoNLgf9nTkun6QliHmjYGjls1eomtH1Wfvdwi7ln0d0cQsUqmlR4fbJfs3ah
# ggIoMIICJAYJKoZIhvcNAQkGMYICFTCCAhECAQEwgY4wdzELMAkGA1UEBhMCVVMx
# EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
# FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEhMB8GA1UEAxMYTWljcm9zb2Z0IFRpbWUt
# U3RhbXAgUENBAhMzAAAAy9lSBlO/PipZAAAAAADLMAkGBSsOAwIaBQCgXTAYBgkq
# hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xODA2MjkyMjQ5
# NTZaMCMGCSqGSIb3DQEJBDEWBBSBdTiaRcvS0f1g/SUyYc49ntguZzANBgkqhkiG
# 9w0BAQUFAASCAQB8waNv4zrx1attXc69HUjRoaRtAdy41358UNqo5Zb82FWhb3gE
# 9+hseaFT8LRR38jGVEw2c8DkfJ1wswrY9/v0PyQa6UR6Vl/VCfXD27SsdWmmMjTo
# 2yYIhPeA7UocVP7bAyqvtoMOLyys37UT60e5ojqzn5wBDkC+yHy7GP+R2RAOr/8w
# ZnGFnX+TeqOHTLLIE0J5T/qSwUlOtRgQFabeZybmIsZoKO66q/aRUBRUzr8lRf2I
# LRmbLTZzcxQFQBjr8odOZsg4sUTgh+LdcwKGqS+B6HDyw4FuKeT930LhE4O6J5l3
# Kzu/Gkun/t4H9TfxtfzAO4hkyTChuEF04opR
# SIG # End signature block
