# Adventure Time: Ooo — Progress Vault

> **Purpose:** Single source of truth for project state. Read this first in any new session to pick up where we left off.
> **Last updated:** Aug 12, 2026

---

## 1. Project overview

- **Game:** Adventure Time: Ooo — Roblox MMORPG
- **Repo:** https://github.com/UMYseven/Adventure-bloxs
- **Branch:** master
- **Platform:** Roblox (PC, Mobile, Console, VR)
- **Genre:** Open-world MMORPG, RNG character creation, pay-to-customize (not pay-to-win)
- **Beta scope:** 2 zones (Candy Kingdom + Grasslands/Tree Fort), sandbox RPG, deep combat, consensual duels

## 2. Documentation set (all in repo root)

| Doc | Purpose |
|-----|---------|
| `GAME_DESIGN_DOCUMENT.md` | Master GDD — vision, RNG trinity, world map, characters, items, buildings, mechanics, roadmap (616 lines) |
| `CLOTHING_ASSET_DOC.md` | R16 rig, 5 archetypes, 8 clothing slots, per-archetype asset lists, shop structure (312 lines) |
| `MVP_BETA_SCOPE.md` | Beta IN/OUT systems, Founder's Pack, sandbox RPG, emergent systems, seasonal roadmap (220 lines) |
| `COMBAT_DOC.md` | Deep combat, PvE + duel PvP, post-beta PvP roadmap (262 lines) |
| `LOCATIONS_DOC.md` | Candy Kingdom + Grasslands detailed for beta, post-beta zones by season (206 lines) |
| `ASSETS_NEEDED.md` | Full list of art/audio/models/animations needed, with priority top 10 (236 lines) |
| `PROGRESS.md` | This file — session handoff vault |

## 3. Locked decisions (do not re-litigate)

### Vision & monetization
- Pay-to-customize, not pay-to-win. RNG + Faith.
- Reroll tokens earnable in-game OR paid. Same odds. Season pass (free + premium tracks).
- Mystery boxes earnable-only; paid path is direct purchase only.

### World & story
- Multiverse framing via Prismo's Time Room (any canon character can appear).
- Show canon first; fanon/speculation added later as expansions.
- Art style: mixed — cartoon-faithful characters, semi-realistic environments.
- Age/tone: default all-ages + opt-in "Nightosphere Mode" toggle.

### Character creation (RNG trinity)
- 19 launch races (tiered rollout). See `GameConstants.luau` RACES table.
- 12 bloodlines (rarity-scaled, progression via Awakened → Tempered → Ascended → Exalted → Mythic Realization).
- 15 talents. 2 ability slots active in beta (slots 3-4 post-beta).
- Lich-cursed race: rollable, ultra-rare (~0.01%).
- Lich-touched bloodline: 1% prestige chance.

