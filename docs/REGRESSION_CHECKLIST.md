# Regression Checklist

## Scope
- This checklist applies to the development directory only.
- Do not overwrite the inner `Clash_Network_Doctor/` release directory by hand.

## Smoke Checks
- Syntax validation:
```powershell
powershell -NoProfile -Command "$null = [System.Management.Automation.PSParser]::Tokenize((Get-Content -Raw '.\Clash_Network_Doctor_CN_deeptrace.ps1'), [ref]$null)"
```
- Build pipeline validation:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\build-release.ps1" -ValidateOnly
```
- Non-interactive smoke run:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File ".\Clash_Network_Doctor_CN_deeptrace.ps1" -NoPause -NoSecretPrompt
```
- Isolated report output:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File ".\Clash_Network_Doctor_CN_deeptrace.ps1" -ReportRoot "$env:TEMP\clash-doctor-test" -NoPause -NoSecretPrompt
```

## Functional Checks
- Confirm startup self-check still renders and exits cleanly.
- Confirm `Run_Clash_Doctor.cmd` still forwards arguments unchanged.
- Confirm report includes `[RESULT]`, `[SUMMARY]`, `[DETAILS]`, `[AI_DEVELOPMENT]`, `[DIAGNOSIS]`, and `[SUGGESTIONS]` when AI probes run.
- Confirm `-NoPause` suppresses all interactive pause prompts.
- Confirm `-ForgetSavedSecret` still removes the saved secret and the script recovers gracefully.

## WSL/AI Checks
- If WSL exists, verify both `WSL HTTP Direct` and `WSL HTTP Proxy` appear in summary and details.
- Verify AI connectivity rows appear for PyPI, HuggingFace, GitHub, Conda, and Ubuntu Repo.
- If `git` exists inside WSL, verify the GitHub git probe produces a verdict and latency.
- If WSL is missing, verify all new probes degrade gracefully with `NO_WSL`-style output.

## Release Notes Checklist
- Update `VERSION`.
- Update `CHANGELOG.md`.
- Update `README.md` if flags, report sections, or usage changed.
- If build flow changes, update `AGENTS.md`.
