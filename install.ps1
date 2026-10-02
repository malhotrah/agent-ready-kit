<#
.SYNOPSIS
  Installs the /agent-ready Claude Code skill for the current user (Windows).

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File install.ps1
  powershell -ExecutionPolicy Bypass -File install.ps1 -Force
  powershell -ExecutionPolicy Bypass -File install.ps1 -Uninstall
#>
param(
    [switch]$Force,
    [switch]$Uninstall
)

$ErrorActionPreference = "Stop"
$SkillName = "agent-ready"
$Source = Join-Path $PSScriptRoot "skills\$SkillName"

$ClaudeDir = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $env:USERPROFILE ".claude" }
$Target = Join-Path $ClaudeDir "skills\$SkillName"

if ($Uninstall) {
    if (Test-Path $Target) {
        Remove-Item -Recurse -Force $Target
        Write-Host "Removed $Target" -ForegroundColor Green
    } else {
        Write-Host "Nothing to remove: $Target does not exist."
    }
    exit 0
}

if (-not (Test-Path (Join-Path $Source "SKILL.md"))) {
    Write-Error "Can't find $Source\SKILL.md. Run this script from the agent-ready-kit folder."
}

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-Warning "'claude' is not on PATH. Install Claude Code first: https://docs.claude.com/en/docs/claude-code (the skill also works in the Claude desktop app's Code tab)."
}
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Warning "'node' is not on PATH. The generated hooks are Node scripts. /agent-ready will offer to skip them."
}

if (Test-Path $Target) {
    if (-not $Force) {
        $answer = Read-Host "$Target already exists. Replace it with this version? [y/N]"
        if ($answer -notmatch '^(y|yes)$') { Write-Host "Cancelled. Nothing changed."; exit 1 }
    }
    Remove-Item -Recurse -Force $Target
}

New-Item -ItemType Directory -Force -Path (Split-Path $Target) | Out-Null
Copy-Item -Recurse -Path $Source -Destination $Target

Write-Host ""
Write-Host "Installed /$SkillName to $Target" -ForegroundColor Green
Write-Host ""
Write-Host "Next:"
Write-Host "  1. Open Claude Code in the repo you want to prepare:   cd <your-repo>; claude"
Write-Host "  2. Run:   /$SkillName          (or '/$SkillName audit' to only report gaps)"
