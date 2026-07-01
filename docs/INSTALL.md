# Installing Tif

Tif can be installed as a native plugin in Codex, Claude Code, and OpenCode. For other hosts, compile the skills into the host's preferred instruction format.

## Prerequisites

- Git
- Python 3, only needed for the skill compiler
- The host app you want to use: Codex, Claude Code, OpenCode, Cursor, Copilot, or another skill-aware agent

Clone the repo first when using a local development install:

```bash
git clone https://github.com/mattoh91/tif.git ~/Repos/tif
cd ~/Repos/tif
```

If the repo is already cloned, use that absolute path in the commands below.

## Codex

Install the local Codex plugin marketplace from the checkout:

```bash
codex plugin marketplace add /absolute/path/to/tif
```

Restart Codex, open:

```text
/plugins
```

Choose `Tif Local`, install `Tif`, then start a new thread.

For subagent workflows and hook-based state refresh, enable these features in `~/.codex/config.toml`:

```toml
[features]
multi_agent = true
hooks = true
```

For raw skill development without plugin install, symlink the skills directory instead:

```bash
mkdir -p ~/.agents/skills
ln -sfn /absolute/path/to/tif/skills ~/.agents/skills/tif
```

Restart Codex after changing plugin or skill discovery state.

## Claude Code

Add Tif's Claude Code marketplace from this checkout:

```text
/plugin marketplace add /absolute/path/to/tif/.claude-plugin/marketplace.json
```

Install the plugin:

```text
/plugin install tif@tif-dev
```

Reload plugins or restart Claude Code:

```text
/reload-plugins
```

Use `/plugin` to choose user, project, or local scope interactively when you do not want the default user-scope install.

## OpenCode

Add Tif to the `plugin` array in your global or project `opencode.json`:

```json
{
  "plugin": ["tif@git+https://github.com/mattoh91/tif.git"]
}
```

Restart OpenCode. The plugin installs through Bun and registers the Tif skills directory automatically.

## Cursor, Copilot, And Other Hosts

Use the compiler to generate host-native instruction files:

```bash
python3 scripts/tif-compile.py skills --agent cursor --output /path/to/project
python3 scripts/tif-compile.py skills --agent copilot --output /tmp/tif-copilot
python3 scripts/tif-compile.py skills --agent claude --output /tmp/tif-claude
python3 scripts/tif-compile.py skills --agent codex --output /tmp/tif-codex
```

Compiler outputs:

- Claude/Copilot: `<output>/<skill>/SKILL.md`
- Cursor: `<output>/.cursor/rules/<skill>.md`
- Codex: `<output>/AGENTS.md` with replaceable Tif markers

## Verify

Ask the host:

```text
Use Tif to scaffold this repo.
```

Or start with the explicit onboarding command (`/intake` still works as an alias):

```text
/onboard
```

For a local checkout, also run:

```bash
scripts/check-tif-state.sh .
tests/story-flow/test-story-flow-contract.sh
```

## Slide Deck (optional)

The `/deck` command renders a self-contained `docs/ppt/deck.html` presentation
from your `.tif/` artifacts, embedding a hand-authored draw.io architecture
SVG. It is opt-in: `/finish` and `/document` never generate a deck.

Requirements:

- Node.js (already required for OpenCode; used here to build and verify the deck).
- Playwright, only for the diagram neatness gate:

  ```bash
  npm install -D playwright
  npx playwright install chromium
  ```

  Without Playwright the deck still renders; the neatness gate reports
  `skipped` and never claims the diagram was verified.

Run the deck's own tests:

```bash
npm run test:deck
```

## Update

For local installs:

```bash
cd /absolute/path/to/tif
git pull
```

Then restart the host or reload plugins. OpenCode git installs refresh on restart.

## Uninstall

Codex:

```bash
codex plugin marketplace remove tif-local
rm -f ~/.agents/skills/tif
```

Claude Code:

```text
/plugin uninstall tif@tif-dev
/plugin marketplace remove tif-dev
```

OpenCode:

Remove the Tif entry from `opencode.json`, then restart OpenCode.
