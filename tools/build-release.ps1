#requires -Version 5.1
[CmdletBinding()]
param(
    [string]$SourceScript = "",
    [string]$OutputScript = "",
    [switch]$ValidateOnly = $false
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-FullPath {
    param([string]$Path,[string]$BaseDir)
    if ([string]::IsNullOrWhiteSpace($Path)) { return "" }
    if ([System.IO.Path]::IsPathRooted($Path)) { return $Path }
    return (Join-Path $BaseDir $Path)
}

$repoRoot = Split-Path -Path $PSScriptRoot -Parent
$srcDir = Join-Path $repoRoot "src"
$sourcePath = if ([string]::IsNullOrWhiteSpace($SourceScript)) { Join-Path $repoRoot "Clash_Network_Doctor_CN_deeptrace.ps1" } else { Get-FullPath -Path $SourceScript -BaseDir $repoRoot }
$outputPath = if ([string]::IsNullOrWhiteSpace($OutputScript)) { Join-Path $repoRoot "build\Clash_Network_Doctor_CN_deeptrace.ps1" } else { Get-FullPath -Path $OutputScript -BaseDir $repoRoot }

if (-not (Test-Path $sourcePath)) {
    throw "Source script not found: $sourcePath"
}

$parts = @()
if (Test-Path $srcDir) {
    $parts = @(Get-ChildItem -Path $srcDir -File -Filter *.ps1 | Sort-Object Name)
}

$sourceContent = Get-Content -Path $sourcePath -Raw -Encoding UTF8
$sections = New-Object System.Collections.Generic.List[string]
$sections.Add("# AUTO-GENERATED FILE. DO NOT EDIT DIRECTLY.") | Out-Null
$sections.Add(("# Generated: {0}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))) | Out-Null
$sections.Add(("# Source: {0}" -f $sourcePath)) | Out-Null

foreach ($part in $parts) {
    $sections.Add("") | Out-Null
    $sections.Add(("# --- BEGIN {0} ---" -f $part.Name)) | Out-Null
    $sections.Add((Get-Content -Path $part.FullName -Raw -Encoding UTF8)) | Out-Null
    $sections.Add(("# --- END {0} ---" -f $part.Name)) | Out-Null
}

$sections.Add("") | Out-Null
$sections.Add("# --- BEGIN development-root-script ---") | Out-Null
$sections.Add($sourceContent) | Out-Null
$sections.Add("# --- END development-root-script ---") | Out-Null

$builtContent = ($sections -join [Environment]::NewLine)

if ($ValidateOnly) {
    $null = [System.Management.Automation.PSParser]::Tokenize($builtContent, [ref]$null)
    Write-Host "Validation OK" -ForegroundColor Green
    exit 0
}

$outDir = Split-Path -Path $outputPath -Parent
if (-not (Test-Path $outDir)) {
    New-Item -Path $outDir -ItemType Directory -Force | Out-Null
}

Set-Content -Path $outputPath -Value $builtContent -Encoding UTF8
$null = [System.Management.Automation.PSParser]::Tokenize((Get-Content -Path $outputPath -Raw -Encoding UTF8), [ref]$null)
Write-Host ("Built release script: {0}" -f $outputPath) -ForegroundColor Green
