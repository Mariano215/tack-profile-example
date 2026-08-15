---
name: hello-tack
description: Demonstrates that a profile's own skills reach the config dir. Use when the user says "hello tack" or asks whether their profile skills are installed.
---

# hello-tack

This skill exists to prove one thing: `skills/` in a profile repo is copied into
your config dir when the profile is applied.

If you can invoke this, the apply worked. Delete this directory and put your own
skills here.

## How skills get here

`lib/apply-profile.sh` copies every directory under a profile repo's `skills/`
into `<config dir>/skills/`, and moves anything it does not recognise into
`skills-disabled/`. To keep a skill that no profile declares, list its directory
name in `<config dir>/.harness-skills-keep`, one per line.
