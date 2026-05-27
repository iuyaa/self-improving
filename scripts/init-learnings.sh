#!/usr/bin/env bash
set -euo pipefail

root="${1:-.}"
base_dir="$root/.self-improving"
logs_dir="$base_dir/logs"
memory_dir="$base_dir/memory"
knowledge_dir="$base_dir/knowledge-base"
experience_dir="$base_dir/experience"

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
  file="$knowledge_dir/$category.md"
  if [[ ! -f "$file" ]]; then
    cat > "$file" <<EOF
# $category Knowledge

Reusable knowledge promoted from .self-improving/logs/.

---

<!-- Promoted knowledge goes here. -->
EOF
  fi
done

if [[ ! -f "$experience_dir/_index.json" ]]; then
  cat > "$experience_dir/_index.json" <<'EOF'
{
  "lastUpdated": null,
  "version": "1.0.0",
  "skills": []
}
EOF
fi

printf 'Initialized self-improvement files in %s\n' "$base_dir"
