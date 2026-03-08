# AGENTS.md

## Scope
- This repository is a Windows-first PowerShell utility for diagnosing Clash, browser proxying, WSL networking, and AI-development connectivity issues.
- The outer directory is the development directory and is the place to evolve source, docs, and build tooling.
- The inner `Clash_Network_Doctor/` directory is the release directory and should not be edited during normal development work unless the user explicitly asks.
- The active development script lives at `Clash_Network_Doctor_CN_deeptrace.ps1`.
- The launcher lives at `Run_Clash_Doctor.cmd`.
- Development build helpers live under `tools/`, source fragments live under `src/`, and reports are written under `Clash_Network_Doctor_Reports/` at runtime.

## Repository Facts
- Language: PowerShell 5.1 script plus a tiny Windows `.cmd` launcher.
- Runtime target: Windows PowerShell (`powershell.exe`), not PowerShell 7-specific tooling.
- Entry point: `Clash_Network_Doctor_CN_deeptrace.ps1`.
- Script header uses `#requires -Version 5.1` and `[CmdletBinding()]`.
- Script supports `-NoPause` for non-interactive automation.
- The script stores a locally encrypted Clash API secret in `.clash_api_secret.dat`.
- There is still no formal test framework, but there is now a build script and a regression checklist.

## Agent Priorities
- Preserve Windows PowerShell 5.1 compatibility unless the user explicitly asks to raise the minimum version.
- Preserve current Chinese user-facing copy unless there is a clear reason to revise it.
- Prefer small, surgical edits; the root script remains the source of truth even as the development layout evolves.
- Do not assume Unix tooling, bash, or cross-platform abstractions are available to end users.
- Treat generated reports and saved secret files as runtime artifacts, not source files to edit.
- Keep the end-user delivery model as a single script plus launcher, even if development files become split.

## Cursor And Copilot Rules
- No `.cursorrules` file was found.
- No files were found under `.cursor/rules/`.
- No `.github/copilot-instructions.md` file was found.
- If any of those files are added later, merge their guidance into this document and treat the more specific rule as higher priority.

## Build Commands
- Build validation only:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\build-release.ps1" -ValidateOnly
```
- Generate single-file build artifact:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\build-release.ps1"
```
- Preferred smoke run:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File ".\Clash_Network_Doctor_CN_deeptrace.ps1"
```
- Non-interactive smoke run:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File ".\Clash_Network_Doctor_CN_deeptrace.ps1" -NoPause -NoSecretPrompt
```
- Launcher-based run:
```cmd
.\Run_Clash_Doctor.cmd
```

## Lint Commands
- No linter is configured in-repo.
- Closest safe syntax validation from the shell:
```powershell
powershell -NoProfile -Command "$null = [System.Management.Automation.PSParser]::Tokenize((Get-Content -Raw '.\Clash_Network_Doctor_CN_deeptrace.ps1'), [ref]$null)"
```
- If `PSScriptAnalyzer` is installed globally, this is the preferred optional lint command:
```powershell
powershell -NoProfile -Command "Invoke-ScriptAnalyzer -Path '.\Clash_Network_Doctor_CN_deeptrace.ps1'"
```
- Do not add a lint step that requires new dependencies unless the user asks for tooling setup.

## Test Commands
- No automated test suite is checked in.
- No Pester tests were found.
- No single-test command exists today because there are no test files or test framework configuration.
- Best available verification is targeted script execution with parameters.

