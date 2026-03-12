# games/game-01 — Obby with Checkpoint Persistence

First proof game built on top of the scaffold.  
Uses scaffold systems only; avoids hand-rolled one-off infrastructure.

See [issue #17](https://github.com/goblinsan/roblox-game-scaffold/issues/17) for the full implementation plan.

## Source layout

```
src/
  server/   — ServerScriptService scripts
  client/   — StarterPlayerScripts
  shared/   — ReplicatedStorage shared modules
```

## Rojo

```bash
# From this directory:
rojo serve default.project.json
# or build a place file:
rojo build default.project.json --output game-01.rbxlx
```

## Wally dependencies

```bash
# From this directory:
wally install
```

Once the scaffold packages are published to the Wally registry, uncomment the
dependency lines in `wally.toml` and re-run `wally install`.
