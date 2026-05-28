---
name: self-improving
description: "Capture errors, corrections, reusable patterns, and feature requests for Claude Code/Codex. Use after command failures, user corrections, non-obvious fixes, recurring workflow friction, or when promoting learnings into reusable skills."
---

# Self-Improving

A safe self-improvement skill for Claude Code and Codex. It combines:

- peterskoett-style low-risk markdown learning logs
- zhaono1-style structured pattern memory with confidence and application counts
- auto-skill-style optional keyword indexes for promoted knowledge and skill-specific experience
- opt-in hooks that remind and detect, but do not silently mutate durable guidance

## Attribution

This skill is an independent Claude Code/Codex adaptation inspired by:

- https://github.com/zhaono1/agent-playbook/tree/main/skills/self-improving-agent for structured multi-memory, semantic patterns, confidence tracking, and pattern promotion ideas.
- https://github.com/peterskoett/self-improving-agent for the learning log workflow, safe hook reminder model, markdown entry formats, and skill extraction flow.
- https://github.com/Toolsai/auto-skill for optional keyword-indexed knowledge-base and cross-skill experience memory layer ideas.

## Operating Principle

Raw capture is automatic; promotion is consent-based.

Record short, redacted raw facts when useful. Ask before turning those facts into durable guidance that changes future behavior or shared repository state.

## Storage Layout

By default, self-improvement data lives under this skill's directory. The initializer infers the skill root from its own path: the `scripts/` parent directory is the skill root.

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

Optional project-local buffers can be initialized under `<project>/.self-improving/` when project-specific raw logs should not enter the skill-local global store.

## Quick Reference

| Situation | Action | Ask first? |
|---|---|---:|
| Command/tool failed unexpectedly | Append an `ERR-*` entry to `data/logs/ERRORS.md` | No |
| User corrected the agent | Append an `LRN-*` correction to `data/logs/LEARNINGS.md` | No |
| Non-obvious solution was discovered | Append an `LRN-*` insight or best practice to `data/logs/LEARNINGS.md` | No |
| User requested missing capability | Append a `FEAT-*` entry to `data/logs/FEATURE_REQUESTS.md` | No |
| Same pattern repeats | Update `data/memory/semantic-patterns.json` with a redacted summary | No |
| Pattern becomes broadly useful | Promote to `data/knowledge-base/` or `data/experience/` | Yes |
| Rule affects future agent behavior | Promote to `CLAUDE.md`, `AGENTS.md`, or Copilot instructions | Yes |
| Learning becomes reusable procedure | Extract a new skill | Yes |
| Changes should be shared | Commit or push | Yes |

## First-Use Initialization

Run the initializer from the skill root:

```bash
./scripts/init-learnings.sh
./scripts/init-learnings.sh --scope project --root /path/to/project
./scripts/init-learnings.sh --scope both --root /path/to/project
```

PowerShell:

```powershell
pwsh -File scripts/init-learnings.ps1
pwsh -File scripts/init-learnings.ps1 -Scope Project -Root .
pwsh -File scripts/init-learnings.ps1 -Scope Both -Root .
```

The default scope is global and initializes `<skill>/data/` without overwriting existing files. Project scope initializes `<project>/.self-improving/` as an optional local buffer.

## Logging Rules

### Do log automatically to `data/logs/`

- short summaries of failures and fixes
- project-specific gotchas discovered through work
- corrections from the user
- repeated friction that could be automated
- redacted excerpts needed to reproduce an issue
- missing capabilities requested by the user

### Do not log by default

- secrets, tokens, private keys, cookies, environment variable dumps
- full transcripts or full source/config files
- raw command output that may contain private data
- cross-session content unless the user explicitly requests it

## Entry IDs

Use `TYPE-YYYYMMDD-XXX`:

- `LRN` for learnings
- `ERR` for errors
- `FEAT` for feature requests

Example: `LRN-20260528-001`.

## Learning Entry Format

Append to `data/logs/LEARNINGS.md`:

```markdown
## [LRN-YYYYMMDD-XXX] category

**Logged**: ISO-8601 timestamp
**Priority**: low | medium | high | critical
**Status**: pending
**Area**: frontend | backend | infra | tests | docs | config | agent

### Summary
One-line description.

### Details
What happened, what was wrong or surprising, and what is now known.

### Suggested Action
Concrete next action or prevention rule.

### Metadata
- Source: conversation | error | user_feedback | review | simplify-and-harden
- Related Files: path/to/file.ext
- Tags: tag1, tag2
- Pattern-Key: optional.stable.key
- Recurrence-Count: 1
- First-Seen: YYYY-MM-DD
- Last-Seen: YYYY-MM-DD

---
```

## Error Entry Format

Append to `data/logs/ERRORS.md`:

````markdown
## [ERR-YYYYMMDD-XXX] command_or_tool

**Logged**: ISO-8601 timestamp
**Priority**: low | medium | high | critical
**Status**: pending
**Area**: frontend | backend | infra | tests | docs | config | agent

### Summary
Brief description of what failed.

### Error
```text
Short redacted error excerpt.
```

### Context
- Command/operation attempted
- Relevant inputs, redacted
- Environment details if relevant

### Suggested Fix
Likely fix or next diagnostic step.

### Metadata
- Reproducible: yes | no | unknown
- Related Files: path/to/file.ext
- See Also: ERR-YYYYMMDD-XXX