## Single-Test Equivalents
- For fast verification, run the script with non-interactive flags:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File ".\Clash_Network_Doctor_CN_deeptrace.ps1" -NoPause -NoSecretPrompt
```
- To validate a specific API-secret flow:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File ".\Clash_Network_Doctor_CN_deeptrace.ps1" -ClashSecret "<secret>" -NoPause
```
- To isolate report output during testing:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File ".\Clash_Network_Doctor_CN_deeptrace.ps1" -ReportRoot "$env:TEMP\clash-doctor-test" -NoPause -NoSecretPrompt
```
- To verify saved-secret reset behavior:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File ".\Clash_Network_Doctor_CN_deeptrace.ps1" -ForgetSavedSecret -NoPause
```
- To validate the build script without writing artifacts:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\build-release.ps1" -ValidateOnly
```

## Developer Workflow
- Read `README.md` first for user-facing behavior and operational expectations.
- Read the root script before making assumptions; it remains the executable source of truth.
- Treat `src/` as development scaffolding for future split-source maintenance and `tools/build-release.ps1` as the single-file build path.
- Check whether a change affects interactive prompts, report output, saved secret handling, or runtime probe timing.
- When possible, verify with a non-interactive run to avoid blocking on `Read-Host`.
- Use `docs/REGRESSION_CHECKLIST.md` as the baseline manual verification list.

## Style Overview
- Follow existing PowerShell style rather than introducing a new formatting regime.
- Match the current script's imperative, utility-oriented structure.
- Keep functions small enough to be skimmable, but do not over-fragment a linear diagnostic flow.
- Prefer readability over cleverness; this script is maintained as an operations tool.

## Formatting
- Use 4-space indentation.
- Put opening braces on the same line as `function`, `if`, `foreach`, and `try` blocks.
- Keep parameter declarations compact when short; use one parameter per line when signatures grow.
- Preserve the existing blank-line rhythm between functions and major execution phases.
- Prefer one logical step per line in the main execution flow.

## Imports And Dependencies
- There are no explicit module imports today.
- Prefer built-in Windows PowerShell cmdlets and .NET types already available in PowerShell 5.1.
- Avoid adding external module dependencies unless the user explicitly wants repository tooling expanded.
- If an optional tool is used, gate it defensively and keep the script functional without it.

## Types And Data Shapes
- Use explicit parameter types for public function inputs where practical, e.g. `[string]`, `[int]`, `[switch]`.
- Use `[pscustomobject]` for structured return values from probe/helper functions.
- Use `[ordered]@{}` when output field ordering matters.
- Use `System.Collections.Generic.List[string]` when the script accumulates report lines, diagnosis items, or suggestions.
- Normalize nullable or missing values to sentinel text like `<empty>` when the current output format expects strings.

## Naming Conventions
- Use PascalCase with verb-noun names for functions, e.g. `Invoke-WslProbe`, `Get-SystemProxyInfo`, `Save-Report`.
- Use approved PowerShell verbs when possible: `Get`, `Invoke`, `Save`, `Select`, `Write`, `Add`, `Format`, `Read`.
- Use descriptive variable names over abbreviations unless the value is conventional and obvious.
- Reserve `$script:` scope for shared report state and cross-function execution context.
- Keep report field names stable unless the user explicitly wants a breaking output change.

## Error Handling
- This script intentionally sets `$ErrorActionPreference = "SilentlyContinue"` globally; do not change that casually.
- Use local `try/catch` blocks around probes that can fail due to network, permissions, or missing Windows features.
- Convert exceptions into structured evidence instead of terminating the whole run.
- Return stable objects with explicit failure markers rather than throwing for routine probe failures.
- Use `Safe-Text`-style normalization when surfacing exception messages or optional values.

## Output And UX
- Preserve the current console/report structure: summary, quick status, details, AI Development, diagnosis, suggestions.
- Keep user-facing output actionable and diagnostic, not just raw command output.
- Prefer concrete evidence strings over vague success/failure labels.
- When adding a new probe, add both machine-readable summary status and human-readable evidence where appropriate.
- Keep interactive prompts minimal and only for values the script genuinely cannot infer.
- For AI-development probes, prefer recommendation output such as "proxy recommended" or "mirror may help" over automatic environment mutation.

## Control Flow Patterns
- Existing code prefers helper functions that return objects, followed by a linear aggregation phase.
- Continue using that pattern for new probes.
- Compute raw probe results first, then derive status strings, then append diagnosis/suggestion text.
- Avoid deeply nested control flow when a sequence of guard clauses or derived status variables is clearer.

## Data And Security Handling
- Never log or hardcode a real Clash API secret.
- Preserve the current DPAPI-style `ConvertFrom-SecureString` / `ConvertTo-SecureString` local secret storage approach unless security requirements change.
- Be careful when editing report output so secrets, bearer tokens, or private local paths are not leaked unintentionally.
- Treat `.clash_api_secret.dat` as sensitive local state.

## Compatibility Guidance
- Prefer cmdlets and APIs known to work in Windows PowerShell 5.1.
- Be conservative with syntax that is only common in PowerShell 7+.
- Assume some commands may fail on systems without WSL, Microsoft Store, or Clash; the script should degrade gracefully.
- Keep timeouts short and defensive for network probes.
- WSL probes must degrade cleanly when `wsl.exe`, `curl`, `wget`, or `git` are unavailable inside the distro.

## When Editing This Repo
- Update `README.md` if user-visible flags, launch steps, or output behavior change materially.
- If you add tests or lint configuration, update this file with exact commands, including how to run a single test.
- If you add new rule files for Cursor or Copilot, reflect them here.
- Keep development changes in the outer directory unless the user explicitly asks to modify the inner release directory.
- If you change the build or release flow, update `tools/build-release.ps1` and `docs/REGRESSION_CHECKLIST.md` together.
- If an `AGENTS.md` is later added inside a subdirectory, prefer the most local file for that subtree while keeping this root file as the broad default.