### Combat (deep)
- Combos, parry (0.3s window), block (70% reduction), dodge (0.4s i-frames), 2 abilities, hero meter (10s mode at 100).
- 4 beta elements: Fire, Ice, Slime, Candy. (Demon/Cosmic post-beta.)
- 5 weapons: Sword, Axe, Staff, Unarmed, Bow. (Bass-axe post-beta.)
- Stamina: medium regen, costs per action.
- Death: harsh — 10% gold loss + XP debt (debt slows, doesn't block).
- Friendly fire: toggle (off by default). Duel consumables: allowed.
- Auto-target: OFF on PC, ON on mobile (toggle).
- Camera: default fixed behind player, opt-in lock-on.
- Telegraphing: bright red flashes + colorblind palette swap.

### Beta scope
- 2 zones: Candy Kingdom (full) + Grasslands/Tree Fort (5 sub-areas, mid-tier housing).
- Sandbox RPG — light story (~10 short quests), heavy emergent play.
- 4 emergent systems: candy-eating, guard interactions, Sugar Rush parkour, environmental interaction.
- Day/night cycle: full. Weather: light (cosmetic). NPC schedules: hybrid.
- Fishing: basic at River Crossing. Mounts: 1 basic (Battle Cube, earnable).
- Level cap: 20. Transmog: yes, in beta.
- Founder's Pack: $5 (exclusive hat + aura + Tree Fort decor + Cosmic Shards + Founder title).
- Beta length: open-ended. Beta ending: live "Lich omen" weekend finale event.
- Beta wipe: partial — keep cosmetics + titles, wipe levels/gold/inventory/reputation.

### Clothing
- R16 rig (hybrid: community base + custom tweaks per archetype).
- 5 archetypes: A Humanoid, B Stubby, C Lanky, D Beast, E Blob.
- 8 core slots: Hat, Hair, Top, Back, Gloves, Legs, Boots, Aura. (Tail/face/horns are race body features.)
- Cosplay policy: inspired-by only, no 1:1 canon outfits.
- Dye system: tiered — common = full freedom, legendary = curated.
- Aura stacking: up to 2.

### Update cadence
- Seasonal: quarterly big update + monthly minor patch. Live events between.
- Season 1 "Foundations": sidekicks, full Tree Fort tycoon, minigames, reroll, cosmetics shop, season pass, dyes, mystery boxes, mounts, Ice Kingdom.
- Season 2 "Courts & Conflict": guilds, open-world PvP, Permadeath Mode, bloodline ascension, Fire + Goblin kingdoms.
- Season 3 "Beyond Ooo": Nightosphere, Dead World, Hunson boss, Slime + Wildberry kingdoms.
- Season 4 "Cosmic Horrors": Prismo's, Crystal Citadel, Lich + Orgalorg bosses, Cloud + Lumpy Space.
- Season 5 "The Vault": Farmworld, Pillow World, GOLB, Hot Dog + Turtle + Lemongrab.
- Season 6+ "Eternal Ooo": remaining kingdoms, Mars, Founders' Island, Cosmic Realm, UGC.

## 4. Code architecture

### Toolchain
- **Aftman** manages Rojo 7.4.4, Wally 0.3.2, Selene 0.27.1 (pinned in `aftman.toml`).
- Run `aftman install` to fetch. Run `rojo serve` to sync to Studio.
- Lint: `selene src`. Build: `rojo build default.project.json -o place.rbxlx`.

### Project structure
```
src/
├── server/            # ServerScriptService
│   ├── Core/Bootstrap.server.luau   # loads all 9 systems
│   ├── DataStore/Init.luau          # ✅ save/load + autosave
│   ├── RNG/Init.luau                 # ✅ race/bloodline/talent roller
│   ├── Combat/Init.luau              # ✅ combat manager (HP, stamina, hero, damage, death)
│   ├── Reputation/                  # 🚧 TODO
│   ├── SugarRush/                    # 🚧 TODO
│   ├── Guards/                       # 🚧 TODO
│   ├── Dungeon/                      # 🚧 TODO
│   ├── Quests/                       # 🚧 TODO
│   └── Spawns/                       # 🚧 TODO
├── shared/             # ReplicatedStorage
│   ├── Constants/
│   │   ├── GameConstants.luau       # ✅ races, bloodlines, talents, elements, weapons, sugar tiers, rep tiers
│   │   └── CombatConstants.luau      # ✅ parry, dodge, hero, stamina, death penalty
│   ├── Types/PlayerData.luau          # ✅ PlayerData schema + DEFAULT
│   ├── Remotes/RemotesSetup.luau     # ✅ creates BindableEvents + RemoteEvents
│   ├── Util/                         # 🚧 TODO
│   └── Config/                       # 🚧 TODO
├── client/             # StarterPlayerScripts
│   ├── Core/Bootstrap.client.luau    # ✅ loads all 6 client systems
│   ├── Input/Init.luau                # ✅ LMB/RMB/Space/Shift/Q/E/R
│   ├── Combat/Init.luau               # ✅ VFX hook (hero mode highlight)
│   ├── HUD/                           # ✅ HUDGui + Init
│   ├── UI/                           # ✅ RNGScreen + Init (more UI 🚧 TODO)
│   ├── Camera/                       # 🚧 TODO
│   └── Interaction/                 # 🚧 TODO
└── starter/StarterCharacter/         # 🚧 TODO
```

### Remote protocol
- `ClientToServer` (RemoteEvent): client → server intents. Actions: `LightAttack`, `HeavyAttack`, `Dodge`, `BlockStart`, `BlockStop`, `Parry`, `Ability` (with slot), `ConfirmRNG`.
- `ServerToClient` (RemoteEvent): server → client updates. Actions: `RNGResult` (with roll), `Stats` (HP/stamina/hero/sugar), `Progression` (level/xp/gold), `Reputation` (tier/value), `HitConfirm`, `ParrySuccess`.
- `RequestPlayerData` (RemoteFunction): client invokes → server returns safe snapshot.
- `PlayerDataReady` (BindableEvent, server-only): fired when DataStore loads a player.
- `RNGRolled` (BindableEvent, server-only): fired when RNG applies a roll.

## 5. What's done (✅)

- All 6 design docs + ASSETS_NEEDED + this vault.
- Rojo scaffold + toolchain (Rojo + Wally + Selene via Aftman).
- Server bootstrap + client bootstrap.
- Shared constants (GameConstants + CombatConstants) matching locked GDD.
- PlayerData type schema + DEFAULT.
- RemotesSetup (PlayerDataReady, RNGRolled, RequestPlayerData, ClientToServer, ServerToClient).
- DataStore system (LoadAsync, SaveAsync, autosave 60s, save-on-leave, save-on-shutdown, kick on load fail).
- RNG system (server roller + client character creation screen with rolling animation + rarity colors).
- HUD system (health, stamina, hero, sugar, XP, gold, reputation tier; tweened bars; listens for ServerToClient).
- Combat core (server state, stamina regen, damage pipeline with dodge/block/parry, hero mode, death with 10% gold + XP debt; client input + VFX hook).
- All linting clean (0 errors, 0 warnings). All builds clean.

## 6. What's next (priority order)

1. **Placeholder place geometry** — Candy Kingdom (castle, town square, residential, market, gates, dungeon entrance) + Grasslands (Tree Fort, camp, sub-areas) built from parts. (User picked this next.)
2. **All UI** — inventory, quest log, settings, map, dialog/NPC talk, shop, pause menu, duel request, reputation panel, sugar rush indicator, death/respawn, fast-travel map, founder's pack redemption, Lich omen finale. Use Fusion (install via Wally) for cleaner component-based UI.
3. **Reputation system** — Candy Kingdom meter, tier shifts, guard behavior hook.
4. **Sugar Rush system** — eat candy → meter → tiers → buff/crash, hooks into combat + HUD.
5. **Guards system** — Banana Guard AI (patrol, chase, bribe/fight/sneak/impersonate).
6. **Dungeon system** — Banana Guard Dungeon (3-5 rooms, Warden boss, repeatable).
7. **Quests system** — ~10 short beta quests.
8. **Spawns system** — mob spawns across Candy Kingdom + Grasslands.
9. **R16 rig setup** — 5 archetype base rigs + race signature pieces (needs 3D models from user).
10. **Camera system** — client camera (default fixed, opt-in lock-on).
11. **Interaction system** — environmental (push, break, climb, hide).

## 7. Assets needed from user (full list in `ASSETS_NEEDED.md`)

**Top 10 priority for beta MVP:**
1. R16 Archetype A base rig (Humanoid) — unblocks 6 races
2. Candy Kingdom theme music
3. Finn-style mumble voice set
4. HUD bar textures
5. Princess Bubblegum NPC model
6. Banana Guard NPC model
7. Candy Castle exterior
8. Sword (basic variant)
9. Light attack swing SFX
10. Game logo + loading screen

## 8. Open questions (parked for now)

- Beta length: open-ended (until Season 1 ready) — confirm or set a target.
- Quest count: ~10 short quests — confirm exact number.
- Grasslands sub-areas: 5 locked — confirm exact count.
- XP debt mechanic: slows, doesn't block — confirm.
- Lich omen event length: weekend finale (Friday-Sunday) — confirm.
- Founder's Pack contents: locked (hat + aura + Tree Fort decor + Cosmic Shards + Founder title) — confirm exact items.

## 9. How to resume in a new session

1. Open this repo in Cursor.
2. Read this file first — it's the single source of truth.
3. Skim the design docs if you need deep context on a specific system.
4. Run `aftman install` then `rojo serve` to reconnect to Studio.
5. Pick up from section 6 (What's next) — the next item is placeholder geometry, then all UI.
6. Lint with `selene src`, build with `rojo build default.project.json -o place.rbxlx`.

---

*This vault is the contract between sessions. Update it every time something ships.*
