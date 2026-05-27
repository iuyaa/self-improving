# Self-Improving Agent

A Claude Code/Codex skill for safe continuous improvement.

## Attribution

This project is an independent Claude Code/Codex adaptation that combines ideas from:

- https://github.com/zhaono1/agent-playbook/tree/main/skills/self-improving-agent — structured multi-memory design, semantic pattern memory, confidence/application tracking.
- https://github.com/peterskoett/self-improving-agent — low-risk learning logs, hook reminders, markdown log formats, skill extraction scaffold.
- https://github.com/Toolsai/auto-skill — optional keyword-indexed knowledge base and cross-skill experience memory layer ideas.

The implementation here is rewritten with conservative safety defaults: raw local capture may be automatic, but promotion to durable guidance requires consent.

## Storage Layout

All self-improvement data lives under one root:

```text
.self-improving/
├── logs/
│   ├── LEARNINGS.md
│   ├── ERRORS.md
│   └── FEATURE_REQUESTS.md
├── memory/
│   └── semantic-patterns.json
├── knowledge-base/
│   ├── _index.json
│   ├── workflow.md
│   ├── coding.md
│   └── writing.md
└── experience/
    ├── _index.json
    └── skill-self-improving-agent.md
```

## Quick Start

```bash
./scripts/init-learnings.sh
```

Windows/PowerShell:

```powershell
pwsh -File scripts/init-learnings.ps1 -Root .
```

This initializes `.self-improving/` without overwriting existing files.

Optional Claude Code/Codex hook config examples live in `settings/`.

## Consent Model

- Raw capture is automatic: failures, user corrections, non-obvious fixes, and feature requests can be recorded to `.self-improving/logs/` without asking each time.
- Local pattern indexing is automatic: distilled summaries can update `.self-improving/memory/semantic-patterns.json` without storing raw sensitive output.
- Promotion is consent-based: ask before writing to `.self-improving/knowledge-base/`, `.self-improving/experience/`, `CLAUDE.md`, `AGENTS.md`, Copilot instructions, new skills, commits, or remote pushes.

## Design

- Hooks remind; they do not silently mutate durable guidance files.
- `.self-improving/logs/` and `.self-improving/memory/` stay local by default; promoted `.self-improving/knowledge-base/` and `.self-improving/experience/` entries can be shared after consent.
- `.self-improving/logs/` is the raw event log.
- `.self-improving/knowledge-base/` and `.self-improving/experience/` are promoted memory.
- Knowledge and experience indexes are read only when relevant, not on every turn.
