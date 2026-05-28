#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
skill_dir="$(cd -- "$script_dir/.." && pwd -P)"
data_dir="$skill_dir/data"

cat <<EOF
<self-improvement-reminder>
After this task, automatically capture only durable raw learning to $data_dir/logs/: unexpected failures, user corrections, non-obvious fixes, recurring friction, or missing capabilities. Redact secrets. Ask before promoting to knowledge-base, experience, instructions, skills, commits, or remote pushes.
</self-improvement-reminder>
EOF
