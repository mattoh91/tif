# Installing Cutiepie for Codex

Cutiepie can be installed as a Codex plugin from this local checkout.

## Local Plugin Installation

```bash
codex plugin marketplace add /Users/OHM02/Repos/cutiepie
```

Restart Codex, open:

```text
/plugins
```

Choose `Cutiepie Local`, install `Cutiepie`, then start a new thread.

## Direct Skill Symlink

For raw skill development without installing the plugin:

```bash
mkdir -p ~/.agents/skills
ln -sfn /Users/OHM02/Repos/cutiepie/skills ~/.agents/skills/cutiepie
```

Restart Codex after changing the symlink.

## Subagents and Hooks

For subagent workflows and Cutiepie hook persistence, enable these features in `~/.codex/config.toml`:

```toml
[features]
multi_agent = true
hooks = true
```

Codex loads project hooks from `.codex/hooks.json` when this repo's `.codex/` config layer is trusted. Cutiepie wires `SessionStart` to `hooks/session-start` and `Stop` to `hooks/codex-stop`.

## Verify

Ask Codex:

```text
Use Cutiepie to scaffold this repo.
```

Or:

```text
Use the preamble skill to generate my session context.
```
