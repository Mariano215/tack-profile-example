#!/usr/bin/env bash
# Applied by `tack use example`. Do not add logic here: the engine is versioned
# in the core submodule, and a profile that grows its own apply logic stops
# being reproducible from the manifest alone.
set -euo pipefail
git submodule update --init --recursive
exec bash ./core/lib/apply-profile.sh ./manifest.json
