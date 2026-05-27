param(
  [string]$Root = "."
)

$learningsDir = Join-Path $Root ".learnings"
$memoryDir = Join-Path $learningsDir "memory"
$knowledgeDir = Join-Path $Root "knowledge-base"
$experienceDir = Join-Path $Root "experience"

New-Item -ItemType Directory -Force -Path $memoryDir, $knowledgeDir, $experienceDir | Out-Null

$learningsPath = Join-Path $learningsDir "LEARNINGS.md"
$errorsPath = Join-Path $learningsDir "ERRORS.md"
$featuresPath = Join-Path $learningsDir "FEATURE_REQUESTS.md"
$patternsPath = Join-Path $memoryDir "semantic-patterns.json"
$knowledgeIndexPath = Join-Path $knowledgeDir "_index.json"
$experienceIndexPath = Join-Path $experienceDir "_index.json"

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

if (-not (Test-Path $knowledgeIndexPath)) {
@'
{
  "lastUpdated": null,
  "version": "1.0.0",
  "totalEntries": 0,
  "categories": [
    {
      "id": "workflow",
      "name": "Workflow",
      "keywords": ["workflow", "automation", "process", "handoff", "coordination"],
      "file": "workflow.md",
      "count": 0
    },
    {
      "id": "coding",
      "name": "Coding",
      "keywords": ["coding", "debugging", "testing", "refactor", "implementation"],
      "file": "coding.md",
      "count": 0
    },
    {
      "id": "writing",
      "name": "Writing",
      "keywords": ["writing", "docs", "copy", "tone", "summary"],
      "file": "writing.md",
      "count": 0
    }
  ]
}
'@ | Set-Content -Path $knowledgeIndexPath -Encoding UTF8
}

$categories = @("workflow", "coding", "writing")
foreach ($category in $categories) {
  $file = Join-Path $knowledgeDir "$category.md"
  if (-not (Test-Path $file)) {
    $title = (Get-Culture).TextInfo.ToTitleCase($category)
@"
# $title Knowledge

Reusable knowledge promoted from .learnings/.

---

<!-- Promoted knowledge goes here. -->
"@ | Set-Content -Path $file -Encoding UTF8
  }
}

if (-not (Test-Path $experienceIndexPath)) {
@'
{
  "lastUpdated": null,
  "version": "1.0.0",
  "skills": []
}
'@ | Set-Content -Path $experienceIndexPath -Encoding UTF8
}

Write-Output "Initialized self-improvement files in $learningsDir, $knowledgeDir, and $experienceDir"
