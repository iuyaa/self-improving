# Self-Improving Agent

A Claude Code/Codex skill for safe continuous improvement.

## Attribution

This project is an independent Claude Code/Codex adaptation that combines ideas from:

- https://github.com/zhaono1/agent-playbook/tree/main/skills/self-improving-agent — structured multi-memory design, semantic pattern memory, confidence/application tracking.
- https://github.com/peterskoett/self-improving-agent — low-risk `.learnings/` workflow, hook reminders, markdown log formats, skill extraction scaffold.

The implementation here is rewritten for this repository with conservative safety defaults: hooks remind rather than auto-mutate durable files.

It combines markdown learning logs with optional structured pattern memory:

- `.learnings/LEARNINGS.md` for corrections, insights, and best practices
- `.learnings/ERRORS.md` for command/tool failures
- `.learnings/FEATURE_REQUESTS.md` for requested capabilities
- `.learnings/memory/semantic-patterns.json` for recurring reusable patterns

## Quick Start

```bash
./scripts/init-learnings.sh
```

Optional Claude Code/Codex hook config examples live in `settings/`.

## Design

- Hooks remind; they do not silently mutate durable files.
- Logs are short, redacted, and local by default.
- Repeated learnings can be promoted to `CLAUDE.md`, `AGENTS.md`, Copilot instructions, or a new skill.
