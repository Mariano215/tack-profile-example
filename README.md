# tack-profile-example

A working [tack](https://github.com/Mariano215/tack) profile for Claude Code and
Codex. Fork it, rename it, edit `manifest.json`. Or ask your agent for a new
harness and let tack's `harness-builder` skill do the research and the build
from this template.

## Use it

```bash
export HARNESS_ORG=your-github-account
# fork this repo to <your-account>/tack-dev, then:
tack install dev
```

Or point tack at it directly without forking:

```bash
git clone --recurse-submodules https://github.com/Mariano215/tack-profile-example.git ~/Projects/tack-example
tack use example
```

## What is in here

```
manifest.json     what to enable, per agent: plugins, MCP servers, env, permissions
install.sh        three lines, never edit
core/             the tack engine, pinned as a git submodule
skills/           your skills, copied into the config dir on every apply
```

That is the whole contract. `tack use <name>` runs `install.sh`, which runs the
engine's apply against `manifest.json` for every agent CLI it finds (`claude`,
`codex`). `tack open <name>` then starts both in one workspace.

## The manifest

```json
{
  "schema_version": 2,
  "name": "example",
  "description": "Starter profile.",
  "mcp": [],
  "memory": { "enabled": false },
  "providers": {
    "claude": {
      "plugins": { "superpowers@claude-plugins-official": true },
      "env": {}
    },
    "codex": {}
  },
  "notes": "free text, ignored by the engine"
}
```

| Key | Effect |
|---|---|
| `name` | Recorded as the active profile. Required. |
| `description` | Shown by `tack list`. Required. |
| `schema_version` | `2` puts agent-specific keys under `providers`. Without it the manifest is v1: `plugins`, `env` and `permissions` sit at the top level and apply to Claude only. |
| `mcp` | MCP servers to enable, for both agents. |
| `memory` | `{"enabled": true, "engine": "claude-mem"}` installs claude-mem. Off here. |
| `providers.claude.plugins` | Merged over `base-settings.json`'s `enabledPlugins`. |
| `providers.claude.env` | Merged into `settings.json` `env`. |
| `providers.claude.permissions` | Merged into `settings.json` `permissions`. Declaring `defaultMode` here makes the profile own it, and `personal-overrides.json` can no longer change it. |
| `providers.codex.config` | Written into `$CODEX_HOME/<name>.config.toml`, e.g. `{"model_reasoning_effort": "high"}`. |
| `providers.codex.permissions` | Codex approval and sandbox settings, e.g. `{"approval_policy": "on-request"}`. |
| `skills_link` | Symlink skills in from outside the repo, e.g. a shared skills tree. Missing targets are skipped with a message rather than failing. |
| `skills_source` | Where a missing `skills_link` target installs from, as `owner/repo@skill`. |

Full schema: `core/manifest.schema.json`.

## Adding a skill

Drop a directory under `skills/` with a `SKILL.md` that has `name` and
`description` frontmatter, then re-apply:

```bash
tack use example
```

`skills/hello-tack` is there to prove the path works. Delete it once you have
your own.

## Pointing at your fork of the engine

The `core` submodule tracks `github.com/Mariano215/tack`. To follow a fork:

```bash
git config -f .gitmodules submodule.core.url https://github.com/you/tack.git
git submodule sync && git submodule update --init --remote
git commit -am "chore(core): track fork"
```

## Keeping it current

```bash
tack sync --push
```

Pulls this repo, advances the `core` pin to the latest engine commit, commits
the bump, pushes, and re-applies.
