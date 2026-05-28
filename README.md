# Self-Improving

A Claude Code/Codex skill for safe continuous improvement.

## Attribution

This project is an independent Claude Code/Codex adaptation that combines ideas from:

- https://github.com/zhaono1/agent-playbook/tree/main/skills/self-improving-agent — structured multi-memory design, semantic pattern memory, confidence/application tracking.
- https://github.com/peterskoett/self-improving-agent — low-risk learning logs, hook reminders, markdown log formats, skill extraction scaffold.
- https://github.com/Toolsai/auto-skill — optional keyword-indexed knowledge base and cross-skill experience memory layer ideas.

The implementation here is rewritten with conservative safety defaults: raw local capture may be automatic, but promotion to durable guidance requires consent.

## Storage Layout

By default, self-improvement data lives under the skill directory:

```text
<skill-dir>/
└── data/
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
        └── skill-self-improving.md
```

The initializer infers the skill directory from its own location: `scripts/` parent directory is treated as the skill root. Optional project-local buffers can still be initialized under `<project>/.self-improving/`.

## Quick Start

```bash
./scripts/init-learnings.sh
./scripts/init-learnings.sh --scope project --root /path/to/project
./scripts/init-learnings.sh --scope both --root /path/to/project
```

Windows/PowerShell:

```powershell
pwsh -File scripts/init-learnings.ps1
pwsh -File scripts/init-learnings.ps1 -Scope Project -Root .
pwsh -File scripts/init-learnings.ps1 -Scope Both -Root .
```

The default scope is global and initializes `<skill>/data/` without overwriting existing files. Project scope initializes `<project>/.self-improving/` as an optional local buffer.

Optional Claude Code/Codex hook config examples live in `settings/`; replace `<path-to-skill>` with the absolute installed skill path before enabling them.

## Consent Model

- Raw capture is automatic: failures, user corrections, non-obvious fixes, and feature requests can be recorded to the skill-local `data/logs/` without asking each time.
- Pattern indexing is automatic: distilled summaries can update the skill-local `data/memory/semantic-patterns.json` without storing raw sensitive output.
- Promotion is consent-based: ask before writing to `data/knowledge-base/`, `data/experience/`, `CLAUDE.md`, `AGENTS.md`, Copilot instructions, new skills, commits, or remote pushes.

## Design

- Hooks remind; they do not silently mutate durable guidance files.
- The default global store is skill-local `data/`, so it moves with the installed skill instead of living under the user home directory.
- `data/logs/` is the raw event log, and `data/memory/` stores redacted pattern summaries.
- `data/knowledge-base/` and `data/experience/` are promoted memory.
- Optional project-local `.self-improving/` buffers are ignored by git by default.
- Knowledge and experience indexes are read only when relevant, not on every turn.
