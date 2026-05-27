#!/usr/bin/env bash
set -euo pipefail

input=""
if [[ ! -t 0 ]]; then
  input="$(cat || true)"
fi

output="${CLAUDE_TOOL_OUTPUT:-${CODEX_TOOL_OUTPUT:-}}"
if [[ -z "$output" ]]; then
  output="$input"
fi

if [[ -z "$output" ]]; then
  exit 0
fi

patterns=(
  "error:"
  "Error:"
  "ERROR:"
  "failed"
  "FAILED"
  "command not found"
  "No such file"
  "Permission denied"
  "fatal:"
  "Exception"
  "Traceback"
  "npm ERR!"
  "ModuleNotFoundError"
  "SyntaxError"
  "TypeError"
  "exit code"
  "non-zero"
)

contains_error=false
for pattern in "${patterns[@]}"; do
  if [[ "$output" == *"$pattern"* ]]; then
    contains_error=true
    break
  fi
done

if [[ "$contains_error" == true ]]; then
  cat <<'EOF'
<self-improvement-error-reminder>
A failure-like tool output was detected. If it was unexpected, non-obvious, or reusable, append a short redacted ERR entry to .learnings/ERRORS.md. Do not persist raw output that may contain secrets.
</self-improvement-error-reminder>
EOF
fi
