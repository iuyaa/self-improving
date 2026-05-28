param(
  [ValidateSet("Global", "Project", "Both")]
  [string]$Scope = "Global",
  [string]$Root = "."
)

$scriptDir = Split-Path -Parent $PSCommandPath
$skillDir = Split-Path -Parent $scriptDir
$globalBaseDir = Join-Path $skillDir "data"
$projectBaseDir = Join-Path $Root ".self-improving"

function Initialize-SelfImprovingBase {
  param(
    [string]$BaseDir
  )

  $logsDir = Join-Path $BaseDir "logs"
  $memoryDir = Join-Path $BaseDir "memory"
  $knowledgeDir = Join-Path $BaseDir "knowledge-base"
  $experienceDir = Join-Path $BaseDir "experience"

  New-Item -ItemType Directory -Force -Path $logsDir, $memoryDir, $knowledgeDir, $experienceDir | Out-Null

  $learningsPath = Join-Path $logsDir "LEARNINGS.md"
  $errorsPath = Join-Path $logsDir "ERRORS.md"
  $featuresPath = Join-Path $logsDir "FEATURE_REQUESTS.md"
  $patternsPath = Join-Path $memoryDir "semantic-patterns.json"
  $knowledgeIndexPath = Join-Path $knowledgeDir "_index.json"
  $experienceIndexPath = Join-Path $experienceDir "_index.json"
  $skillExperiencePath = Join-Path $experienceDir "skill-self-improving.md"

  if (-not (Test-Path $learningsPath)) {
@'
# Learnings

Raw corrections, insights, knowledge gaps, and best practices captured during development.

**Categories**: correction | insight | knowledge_gap | best_practice

---
'@ | Set-Content -Path $learningsPath -Encoding UTF8
  }

  if (-not (Test-Path $errorsPath)) {
@'
# Errors

Raw command, tool, and integration failures. Keep entries short and redact sensitive output.

---
'@ | Set-Content -Path $errorsPath -Encoding UTF8
  }

  if (-not (Test-Path $featuresPath)) {
@'
# Feature Requests

Raw capabilities requested by the user or discovered as workflow gaps.

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
@"
# $category Knowledge

Reusable knowledge promoted from logs/.

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
  "skills": [
    {
      "id": "self-improving",
      "name": "Self-Improving",
      "file": "skill-self-improving.md",
      "keywords": ["self-improving", "learning", "memory", "promotion"],
      "count": 0
    }
  ]
}
'@ | Set-Content -Path $experienceIndexPath -Encoding UTF8
  }

  if (-not (Test-Path $skillExperiencePath)) {
@'
# Self-Improving Experience

Skill-specific lessons for using or maintaining this skill.

---

<!-- Skill-specific experience goes here. -->
'@ | Set-Content -Path $skillExperiencePath -Encoding UTF8
  }

  Write-Output "Initialized self-improvement files in $BaseDir"
}

if ($Scope -eq "Global" -or $Scope -eq "Both") {
  Initialize-SelfImprovingBase -BaseDir $globalBaseDir
}

if ($Scope -eq "Project" -or $Scope -eq "Both") {
  Initialize-SelfImprovingBase -BaseDir $projectBaseDir
}
