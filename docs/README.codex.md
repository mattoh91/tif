# Cutiepie for Codex

Guide for using Cutiepie with OpenAI Codex via local plugin installation.

## Quick Install

From a local checkout:

```bash
codex plugin marketplace add /absolute/path/to/cutiepie
```

Restart Codex, open `/plugins`, choose `Cutiepie Local`, install `Cutiepie`, then start a new thread.

## Manual Installation

### Prerequisites

- OpenAI Codex CLI
- Git

### Steps

1. Clone the repo:
   ```bash
   git clone https://github.com/mattoh91/cutiepie.git ~/.codex/cutiepie
   ```

2. Add the local plugin marketplace:
   ```bash
   codex plugin marketplace add ~/.codex/cutiepie
   ```

3. Restart Codex, open `/plugins`, choose `Cutiepie Local`, and install `Cutiepie`.

### Direct Skill Symlink

For raw skill development without installing the plugin:

   ```bash
   mkdir -p ~/.agents/skills
   ln -sfn ~/.codex/cutiepie/skills ~/.agents/skills/cutiepie
   ```

Restart Codex after changing the symlink.

### Subagents and Hooks

For subagent skills and hook-based state refresh, enable these features in `~/.codex/config.toml`:

   ```toml
   [features]
   multi_agent = true
   hooks = true
   ```

### Windows

Use a junction instead of a symlink (works without Developer Mode):

```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.agents\skills"
cmd /c mklink /J "$env:USERPROFILE\.agents\skills\cutiepie" "$env:USERPROFILE\.codex\cutiepie\skills"
```

## How It Works

Codex installs Cutiepie through the local marketplace in `.agents/plugins/marketplace.json`, which points at this checkout and reads `.codex-plugin/plugin.json`.

The direct symlink fallback uses Codex skill discovery, which scans `~/.agents/skills/` at startup, parses SKILL.md frontmatter, and loads skills on demand:

```
~/.agents/skills/cutiepie/ → ~/.codex/cutiepie/skills/
```

The `using-cutiepie` skill is discovered automatically in either path and enforces skill usage discipline.

## Usage

Skills are discovered automatically. Codex activates them when:
- You mention a skill by name (e.g., "use brainstorming")
- The task matches a skill's description
- The `using-cutiepie` skill directs Codex to use one

### Personal Skills

Create your own skills in `~/.agents/skills/`:

```bash
mkdir -p ~/.agents/skills/my-skill
```

Create `~/.agents/skills/my-skill/SKILL.md`:

```markdown
---
name: my-skill
description: Use when [condition] - [what it does]
---

# My Skill

[Your skill content here]
```

The `description` field is how Codex decides when to activate a skill automatically — write it as a clear trigger condition.

## Updating

```bash
cd ~/.codex/cutiepie && git pull
```

Restart Codex after updating a plugin install. Direct symlink installs see file changes immediately, but Codex still needs a restart for discovery changes.

## Uninstalling

Plugin install:

```bash
codex plugin marketplace remove cutiepie-local
```

Direct symlink install:

```bash
rm ~/.agents/skills/cutiepie
```

**Windows (PowerShell):**
```powershell
Remove-Item "$env:USERPROFILE\.agents\skills\cutiepie"
```

Optionally delete the clone: `rm -rf ~/.codex/cutiepie` (Windows: `Remove-Item -Recurse -Force "$env:USERPROFILE\.codex\cutiepie"`).

## Troubleshooting

### Skills not showing up

1. Verify the symlink: `ls -la ~/.agents/skills/cutiepie`
2. Check skills exist: `ls ~/.codex/cutiepie/skills`
3. Restart Codex — skills are discovered at startup

### Windows junction issues

Junctions normally work without special permissions. If creation fails, try running PowerShell as administrator.

## Getting Help

- Report issues: https://github.com/mattoh91/cutiepie/issues
- Main documentation: https://github.com/mattoh91/cutiepie
