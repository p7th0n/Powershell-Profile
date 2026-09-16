# PowerShell Windows Configuration

- Windows forced using a OneDrive folder for the PowerShell profile.
- My PowerShell scripts accumulated ideas pulled from the Internet that seemed good at the time.
- Over time OneDrive's syncing corrupted the PS profile Git repo.
- When it came time to clean up, poor documentation and forgotten context made the problem harder than it should be.
- In the end the $PROFILE repo landed in a separate drive folder outside of OneDrive syncing.
- Windows would not allow changing the 'PowerShell' folder. So this wouldn't work:

  ```
  New-Item -ItemType SymbolicLink -Path "C:\Users\UserName\Documents\PowerShell" -Target "C:\Users\UserName\.config\powershell"
  ```

- Each file and directory in the Source had separate SymbolicLinks.

  ```
  New-Item -ItemType SymbolicLink -Path "C:\Users\UserName\Documents\PowerShell\profile.ps1" -Target "C:\Users\UserName\.config\powershell\profile.ps1"
  ```

## Source Directory

- Source Directory
- Git repo
- Directory: C:\Users\UserName\Documents\Powershell

```bash
Mode  Length Name
----  ------ ----
d----        Modules
-a---    145 .gitattributes
-a---    511 .gitignore
-a---   3966 Microsoft.PowerShell_profile.ps1
-a---    496 Microsoft.VSCode_profile.ps1
-a---  55915 powershell_config_issues.md
-a---     55 powershell.config.json
-a---   2049 profile.ps1
-a---   2327 README.md
```

---

## Target Directory

- Target Directory
- Windows OneDrive directory
- Directory: C:\Users\UserName\OneDrive\Documents2\PowerShell

```bash
Mode  Name
----  ----
l-r-- Modules -> C:\Users\UserName\Documents\Powershell\Modules\
la--- Microsoft.PowerShell_profile.ps1 -> C:\Users\UserName\Documents\Powershell\Microsoft.PowerShell_profile.ps1
la--- Microsoft.VSCode_profile.ps1 -> C:\Users\UserName\Documents\Powershell\Microsoft.VSCode_profile.ps1
la--- powershell.config.json -> C:\Users\UserName\Documents\Powershell\powershell.config.json
la--- profile.ps1 -> C:\Users\UserName\Documents\Powershell\profile.ps1
la--- README.md -> C:\Users\UserName\Documents\Powershell\README.md
```

---

## References

- [Is It Possible to Change the Default $profile Location in PowerShell](https://www.codegenes.net/blog/is-it-possible-to-change-the-default-value-of-profile-to-a-new-value/)
- [OneDrive conflicts with ShareX screen capture hotkeys](https://github.com/ShareX/ShareX/issues/6581#issuecomment-1369280267)
