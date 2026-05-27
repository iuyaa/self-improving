#!/usr/bin/env bash
set -euo pipefail

root="${1:-.}"
learnings_dir="$root/.learnings"
memory_dir="$learnings_dir/memory"

mkdir -p "$memory_dir"

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

printf 'Initialized self-improvement files in %s\n' "$learnings_dir"
