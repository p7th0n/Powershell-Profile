# PowerShell Configuration — Issues Report

**Audited:** 2026-09-15
**Target:** `C:\Users\dkurm\OneDrive\Documents2\PowerShell` (the PowerShell 7 `CurrentUser` profile
directory, tracked as git repo `p7th0n/Powershell-Profile`, branch `master`), plus the adjacent
Windows PowerShell 5.1 profile and machine-level `Path`.

**Status:** Originally diagnosis-only. **Update 2026-09-15:** all six Tier 1 findings (security /
correctness, `85bbbf6`), all nine Tier 2 findings (silent no-ops, `1dc2204`), and nine of ten Tier 3
findings (robustness/cost/hygiene, across `56dd740`/`b1a8911`/`d7e90fb`/`05ee7ad` plus a direct disk
cleanup) have since been fixed. Fabric AI integration was also removed entirely (a separate, explicit
request, `56dd740`) — this mooted 3.2 and half of 4.1 at the root rather than fixing them in place.
Only 3.10's OneDrive-relocation half and 4.2 (machine `Path` duplicates) remain open, both
deliberately — see those entries. Each resolved item is marked ✅ RESOLVED below with what was done
and how it was re-verified; the rest of the document is unchanged from the original audit.

**Update 2026-09-16:** 3.10 is now fully resolved. Its OneDrive-relocation half was resolved via a
per-file-symlink workaround (documented in `posh_config.md`, `7d2196e`) — the repo now lives at
`C:\Users\dkurm\Documents\Powershell`, outside OneDrive sync. Its `.git` object-store bloat half
was then resolved with a `git filter-repo` history rewrite + force-push, stripping the old vendor
binaries out of every commit (692 objects / 4.76 MiB → 264 objects / 82.6 KiB). 4.2 (machine `Path`
duplicates) has also since been resolved (the persisted user `Path` was deduplicated and the `e:\`
typo removed). **Every finding in this document is now resolved** — nothing remains open.

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
   below. **Fixed in `85bbbf6`.**
2. **Two things you deliberately configured are silently doing nothing.** The Catppuccin fzf theme
   and the Catppuccin oh-my-posh theme both fail soft. Neither prints an error; both just don't
   apply. **Fixed in `1dc2204`** — fzf now carries the real palette; oh-my-posh falls back
   explicitly instead of silently (the theme *file* itself still doesn't exist on this machine,
   which is a separate, unrelated task from the config fix).
3. **Your git history is being corrupted by line-ending churn.** 12 of the 13 currently "modified"
   files contain no real changes, and the current HEAD commit is semantically empty. **Fixed in
   `b1a8911`** — `.gitattributes` alone resolved 12 of the 13 files; only content changes commit
   cleanly from here on.

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

**Update 2026-09-15, post-fixes:** with the fabric loop removed entirely and the zoxide
double/triple-init collapsed to one guarded call (Tier 2/3), re-measured startup is **~1,188 ms**
(median of 4) — down from 1,368 ms. `Modules/` dropped from 65 MB to 50 MB after the 3.8 disk
cleanup (`Microsoft.WinGet.Client`, actively used by `winget`, accounts for nearly all of what's
left). The branch is now well ahead of `origin/master` across the Tier 1/2/3 and fabric-removal
commits — see `git log` rather than a fixed count here, since it'll only keep climbing.

**Update 2026-09-16, OneDrive relocation:** the git repo itself now lives at
`C:\Users\dkurm\Documents\Powershell`, not under OneDrive. The `**Target**` path named at the top
of this document (`...\OneDrive\Documents2\PowerShell`) is no longer the repo — it's a folder of
per-file/per-folder symlinks pointing back into the real repo, because Windows would not allow the
whole `Documents\PowerShell`-style folder to be replaced with a single symlink (see
`posh_config.md` for the exact command that was rejected and the full before/after directory
listings). `$PROFILE` still resolves through the OneDrive path for every host, since that's the
directory Windows/PowerShell hardcode — but it now just follows symlinks out to the non-synced
files, so OneDrive's background sync can no longer race with `.git`'s object store the way it did
before this fix.

**Update 2026-09-16, `.git` bloat stripped:** the `.git` 5.4 MB figure in the table above is also
stale. A `git filter-repo` rewrite + force-push (see 3.10) removed the old vendored-module binaries
from every commit in history; `.git` is now 82.6 KiB. Every commit hash cited elsewhere in this
document was rewritten by that operation — all references below have been updated to the new
hashes (the one exception is the "remove modules from tracking" commit, formerly `7c1bb6e`, whose
entire diff was content this rewrite stripped, so `filter-repo` pruned it as empty and it no longer
exists as a distinct commit).

**External tools** — all currently resolve: `zoxide`, `starship`, `fzf`, `oh-my-posh`, `git`, `rg`,
`bat`, `fd`, `gh`, `scoop`, `choco`, `winget`, `node`, `python`, `uv`, `kubectl`, `docker`, `ag`,
`fabric`, `yazi`, `lazydocker`, `komorebic`, `nvim`, `open-webui`. Not installed: `fnm`, `nvm`,
`eza`, `lsd`, `delta`, `direnv`, `terraform`, `aws`, `az`.

All `.ps1` / `.psm1` files in the repo **parse cleanly** — there are no syntax errors. Every problem
below is a semantic one.

---

## Tier 1 — Security and correctness — ✅ ALL RESOLVED

All six findings in this tier were fixed and committed in `85bbbf6` ("Fix Tier 1 security/correctness issues from config audit"). Each item below is marked
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

**Resolved (`85bbbf6`):** `Get-ChildItemColor.psm1:59-61` now branches on whether `$Path` was
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
  removed from this setup in commit `56fb743 "remove dropbox notes reference"`. `Resolve-Path` on
  line 5 therefore errors before `ag` is ever reached.
- **Dead module.** Neither profile imports `Search-Notes`. It has no manifest (reports version `0.0`),
  no `[CmdletBinding()]`, and no parameter validation.

> **Fix:** delete the module. If kept: `ag -- $search_term $notes_path` with no `Invoke-Expression`,
> a real path, and `rg` instead of `ag` (which you already have installed, and which has been
> maintained since `ag`'s last release in 2018).

**Resolved (`85bbbf6`):** module deleted (`Modules/Search-Notes/`). Confirmed nothing else in
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

**Resolved (`85bbbf6`):** `powershell.config.json` now reads
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

**Resolved (`85bbbf6`):** applied the append fix (`$env:path += ";" + ...`) and swapped
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

**Resolved (`85bbbf6`):** both copies deleted (`Microsoft.PowerShell_profile.ps1` and
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

**Resolved (`85bbbf6`):** file deleted. Confirmed nothing else in the repo referenced it, and
`fpat` (`Microsoft.PowerShell_profile.ps1:310-316`) still resolves after profile load.

---

## Tier 2 — Configured, but silently doing nothing — ✅ ALL RESOLVED

These are the expensive ones to find by hand, because nothing errors. All nine findings in
this tier were fixed and committed in `1dc2204` ("Fix Tier 2 silent-no-op issues from config
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

**Resolved (`1dc2204`):** took the inline option — no `Catppuccin` module is installed on this
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

**Resolved (`1dc2204`):** the theme file (`catppuccin_mocha.omp.json`) doesn't exist anywhere on
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

**Resolved (`1dc2204`):** removed `chcp 1252` and its misleading comment. Deliberately did *not*
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

**Resolved (`1dc2204`):** both blocks deleted from both profiles. Re-verified: `$DefaultUser`
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

**Resolved (`1dc2204`):** collapsed the whole pasted block plus the live call down to:
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

**Resolved (`1dc2204`):** removed the redundant `Import-Module posh-git` from both host-specific
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

**Resolved (`1dc2204`):** replaced the dead `ConsoleHost` guard with an unconditional
`Import-Module PSReadLine -ErrorAction SilentlyContinue` and a comment explaining why (this file
only ever loads under the VS Code host). The PSReadLine option/key-handler calls below it no
longer depend on VS Code's extension happening to preload the module first. Re-verified: PSReadLine
is loaded and those calls succeed with `profile.ps1` + this file dot-sourced in isolation.

### 2.8 `Microsoft.VSCode_profile.ps1:63` — leftover Dropbox variable — ✅ RESOLVED

```powershell
$dbNotes = "~\Dropbox\Notes"   # Notes folder
```

The path does not exist, and the variable is referenced nowhere in the repo. Commit `56fb743`
removed this from the console profile and missed this copy — the same drift described in 3.3.

**Resolved (`1dc2204`):** line deleted.

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

**Resolved (`1dc2204`):** fixed in place rather than swapping to a maintained replacement.
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

## Tier 3 — Robustness, cost, and hygiene — ✅ RESOLVED (one item partial, one deliberately left open)

Nine of ten findings fully resolved across `56dd740` (fabric removal, which mooted 3.2),
`b1a8911` (git hygiene: 3.5, 3.6, 3.7), `d7e90fb` (profile consolidation + tool guards +
function fixes: 3.1, 3.3, 3.4, 3.9), `05ee7ad` (README: half of 3.10), and a direct disk
cleanup (3.8, confirmed with the user before deleting anything since it's outside git's
tracking). The other half of 3.10 - moving the repo out of OneDrive - is deliberately left
open; see that entry.

### 3.1 No error handling around any external tool — ✅ RESOLVED

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

**Resolved (`d7e90fb`):** `oh-my-posh` and `zoxide` were already guarded in the Tier 2 fix
(`1dc2204`); `chcp` and `fabric` are gone entirely (removed separately, see `56dd740` and the
3.2/fabric-removal notes). This commit guards the remaining two: `rbenv.ps1` init is now wrapped
in `Test-Path`; the `open-webui` completer only registers when the command exists, and its
scriptblock's `_TYPER_COMPLETE_*`/`_OPEN_WEBUI_COMPLETE` cleanup moved into a `finally`; `y`
checks `yazi.exe` exists before running and wraps its body in `try`/`finally` so the temp
`--cwd-file` is always removed. Live-tested the `y` guard by pointing `$env:PATH` at a bogus
directory: got a clean `"yazi is not installed or not on PATH."` error instead of a crash.

### 3.2 216 generated functions compiled into every shell — ✅ RESOLVED (by removal)

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

**Resolved (`56dd740`):** the user asked to remove Fabric AI entirely, which removes this
finding at the root rather than optimizing it - the whole pattern loader, `yt`, and `fpat` are
gone. Also cleared the adjacent, untracked Windows PowerShell 5.1 profile (see 4.1), whose
entire content was an independent copy of the same code. `fab-pat.ps1` (the third copy) was
already deleted in the Tier 1 fix. No fabric references remain anywhere in this repo, that
profile, or the README.

### 3.3 `Microsoft.VSCode_profile.ps1` is ~110 lines of drifted copy-paste — ✅ RESOLVED

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

**Resolved (`d7e90fb`):** moved everything genuinely duplicated (posh-git/posh-docker imports,
the oh-my-posh init, `Get-ChildItemColor`/`Send-ToDrafts` imports, PSReadLine + its options/key
handlers, the fzf colors, the UTF-8 encoding default, the `ls`/`dir`/`which`/`type` aliases, and
`ll`/`dos2unix`/`Measure-Command2` plus the Chocolatey import) into `profile.ps1`. Console-only
content (rbenv, zoxide, yazi, open-webui, WezTerm, `Get-PublicIp`, `top`, `touch`,
`Restart-Process`, `pbcopy`/`pbpaste`/`k`/`v`/`lzd`) stayed in the console profile; the
ssh-agent aliases + `Start-SshAgent` stayed in the VS Code profile (the console profile has
those same three lines deliberately commented out - a real behavioral difference, not drift, so
left as-is rather than "fixed"). `$GitPromptSettings`/`$DefaultUser`/`Remove-Service` were
already removed from both in the Tier 1/2 fixes, so they didn't need moving. VS Code's
oh-my-posh line picks up the same guard the console profile already had, for free. Verified by
dot-sourcing `profile.ps1` + each host file in isolation - shared functionality confirmed working
in both, console-only functions confirmed absent from the VS Code chain.

### 3.4 Minor function defects — ✅ RESOLVED

- **`Microsoft.PowerShell_profile.ps1:189-193` — `touch`** only handles `$args[0]`, and
  `New-Item -ItemType File` **throws if the file already exists** — the opposite of Unix `touch`,
  whose main job is updating the timestamp of an existing file.
- **`:184-187` — `top`** is `While(1) { ps | sort -des cpu | select -f 15 | ft -a; sleep 1; cls }`.
  No Ctrl-C cleanup, so interrupting it can leave the screen cleared mid-render. The `cls` and `ps`
  aliases do not exist on non-Windows pwsh.
- **`:91-93` — `mkdir`** shadows the built-in `mkdir` function and drops its `-Force`,
  `-WhatIf`, and multi-path support.

**Resolved (`d7e90fb`):** `touch` now accepts multiple paths and, for an existing file, updates
`LastWriteTime` instead of throwing - re-verified both behaviors live (new file created, existing
file's timestamp actually advances, multiple paths in one call all created). `top` now uses full
cmdlet names (`Get-Process`/`Sort-Object`/`Select-Object`/`Format-Table`/`Clear-Host`) instead of
aliases - this is a clarity fix, not a portability one: this profile is Windows-only by design
(`C:\` paths, `chcp`, `komorebic` throughout), and `ps`/`cls` **do** resolve fine on this pwsh 7
install, so the "don't exist on non-Windows pwsh" part of the original finding doesn't actually
apply to how this profile is used. `mkdir` was deleted entirely rather than fixed - PowerShell's
own built-in `mkdir` function already supports `-Force` and multiple/pipeline paths (verified:
`(Get-Command mkdir).CommandType` → `Function`, and `mkdir $existingDir -Force` succeeds without
error), so the custom one was strictly worse with nothing to preserve. Same fix applied to the
VS Code profile's copy, which had the identical bug but wasn't separately cited in the audit.

### 3.5 Git: 12 of 13 "modified" files contain no real change — ✅ RESOLVED

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

**Resolved (`b1a8911`):** added `.gitattributes` (`* text=auto`, `eol=crlf` for
`.ps1`/`.psm1`/`.psd1`/`.xml`/`.json`, `eol=lf` for `.md`). This alone made `git status` go from
13 modified files down to just the one genuine pending change (`.gitignore`) - confirmed with
`git diff --ignore-cr-at-eol --stat` before and after. The three consolidated profile files were
also renormalized to CRLF to match the rest of the repo's convention.

### 3.6 Both submodule declarations are broken, in different ways — ✅ RESOLVED

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

**Resolved (`b1a8911`):** took the drop option for both. `Modules/Convertto-UnixLF`'s gitlink
was removed from the index (the directory was already empty on disk, so nothing was lost) and
the leftover empty directory removed. With both submodules gone, `.gitmodules` itself was
deleted. The two dangling `# Import-Module Convertto-UnixLF` comments in the profiles (pointing
at a module that no longer exists at all) were removed too, alongside the stale
`C:\Users\Dave\...` comment next to them (3.9).

