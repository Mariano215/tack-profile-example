# tack-profile-example

A working [tack](https://github.com/Mariano215/tack) profile. Fork it, rename it,
edit `manifest.json`.

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
manifest.json     what to enable: plugins, MCP servers, env, permissions
install.sh        three lines, never edit
core/             the tack engine, pinned as a git submodule
skills/           your skills, copied into the config dir on every apply
```

That is the whole contract. `tack use <name>` runs `install.sh`, which runs the
engine's apply against `manifest.json`.

## The manifest

```json
{
  "name": "example",
  "description": "Starter profile.",
  "plugins": { "superpowers@claude-plugins-official": true },
  "mcp": [],
  "env": {},
  "notes": "free text, ignored by the engine"
}
```

| Key | Effect |
|---|---|
| `name` | Recorded as the active profile. Required. |
| `description` | Shown by `tack list`. Required. |
| `plugins` | Merged over `base-settings.json`'s `enabledPlugins`. |
| `mcp` | User-scope MCP servers to enable. |
| `env` | Merged into `settings.json` `env`. |
| `permissions` | Merged into `settings.json` `permissions`. Declaring `defaultMode` here makes the profile own it, and `personal-overrides.json` can no longer change it. |
| `skills_link` | Symlink skills in from outside the repo, e.g. a shared skills tree. Missing targets are skipped with a message rather than failing. |

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
