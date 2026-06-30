# Installing Gummy

Gummy can be installed as a native plugin in Codex, Claude Code, and OpenCode. For other hosts, compile the skills into the host's preferred instruction format.

## Prerequisites

- Git
- Python 3, only needed for the skill compiler
- The host app you want to use: Codex, Claude Code, OpenCode, Cursor, Copilot, or another skill-aware agent

Clone the repo first when using a local development install:

```bash
git clone https://github.com/mattoh91/gummy.git ~/Repos/gummy
cd ~/Repos/gummy
```

If the repo is already cloned, use that absolute path in the commands below.

## Codex

Install the local Codex plugin marketplace from the checkout:

```bash
codex plugin marketplace add /absolute/path/to/gummy
```

Restart Codex, open:

```text
/plugins
```

Choose `Gummy Local`, install `Gummy`, then start a new thread.

For subagent workflows and hook-based state refresh, enable these features in `~/.codex/config.toml`:

```toml
[features]
multi_agent = true
hooks = true
```

For raw skill development without plugin install, symlink the skills directory instead:

```bash
mkdir -p ~/.agents/skills
ln -sfn /absolute/path/to/gummy/skills ~/.agents/skills/gummy
```

Restart Codex after changing plugin or skill discovery state.

## Claude Code

Add Gummy's Claude Code marketplace from this checkout:

```text
/plugin marketplace add /absolute/path/to/gummy/.claude-plugin/marketplace.json
```

Install the plugin:

```text
/plugin install gummy@gummy-dev
```

Reload plugins or restart Claude Code:

```text
/reload-plugins
```

Use `/plugin` to choose user, project, or local scope interactively when you do not want the default user-scope install.

## OpenCode

Add Gummy to the `plugin` array in your global or project `opencode.json`:

```json
{
  "plugin": ["gummy@git+https://github.com/mattoh91/gummy.git"]
}
```

Restart OpenCode. The plugin installs through Bun and registers the Gummy skills directory automatically.

## Cursor, Copilot, And Other Hosts

Use the compiler to generate host-native instruction files:

```bash
python3 scripts/gummy-compile.py skills --agent cursor --output /path/to/project
python3 scripts/gummy-compile.py skills --agent copilot --output /tmp/gummy-copilot
python3 scripts/gummy-compile.py skills --agent claude --output /tmp/gummy-claude
python3 scripts/gummy-compile.py skills --agent codex --output /tmp/gummy-codex
```

Compiler outputs:

- Claude/Copilot: `<output>/<skill>/SKILL.md`
- Cursor: `<output>/.cursor/rules/<skill>.md`
- Codex: `<output>/AGENTS.md` with replaceable Gummy markers

## Verify

Ask the host:

```text
Use Gummy to scaffold this repo.
```

Or start with the explicit intake command:

```text
/intake
```

For a local checkout, also run:

```bash
scripts/check-gummy-state.sh .
tests/story-flow/test-story-flow-contract.sh
```

## Update

For local installs:

```bash
cd /absolute/path/to/gummy
git pull
```

Then restart the host or reload plugins. OpenCode git installs refresh on restart.

## Uninstall

Codex:

```bash
codex plugin marketplace remove gummy-local
rm -f ~/.agents/skills/gummy
```

Claude Code:

```text
/plugin uninstall gummy@gummy-dev
/plugin marketplace remove gummy-dev
```

OpenCode:

Remove the Gummy entry from `opencode.json`, then restart OpenCode.
