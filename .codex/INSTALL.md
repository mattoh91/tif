# Installing Sweet for Codex

Sweet can be installed as a Codex plugin from this local checkout.

## Local Plugin Installation

```bash
codex plugin marketplace add /Users/OHM02/Repos/sweet
```

Restart Codex, open:

```text
/plugins
```

Choose `Sweet Local`, install `Sweet`, then start a new thread.

## Direct Skill Symlink

For raw skill development without installing the plugin:

```bash
mkdir -p ~/.agents/skills
ln -sfn /Users/OHM02/Repos/sweet/skills ~/.agents/skills/sweet
```

Restart Codex after changing the symlink.

## Subagents and Hooks

For subagent workflows and Sweet hook persistence, enable these features in `~/.codex/config.toml`:

```toml
[features]
multi_agent = true
codex_hooks = true
```

Codex loads project hooks from `.codex/hooks.json` when this repo's `.codex/` config layer is trusted. Sweet wires `SessionStart` to `hooks/session-start` and `Stop` to `hooks/codex-stop`.

## Verify

Ask Codex:

```text
Use Sweet to scaffold this repo.
```

Or:

```text
Use the preamble skill to generate my session context.
```
