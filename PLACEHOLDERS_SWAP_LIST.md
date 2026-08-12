# Placeholder Swap List

> **Purpose:** Every placeholder in the code that needs to be swapped out for a real asset later.
> **Use:** When you have a real asset (image, model, audio, animation), find it here, swap it in, and remove the row.
> **Last updated:** Aug 12, 2026

## How to swap a placeholder

1. Find the placeholder in the table below.
2. Make the real asset (or have me make it from your spec).
3. Drop the asset into Studio (or `src/assets/`).
4. Tell me the asset name + which placeholder it replaces.
5. I update the code to use the real asset and remove the row from this list.

---

## 1. UI / 2D Art 🎨

| ID | Placeholder | Where | Real asset needed |
|----|-------------|-------|-------------------|
| UI-001 | Colored frames for HUD bars | `src/client/HUD/HUDGui.luau` | Health/stamina/hero/sugar/XP bar fill textures (5 images) |
| UI-002 | Plain text labels for bar values | `src/client/HUD/HUDGui.luau` | HUD frame overlay image |
| UI-003 | "HP / STA / HERO / SUGAR" text | `src/client/HUD/HUDGui.luau` | Icon versions of each (5 icons) |
| UI-004 | Gold text "Gold: 0" | `src/client/HUD/HUDGui.luau` | Gold coin icon |
| UI-005 | Reputation text "Candy: Neutral" | `src/client/HUD/HUDGui.luau` | 6 reputation tier badges (Beloved/Liked/Neutral/Disliked/Wanted/Hunted) |
| UI-006 | Solid color background on RNG screen | `src/client/UI/RNGScreen.luau` | Prismo's Time Room background art |
| UI-007 | Plain frames for race/bloodline/talent rolls | `src/client/UI/RNGScreen.luau` | 3 roll frame images (race/bloodline/talent) |
| UI-008 | Text rarity tier names | `src/client/UI/RNGScreen.luau` | 6 rarity tier badge images (Common→Mythic) |
| UI-009 | Green "BEGIN ADVENTURE" button | `src/client/UI/RNGScreen.luau`` | Begin button (normal + hover + pressed) |
| UI-010 | Solid color panels for all menus | `src/client/UI/*.luau` | Themed panel background (1 image, reused) |
| UI-011 | "X" text on close buttons | All UI screens | Close icon (1 image) |
| UI-012 | Plain text "PAUSED" | `src/client/UI/PauseMenu.luau` | Pause menu title art |
| UI-013 | Plain text button labels | All UI screens | Themed button backgrounds (normal + hover + pressed) |
| UI-014 | "?" placeholder for item icons | `src/client/UI/InventoryScreen.luau`, `ShopScreen.luau` | Per-item icon images (~20 for beta) |
| UI-015 | Solid color slots in inventory grid | `src/client/UI/InventoryScreen.luau` | Inventory slot frame image |
| UI-016 | Plain text "INVENTORY" / "QUEST LOG" / etc. | All UI screens | Themed title art per screen |
| UI-017 | Solid color map background | `src/client/UI/MapScreen.luau` | Stylized map of Ooo background art |
| UI-018 | Solid color "landmass" rectangle | `src/client/UI/MapScreen.luau` | Stylized Ooo landmass shape |
| UI-019 | Plain buttons for map locations | `src/client/UI/MapScreen.luau` | Per-location pin icons (27 locations) |
| UI-020 | Solid color portrait box in dialog | `src/client/UI/DialogScreen.luau` | Per-NPC portrait images (~10 for beta) |
| UI-021 | Plain text dialog body | `src/client/UI/DialogScreen.luau` | Themed dialog box frame |
| UI-022 | Solid color choice buttons in dialog | `src/client/UI/DialogScreen.luau` | Themed choice button backgrounds |
| UI-023 | Solid color shop item slots | `src/client/UI/ShopScreen.luau` | Shop slot frame image |
| UI-024 | "BUY" text buttons in shop | `src/client/UI/ShopScreen.luau` | Buy button (normal + hover + pressed) |
| UI-025 | Solid color duel request panel | `src/client/UI/DuelScreen.luau` | Duel request themed panel |
| UI-026 | Solid color death screen | `src/client/UI/DeathScreen.luau` | Death screen themed background |
| UI-027 | Solid color founder's pack panel | `src/client/UI/FounderScreen.luau` | Founder's Pack themed panel + key art |
| UI-028 | Plain TextBox for founder code | `src/client/UI/FounderScreen.luau` | Themed TextBox background |
| UI-029 | Solid dark overlay on Lich finale | `src/client/UI/LichFinaleScreen.luau` | Lich omen themed background |
| UI-030 | Pulsing red frame on Lich finale | `src/client/UI/LichFinaleScreen.luau` | Lich omen vignette VFX overlay |
| UI-031 | Plain text "MAP OF OOO" title | `src/client/UI/MapScreen.luau` | Map screen title art |
| UI-032 | Plain text legend dots | `src/client/UI/MapScreen.luau` | Legend icons (active/coming/future) |

---

## 2. 3D Models / Geometry 🧊

| ID | Placeholder | Where | Real asset needed |
|----|-------------|-------|-------------------|
| GEO-001 | Pink flat ground plane for Candy Kingdom | `src/server/Spawns/CandyKingdomGeo.luau` | Candy Kingdom ground texture/terrain |
| GEO-002 | Box-shaped Candy Castle (base + 4 towers + throne room) | `src/server/Spawns/CandyKingdomGeo.luau` | Candy Castle exterior model |
| GEO-003 | Box-shaped candy houses (6) | `src/server/Spawns/CandyKingdomGeo.luau` | Candy house model (3 variants) |
| GEO-004 | Box-shaped market stalls (4) | `src/server/Spawns/CandyKingdomGeo.luau` | Market stall model (2 variants) |
| GEO-005 | Box-shaped Banana Guard barracks | `src/server/Spawns/CandyKingdomGeo.luau` | Barracks model |
| GEO-006 | Flat trapdoor for dungeon entrance | `src/server/Spawns/CandyKingdomGeo.luau` | Dungeon entrance prop |
| GEO-007 | Flat vault door for Royal Tart Vault | `src/server/Spawns/CandyKingdomGeo.luau` | Vault door prop |
| GEO-008 | Pillar-style Candy Kingdom gate (locked) | `src/server/Spawns/CandyKingdomGeo.luau` | Candy Kingdom gate model (locked + open states) |
| GEO-009 | Cylinder + sphere candy cane trees (8) | `src/server/Spawns/CandyKingdomGeo.luau` | Candy cane tree model |
| GEO-010 | Flat shrine base + neon statue | `src/server/Spawns/WorldBuilder.luau` (makeShrine) | Cosmic Owl shrine statue model |
| GEO-011 | Flat save terminal base + neon screen | `src/server/Spawns/WorldBuilder.luau` (makeSaveTerminal) | BMO save terminal model |
| GEO-012 | Green flat ground for Grasslands | `src/server/Spawns/GrasslandsGeo.luau` | Grasslands terrain |
| GEO-013 | Box-shaped Tree Fort (trunk + canopy + door) | `src/server/Spawns/GrasslandsGeo.luau` | Tree Fort exterior model |
| GEO-014 | Flat camp ground | `src/server/Spawns/GrasslandsGeo.luau` | Camp props set |
| GEO-015 | Flat old road | `src/server/Spawns/GrasslandsGeo.luau` | Road texture/decals |
| GEO-016 | Box hilltop | `src/server/Spawns/GrasslandsGeo.luau` | Hilltop with shrine |
| GEO-017 | Box ruined outpost | `src/server/Spawns/GrasslandsGeo.luau` | Ruined outpost structure set |
| GEO-018 | Flat blue river | `src/server/Spawns/GrasslandsGeo.luau` | River with flowing water |
| GEO-019 | Box wolf den | `src/server/Spawns/GrasslandsGeo.luau` | Wolf den cave entrance |
| GEO-020 | Cylinder + sphere oak trees (10) | `src/server/Spawns/GrasslandsGeo.luau` | Oak tree model |
| GEO-021 | Flat mushfield + box mushrooms (6) | `src/server/Spawns/GrasslandsGeo.luau` | Mushroom model (3 variants) |
| GEO-022 | Default Roblox R15 rig (no R16 yet) | `src/starter/StarterCharacter/` | R16 archetype A base rig (Humanoid) |
| GEO-023 | No race body features yet | (future) | 19 race signature meshes (horns, tails, manes, drips) |
| GEO-024 | No clothing meshes yet | (future) | 8 clothing slot meshes × 5 archetypes (~250 total) |
| GEO-025 | No weapon models yet | (future) | 5 weapons × 3 variants (15 total) |
| GEO-026 | No NPC models yet | (future) | PB, Peppermint Butler, Starchy, Cinnamon Bun, Tree Trunks, Banana Guard, etc. |
| GEO-027 | No mob models yet | (future) | Wild Berry Wolf, Candy Bandit, Sugar Sprout, Mushroom, Warden, Tart Golem |

---

## 3. Audio 🎵

| ID | Placeholder | Where | Real asset needed |
|----|-------------|-------|-------------------|
| AUD-001 | No music anywhere | (future) | Candy Kingdom theme, Grasslands theme, combat theme, dungeon theme, character creation theme, main menu, Lich omen |
| AUD-002 | No SFX for combat | `src/client/Combat/Init.luau` (placeholder HitConfirm) | Light/heavy swing (3 each), dodge whoosh, block thud, parry chime, hit confirm (3), hurt (3), death, level up, sugar rush activate/crash, candy eaten squelch (2), banana guard alert/arrest, UI clicks (3), footsteps (3), jump/land |
| AUD-003 | No mumble voices | `src/client/UI/DialogScreen.luau` (placeholder print) | 10 mumble voice sets (Finn, Jake, PB, Marceline, Ice King, LSP, Peppermint Butler, Banana Guard, Candy Person, generic) |

---

## 4. Animations 🎬

| ID | Placeholder | Where | Real asset needed |
|----|-------------|-------|-------------------|
| ANIM-001 | Default Roblox anims (no R16 anims yet) | (future) | Idle/Walk/Run/Jump/Land/Fall × 5 archetypes (30) |
| ANIM-002 | No combat anims | (future) | Light combo (3) × 5, heavy × 5, dodge × 5, block (3) × 5, parry × 5, hit react × 5, death × 5, hero mode × 5 (95 total) |
| ANIM-003 | No mob anims | (future) | Per mob: idle/walk/attack/hurt/death (~30 total) |
| ANIM-004 | No special anims | (future) | Eat candy, sugar rush sprint, sugar crash, banana guard arrest, dungeon escape |

---

## 5. Logic / Data Placeholders 📋

| ID | Placeholder | Where | Real value needed |
|----|-------------|-------|-------------------|
| LOGIC-001 | Shop items list is empty | (future, server Shop system) | Real shop item catalog (cosmetics, reroll tokens, consumables) |
| LOGIC-002 | Quest list is empty | (future, server Quests system) | ~10 beta quests with real objectives |
| LOGIC-003 | Founder's code validation is a stub | (future, server Founder system) | Real code redemption backend |
| LOGIC-004 | Fast-travel just prints | (future, server FastTravel) | Real teleport to shrine positions |
| LOGIC-005 | Duel matchmaking is a stub | (future, server Duel system) | Real duel arena + rules |
| LOGIC-006 | Lich omen event is a stub | (future, server LichEvent) | Real weekend finale event logic |
| LOGIC-007 | Inventory sync is one-way | (future, server Inventory system) | Real inventory save/load + item definitions |
| LOGIC-008 | Reputation tiers defined but not applied | `src/shared/Constants/GameConstants.luau` | Hook into guard behavior + vendor prices |
| LOGIC-009 | Sugar Rush tiers defined but not applied | `src/shared/Constants/GameConstants.luau` | Hook into combat + movement + HUD |
| LOGIC-010 | R16 rig not set up | `src/starter/StarterCharacter/` | R16 archetype rigs + race signature pieces |
| LOGIC-011 | No mob spawns yet | (future, server Spawns mobs) | Mob spawn points + AI |
| LOGIC-012 | No NPC schedules yet | (future, server NPCs) | Day/night NPC schedules |
| LOGIC-013 | No fishing minigame yet | (future) | River Crossing fishing logic |
| LOGIC-014 | No mount yet | (future) | Battle Cube mount logic |
| LOGIC-015 | No weather yet | (future) | Light cosmetic weather |
| LOGIC-016 | No day/night cycle yet | (future) | Clock + lighting cycle |

---

## Priority swap order (if you want to tackle incrementally)

1. **UI-006** — RNG screen background (first impression for new players)
2. **UI-001** — HUD bar textures (always visible)
3. **GEO-022** — R16 Archetype A base rig (unblocks clothing + combat anims)
4. **AUD-001** — Candy Kingdom theme music (sets tone)
5. **AUD-003** — Finn-style mumble voice (NPC dialog comes alive)
6. **GEO-005** — Banana Guard model (signature chase loop)
7. **GEO-002** — Candy Castle exterior (landmark)
8. **GEO-013** — Tree Fort exterior (player home)
9. **UI-017** — Map of Ooo background art
10. **LOGIC-001 → LOGIC-016** — Logic systems (I'll build these as I build the server systems)

---

## Stats

- **Total placeholders:** 81 (32 UI + 27 3D + 3 audio + 4 animations + 15 logic)
- **Total real assets needed:** ~400+ (full list in `ASSETS_NEEDED.md`)
- **Beta MVP critical path:** 10 items above
