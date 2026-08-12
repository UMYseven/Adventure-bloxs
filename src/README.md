# Adventure Time: Ooo — Roblox Game Source

This folder holds the Roblox Studio source for the Adventure Time Ooo MMORPG, synced via [Rojo](https://rojo.space).

## Toolchain

Tools are pinned in `aftman.toml`. Install them once:

```bash
aftman install
```

This fetches:
- **Rojo 7.4.4** — file sync between this folder and Roblox Studio
- **Wally 0.3.2** — Luau package manager (for future dependencies)
- **Selene 0.27.1** — Luau linter

## Project layout

```
src/
├── server/            # ServerScriptService (server-side systems)
│   ├── Core/          # Bootstrap loader
│   ├── DataStore/     # Save/load (XP, gold, reputation, inventory)
│   ├── RNG/           # Race/bloodline/talent rolling (server-authoritative)
│   ├── Combat/        # PvE + duel PvP logic
│   ├── Reputation/    # Candy Kingdom reputation meter
│   ├── SugarRush/     # Sugar Rush tiers + crash
│   ├── Guards/        # Banana Guard AI + bribe/fight/sneak/impersonate
│   ├── Dungeon/       # Banana Guard Dungeon + Warden boss
│   ├── Quests/        # ~10 beta quests
│   └── Spawns/        # Mob spawns across Candy Kingdom + Grasslands
├── shared/           # ReplicatedStorage (shared between client & server)
│   ├── Constants/    # GameConstants.luau — locked GDD values
│   ├── Types/        # Luau type definitions
│   ├── Util/         # Shared utility functions
│   ├── Remotes/       # RemoteEvent / RemoteFunction definitions
│   └── Config/        # Tunables (drop rates, costs, etc.)
├── client/           # StarterPlayerScripts (client-side)
│   ├── Core/         # Bootstrap loader
│   ├── Input/        # Controls (light/heavy/dodge/block/abilities)
│   ├── Camera/       # Combat camera (default fixed, opt-in lock-on)
│   ├── Combat/       # Client-side combat feedback (VFX, hit markers)
│   ├── HUD/          # Health, stamina, hero meter, sugar meter
│   ├── UI/           # Menus, quest log, inventory
│   └── Interaction/ # Environmental interaction (push, break, climb, hide)
└── starter/          # StarterPack / StarterCharacter
    └── StarterCharacter/
```

## Connecting to Roblox Studio

1. **Install the Rojo plugin in Studio** (one-time):
   - Open Roblox Studio.
   - Go to **Manage Plugins** (or search "Rojo" in the Toolbox under Plugins).
   - Install the **Rojo** plugin (v7 compatible).

2. **Start the Rojo server** from this folder:
   ```bash
   rojo serve
   ```
   You'll see output like `Listening on http://127.0.0.1:34883`.

3. **Connect from Studio**:
   - Open your place file in Studio (or a fresh baseplate).
   - In Studio, click the **Rojo** plugin button in the ribbon.
   - Click **Connect**.
   - The `src/` folder tree will appear in Studio's Explorer, synced live.

4. **Edit from either side**: change a `.luau` file here → it appears in Studio. Change a script in Studio → it saves back here. (Two-way sync.)

## Common commands

```bash
# Start live sync to Studio
rojo serve

# Build a place file from the project (no Studio needed)
rojo build default.project.json place.rbxlx

# Lint all Luau
selene src
```

## What's implemented so far

- ✅ Toolchain (Rojo + Wally + Selene via Aftman)
- ✅ Project structure matching the locked GDD
- ✅ Server + client bootstrap loaders
- ✅ Shared constants (19 races, 12 bloodlines, 15 talents, 4 beta elements, 5 weapons, sugar rush tiers, reputation tiers)
- 🚧 System `Init` modules (DataStore, RNG, Combat, Reputation, SugarRush, Guards, Dungeon, Quests, Spawns)
- 🚧 Client systems (Input, Camera, Combat, HUD, UI, Interaction)
- 🚧 R16 rig setup + clothing archetype base rigs
- 🚧 Candy Kingdom + Grasslands place geometry

## Beta scope reference

See `../MVP_BETA_SCOPE.md` for the locked beta scope, `../COMBAT_DOC.md` for combat, `../LOCATIONS_DOC.md` for zone detail, `../CLOTHING_ASSET_DOC.md` for the R16 clothing system, and `../GAME_DESIGN_DOCUMENT.md` for the master GDD.
