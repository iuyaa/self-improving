#!/usr/bin/env bash
set -euo pipefail

root="${1:-.}"
learnings_dir="$root/.learnings"
memory_dir="$learnings_dir/memory"
knowledge_dir="$root/knowledge-base"
experience_dir="$root/experience"

mkdir -p "$memory_dir" "$knowledge_dir" "$experience_dir"

if [[ ! -f "$learnings_dir/LEARNINGS.md" ]]; then
  cat > "$learnings_dir/LEARNINGS.md" <<'EOF'
# Learnings

Corrections, insights, knowledge gaps, and best practices captured during development.

**Categories**: correction | insight | knowledge_gap | best_practice

---
EOF
fi

if [[ ! -f "$learnings_dir/ERRORS.md" ]]; then
  cat > "$learnings_dir/ERRORS.md" <<'EOF'
# Errors

Command, tool, and integration failures. Keep entries short and redact sensitive output.

---
EOF
fi

if [[ ! -f "$learnings_dir/FEATURE_REQUESTS.md" ]]; then
  cat > "$learnings_dir/FEATURE_REQUESTS.md" <<'EOF'
# Feature Requests

Capabilities requested by the user or discovered as workflow gaps.

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
    title="$category"
    cat > "$file" <<EOF
# $title Knowledge

Reusable knowledge promoted from .learnings/.

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

printf 'Initialized self-improvement files in %s, %s, and %s\n' "$learnings_dir" "$knowledge_dir" "$experience_dir"
