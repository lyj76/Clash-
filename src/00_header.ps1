#requires -Version 5.1
[CmdletBinding()]
param(
    [string]$ProxyHost = "127.0.0.1",
    [int]$ProxyPort = 7890,
    [int]$MixedPort = 7891,
    [int]$ApiPort   = 9090,
    [string]$ClashSecret = "",
    [string]$ReportRoot = "",
    [string]$SecretStorePath = "",
    [switch]$NoSecretPrompt = $false,
    [switch]$ForgetSavedSecret = $false,
    [switch]$NoPause = $false
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "SilentlyContinue"

try {
    [Console]::OutputEncoding = [System.Text.UTF8Encoding]::UTF8
    $OutputEncoding = [System.Text.UTF8Encoding]::UTF8
} catch {}