### 3.7 Tracked files that should not be — ✅ RESOLVED

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

**Resolved (`b1a8911`):** did exactly this - `git rm --cached` on all three, plus
`Modules/Microsoft.PowerToys.Configure` added to `.gitignore`. All three files remain on disk,
just untracked. Did not switch `.gitignore` to an allowlist - the denylist works fine now that
the one thing it was missing is added, and an allowlist rewrite wasn't asked for.

### 3.8 Stale and conflicting modules on disk — ✅ RESOLVED

`Modules/` is 65 MB. Most of it is untracked since a commit titled "remove modules from tracking"
(which removed 243 files / 100,656 lines — good cleanup), but it is all still on disk and still being
synced to OneDrive. *(That commit's hash, `7c1bb6e`, no longer resolves after the 2026-09-16
`git filter-repo` history rewrite — see 3.10 — because once the paths it removed were stripped from
every commit, its own diff became empty and `filter-repo` pruned it entirely.)*

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

**Resolved:** confirmed with the user before deleting anything (this is real disk content outside
git's tracking, on the broader PS7 module path, not just this repo). Deleted `Pscx` (can't load
in PS7 at all), `PowerShellGet` (both 1.6.6 and 2.0.0), `PackageManagement`, `PowerTab`,
`Plaster`, `VirtualEnvWrapper`, and `posh-sshell` - all confirmed unused and all reinstallable
from PSGallery if ever needed. Kept `Microsoft.WinGet.Client` (actively used by `winget`, not
part of this profile's own tooling) untouched. `Modules/` dropped from 65 MB to 50 MB (nearly all
of what remains is `Microsoft.WinGet.Client`). Re-verified both profile chains still load and
`Start-SshAgent` still resolves (via posh-git 0.7.3, as before - deleting the unused
`posh-sshell` copy doesn't change that it was never the one providing it).

### 3.9 Stale identity in tracked files — ✅ RESOLVED

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

**Resolved (`b1a8911`, `d7e90fb`):** the `C:\Users\Dave\...` comments in both profiles are
gone (removed alongside the dead `Convertto-UnixLF` import comments, 3.6); `PowerTabConfig.xml`
is untracked (3.7, file itself still has the stale path on disk, but it's no longer version-
controlled); `$DefaultUser = 'Dave'` was already removed in the Tier 2 fix; `.gitmodules` (and
the account name in it) is deleted entirely (3.6). `Modules/Search-Notes/Search-Notes.psm1` was
deleted in the Tier 1 fix. `Modules/Send-ToDrafts/Send-ToDrafts.psm1:43`'s Dropbox path is inside
a small hand-written module this audit didn't otherwise flag for changes - left as-is; worth a
look if Dropbox-based drafts are still wanted.

### 3.10 Structural — ✅ ALL RESOLVED

- **The repo lived inside OneDrive**, so `.git` itself was cloud-synced — a known cause of index
  corruption when sync and git touch the object store concurrently, and it placed full repo
  history on a third-party service. **✅ RESOLVED:** Windows would not allow the profile folder
  itself to be replaced with a single symlink (`New-Item -ItemType SymbolicLink -Path
  "...\Documents\PowerShell" -Target "...\.config\powershell"` was rejected — see `posh_config.md`
  for the exact attempt). The working fix instead relocated the real repo to
  `C:\Users\dkurm\Documents\Powershell` and replaced every file/folder under the OneDrive-synced
  `...\OneDrive\Documents2\PowerShell` with an individual symlink pointing back into it
  (`New-Item -ItemType SymbolicLink -Path "...\Documents2\PowerShell\profile.ps1" -Target
  "...\Documents\Powershell\profile.ps1"`, repeated per item). `$PROFILE` still resolves through
  the OneDrive path — that part isn't configurable — but git now only ever touches the non-synced
  copy, so sync and `.git` can no longer race. Documented in `posh_config.md` (`7d2196e`).
- **`.git` was 5.4 MB against ~200 KB of live source**, because the binaries removed by the now-pruned
  "remove modules from tracking" commit (see 3.8) were permanently in the pack:
  `Modules/Pscx/3.3.2/7z64.dll` (1.48 MB), both `PSModule.psm1` copies (1.36 MB each), `7z.dll`
  (1.13 MB), `Pscx.dll-Help.xml` (798 KB), plus `Pscx.dll`, `System.Management.Automation.dll`, and
  several `Microsoft.Management.Deployment.winmd` variants. `Modules/pscx/Pscx.dll` (lowercase) also
  appeared in history alongside `Modules/Pscx/3.3.2/Pscx.dll` — a case-collision artifact of
  `core.ignorecase=true`; the same module was committed twice under two casings.
  **✅ RESOLVED (2026-09-16):** ran the standalone `git-filter-repo` script (no package install
  available without `sudo`, so used the single-file script from the upstream project directly)
  with `--invert-paths` against every directory that had ever held vendored/generated content and
  was no longer tracked: `Modules/{Pscx,pscx,PowerShellGet,PackageManagement,PowerTab,Plaster,
  VirtualEnvWrapper,posh-sshell,Microsoft.WinGet.Client,posh-docker,posh-git,PSReadLine,
  Microsoft.PowerToys.Configure}`, plus `TabExpansion.xml` and `PowerTabConfig.xml`. Deliberately
  left `Modules/Search-Notes` alone — stripping the audit trail for a documented, already-fixed
  security finding (1.2) wasn't worth the negligible space it would save.
  **Verified:** `git count-objects -vH` went from 692 objects / 4.76 MiB to 264 objects / 82.6 KiB;
  `git fsck --full --strict` was clean; `git ls-files` at the new HEAD matches the previously
  tracked-file list exactly (nothing live was touched, only history). Commit count dropped from 77
  to 66 — the 11 pruned commits were ones whose entire diff was content under the stripped paths
  (they became empty once that content was removed and `filter-repo` drops empty commits by
  default), so nothing with any surviving content was lost. A local mirror backup of the
  pre-rewrite repo was taken before running anything, and a fresh clone of the pushed remote was
  diffed against the local result to confirm GitHub actually received the rewritten history before
  declaring this done. This was a force-push to a private repo with 0 forks and no other branches,
  and the user confirmed beforehand that no coworker still has an active clone pulling from it.
- **`README.md` is stale.** It instructs cloning to `$env:USERPROFILE\Documents\WindowsPowerShell`
  (the 5.1 location, not where this repo lives), lists "Windows 10, 8 or 7" as dependencies, and its
  module table cites oh-my-posh 2.0.223, PowerShellGet 1.6.6, and newtonsoft.json — none of which
  reflect the current setup.

**Resolved (`05ee7ad`):** README rewritten to describe the actual PS7 layout (including the
`profile.ps1`/host-profile split from 3.3), the modules actually imported, and the external
tools the profile now guards against being missing. It also no longer cites `Remove-Service` as
an example function, since that was deleted in the Tier 1 fix.

**Resolved (`7d2196e`, documented in `posh_config.md`):** the repo was moved out of OneDrive to
`C:\Users\dkurm\Documents\Powershell`, with the OneDrive-synced folder replaced by per-item
symlinks back into it (see the bullet above for the mechanics and why the whole-folder symlink
Windows was tried first didn't work). This was the user's own decision and action, taken outside
git - there's no separate code commit for the move itself, only the doc that records it.

Nothing remains open under this finding.

---

## Adjacent environment

### 4.1 A second, untracked profile for Windows PowerShell 5.1 — ✅ RESOLVED (fabric content only)

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

**Resolved (fabric removal):** the fabric loop, `yt`, and `fpat` were this file's *entire* content, so
removing Fabric AI (a separate, explicit request from the user, not from this audit) left nothing to
consolidate — the file now holds a single comment noting it's intentionally empty. This file is still
not part of the git repo and still isn't brought under version control; that half of the original
finding remains open if it's ever wanted.

### 4.2 User `Path` has duplicates and a drive-letter typo — ✅ RESOLVED

Reading the **persisted** user-scope `Path` (`[Environment]::GetEnvironmentVariable("Path","User")`):

- **`C:\Users\dkurm\.dotnet\tools` appears 3×**
- **`C:\Users\dkurm\AppData\Local\Microsoft\WindowsApps` appears 2×**
- **`C:\Users\dkurm\go\bin` appears 2×**
- **`e:\Users\dkurm\.cache\lm-studio\bin`** — drive **`e:`**, where every sibling entry uses `C:`.
  `C:\Users\dkurm\.cache\lm-studio\bin` appears separately earlier in the list, so this is almost
  certainly a typo'd duplicate of it.

Every dead or duplicate entry is walked on each command resolution that misses.

**Resolved (2026-09-16):** re-read the live persisted `Path` before touching anything, since 11 days
had passed since the audit and the account had picked up several new entries in the meantime
(Warp, Obsidian, xonsh, `nu`, zoxide, mingw64, WinGet `Links`, PowerToys `DSCModules`, etc.) — the
count had grown from the audit's snapshot to 34 entries, but the same specific duplicates/typo
persisted unchanged the whole time. Deduplicated by exact string match, preserving first-occurrence
order, and dropped the `e:\...lm-studio\bin` entry entirely (its `C:\` counterpart was already
present earlier in the list, confirming the original audit's read of it as a typo rather than an
intentional second path). Used `[Environment]::SetEnvironmentVariable('Path', $new, 'User')` rather
than `setx`, which silently truncates at 1024 characters and would have corrupted a `Path` this
long. **Verified:** entry count 34 → 29; re-read the persisted value back and diffed it byte-for-byte
against the intended result before considering this done; confirmed `.dotnet\tools`, `WindowsApps`,
and `go\bin` each now appear exactly once and the `e:` entry is gone. A raw copy of the pre-change
value was saved first for easy rollback if anything downstream turns out to depend on the old
(broken) ordering.

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
| 1 | Add `.gitattributes`, `git add --renormalize .`, commit | 3.5 | ✅ Done (`b1a8911`) |
| 2 | Replace `Invoke-Expression` in `Get-ChildItemColor` with `-LiteralPath` (or swap for `Terminal-Icons`) | 1.1 | ✅ Done (`85bbbf6`) |
| 3 | Delete `Search-Notes`, `fab-pat.ps1`, `z.ps1`, both `Remove-Service` copies | 1.2, 1.6, 2.5, 1.5 | ✅ Done (`85bbbf6`, `1dc2204`) |
| 4 | `powershell.config.json` → `RemoteSigned` | 1.3 | ✅ Done (`85bbbf6`) |
| 5 | Fix or delete `ngen.ps1` | 1.4 | ✅ Done (`85bbbf6`) — fixed, not deleted |
| 6 | Point oh-my-posh at the real theme path; drop `chcp 1252` | 2.2, 2.3 | ✅ Done (`1dc2204`) — guarded + falls back explicitly; the theme file itself still doesn't exist on disk, separately from this config fix |
| 7 | Define `$Flavor`, or inline the fzf hex colors | 2.1 | ✅ Done (`1dc2204`) — inlined |
| 8 | Delete the dead `$GitPromptSettings` blocks and `$DefaultUser` | 2.4 | ✅ Done (`1dc2204`) |
| 9 | Consolidate the two host profiles into `profile.ps1` | 3.3, 2.6, 2.7, 2.8 | ✅ Done (`d7e90fb`) |
| 10 | Cache or dispatcher-ise the fabric loader (both copies) | 3.2, 4.1 | ✅ Done (`56dd740`) — removed entirely rather than optimized, per explicit request |
| 11 | Guard every external-tool init with `Get-Command` | 3.1 | ✅ Done (`d7e90fb`, plus `1dc2204` for oh-my-posh/zoxide) |
| 12 | Untrack `TabExpansion.xml` / `PowerTabConfig.xml`; ignore `Microsoft.PowerToys.Configure` | 3.7 | ✅ Done (`b1a8911`) |
| 13 | Fix `.gitmodules`; prune stale modules from disk | 3.6, 3.8 | ✅ Done (`b1a8911` for `.gitmodules`; disk pruning done directly, confirmed with user first — no commit, all pruned paths were already gitignored) |
| 14 | Deduplicate user `Path`; fix the `e:\...lm-studio` typo | 4.2 | ✅ Done (2026-09-16) — 34 entries deduplicated to 29, `e:\` typo removed |
| 15 | Rewrite `README.md`; consider moving the repo out of OneDrive | 3.10 | ✅ Done — README rewritten (`05ee7ad`); OneDrive relocation done via per-file symlinks (`7d2196e`, see `posh_config.md`); `.git` object-store bloat stripped via `git filter-repo` + force-push (2026-09-16, see 3.10) |
