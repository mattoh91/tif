# Installing Cutiepie

Cutiepie can be installed as a native plugin in Codex, Claude Code, and OpenCode. For other hosts, compile the skills into the host's preferred instruction format.

## Prerequisites

- Git
- Python 3, only needed for the skill compiler
- The host app you want to use: Codex, Claude Code, OpenCode, Cursor, Copilot, or another skill-aware agent

Clone the repo first when using a local development install:

```bash
git clone https://github.com/mattoh91/cutiepie.git ~/Repos/cutiepie
cd ~/Repos/cutiepie
```

If the repo is already cloned, use that absolute path in the commands below.

## Codex

Install the local Codex plugin marketplace from the checkout:

```bash
codex plugin marketplace add /absolute/path/to/cutiepie
```

Restart Codex, open:

```text
/plugins
```

Choose `Cutiepie Local`, install `Cutiepie`, then start a new thread.

For subagent workflows and hook-based state refresh, enable these features in `~/.codex/config.toml`:

```toml
[features]
multi_agent = true
hooks = true
```

For raw skill development without plugin install, symlink the skills directory instead:

```bash
mkdir -p ~/.agents/skills
ln -sfn /absolute/path/to/cutiepie/skills ~/.agents/skills/cutiepie
```

Restart Codex after changing plugin or skill discovery state.

## Claude Code

Add Cutiepie's Claude Code marketplace from this checkout:

```text
/plugin marketplace add /absolute/path/to/cutiepie/.claude-plugin/marketplace.json
```

Install the plugin:

```text
/plugin install cutiepie@cutiepie-dev
```

Reload plugins or restart Claude Code:

```text
/reload-plugins
```

Use `/plugin` to choose user, project, or local scope interactively when you do not want the default user-scope install.

## OpenCode

Add Cutiepie to the `plugin` array in your global or project `opencode.json`:

```json
{
  "plugin": ["cutiepie@git+https://github.com/mattoh91/cutiepie.git"]
}
```

Restart OpenCode. The plugin installs through Bun and registers the Cutiepie skills directory automatically.

## Cursor, Copilot, And Other Hosts

Use the compiler to generate host-native instruction files:

```bash
python3 scripts/cutiepie-compile.py skills --agent cursor --output /path/to/project
python3 scripts/cutiepie-compile.py skills --agent copilot --output /tmp/cutiepie-copilot
python3 scripts/cutiepie-compile.py skills --agent claude --output /tmp/cutiepie-claude
python3 scripts/cutiepie-compile.py skills --agent codex --output /tmp/cutiepie-codex
```

Compiler outputs:

- Claude/Copilot: `<output>/<skill>/SKILL.md`
- Cursor: `<output>/.cursor/rules/<skill>.md`
- Codex: `<output>/AGENTS.md` with replaceable Cutiepie markers

## Verify

Ask the host:

```text
Use Cutiepie to scaffold this repo.
```

Or start with the explicit intake command:

```text
/intake
```

For a local checkout, also run:

```bash
scripts/check-cutiepie-state.sh .
tests/story-flow/test-story-flow-contract.sh
```

## Update

For local installs:

```bash
cd /absolute/path/to/cutiepie
git pull
```

Then restart the host or reload plugins. OpenCode git installs refresh on restart.

## Uninstall

Codex:

```bash
codex plugin marketplace remove cutiepie-local
rm -f ~/.agents/skills/cutiepie
```

Claude Code:

```text
/plugin uninstall cutiepie@cutiepie-dev
/plugin marketplace remove cutiepie-dev
```

OpenCode:

Remove the Cutiepie entry from `opencode.json`, then restart OpenCode.
