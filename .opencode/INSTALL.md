# Installing Cutiepie for OpenCode

## Prerequisites

- [OpenCode.ai](https://opencode.ai) installed

## Installation

Add cutiepie to the `plugin` array in your `opencode.json` (global or project-level):

```json
{
  "plugin": ["cutiepie@git+https://github.com/mattoh91/cutiepie.git"]
}
```

Restart OpenCode. That's it — the plugin auto-installs and registers all skills.

Verify by asking: "Tell me about your cutiepie"

## Migrating from the old symlink-based install

If you previously installed cutiepie using `git clone` and symlinks, remove the old setup:

```bash
# Remove old symlinks
rm -f ~/.config/opencode/plugins/cutiepie.js
rm -rf ~/.config/opencode/skills/cutiepie

# Optionally remove the cloned repo
rm -rf ~/.config/opencode/cutiepie

# Remove skills.paths from opencode.json if you added one for cutiepie
```

Then follow the installation steps above.

## Usage

Use OpenCode's native `skill` tool:

```
use skill tool to list skills
use skill tool to load cutiepie/brainstorming
```

## Updating

Cutiepie updates automatically when you restart OpenCode.

To pin a specific version:

```json
{
  "plugin": ["cutiepie@git+https://github.com/mattoh91/cutiepie.git#v5.0.3"]
}
```

## Troubleshooting

### Plugin not loading

1. Check logs: `opencode run --print-logs "hello" 2>&1 | grep -i cutiepie`
2. Verify the plugin line in your `opencode.json`
3. Make sure you're running a recent version of OpenCode

### Skills not found

1. Use `skill` tool to list what's discovered
2. Check that the plugin is loading (see above)

### Tool mapping

When skills reference Claude Code tools:
- `TodoWrite` → `todowrite`
- `Task` with subagents → `@mention` syntax
- `Skill` tool → OpenCode's native `skill` tool
- File operations → your native tools

## Getting Help

- Report issues: https://github.com/mattoh91/cutiepie/issues
- Full documentation: https://github.com/mattoh91/cutiepie/blob/main/docs/README.opencode.md
