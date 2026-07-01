# Installing Tif for Codex

Tif can be installed as a Codex plugin from this local checkout.

## Local Plugin Installation

```bash
codex plugin marketplace add /absolute/path/to/tif
```

Restart Codex, open:

```text
/plugins
```

Choose `Tif Local`, install `Tif`, then start a new thread.

## Direct Skill Symlink

For raw skill development without installing the plugin:

```bash
mkdir -p ~/.agents/skills
ln -sfn /absolute/path/to/tif/skills ~/.agents/skills/tif
```

Restart Codex after changing the symlink.

## Subagents and Hooks

For subagent workflows and Tif hook persistence, enable these features in `~/.codex/config.toml`:

```toml
[features]
multi_agent = true
hooks = true
```

Codex loads project hooks from `.codex/hooks.json` when this repo's `.codex/` config layer is trusted. Tif wires `SessionStart` to `hooks/session-start` and `Stop` to `hooks/codex-stop`.

## Verify

Ask Codex:

```text
Use Tif to scaffold this repo.
```

Or:

```text
Use the preamble skill to generate my session context.
```