---
````

## Feature Request Format

Append to `data/logs/FEATURE_REQUESTS.md`:

```markdown
## [FEAT-YYYYMMDD-XXX] capability_name

**Logged**: ISO-8601 timestamp
**Priority**: low | medium | high | critical
**Status**: pending
**Area**: frontend | backend | infra | tests | docs | config | agent

### Requested Capability
What the user wanted.

### User Context
Why it matters.

### Complexity Estimate
simple | medium | complex

### Suggested Implementation
Potential implementation path.

### Metadata
- Frequency: first_time | recurring
- Related Features: existing_feature_name

---
```

## Semantic Pattern Memory

Use `data/memory/semantic-patterns.json` for reusable patterns that are safe to index as redacted summaries.

```json
{
  "patterns": {
    "stable_pattern_key": {
      "id": "pat-YYYYMMDD-001",
      "name": "Short pattern name",
      "category": "workflow|tooling|testing|debugging|architecture|agent",
      "source": "LRN-YYYYMMDD-001",
      "confidence": 0.7,
      "applications": 1,
      "created": "YYYY-MM-DD",
      "last_seen": "YYYY-MM-DD",
      "pattern": "One-line reusable rule",
      "problem": "What problem this prevents",
      "solution": "What to do instead",
      "promotion_target": ["knowledge-base", "experience", "skill"]
    }
  },
  "meta": {
    "version": "1.0.0",
    "last_updated": "YYYY-MM-DD"
  }
}
```

## Promotion Rules

Promotion requires user consent. Promote when at least one is true:

- user explicitly says to remember, promote, or save as a skill
- it recurs 3+ times across at least 2 tasks
- it prevents a high-impact failure
- it is broadly applicable and verified

Promotion targets:

| Target | Use for |
|---|---|
| `data/knowledge-base/` | General reusable rules and procedures |
| `data/experience/` | Skill-specific gotchas, parameters, and successful procedures |
| `CLAUDE.md` | Project-specific rules and conventions |
| `AGENTS.md` | Agent workflows, automation, handoffs |
| `.github/copilot-instructions.md` | Copilot-facing repo guidance |
| New skill | Reusable cross-project procedure with examples/scripts |
| User memory | Stable user preference or collaboration rule |

Before promoting, distill the entry into a concise rule. Do not paste the raw incident log verbatim.

## Knowledge and Experience Layers

Use these layers only after raw entries have been distilled and the user has approved promotion.

| Layer | Path | Purpose |
|---|---|---|
| Raw event log | `data/logs/*.md` | Corrections, failures, requests, and one-off observations |
| Pattern index | `data/memory/semantic-patterns.json` | Machine-readable recurring patterns with confidence/applications |
| General knowledge | `data/knowledge-base/` | Promoted reusable rules organized by topic keywords |
| Skill experience | `data/experience/` | Skill-specific gotchas, parameters, successful procedures, and caveats |

### Reading Policy

- Read `data/knowledge-base/_index.json` only when the current task clearly matches a topic, the user asks for memory, or you are promoting/reviewing knowledge.
- Read `data/experience/_index.json` only when using or improving a specific skill and skill-specific history could affect the result.
- Do not force these reads every turn.

### Knowledge Entry Format

Use `templates/knowledge-entry.md`.

### Experience Entry Format

Use `templates/experience-entry.md`.

## Hooks

Hooks are optional and intentionally low authority.

### Claude Code / Codex minimal hook

Use `settings/claude-code-hooks.example.json` as a starting point. Replace `<path-to-skill>` with the absolute installed skill path before enabling the hook. The recommended default is only `UserPromptSubmit`.

### Optional error reminder

Enable `PostToolUse` only if you are comfortable with the hook inspecting tool output for error-like text. The script prints a reminder; it does not write logs automatically.

## Workflow

1. Initialize `data/` if missing.
2. Work normally.
3. When a trigger occurs, automatically log a compact raw entry to the skill-local `data/logs/`. Use project-local `.self-improving/logs/` only when the entry is project-specific and should not enter the global skill store.
4. If repeated or broadly applicable, automatically update the skill-local `data/memory/semantic-patterns.json` with a redacted summary.
5. Ask before promoting distilled content to `data/knowledge-base/`, `data/experience/`, project/user instructions, or a new skill.
6. Mark the original entry `resolved`, `promoted`, `wont_fix`, or `promoted_to_skill`.

## Skill Extraction

Create a scaffold from a promoted learning:

```bash
./scripts/extract-skill.sh my-new-skill --dry-run
./scripts/extract-skill.sh my-new-skill
```

Then edit `skills/my-new-skill/SKILL.md`, update the source learning status to `promoted_to_skill`, and include the skill path in metadata.

## Safety Boundaries

- Raw local logs may be automatic, but must be short and redacted.
- Do not let hooks automatically edit `SKILL.md`, `CLAUDE.md`, `AGENTS.md`, knowledge indexes, experience files, or shared memory files.
- Do not auto-create PRs or auto-push from learnings.
- Do not persist raw tool input/output by default.
- Do not auto-append global rules or force this skill into every task.
- Ask before modifying shared/global settings.
- Treat raw `data/logs/` and `data/memory/` data as skill-local private data by default; share promoted knowledge or experience only with consent.
