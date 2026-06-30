# Installing Gummy for Codex

Gummy can be installed as a Codex plugin from this local checkout.

## Local Plugin Installation

```bash
codex plugin marketplace add /absolute/path/to/gummy
```

Restart Codex, open:

```text
/plugins
```

Choose `Gummy Local`, install `Gummy`, then start a new thread.

## Direct Skill Symlink

For raw skill development without installing the plugin:

```bash
mkdir -p ~/.agents/skills
ln -sfn /absolute/path/to/gummy/skills ~/.agents/skills/gummy
```

Restart Codex after changing the symlink.

## Subagents and Hooks

For subagent workflows and Gummy hook persistence, enable these features in `~/.codex/config.toml`:

```toml
[features]
multi_agent = true
hooks = true
```

Codex loads project hooks from `.codex/hooks.json` when this repo's `.codex/` config layer is trusted. Gummy wires `SessionStart` to `hooks/session-start` and `Stop` to `hooks/codex-stop`.

## Verify

Ask Codex:

```text
Use Gummy to scaffold this repo.
```

Or:

```text
Use the preamble skill to generate my session context.
```
