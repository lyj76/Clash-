# Changelog

## 1.4.0 - 2026-03-08
- Added development-oriented build pipeline with source split support via `tools/build-release.ps1` while keeping end-user delivery as a single script.
- Added WSL direct/proxy HTTPS comparison to distinguish host connectivity problems from WSL proxy inheritance issues.
- Added `AI Development` diagnostics for WSL access to PyPI, HuggingFace, GitHub, Conda, and Ubuntu repositories.
- Added WSL `git ls-remote` probe for GitHub developer workflow validation.
- Added MTU risk heuristic and more scenario-based diagnosis/suggestion rules for AI development workflows.
- Expanded report output and quick status with AI-development-specific verdicts and evidence.

## 1.1.0 - 2026-03-08
- Added startup self-check section (PowerShell version, writable directory, proxy/API listening precheck).
- Added structured exit code contract for automation:
  - `0`: SUCCESS
  - `10`: PARTIAL
  - `20`: FAIL
  - `30`: RUNTIME_ERROR
- Added `-NoPause` switch for CI/automation mode.
- Added report `[RESULT]` section with `ExitCode` and `ExitCategory`.
- Updated launcher `Run_Clash_Doctor.cmd` to pass through arguments and return script exit code.
- Added `VERSION` file and surfaced project version in runtime output/details.
