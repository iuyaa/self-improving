---
name: self-improving-agent
description: "Capture errors, corrections, reusable patterns, and feature requests for Claude Code/Codex. Use after command failures, user corrections, non-obvious fixes, recurring workflow friction, or when promoting learnings into reusable skills."
---

# Self-Improving Agent

A safe self-improvement skill for Claude Code and Codex. It combines:

- peterskoett-style low-risk `.learnings/` markdown logs
- zhaono1-style structured pattern memory with confidence and application counts
- auto-skill-style optional keyword indexes for promoted knowledge and skill-specific experience
- opt-in hooks that remind and detect, but do not silently mutate code or skills

## Attribution

This skill is an independent Claude Code/Codex adaptation inspired by:

- https://github.com/zhaono1/agent-playbook/tree/main/skills/self-improving-agent for structured multi-memory, semantic patterns, confidence tracking, and pattern promotion ideas.
- https://github.com/peterskoett/self-improving-agent for the `.learnings/` logging workflow, safe hook reminder model, markdown entry formats, and skill extraction flow.
- https://github.com/Toolsai/auto-skill for the optional keyword-indexed `knowledge-base/` and cross-skill `experience/` memory layer ideas.

## Operating Principle

Record facts first, promote later. Hooks may remind the agent, but durable changes require an explicit agent action in the current task or user approval when they affect shared instructions, skills, or repository behavior.

## Quick Reference

| Situation | Action |
|---|---|
| Command/tool failed unexpectedly | Append an `ERR-*` entry to `.learnings/ERRORS.md` |
| User corrected the agent | Append an `LRN-*` correction to `.learnings/LEARNINGS.md` |
| Non-obvious solution was discovered | Append an `LRN-*` best_practice or insight |
| User requested missing capability | Append a `FEAT-*` entry to `.learnings/FEATURE_REQUESTS.md` |
| Same pattern repeats | Update `memory/semantic-patterns.json` with confidence/applications |
| Pattern becomes broadly useful | Promote to `CLAUDE.md`, `AGENTS.md`, `.github/copilot-instructions.md`, or a new skill |

## First-Use Initialization

Run the initializer from the workspace root:

```bash
./scripts/init-learnings.sh
```

It creates, without overwriting existing files:

```text
.learnings/
├── LEARNINGS.md
├── ERRORS.md
├── FEATURE_REQUESTS.md
└── memory/
    └── semantic-patterns.json
knowledge-base/
├── _index.json
├── workflow.md
├── coding.md
└── writing.md
experience/
├── _index.json
└── skill-self-improving-agent.md
```

## Logging Rules

### Do log

- short summaries of failures and fixes
- project-specific gotchas discovered through work
- corrections from the user
- repeated friction that could be automated
- redacted excerpts needed to reproduce an issue

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

Example: `LRN-20260527-001`.

## Learning Entry Format

Append to `.learnings/LEARNINGS.md`:

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

Append to `.learnings/ERRORS.md`:

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

Append to `.learnings/FEATURE_REQUESTS.md`:

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

