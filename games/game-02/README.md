# games/game-02 — Round-Based Minigame (Tag / Colour-Sort)

Second proof game built on top of the scaffold.  
Stress-tests round manager, remote registry, and scoring loops in a multiplayer context.

See [issue #19](https://github.com/goblinsan/roblox-game-scaffold/issues/19) for the full implementation plan.

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
rojo build default.project.json --output game-02.rbxlx
```

## Wally dependencies

```bash
# From this directory:
wally install
```

Once the scaffold packages are published to the Wally registry, uncomment the
dependency lines in `wally.toml` and re-run `wally install`.
