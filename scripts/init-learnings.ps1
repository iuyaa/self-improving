param(
  [string]$Root = "."
)

$learningsDir = Join-Path $Root ".learnings"
$memoryDir = Join-Path $learningsDir "memory"

New-Item -ItemType Directory -Force -Path $memoryDir | Out-Null

$learningsPath = Join-Path $learningsDir "LEARNINGS.md"
$errorsPath = Join-Path $learningsDir "ERRORS.md"
$featuresPath = Join-Path $learningsDir "FEATURE_REQUESTS.md"
$patternsPath = Join-Path $memoryDir "semantic-patterns.json"

if (-not (Test-Path $learningsPath)) {
@'
# Learnings

Corrections, insights, knowledge gaps, and best practices captured during development.

**Categories**: correction | insight | knowledge_gap | best_practice

---
'@ | Set-Content -Path $learningsPath -Encoding UTF8
}

if (-not (Test-Path $errorsPath)) {
@'
# Errors

Command, tool, and integration failures. Keep entries short and redact sensitive output.

---
'@ | Set-Content -Path $errorsPath -Encoding UTF8
}

if (-not (Test-Path $featuresPath)) {
@'
# Feature Requests

Capabilities requested by the user or discovered as workflow gaps.

---
'@ | Set-Content -Path $featuresPath -Encoding UTF8
}

if (-not (Test-Path $patternsPath)) {
@'
{
  "patterns": {},
  "meta": {
    "version": "1.0.0",
    "last_updated": null
  }
}
'@ | Set-Content -Path $patternsPath -Encoding UTF8
}

Write-Output "Initialized self-improvement files in $learningsDir"
