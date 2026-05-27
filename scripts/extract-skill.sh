#!/usr/bin/env bash
set -euo pipefail

skills_dir="./skills"
dry_run=false
skill_name=""

usage() {
  cat <<'EOF'
Usage: extract-skill.sh <skill-name> [--dry-run] [--output-dir <relative-dir>]

Create a new skill scaffold from a verified learning.

Examples:
  ./scripts/extract-skill.sh pnpm-workspace-gotchas --dry-run
  ./scripts/extract-skill.sh pnpm-workspace-gotchas
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      dry_run=true
      shift
      ;;
    --output-dir)
      [[ -n "${2:-}" ]] || { echo "--output-dir requires a value" >&2; exit 1; }
      skills_dir="$2"
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
      if [[ -z "$skill_name" ]]; then
        skill_name="$1"
      else
        echo "Unexpected argument: $1" >&2
        usage
        exit 1
      fi
      shift
      ;;
  esac
done

[[ -n "$skill_name" ]] || { echo "skill-name is required" >&2; usage; exit 1; }

if ! [[ "$skill_name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Invalid skill name. Use lowercase letters, numbers, and hyphens only." >&2
  exit 1
fi

if [[ "$skills_dir" = /* || "$skills_dir" =~ (^|/)\.\.(/|$) ]]; then
  echo "Output directory must be a relative path under the current workspace." >&2
  exit 1
fi

skills_dir="${skills_dir#./}"
skill_path="./$skills_dir/$skill_name"

title="$(printf '%s' "$skill_name" | sed 's/-/ /g')"

template() {
  cat <<EOF
---
name: $skill_name
description: "TODO: describe what this skill does and when to use it."
---

# $title

TODO: Explain the reusable problem this skill solves.

## Quick Reference

| Situation | Action |
|---|---|
| TODO | TODO |

## Procedure

1. TODO
2. TODO
3. Verify the result.

## Examples

TODO: Add a compact example.

## Safety

- Do not include secrets or project-private raw logs.
- Keep examples self-contained.

## Source Learning

- Learning ID: TODO
- Original File: .learnings/LEARNINGS.md
- Extraction Date: TODO
EOF
}

if [[ "$dry_run" == true ]]; then
  printf 'Would create %s/SKILL.md\n\n' "$skill_path"
  template
  exit 0
fi

if [[ -e "$skill_path" ]]; then
  echo "Skill path already exists: $skill_path" >&2
  exit 1
fi

mkdir -p "$skill_path"
template > "$skill_path/SKILL.md"
printf 'Created %s/SKILL.md\n' "$skill_path"
