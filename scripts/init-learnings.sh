#!/usr/bin/env bash
set -euo pipefail

scope="global"
root="."

usage() {
  cat <<'EOF'
Usage: init-learnings.sh [--scope global|project|both] [--root <project-root>]

Initializes self-improvement storage. Global storage lives in the skill's data/ directory, inferred from this script's parent directory.
Project storage lives under <project-root>/.self-improving/ and is intended as an optional local buffer.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --scope)
      [[ -n "${2:-}" ]] || { echo "--scope requires a value" >&2; exit 1; }
      scope="$2"
      shift 2
      ;;
    --root)
      [[ -n "${2:-}" ]] || { echo "--root requires a value" >&2; exit 1; }
      root="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -* )
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
    *)
      root="$1"
      shift
      ;;
  esac
done

case "$scope" in
  global|project|both) ;;
  *) echo "Invalid scope. Use global, project, or both." >&2; exit 1 ;;
esac

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
skill_dir="$(cd -- "$script_dir/.." && pwd -P)"

global_base_dir="$skill_dir/data"
project_base_dir="$root/.self-improving"

init_base() {
  local base_dir="$1"
  local logs_dir="$base_dir/logs"
  local memory_dir="$base_dir/memory"
  local knowledge_dir="$base_dir/knowledge-base"
  local experience_dir="$base_dir/experience"
  local experience_index_path="$experience_dir/_index.json"
  local skill_experience_path="$experience_dir/skill-self-improving.md"

  mkdir -p "$logs_dir" "$memory_dir" "$knowledge_dir" "$experience_dir"

  if [[ ! -f "$logs_dir/LEARNINGS.md" ]]; then
    cat > "$logs_dir/LEARNINGS.md" <<'EOF'
# Learnings

Raw corrections, insights, knowledge gaps, and best practices captured during development.

**Categories**: correction | insight | knowledge_gap | best_practice

---
EOF
  fi

  if [[ ! -f "$logs_dir/ERRORS.md" ]]; then
    cat > "$logs_dir/ERRORS.md" <<'EOF'
# Errors

Raw command, tool, and integration failures. Keep entries short and redact sensitive output.

---
EOF
  fi

  if [[ ! -f "$logs_dir/FEATURE_REQUESTS.md" ]]; then
    cat > "$logs_dir/FEATURE_REQUESTS.md" <<'EOF'
# Feature Requests

Raw capabilities requested by the user or discovered as workflow gaps.

---
EOF
  fi

  if [[ ! -f "$memory_dir/semantic-patterns.json" ]]; then
    cat > "$memory_dir/semantic-patterns.json" <<'EOF'
{
  "patterns": {},
  "meta": {
    "version": "1.0.0",
    "last_updated": null
  }
}
EOF
  fi

  if [[ ! -f "$knowledge_dir/_index.json" ]]; then
    cat > "$knowledge_dir/_index.json" <<'EOF'
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
EOF
  fi

  for category in workflow coding writing; do
    local file="$knowledge_dir/$category.md"
    if [[ ! -f "$file" ]]; then
      cat > "$file" <<EOF
# $category Knowledge

Reusable knowledge promoted from logs/.

---

<!-- Promoted knowledge goes here. -->
EOF
    fi
  done

  if [[ ! -f "$experience_index_path" ]]; then
    cat > "$experience_index_path" <<'EOF'
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
EOF
  fi

  if [[ ! -f "$skill_experience_path" ]]; then
    cat > "$skill_experience_path" <<'EOF'
# Self-Improving Experience

Skill-specific lessons for using or maintaining this skill.

---

<!-- Skill-specific experience goes here. -->
EOF
  fi

  printf 'Initialized self-improvement files in %s\n' "$base_dir"
}

if [[ "$scope" == "global" || "$scope" == "both" ]]; then
  init_base "$global_base_dir"
fi

if [[ "$scope" == "project" || "$scope" == "both" ]]; then
  init_base "$project_base_dir"
fi