Use `.learnings/memory/semantic-patterns.json` only for patterns that are reusable beyond one incident.

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
      "promotion_target": ["CLAUDE.md", "AGENTS.md", "skill"]
    }
  },
  "meta": {
    "version": "1.0.0",
    "last_updated": "YYYY-MM-DD"
  }
}
```

### Confidence Guidance

| Evidence | Confidence |
|---|---:|
| One plausible incident | 0.50-0.65 |
| Verified fix in current task | 0.70-0.80 |
| Repeated across 2+ tasks | 0.80-0.90 |
| Repeated and user-confirmed | 0.90-0.98 |

## Promotion Rules

Promote a learning when at least one is true:

- user explicitly says to remember or save as a skill
- it recurs 3+ times across at least 2 tasks
- it prevents a high-impact failure
- it is broadly applicable and verified

Promotion targets:

| Target | Use for |
|---|---|
| `CLAUDE.md` | Project-specific rules and conventions |
| `AGENTS.md` | Agent workflows, automation, handoffs |
| `.github/copilot-instructions.md` | Copilot-facing repo guidance |
| New skill | Reusable cross-project procedure with examples/scripts |
| User memory | Stable user preference or collaboration rule |

Before promoting, distill the entry into a concise rule. Do not paste the incident log verbatim.

## Optional Knowledge and Experience Layers

Use these layers only after raw entries have been distilled. They are not mandatory per-turn reads.

| Layer | Path | Purpose |
|---|---|---|
| Raw event log | `.learnings/*.md` | Corrections, failures, requests, and one-off observations |
| Pattern index | `.learnings/memory/semantic-patterns.json` | Machine-readable recurring patterns with confidence/applications |
| General knowledge | `knowledge-base/` | Promoted reusable rules organized by topic keywords |
| Skill experience | `experience/` | Skill-specific gotchas, parameters, successful procedures, and caveats |

### Reading Policy

- Read `knowledge-base/_index.json` only when the current task clearly matches a topic, the user asks for memory, or you are promoting/reviewing knowledge.
- Read `experience/_index.json` only when using or improving a specific skill and skill-specific history could affect the result.
- Do not force these reads every turn.
- If a task succeeds and the user is satisfied, ask before promoting the distilled lesson into `knowledge-base/` or `experience/`.

### Knowledge Entry Format

Use `templates/knowledge-entry.md`:

```markdown
## [Short title]

**Date**: YYYY-MM-DD
**Context**: When this rule applies.
**Best Practice**:
- Step or rule 1
- Step or rule 2

**Why it matters**: What time, risk, or confusion this prevents.
**Source Learning**: LRN-YYYYMMDD-XXX
**Keywords**: keyword1, keyword2, keyword3

---
```

### Experience Entry Format

Use `templates/experience-entry.md`:

```markdown
## [Problem or technique title]

**Date**: YYYY-MM-DD
**Skill**: skill-id
**Context**: When this skill-specific experience applies.
**Solution**:
- Concrete step 1
- Concrete step 2

**Key Files/Paths**:
- path/to/file

**Source Learning**: LRN-YYYYMMDD-XXX
**Keywords**: keyword1, keyword2, keyword3

---
```

## Hooks

Hooks are optional and intentionally low authority.

### Claude Code / Codex minimal hook

Use `settings/claude-code-hooks.example.json` as a starting point. The recommended default is only `UserPromptSubmit`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "./scripts/activator.sh"
          }
        ]
      }
    ]
  }
}
```

### Optional error reminder

Enable `PostToolUse` only if you are comfortable with the hook inspecting tool output for error-like text. The script prints a reminder; it does not write logs automatically.

## Workflow

1. Initialize `.learnings/`, `knowledge-base/`, and `experience/` if missing.
2. Work normally.
3. When a trigger occurs, log a compact raw entry to `.learnings/`.
4. If repeated or broadly applicable, update semantic pattern memory.
5. If verified and valuable, ask before promoting distilled content to project/user instructions, `knowledge-base/`, `experience/`, or a new skill.
6. Mark the original entry `resolved`, `promoted`, `wont_fix`, or `promoted_to_skill`.

## Skill Extraction

Create a scaffold from a learning:

```bash
./scripts/extract-skill.sh my-new-skill --dry-run
./scripts/extract-skill.sh my-new-skill
```

Then edit `skills/my-new-skill/SKILL.md`, update the source learning status to `promoted_to_skill`, and include the skill path in metadata.

## Safety Boundaries

- Do not let hooks automatically edit `SKILL.md`, `CLAUDE.md`, `AGENTS.md`, knowledge indexes, experience files, or memory files.
- Do not auto-create PRs from learnings.
- Do not persist raw tool input/output by default.
- Do not auto-append global rules or force this skill into every task.
- Ask before modifying shared/global settings.
- Treat `.learnings/` as local by default unless the team explicitly wants it committed.
