# PowerShell Configuration — Issues Report

**Audited:** 2026-09-15
**Target:** `C:\Users\dkurm\OneDrive\Documents2\PowerShell` (the PowerShell 7 `CurrentUser` profile
directory, tracked as git repo `p7th0n/Powershell-Profile`, branch `master`), plus the adjacent
Windows PowerShell 5.1 profile and machine-level `Path`.

**Status:** Originally diagnosis-only. **Update 2026-09-15:** all six Tier 1 findings (security /
correctness, `e90bd3c`) and all nine Tier 2 findings (silent no-ops, `3bfcbd8`) have since been
fixed and committed. Tier 3 and the adjacent-environment findings are still open. Each resolved item
is marked ✅ RESOLVED below with what was done and how it was re-verified; the rest of the document
is unchanged from the original audit.

---

## Summary

Findings were verified by running against the live configuration — `pwsh 7.6.3` and
`powershell 5.1.26100.9444` — not by reading the scripts alone. Where a claim is marked
**Verified**, the observed output is quoted.

The configuration works day-to-day, but it has accumulated about a decade of layers: PowerTab-era
artifacts from a Windows 7/8 machine, a Windows PowerShell 5.1 heritage that the PS7 files never
fully shed, three competing prompt systems, two hand-rolled modules that build commands as strings,
and a 216-function generated loader.

Three things stand out:

1. **`ls` and `dir` execute arbitrary code from the path they are given.** This was a live
   code-execution path in the alias used most, and it was not theoretical — it is demonstrated
   below. **Fixed in `e90bd3c`.**
2. **Two things you deliberately configured are silently doing nothing.** The Catppuccin fzf theme
   and the Catppuccin oh-my-posh theme both fail soft. Neither prints an error; both just don't
   apply. **Fixed in `3bfcbd8`** — fzf now carries the real palette; oh-my-posh falls back
   explicitly instead of silently (the theme *file* itself still doesn't exist on this machine,
   which is a separate, unrelated task from the config fix).
3. **Your git history is being corrupted by line-ending churn.** 12 of the 13 currently "modified"
   files contain no real changes, and the current HEAD commit is semantically empty. *(Tier 3 —
   still open.)*

Startup cost is ~1.2 s per shell. No credentials, API keys, or tokens were found anywhere in the
working tree or in git history.

---

## Environment snapshot

| | |
|---|---|
| PowerShell 7 | `7.6.3` at `C:\Program Files\PowerShell\7\pwsh.exe` |
| Windows PowerShell | `5.1.26100.9444` |
| `$PROFILE.CurrentUserAllHosts` (7) | `...\Documents2\PowerShell\profile.ps1` — exists |
| `$PROFILE.CurrentUserCurrentHost` (7) | `...\Documents2\PowerShell\Microsoft.PowerShell_profile.ps1` — exists |
| `$PROFILE.CurrentUserAllHosts` (5.1) | `...\Documents2\WindowsPowerShell\profile.ps1` — **does not exist** |
| `$PROFILE.CurrentUserCurrentHost` (5.1) | `...\Documents2\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` — exists, **not in this repo** |
| Working tree | 72 MB (65 MB of it `Modules/`), `.git` 5.4 MB, 24 tracked files |
| Branch | `master`, **2 commits ahead of `origin/master`**, unpushed |

**Startup cost** (median of 4 runs each):

```
pwsh -NoProfile     193 ms
pwsh (with profile) 1,368 ms      →  profile cost ≈ 1,175 ms
```

Warm breakdown of the profile's own work:

```
module imports        367 ms   (posh-git, posh-docker, Get-ChildItemColor, Send-ToDrafts, PSReadLine)
fabric pattern loop   170 ms   (~1,800 ms cold)
oh-my-posh init       113 ms
chocolatey profile     92 ms
zoxide init            42 ms
rbenv init             12 ms
```

**External tools** — all currently resolve: `zoxide`, `starship`, `fzf`, `oh-my-posh`, `git`, `rg`,
`bat`, `fd`, `gh`, `scoop`, `choco`, `winget`, `node`, `python`, `uv`, `kubectl`, `docker`, `ag`,
`fabric`, `yazi`, `lazydocker`, `komorebic`, `nvim`, `open-webui`. Not installed: `fnm`, `nvm`,
`eza`, `lsd`, `delta`, `direnv`, `terraform`, `aws`, `az`.

All `.ps1` / `.psm1` files in the repo **parse cleanly** — there are no syntax errors. Every problem
below is a semantic one.

---

## Tier 1 — Security and correctness — ✅ ALL RESOLVED

All six findings in this tier were fixed and committed in `e90bd3c` ("Fix Tier 1 security/correctness issues from config audit"). Each item below is marked
with what was actually done and how it was verified.

### 1.1 `ls` and `dir` execute arbitrary code from the path argument — ✅ RESOLVED

**`Modules/Get-ChildItemColor/Get-ChildItemColor.psm1:59-61`**

```powershell
$Expression = "Get-ChildItem -Path `"$Path`" $Args"
$Items = Invoke-Expression $Expression
```

The path is interpolated into a double-quoted string and the result is executed. `$Args` is spliced
in raw as well. This function is aliased to `ls` and `dir` in both profiles
(`Microsoft.PowerShell_profile.ps1:71,73`, `Microsoft.VSCode_profile.ps1:53,55`) with
`-option AllScope -Force`, so it intercepts essentially every directory listing.

**Verified:**

```
PS> Get-ChildItemColor -Path 'C:\$(Write-Host "INJECTED-CODE-RAN")Windows'
INJECTED-CODE-RAN
appcompat
```

The subexpression ran, then the listing proceeded normally. Any path containing `$(...)`, a backtick,
or a `"` executes — including a path that arrives from a variable, from a pipeline, or from
tab-completing into a directory whose name someone else chose (a cloned repo, an extracted archive,
a network share).

> **Fix:** `Get-ChildItem -LiteralPath $Path @Args`. No string building, no `Invoke-Expression`.
> Better still, replace the module with maintained `Get-ChildItemColor` v2/v3 or `Terminal-Icons`.

