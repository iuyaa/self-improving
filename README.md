# Self-Improving Agent

A Claude Code/Codex skill for safe continuous improvement.

## Attribution

This project is an independent Claude Code/Codex adaptation that combines ideas from:

- https://github.com/zhaono1/agent-playbook/tree/main/skills/self-improving-agent — structured multi-memory design, semantic pattern memory, confidence/application tracking.
- https://github.com/peterskoett/self-improving-agent — low-risk `.learnings/` workflow, hook reminders, markdown log formats, skill extraction scaffold.
- https://github.com/Toolsai/auto-skill — optional keyword-indexed `knowledge-base/` and cross-skill `experience/` memory layer ideas.

The implementation here is rewritten for this repository with conservative safety defaults: hooks remind rather than auto-mutate durable files.

It combines markdown learning logs with optional structured memory layers:

- `.learnings/LEARNINGS.md` for raw corrections, insights, and best practices
- `.learnings/ERRORS.md` for raw command/tool failures
- `.learnings/FEATURE_REQUESTS.md` for requested capabilities
- `.learnings/memory/semantic-patterns.json` for machine-readable recurring patterns, confidence, and application counts
- `knowledge-base/` for promoted reusable rules organized by topic
- `experience/` for skill-specific gotchas, parameters, and successful procedures

## Quick Start

```bash
./scripts/init-learnings.sh
```

Windows/PowerShell:

```powershell
pwsh -File scripts/init-learnings.ps1 -Root .
```

This initializes `.learnings/`, `knowledge-base/`, and `experience/` without overwriting existing files.

Optional Claude Code/Codex hook config examples live in `settings/`.

## Design

- Hooks remind; they do not silently mutate durable files.
- Logs are short, redacted, and local by default.
- `.learnings/` is the raw event log; `knowledge-base/` and `experience/` are optional promoted memory.
- Knowledge and experience indexes are read only when relevant, not on every turn.
- Repeated learnings can be promoted to `CLAUDE.md`, `AGENTS.md`, Copilot instructions, `knowledge-base/`, `experience/`, or a new skill.