**Resolved (`e90bd3c`):** `Get-ChildItemColor.psm1:59-61` now branches on whether `$Path` was
given and calls `Get-ChildItem -LiteralPath $Path @Args` (or `Get-ChildItem @Args` with no path),
with no string building anywhere. Re-verified the exact injection payload from this report —
`Get-ChildItemColor -Path 'C:\$(Write-Host "INJECTED-CODE-RAN")Windows'` — now fails with
*"Cannot find path ... because it does not exist"* instead of executing. Normal usage
(`ls`, `ls Modules`, `ls Modules -Force`) confirmed unchanged.

### 1.2 `Search-Notes` — same injection, and broken besides — ✅ RESOLVED

**`Modules/Search-Notes/Search-Notes.psm1:4-11`**

```powershell
$notes = '~\Dropbox\Notes\'
$notes_path = Resolve-Path $notes
$search_command = 'ag ' + $search_term + ' ' + $notes_path
Invoke-Expression $search_command
```

Three problems stacked:

- **Injection / quoting.** Unquoted concatenation then `Invoke-Expression`. `Search-Notes "foo bar"`
  passes two arguments to `ag`; a term containing `;` or `$(...)` executes.
- **Dead path.** **Verified:** `Test-Path "$HOME\Dropbox\Notes"` → `False`. Dropbox was deliberately
  removed from this setup in commit `12c5b3f "remove dropbox notes reference"`. `Resolve-Path` on
  line 5 therefore errors before `ag` is ever reached.
- **Dead module.** Neither profile imports `Search-Notes`. It has no manifest (reports version `0.0`),
  no `[CmdletBinding()]`, and no parameter validation.

> **Fix:** delete the module. If kept: `ag -- $search_term $notes_path` with no `Invoke-Expression`,
> a real path, and `rg` instead of `ag` (which you already have installed, and which has been
> maintained since `ag`'s last release in 2018).

**Resolved (`e90bd3c`):** module deleted (`Modules/Search-Notes/`). Confirmed nothing else in
the repo referenced it before removal.

### 1.3 Execution policy pinned to `Unrestricted` — and published — ✅ RESOLVED

**`powershell.config.json`** (entire file):

```json
{"Microsoft.PowerShell:ExecutionPolicy":"Unrestricted"}
```

`Unrestricted` is the loosest setting: downloaded scripts run with at most a prompt. This file is
**tracked in git and pushed to a public GitHub repo**, so the downgrade travels to every machine that
clones it. The repo's own `README.md` recommends `RemoteSigned`.

> **Fix:** `RemoteSigned`. It preserves every current behaviour — local scripts still run unsigned —
> while restoring the mark-of-the-web check on downloaded ones.

**Resolved (`e90bd3c`):** `powershell.config.json` now reads
`{"Microsoft.PowerShell:ExecutionPolicy":"RemoteSigned"}`. Verified with a fresh profile load:
`Get-ExecutionPolicy -Scope CurrentUser` → `RemoteSigned`.

### 1.4 `ngen.ps1` destroys `$env:PATH` and aborts early — ✅ RESOLVED

**`ngen.ps1:10`**

```powershell
$env:path = [Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()
```

Assignment, not append. Dot-sourcing or running this in a working shell leaves `PATH` containing only
the .NET runtime directory — no `git`, no `fzf`, no `zoxide` — until the shell is restarted.

**`ngen.ps1:12`**

```powershell
[AppDomain]::CurrentDomain.GetAssemblies() | ForEach-Object {
  if (! $_.location) {continue}
```

`ForEach-Object`'s scriptblock is not a loop body. `continue` there does not skip one item — it exits
the entire pipeline. Dynamic assemblies (which have no `Location`) are common, so the run typically
aborts partway through with no indication.

Additionally, `ngen.exe` targets .NET **Framework** only. Running it from pwsh 7 (.NET Core)
precompiles nothing relevant to the pwsh startup the file's header comment claims it improves.

> **Fix:** `$env:path += ';' + [Runtime...]::GetRuntimeDirectory()`, and `return` instead of
> `continue`. Or delete the file — it does not do what it says on this runtime.

**Resolved (`e90bd3c`):** applied the append fix (`$env:path += ";" + ...`) and swapped
`continue` for `return`. Kept the file rather than deleting it — the .NET-Framework-only caveat
still applies and is unchanged by this fix, so it remains a niche tool rather than a broken one.
Parses clean; no live re-run (it still requires elevation and only matters on .NET Framework).

### 1.5 `Remove-Service` shadows the real cmdlet and cannot work — ✅ RESOLVED

**`Microsoft.PowerShell_profile.ps1:101-105`** (duplicated verbatim at **`Microsoft.VSCode_profile.ps1:76-80`**)

```powershell
function Remove-Service($service) {
    Get-WmiObject -Class Win32_Service -Filter "Name='$service'"
    Write-Host 'Service: ' + $service
    $service.delete()
}
```

**Verified:** `(Get-Command Remove-Service).CommandType` → `Function`. The real `Remove-Service`
cmdlet, which has shipped since PowerShell 6.0, is masked by this.

The body is wrong four ways:

- `$service` is bound to the *string* name, so `$service.delete()` cannot resolve.
- `Get-WmiObject`'s output is emitted to the pipeline and then discarded — it is never assigned.
- `Write-Host 'Service: ' + $service` prints a literal `+` (three positional arguments, not concatenation).
- `Get-WmiObject` was **removed in PowerShell 6**, so this cannot run in the host it ships in at all.

> **Fix:** delete both copies. The built-in cmdlet already does this correctly.

**Resolved (`e90bd3c`):** both copies deleted (`Microsoft.PowerShell_profile.ps1` and
`Microsoft.VSCode_profile.ps1`). Verified with a fresh profile load:
`(Get-Command Remove-Service).CommandType` → `Cmdlet` (the built-in is no longer shadowed).

### 1.6 `fab-pat.ps1` calls a cmdlet that does not exist — ✅ RESOLVED

**`fab-pat.ps1:4`**

```powershell
fabric --listpatterns | fzf | ForEach-Object {
    if ($_ -ne $null) {
        Write-Out $_
    }
}
```

`Write-Out` is not a cmdlet and is not an alias for `Write-Output`. The script throws
`CommandNotFoundException` on any selection.

The file is also a strictly worse duplicate of `fpat` at
`Microsoft.PowerShell_profile.ps1:310-316`, which already fixed the typo by emitting `$_` bare.
`if ($_ -ne $null)` is the reversed-operand form; `$null` belongs on the left.

> **Fix:** delete the file. `fpat` supersedes it.

**Resolved (`e90bd3c`):** file deleted. Confirmed nothing else in the repo referenced it, and
`fpat` (`Microsoft.PowerShell_profile.ps1:310-316`) still resolves after profile load.

---

## Tier 2 — Configured, but silently doing nothing — ✅ ALL RESOLVED

These are the expensive ones to find by hand, because nothing errors. All nine findings in
this tier were fixed and committed in `3bfcbd8` ("Fix Tier 2 silent-no-op issues from config
audit"). Each item below is marked with what was actually done and how it was re-verified.

### 2.1 The Catppuccin fzf theme never applies — ✅ RESOLVED

**`Microsoft.PowerShell_profile.ps1:49-55`**

```powershell
$ENV:FZF_DEFAULT_OPTS = @"
--color=bg+:$($Flavor.Surface0),bg:$($Flavor.Base),spinner:$($Flavor.Rosewater)
...
"@
```

`$Flavor` is never defined. The upstream Catppuccin snippet requires
`Import-Module Catppuccin; $Flavor = $Catppuccin['Mocha']` first — that import is absent, and no
`Catppuccin` module is installed on this machine.

**Verified** in a live profile-loaded shell:

```
PS> $env:FZF_DEFAULT_OPTS
--color=bg+:,bg:,spinner:
--color=hl:,fg:,header:
--color=info:,pointer:,marker:
--color=fg+:,prompt:,hl+:
--color=border:

PS> Get-Variable Flavor -ErrorAction SilentlyContinue   # → nothing
```

Note: fzf **tolerates** empty color values. I confirmed this — with the above opts,
`"a" | fzf --filter=a` returns `a` and exits `0`, whereas a genuinely malformed value
(`--color=bg+:notacolor`) errors with `invalid color specification` and exit `2`. So fzf is *not*
broken; it simply has no theme, which is why this has gone unnoticed.

> **Fix:** `Import-Module Catppuccin` + `$Flavor = $Catppuccin['Mocha']` before line 49, or inline
> the hex values directly and drop the module dependency.

**Resolved (`3bfcbd8`):** took the inline option — no `Catppuccin` module is installed on this
machine, so hardcoding avoids adding a dependency. `FZF_DEFAULT_OPTS` now carries the official
Catppuccin Mocha fzf palette (`https://github.com/catppuccin/fzf/`) as literal hex values.
Re-verified: `$env:FZF_DEFAULT_OPTS` now resolves to real colors instead of empty ones, and
`fzf --filter` still exits `0`.

### 2.2 The Catppuccin oh-my-posh theme never loads — ✅ RESOLVED

**`Microsoft.PowerShell_profile.ps1:7`**

```powershell
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\catppuccin_mocha.omp.json" | Invoke-Expression
```

**Verified:**

```
PS> $env:POSH_THEMES_PATH
C:\Program Files (x86)\oh-my-posh\themes\          ← note trailing backslash; profile appends another

PS> Test-Path "$env:POSH_THEMES_PATH\catppuccin_mocha.omp.json"
False
```

oh-my-posh does not fail loudly on a missing config. It emits `$env:POSH_CONFIG = ''` and falls back
to its default theme — which is why the prompt looks fine and the problem is invisible. Commit
`8d5d3c6 "chore: switch to catppuccin theme"` is currently inert.

If `$env:POSH_THEMES_PATH` were ever unset, the path would collapse to `\catppuccin_mocha.omp.json`
— the root of the current drive.

> **Fix:** locate the actual themes directory for the installed oh-my-posh (it is the MS Store /
> WinGet build, caching under `AppData\Local\Packages\ohmyposh.cli_*`), use `Join-Path`, and guard
> the whole line with `if (Get-Command oh-my-posh -ErrorAction SilentlyContinue)`.

**Resolved (`3bfcbd8`):** the theme file (`catppuccin_mocha.omp.json`) doesn't exist anywhere on
this machine — not just at the wrong path — so a `Join-Path` fix alone couldn't restore the
themed prompt. Applied the honest version instead: guard on `Get-Command oh-my-posh`, `Test-Path`
the specific theme file, and explicitly fall back to the default `oh-my-posh init pwsh` (no
`--config`) when it's missing, rather than silently building a path to a file that isn't there.
Re-verified: profile loads with no error, `prompt` function is defined, `$env:POSH_CONFIG` is
empty (confirms the documented default-theme fallback, not a crash). Getting the actual
Catppuccin Mocha *theme* onto this machine is a separate, unrelated task (installing/downloading
a theme file), not a config bug — left open.

### 2.3 Three encoding settings fight; none wins — ✅ RESOLVED

- **`Microsoft.PowerShell_profile.ps1:20`** — `chcp 1252` (Windows-1252)
- **`:66`** — `$PSDefaultParameterValues['*:Encoding'] = 'utf8'`
- **`:327`** — the zoxide block forces `[Console]::OutputEncoding` to UTF-8

**Verified** in a profile-loaded shell: `[Console]::OutputEncoding.WebName` → **`ibm437`**. None of
the three intended settings is what the console actually ends up with.

Two further consequences:

- Code page 1252 cannot render the Nerd Font glyphs that the (intended) Catppuccin oh-my-posh theme
  depends on — so 2.2 and 2.3 would still conflict even after 2.2 is fixed.
- `$PSDefaultParameterValues['*:Encoding'] = 'utf8'` means UTF-8 **with BOM** on 5.1 and **without**
  on 7. Any script using it writes different bytes depending on which host runs it.

The comment above line 20 — `# ####### Fix Code Windows\System32\OpenSSH\ssh-agent` — describes
something unrelated to `chcp`, suggesting the line was pasted under the wrong heading.

> **Fix:** drop `chcp 1252`. If a code page must be set, use `chcp 65001` (UTF-8), consistent with
> the other two settings.

**Resolved (`3bfcbd8`):** removed `chcp 1252` and its misleading comment. Deliberately did *not*
add `chcp 65001` in its place — nothing in this tier required forcing a codepage, and doing so on
an older `conhost` (rather than Windows Terminal) can itself cause glyph/rendering issues. The
active conflict (three settings fighting) is gone; the other two settings
(`$PSDefaultParameterValues` and the zoxide block's `[Console]::OutputEncoding` override) are
unopposed now.

### 2.4 Dead prompt configuration — ✅ RESOLVED

**`Microsoft.PowerShell_profile.ps1:36-45`** and **`Microsoft.VSCode_profile.ps1:39-45`**

```powershell
$GitPromptSettings.DefaultPromptSuffix = ...
$GitPromptSettings.DefaultPromptPrefix = '[$(hostname)] '
$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
$GitPromptSettings.DefaultForegroundColor = 'Black'
```

These configure **posh-git's** prompt. oh-my-posh (line 7 / line 8) installs its own `prompt`
function and replaces it entirely, so none of this has any effect.

**`:68` / `:50`** — `$DefaultUser = 'Dave'` is an oh-my-posh **v2** setting that v3+ ignores, and it
names a user that no longer exists on this machine (the current user is `dkurm`).

Three systems in total contend for the prompt: oh-my-posh installs it, posh-git configures one that
is already gone, and the zoxide hook (`:378-388`) wraps whatever `prompt` exists at load time. The
ordering happens to work only because zoxide loads last; the `$global:__zoxide_hooked` guard is the
only thing preventing the hook nesting a second time when the profile is reloaded.

> **Fix:** delete the `$GitPromptSettings` blocks and `$DefaultUser` from both files.

**Resolved (`3bfcbd8`):** both blocks deleted from both profiles. Re-verified: `$DefaultUser`
is no longer defined after a fresh profile load; `prompt` (oh-my-posh's) is unaffected.

### 2.5 zoxide is initialised three times — ✅ RESOLVED

- **`Microsoft.PowerShell_profile.ps1:318-441`** — a pasted copy of `zoxide init powershell` output
- **`:442`** — `Invoke-Expression (& { (zoxide init powershell | Out-String) })` — runs it live and
  redefines every function the pasted block just defined
- **`z.ps1`** — a third copy of the same block (with the final `Invoke-Expression` commented out at
  `:125`), dot-sourced by nothing

**Verified:** `__zoxide_z` is defined after profile load, so it does work — just three times over,
costing an extra subprocess spawn.

The pasted block also contains `if ($PSVersionTable.PSVersion -lt 6.1)` at `:348` and `:351` —
comparing a `[Version]` against a `[double]`, which is fragile. It is zoxide-generated and only
reachable on very old hosts, but it is one more reason not to freeze generated output into a file.

> **Fix:** keep only line 442 (guarded by a `Get-Command zoxide` check), delete `:318-441` and `z.ps1`.

**Resolved (`3bfcbd8`):** collapsed the whole pasted block plus the live call down to:
```powershell
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}
```
and deleted `z.ps1`. Re-verified: `z`, `zi`, and `__zoxide_z` all still resolve after a fresh
profile load — the live `zoxide init` call alone defines everything the pasted copy did.

### 2.6 Duplicate module imports and key handlers — ✅ RESOLVED

- `profile.ps1` is the **`CurrentUserAllHosts`** profile and runs *before* the host-specific one. Its
  entire content is `Import-Module posh-git` — which
  `Microsoft.PowerShell_profile.ps1:1` then does again in every console session, and
  `Microsoft.VSCode_profile.ps1:4` again in every VS Code session.
- `Import-Module PSReadline` at **`:16`** (guarded by `ConsoleHost`) and again unconditionally at **`:447`**.
- `Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete` at **`:33`** and again at **`:448`**.

> **Fix:** `profile.ps1` running for both hosts is exactly the right place for shared setup — see 3.3.

**Resolved (`3bfcbd8`):** removed the redundant `Import-Module posh-git` from both host-specific
profiles (each now carries a comment pointing at `profile.ps1`, which already imports it once for
every host). Removed the unconditional `Import-Module PSReadLine` and the duplicate
`Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete` at the bottom of the console
profile — both were already set earlier in the same file. This is a narrower fix than the full
profile consolidation described in 3.3 (still open); it removes the specific duplication cited
here without moving the rest of the shared content into `profile.ps1`. Re-verified: `Start-SshAgent`
(which depends on posh-git) still resolves with `profile.ps1` + host profile dot-sourced in
isolation, for both hosts.

### 2.7 `Microsoft.VSCode_profile.ps1:20` — a guard that is never true — ✅ RESOLVED

```powershell
if ($host.name -eq "ConsoleHost")
{
    Import-Module PSReadline
}
```

In VS Code the host name is `Visual Studio Code Host`, so PSReadLine is **never** imported by this
file — yet `:26-36` immediately call `Set-PSReadLineOption` and `Set-PSReadlineKeyHandler`
unconditionally. Those only work because the VS Code PowerShell extension preloads PSReadLine itself.
The guard is misleading: it looks like it protects the calls below it, and it does not.

**Resolved (`3bfcbd8`):** replaced the dead `ConsoleHost` guard with an unconditional
`Import-Module PSReadLine -ErrorAction SilentlyContinue` and a comment explaining why (this file
only ever loads under the VS Code host). The PSReadLine option/key-handler calls below it no
longer depend on VS Code's extension happening to preload the module first. Re-verified: PSReadLine
is loaded and those calls succeed with `profile.ps1` + this file dot-sourced in isolation.

### 2.8 `Microsoft.VSCode_profile.ps1:63` — leftover Dropbox variable — ✅ RESOLVED

```powershell
$dbNotes = "~\Dropbox\Notes"   # Notes folder
```

The path does not exist, and the variable is referenced nowhere in the repo. Commit `12c5b3f`
removed this from the console profile and missed this copy — the same drift described in 3.3.

**Resolved (`3bfcbd8`):** line deleted.

### 2.9 `Get-ChildItemColor` — further defects beyond the injection — ✅ RESOLVED

Beyond 1.1, in **`Modules/Get-ChildItemColor/Get-ChildItemColor.psm1`**:

- **`:2` — an always-true guard.**
  `if ([System.Enum]::IsDefined([System.ConsoleColor], 1) -eq "False") { $OriginalForegroundColor = "Gray" }`
  **Verified:** this expression evaluates to `True` (the non-empty string `"False"` coerces to
  `$true`). So `$OriginalForegroundColor` is set to `"Gray"` *unconditionally*, and the intended
  "does this host support color?" detection never happens.
- **`:66-68` — mutates global host state once per item.** Sets `$Host.UI.RawUI.ForegroundColor`
  before and after every single item. If Ctrl-C lands mid-loop the console is left stuck on the last
  colour; in any non-console host (VS Code, remoting, redirected output) it throws or is ignored.
  Emitting items one at a time also defeats PowerShell's table formatter.
- **`:40` — `$Item.GetType().Name -eq 'DirectoryInfo'`** misses registry keys, cert-store items, and
  every other provider. `$Item.PSIsContainer` is the correct test — and the module clearly *wants*
  provider support, since `:97-105` handles registry parents.
- **`:87` — throws on an empty directory** (`$lnStr` is `$null`, so `.Name.Length` fails). The
  `If ($len)` guard on `:89` comes one line too late.
- **`:126` — `$toWrite.Substring(0, $pad - 3)` throws when `$pad < 3`** (narrow window, many columns).
- **`:4-9` — extension table frozen at ~2016.** Lists `.markdown` but not `.md`; no `.yml`/`.yaml`,
  `.toml`, `.tf`, `.go`, `.rs`, `.ts`/`.tsx`, `.psd1`, `.zst`.
- **`:144` — `Export-ModuleMember -Function 'Get-*'`** also exports the internal helper `Get-Color`.
- **No `.psd1` manifest** — the module reports version `0.0`, declares no `PowerShellVersion` or
  `CompatiblePSEditions`, and autoloads only because the folder name happens to match.

Upstream `Get-ChildItemColor` v2/v3 fixed all of these years ago, as did `Terminal-Icons`.

**Resolved (`3bfcbd8`):** fixed in place rather than swapping to a maintained replacement.
Specifics:
- The always-true guard now reads `if (-not [System.Enum]::IsDefined(...))`, matching its
  evident original intent.
- `$Item.GetType().Name -eq 'DirectoryInfo'` → `$Item.PSIsContainer` (covers registry keys and
  other providers, matching the registry-parent handling already in the file).
- The per-item `$Host.UI.RawUI.ForegroundColor` mutation is now wrapped in `try`/`finally`, so
  the console can't get stuck on the last item's color if the pipeline is interrupted.
- **The `:87` "throws on an empty directory" claim did not reproduce** — live-tested against
  this PowerShell 7.6.3 build, `$lnStr.Name.Length` on a `$null` `$lnStr` returns `0`, not an
  error (member access on `$null` doesn't throw here). Added a small explicit guard anyway
  (`$len = if ($lnStr) { $lnStr.Name.Length } else { 0 }`) since it costs nothing and is more
  robust across PowerShell versions/strict-mode settings, but this write-up no longer claims it
  was fixing a live crash.
- **`:126`'s `Substring(0, $pad - 3)` crash on `$pad < 3` did reproduce** (confirmed
  `length ('-1') must be a non-negative value` before the fix) — guarded with
  `if ($pad -lt 3) { $pad = 3 }`.
- Extension table extended with `.md`, `.yml`, `.yaml`, `.toml`, `.tf`, `.go`, `.rs`, `.ts`,
  `.tsx`, `.psd1`, `.xz`, `.zst`, in the same buckets as their existing siblings.
- `Export-ModuleMember` now names the two public functions explicitly instead of `'Get-*'`;
  `Get-Color` is no longer exported.
- Added `Get-ChildItemColor.psd1` (manifest); the module now reports version `1.0.0` instead of
  `0.0`.

**Bonus finding, fixed alongside these:** `Get-ChildItemColorFormatWide` — the module's second
exported function, not wired to any alias but reachable directly (`Import-Module
Get-ChildItemColor; Get-ChildItemColorFormatWide ...`) — had the **exact same
`Invoke-Expression` path-injection pattern as the Tier 1 `Get-ChildItemColor` bug** (its own
separate `$Expression = "Get-ChildItem -Path ..."` string-build). This wasn't cited in the
original audit, which only looked at `Get-ChildItemColor`'s injection. Fixed the same way
(`-LiteralPath` + splatting, with `-Force` handled via a parameter hashtable instead of string
concatenation). Re-verified with the same crafted-path payload used for the Tier 1 fix, via a
disk-log timeline to rule out console-buffering artifacts: payload is rejected with
*"Cannot find path ... because it does not exist"*, no code execution.

---

## Tier 3 — Robustness, cost, and hygiene

### 3.1 No error handling around any external tool

There is no `try`/`catch` anywhere in `Microsoft.PowerShell_profile.ps1`, and no
`Get-Command X -ErrorAction SilentlyContinue` guard around any of:

| Line | Tool |
|---|---|
| `:7` | `oh-my-posh` |
| `:20` | `chcp` |
| `:64` | `rbenv.ps1` |
| `:264`, `:267`, `:305`, `:311` | `fabric` |
| `:311` | `fzf` |
| `:442` | `zoxide` |
| `:454` | `open-webui` |
| `:473` | `yazi.exe` |

Exactly three guarded spots exist in 480 lines: `Test-Path($ChocolateyProfile)` (`:197`), the
`ConsoleHost` check (`:14`), and `Restart-Process` (`:202-222`) — the one function in the file with
proper `try`/`catch` and a mandatory parameter.

Every tool currently resolves on this machine, so nothing is failing *today*. The exposure is
portability (a new machine, or one tool uninstalled, produces a wall of red on every shell launch)
and silent partial failure.

Two specific cases:

- **`:449-465`** — the `open-webui` argument completer spawns a process on every Tab press in that
  command's context, and leaks `$Env:_TYPER_COMPLETE_*` into the session if the call throws before
  the cleanup at `:462-464`.
- **`:471-479`** — `y` calls `Remove-Item -Path $tmp` unguarded; if `yazi.exe` is missing, the
  `Get-Content` on `:474` throws and the temp file is orphaned.

> **Fix:** wrap each third-party init in `if (Get-Command X -ErrorAction SilentlyContinue) { ... }`,
> and put the `y` function's cleanup in a `finally`.

### 3.2 216 generated functions compiled into every shell

**`Microsoft.PowerShell_profile.ps1:228-274`**

```powershell
$patternsPath = Join-Path $HOME ".config/fabric/patterns"
foreach ($patternDir in Get-ChildItem -Path $patternsPath -Directory) {
    ...
    Invoke-Expression $functionDefinition
}
```

**Verified:** 216 pattern directories on this machine → 216 here-strings built and 216
`Invoke-Expression` calls per shell start, each defining a global function named after the pattern.
Measured at ~170 ms warm, ~1,800 ms cold.

Two risks beyond the cost:

- **Namespace collision.** Each pattern name becomes a global function. A pattern named `ai`,
  `analyze`, `clean`, `explain`, `improve`, `rate`, `summarize`, or `write` shadows anything else by
  that name for the rest of the session — silently, and with no way to tell from the prompt.
- **`:230` has no `Test-Path` guard.** If `~/.config/fabric/patterns` is ever missing,
  `Get-ChildItem` errors and the `foreach` iterates over `$null`.

> **Fix:** generate the functions once into a cached `.ps1` (regenerated only when the patterns
> directory mtime changes) and dot-source it; or replace all 216 with a single
> `function fab { param($Pattern, ...) }` dispatcher plus an argument completer.

### 3.3 `Microsoft.VSCode_profile.ps1` is ~110 lines of drifted copy-paste

Roughly 85–90% of its non-blank lines are byte-identical to `Microsoft.PowerShell_profile.ps1`:
the posh-git/posh-docker imports, the PSReadLine block, the `$GitPromptSettings` block, the
`$PSDefaultParameterValues`/`$DefaultUser` pair, the `ls`/`dir`/`which`/`type` aliases, `mkdir`,
`ll`, `Remove-Service`, `dos2unix`, `Measure-Command2`, and the Chocolatey import.

Consequences:

- **Every Tier 1 and Tier 2 bug above exists in both files and must be fixed twice.**
- **The two have drifted.** VS Code profile last touched Mar 2025, console profile Aug 2025. The
  VS Code copy has *no* zoxide, fabric, yazi, WezTerm, `Restart-Process`, `Get-PublicIp`, `top`,
  `touch`, `pbcopy`/`pbpaste`, `v`/`k`/`lzd`, or fzf config.
- **`:8` omits `--config`** (`oh-my-posh.exe init pwsh | Invoke-Expression`), so VS Code is
  intentionally pointed at a different theme than the console — though per 2.2 both currently land
  on the default anyway.

> **Fix:** move everything shared into `profile.ps1` (`CurrentUserAllHosts`), which already runs for
> both hosts and currently holds one line. Leave only genuinely host-specific content in the two
> host profiles.

### 3.4 Minor function defects

- **`Microsoft.PowerShell_profile.ps1:189-193` — `touch`** only handles `$args[0]`, and
  `New-Item -ItemType File` **throws if the file already exists** — the opposite of Unix `touch`,
  whose main job is updating the timestamp of an existing file.
- **`:184-187` — `top`** is `While(1) { ps | sort -des cpu | select -f 15 | ft -a; sleep 1; cls }`.
  No Ctrl-C cleanup, so interrupting it can leave the screen cleared mid-render. The `cls` and `ps`
  aliases do not exist on non-Windows pwsh.
- **`:91-93` — `mkdir`** shadows the built-in `mkdir` function and drops its `-Force`,
  `-WhatIf`, and multi-path support.

### 3.5 Git: 12 of 13 "modified" files contain no real change

```
$ git diff --stat | tail -1
 13 files changed, 46666 insertions(+), 46656 deletions(-)

$ git diff --ignore-cr-at-eol --stat
 .gitignore | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)
```

**The only genuine uncommitted change is `.gitignore`.** Everything else — all 84,406 "changed" lines
of `TabExpansion.xml`, all 7,088 of `Microsoft.PowerToys.Configure.psm1` — is LF↔CRLF flapping.

**Cause:** there is **no `.gitattributes`** and `core.autocrlf` is **unset**. The local config
contains only `core.filemode=false`, `core.symlinks=false`, `core.ignorecase=true`. Editing these
files from Windows tooling versus WSL rewrites every line.

**This has already polluted history.** The current HEAD:

```
$ git show 80f98b3 --ignore-cr-at-eol --stat --oneline
80f98b3 update Send-ToDrafts
                                   ← zero files listed
```

`80f98b3 "update Send-ToDrafts"` is a **semantically empty commit** — its raw stat claims 7 files and
474 insertions, all of it CRLF conversion. It is one of the 2 unpushed commits on `master`.

`Microsoft.PowerShell_profile.ps1` is already internally mixed (`ASCII text, with CRLF, LF line
terminators`).

> **Fix:** add `.gitattributes`:
> ```
> * text=auto
> *.ps1 text eol=crlf
> *.psm1 text eol=crlf
> *.psd1 text eol=crlf
> ```
> then `git add --renormalize .` once. This ends the churn permanently.

### 3.6 Both submodule declarations are broken, in different ways

**`.gitmodules`**

```
[submodule "Modules/Convertto-UnixLF"]
	url = git@DaveKurman@vs-ssh.visualstudio.com:v3/DaveKurman/Convertto-UnixLF/Convertto-UnixLF
[submodule "Modules/Send-ToDrafts"]
	url = git@DaveKurman@vs-ssh.visualstudio.com:v3/DaveKurman/Send-ToDrafts/Send-ToDrafts
```

1. **Malformed URLs.** `git@DaveKurman@vs-ssh...` has two `@`. In scp-style syntax the user parses as
   `git` and `DaveKurman@vs-ssh.visualstudio.com` becomes the hostname. `visualstudio.com` SSH
   endpoints are also the legacy pre-`dev.azure.com` form.
2. **`Modules/Convertto-UnixLF` was never cloned.**
   `git submodule status` → `-d49e91e1... Modules/Convertto-UnixLF` (leading `-` = uninitialised).
   The directory is empty, there is no `.git/modules/`, and `.git/config` has no `submodule.*`
   entries. Harmless only because its import is commented out at
   `Microsoft.PowerShell_profile.ps1:12` and `Microsoft.VSCode_profile.ps1:15`.
3. **`Modules/Send-ToDrafts` is declared as a submodule but is not one.** `git ls-files -s` shows it
   tracked as 7 ordinary `100644` files. The `.gitmodules` entry is stale leftover from
   de-submodularising it, and will make `git submodule update --init` fail.

> **Fix:** delete the `Send-ToDrafts` stanza outright. For `Convertto-UnixLF`, either fix the URL and
> initialise it, or `git rm --cached Modules/Convertto-UnixLF` and drop the stanza — the import is
> commented out anyway.

### 3.7 Tracked files that should not be

- **`TabExpansion.xml` — 1,352,366 bytes, 42,203 lines.** The largest tracked file by 11×. It is
  PowerTab's *generated* completion cache: 1,280 `<COM>`, 6,481 `<Types>`, 1,182 `<WMI>` entries. It
  is effectively a **software inventory of an old Windows 7/8-era machine** — it enumerates
  `InternetExplorer.Application`, `Igfxext.CUIExternal` (Intel graphics), "Send to OneNote from
  Internet Explorer button". Not a credential leak, but machine-fingerprint data in a public repo
  with no reason to be versioned. PowerTab (0.99.6.0, abandoned ~2013) is imported by neither profile;
  PSReadLine — which both profiles *do* load — replaced it.
- **`PowerTabConfig.xml`** — same vintage, same irrelevance, and it embeds dead absolute paths from a
  previous machine: `:120` and `:126` both reference
  `C:\Users\Dave\Documents\WindowsPowerShell\...` — wrong user (`Dave` vs `dkurm`) and wrong edition
  directory (`WindowsPowerShell` vs `PowerShell`).
- **`Modules/Microsoft.PowerToys.Configure/`** — 139 KB of Microsoft-generated vendor code, tracked
  while **every other** PSGallery module in `Modules/` is gitignored. It is simply missing from
  `.gitignore`.

> **Fix:** `git rm --cached TabExpansion.xml PowerTabConfig.xml`, add
> `Modules/Microsoft.PowerToys.Configure` to `.gitignore`. Consider inverting `.gitignore` to an
> allowlist (`Modules/*` then `!Modules/Get-ChildItemColor/` etc.) so it doesn't need editing every
> time a module is installed.

### 3.8 Stale and conflicting modules on disk

`Modules/` is 65 MB. Most of it is untracked since commit `7c1bb6e "remove modules from tracking."`
(which removed 243 files / 100,656 lines — good cleanup), but it is all still on disk and still being
synced to OneDrive.

| Module | Version(s) | Problem |
|---|---|---|
| `PowerShellGet` | **1.6.6 *and* 2.0.0** | Two ancient copies side by side; both shadow the newer one bundled with PS7. Current is 2.2.5 / PSResourceGet 1.x |
| `PackageManagement` | 1.1.7.2 (2017) | Shadows the PS7-bundled copy |
| `Pscx` | 3.3.2 (2017) | Windows PowerShell 5.1 only — ships its own `System.Management.Automation.dll`; **cannot load in PS7** |
| `PowerTab` | 0.99.6.0 | Abandoned ~2013, never imported (see 3.7) |
| `posh-git` | 0.7.3 | Current is 1.1.0 |
| `posh-docker` | 0.7.1 | Stale |
| `VirtualEnvWrapper` | 0.1 | Never imported |
| `Plaster`, `Search-Notes`, `posh-sshell`, `Microsoft.WinGet.Client` | — | Present, never imported |
| `Pester` | 3.4.0 | The 2016 WMF-bundled version; current is 5.x |

`Modules/oh-my-posh` is gitignored *and* absent from disk — the profile now uses the standalone
binary, so that ignore entry is vestigial.

`Scripts/` contains only an empty `InstalledScriptInfos/` — a PowerShellGet artifact, contributing
nothing.

**One latent break worth flagging:** `Microsoft.VSCode_profile.ps1:61` calls `Start-SshAgent`, which
**works today** — the vendored posh-git 0.7.3 still provides it and wins module resolution. But that
function moved to the separate `posh-sshell` module at posh-git 1.0. The moment posh-git is updated,
that line fails. `posh-sshell` 0.3.1 is already on disk, unimported. (Note the console profile
commented these same three lines out at `:86-88`; the VS Code copy was never updated — 3.3 again.)

### 3.9 Stale identity in tracked files

No credentials, API keys, tokens, or private keys were found. I grepped the working tree and scanned
git history with `--pickaxe-regex` for `api[_-]?key`, `token`, `secret`, `password`, `bearer`, `ghp_`,
`github_pat`, `sk-`, `AKIA`, `xoxb-`, and `BEGIN .* PRIVATE`. Zero true positives.
(`fab-pat.ps1` is "fabric patterns", not a personal access token, despite the filename.)

What *is* leaked is a previous identity:

- `Microsoft.PowerShell_profile.ps1:2` and `Microsoft.VSCode_profile.ps1:5` — commented-out
  `C:\Users\Dave\Documents\WindowsPowerShell\Modules\posh-git\0.7.3\posh-git`
- `PowerTabConfig.xml:120,126` — `C:\Users\Dave\Documents\WindowsPowerShell\...`
- `Microsoft.PowerShell_profile.ps1:68` / `Microsoft.VSCode_profile.ps1:50` — `$DefaultUser = 'Dave'`
- `.gitmodules` — the Azure DevOps account name in both URLs
- `Modules/Search-Notes/Search-Notes.psm1:4` and `Modules/Send-ToDrafts/Send-ToDrafts.psm1:43` —
  `~\Dropbox\...` paths for a service no longer in use

### 3.10 Structural

- **The repo lives inside OneDrive**, so `.git` itself is cloud-synced. This is a known cause of
  index corruption when sync and git touch the object store concurrently, and it places full repo
  history on a third-party service.
- **`.git` is 5.4 MB against ~200 KB of live source**, because the binaries removed by `7c1bb6e` are
  permanently in the pack: `Modules/Pscx/3.3.2/7z64.dll` (1.48 MB), both `PSModule.psm1` copies
  (1.36 MB each), `7z.dll` (1.13 MB), `Pscx.dll-Help.xml` (798 KB), plus `Pscx.dll`,
  `System.Management.Automation.dll`, and several `Microsoft.Management.Deployment.winmd` variants.
  Note `Modules/pscx/Pscx.dll` (lowercase) also appears in history alongside `Modules/Pscx/3.3.2/Pscx.dll`
  — a case-collision artifact of `core.ignorecase=true`; the same module was committed twice under
  two casings. Cleaning this needs `git filter-repo` and a force-push; at 5.4 MB it is cosmetic, not urgent.
- **`README.md` is stale.** It instructs cloning to `$env:USERPROFILE\Documents\WindowsPowerShell`
  (the 5.1 location, not where this repo lives), lists "Windows 10, 8 or 7" as dependencies, and its
  module table cites oh-my-posh 2.0.223, PowerShellGet 1.6.6, and newtonsoft.json — none of which
  reflect the current setup.

---

## Adjacent environment

### 4.1 A second, untracked profile for Windows PowerShell 5.1

**`C:\Users\dkurm\OneDrive\Documents2\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`** (90 lines)

This is the Windows PowerShell **5.1** `CurrentUserCurrentHost` profile. It is **not in this repo**
and is versioned by nothing. It contains its own copy of:

- the fabric pattern loader — the same 216-`Invoke-Expression` loop as 3.2
- `yt`
- `fpat`

drifted independently from the tracked PS7 copies. Its `Get-ChildItem -Path $patternsPath` on line 12
has the same missing `Test-Path` guard.

`$PROFILE.CurrentUserAllHosts` for 5.1 (`...\WindowsPowerShell\profile.ps1`) does not exist, and
`WindowsPowerShell\Scripts\` contains only an empty `InstalledScriptInfos/`.

> **Fix:** either bring this file into the repo, or reduce it to a line that dot-sources the shared
> content — right now there are two independent forks of the same fabric loader.

### 4.2 User `Path` has duplicates and a drive-letter typo

Reading the **persisted** user-scope `Path` (`[Environment]::GetEnvironmentVariable("Path","User")`):

- **`C:\Users\dkurm\.dotnet\tools` appears 3×**
- **`C:\Users\dkurm\AppData\Local\Microsoft\WindowsApps` appears 2×**
- **`C:\Users\dkurm\go\bin` appears 2×**
- **`e:\Users\dkurm\.cache\lm-studio\bin`** — drive **`e:`**, where every sibling entry uses `C:`.
  `C:\Users\dkurm\.cache\lm-studio\bin` appears separately earlier in the list, so this is almost
  certainly a typo'd duplicate of it.

Every dead or duplicate entry is walked on each command resolution that misses.

The persisted `PSModulePath` is clean: empty at User scope, and
`C:\Program Files\WindowsPowerShell\Modules;C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules` at
Machine scope.

---

## Verified as working — do not "fix" these

Recorded so a later pass doesn't chase them:

1. **`Start-SshAgent` at `Microsoft.VSCode_profile.ps1:61` works.** The vendored posh-git 0.7.3 wins
   module resolution and still exports it. It becomes a real break only if posh-git is upgraded to
   1.x — see 3.8.
2. **fzf is not broken by the empty color values.** fzf tolerates empty color specs (exit `0`); only
   malformed ones error. The Catppuccin theme is a silent no-op, not a failure — see 2.1.
3. **All `.ps1`/`.psm1` files parse cleanly.** There are no syntax errors anywhere in the repo.
4. **Every aliased tool currently resolves** — `lazydocker`, `komorebic`, `nvim`, `fabric`, `yazi`,
   `open-webui`, plus `C:\usr\local\ruby-on-windows\rbenv\bin\rbenv.ps1` and
   `C:\Program Files\Git\usr\bin\file.exe`. The missing guards (3.1) are a portability risk, not a
   present failure.
5. **The 5.1 `PSModulePath` anomaly is a WSL artifact, not a misconfiguration.** Launching
   `powershell.exe` (5.1) *from WSL* shows a PS7-flavoured `$env:PSModulePath` — including
   `...\Documents2\PowerShell\Modules` and `C:\Program Files\PowerShell\7\Modules` — which makes 5.1
   fail to load `Microsoft.PowerShell.Security` (`Get-ExecutionPolicy` →
   `CouldNotAutoloadMatchingModule`). This is environment inheritance through WSL interop. The
   persisted values are correct (4.2), and a natively launched 5.1 session is unaffected.

---

## Suggested remediation order

Several of these are one-line changes that unblock measuring the others.

| # | Action | Ref | Status |
|---|---|---|---|
| 1 | Add `.gitattributes`, `git add --renormalize .`, commit | 3.5 | Open |
| 2 | Replace `Invoke-Expression` in `Get-ChildItemColor` with `-LiteralPath` (or swap for `Terminal-Icons`) | 1.1 | ✅ Done (`e90bd3c`) |
| 3 | Delete `Search-Notes`, `fab-pat.ps1`, `z.ps1`, both `Remove-Service` copies | 1.2, 1.6, 2.5, 1.5 | ✅ Done (`e90bd3c`, `3bfcbd8`) |
| 4 | `powershell.config.json` → `RemoteSigned` | 1.3 | ✅ Done (`e90bd3c`) |
| 5 | Fix or delete `ngen.ps1` | 1.4 | ✅ Done (`e90bd3c`) — fixed, not deleted |
| 6 | Point oh-my-posh at the real theme path; drop `chcp 1252` | 2.2, 2.3 | ✅ Done (`3bfcbd8`) — guarded + falls back explicitly; the theme file itself still doesn't exist on disk, separately from this config fix |
| 7 | Define `$Flavor`, or inline the fzf hex colors | 2.1 | ✅ Done (`3bfcbd8`) — inlined |
| 8 | Delete the dead `$GitPromptSettings` blocks and `$DefaultUser` | 2.4 | ✅ Done (`3bfcbd8`) |
| 9 | Consolidate the two host profiles into `profile.ps1` | 3.3, 2.6, 2.7, 2.8 | Partial (`3bfcbd8`) — the specific duplications cited in 2.6/2.7/2.8 fixed; full consolidation (3.3, Tier 3) still open |
| 10 | Cache or dispatcher-ise the fabric loader (both copies) | 3.2, 4.1 | Open |
| 11 | Guard every external-tool init with `Get-Command` | 3.1 | Open |
| 12 | Untrack `TabExpansion.xml` / `PowerTabConfig.xml`; ignore `Microsoft.PowerToys.Configure` | 3.7 | Open |
| 13 | Fix `.gitmodules`; prune stale modules from disk | 3.6, 3.8 | Open |
| 14 | Deduplicate user `Path`; fix the `e:\...lm-studio` typo | 4.2 | Open |
| 15 | Rewrite `README.md`; consider moving the repo out of OneDrive | 3.10 | Open |
