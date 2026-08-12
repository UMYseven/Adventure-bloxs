# Adventure Time: Ooo MMORPG — Game Design Document (v0.4 Draft)

> **Status:** Draft for review. Sections marked `[?]` still need your input.
> **Platform:** Roblox (PC, Mobile, Console, VR)
> **Genre:** Open-world MMORPG with RNG character-creation & cosmetic monetization
> **Inspiration:** Adventure Time (Cartoon Network, Pendleton Ward) — canon + lore
>
> **v0.4 changes:** Locked race rollout (tiered — 15 at launch, rest over seasons), Lich-cursed race (rollable, ultra-rare), music (original AT-style score), VA (text + "mumbling" vocalizations like Animal Crossing/Undertale), server topology (hybrid — standard servers + instanced dungeons/forts), sidekick system (1 per player, party of 6 = 12 chars, opt-in perma-death mode for higher rewards, otherwise respawn timeout by rarity), Tree Fort location (shared Grasslands neighborhood + guild-shared neighborhood).
> **v0.3 changes:** Locked story framing, age/tone, companions, opening experience, Tree Fort tycoon.
> **v0.2 changes:** Locked canon approach, art style, PvP scope, bloodline design, reroll monetization.

---

## 1. Vision & Pillars

### 1.1 One-line pitch
A living, breathing Land of Ooo where every player is born into a randomly-determined race, bloodline, and talent — and must adventure, quest, and roll their way through every kingdom, dungeon, and dimension canon has to offer.

### 1.2 Design Pillars
1. **Ooo is the whole world.** Every canon kingdom, city, ruin, dimension, and lore-only location is explorable. Show canon first; fanon/speculation locations added later as expansions.
2. **Luck is the great equalizer.** No paid power. Combat, drops, and progression are RNG-driven.
3. **Customize, don't overpower.** Monetization = cosmetics + rerolls. Zero stat-boosting purchases.
4. **Adventure is the loop.** Quests, minigames, dungeons, world events, PvP tournaments form the daily/weekly loop.
5. **Faithful but playable.** Tone, characters, and music evoke the show; approachable for Roblox's wide age range.

### 1.3 Art Style (locked)
- **Characters**: cartoon-faithful to the show — rounded, pastel, expressive.
- **Environments**: semi-realistic Roblox rendering — depth, lighting, atmosphere — while keeping AT silhouettes and color palettes.
- Goal: characters read instantly as Adventure Time; world feels immersive and lived-in.

### 1.4 PvP Scope (locked)
- **Arena / tournaments**: consensual, ranked, leaderboard-driven.
- **Open-world PvP zones**: City of Thieves and Bad Lands — flagged, with clear signage so no one wanders in by accident.
- Rest of the world is safe / PvE.

### 1.5 Story Framing (locked)
- **Multiverse via Prismo's Time Room.** Prismo pulls characters from any point in the Adventure Time timeline into the game world. This sidesteps the "is this character alive?" problem — anyone canon can appear as a quest giver, mentor, or boss regardless of when they lived/died in-show.
- Lore hook: a Cosmic Owl omen has fractured the timeline; Prismo recruits you (and every other player) to stabilize it. Each kingdom/dimension is a "shard" of the timeline you help restore.
- Lets us use Finn (any age), Jake, Simon, Betty, Marceline, Lich, etc. without contradicting canon endings.

### 1.6 Age / Tone (locked)
- **Default: all-ages (Roblox default).**
- **Opt-in "Nightosphere Mode" toggle** (account-level, parental-gated where possible) unlocks darker Lich/Nightosphere themes — scarier boss visuals, blood-magic VFX, heavier dialogue.
- Content is designed safe-first; Nightosphere variants are layered on top behind the flag.
- Reasoning: keeps the wider player base and avoids moderation risk, while letting older players opt into the edgier experience.

### 1.7 Companions (locked)
- **Canon characters are quest-only cameos** — they appear in story quests, give dialogue, mentor, or fight alongside you temporarily, but don't permanently follow you.
- **Player-recruited sidekicks**: a separate system where you recruit generic Ooo denizens (banana guards, candy citizens, wildberry folk, etc.) as permanent party members. These are not canon characters — they're your squad.
- **Parties**: up to 6 players. Each player brings 1 sidekick → max 12 characters in a party.
- **Sidekick death rules**:
  - Default: sidekicks do **not** perma-die. On defeat they enter a respawn timeout that scales with rarity (Common = short, Mythic = long).
  - **Opt-in "Permadeath Mode"** (toggle per quest): higher rewards, higher XP, better loot tables — but if a sidekick dies, they're gone for good. Risk/reward for veterans.
- **Sidekick progression**: sidekicks level with you, gain classes/talents, equip gear (cosmetic + stat, all earned in-game).

### 1.8 Music & Voice (locked)
- **Music**: original AT-style score (full ownership, no licensing cost). Composed to evoke the show's tone — ukelele, synth, playful + melancholy motifs. Kingdom themes per zone.
- **Voice acting**: text-primary dialogue + **"mumbling" vocalizations** (Animal Crossing / Undertale / Banjo-Kazooie style). Characters make vague vocal noises while text appears — cheap, charming, no VA licensing, preserves the show's playful tone. Pitch/tone of mumble varies per character (Finn = boyish, Marceline = smoky, Ice King = warbly, LSP = valley girl).

### 1.9 Server Topology (locked)
- **Hybrid**: standard Roblox servers (~30–50 players) for the open world + instanced shards for dungeons, Tree Forts, and neighborhood zones.
- Big hubs (Candy Kingdom, Wizard City, Hall of Justifiers) use instanced shards to hold 100+ players.
- Dungeons: 6-player instances (party-sized). Raids/world bosses: 12–24-player instances.
- Tree Fort neighborhoods: instanced shards of ~8–16 forts (see §2B.5).

### 1.3 Monetization philosophy
- **Free to play, fully playable.** Every gameplay system accessible without spending.
- **Pay to customize** — cosmetic skins, mounts, housing, emotes, name color, profile flair.
- **Pay to reroll** — buy reroll tokens (also earnable in-game through play).
- **No pay-to-win** — no stat gear, no exclusive content locks.
- **RNG + Faith** — every roll is provably random (server-seeded, audited). "Faith" is a thematic currency rewarding persistence.

---

## 2. Core Gameplay Loop

```
Spawn (random race/bloodline/talent)
   ↓
Tutorial: Tree Fort intro → choose starter kingdom
   ↓
Quests (story + repeatable) → XP, Gold, Loot, Reroll Tokens
   ↓
Minigames (per-kingdom) → Tickets → Cosmetic Shop
   ↓
Dungeons / World Bosses / Dimensions → Rare gear, lore unlocks
   ↓
PvP Arena / Tournaments → Leaderboard, Titles, Cosmetics
   ↓
Re-roll race/bloodline/talent/abilities → new build → new loop
```

---

## 2A. Opening Experience — Candy Kingdom Starter Zone (locked design)

### 2A.1 Onboarding flow
1. **Spawn**: player rolls race/bloodline/talent, gets a short Prismo intro cinematic ("the timeline is fractured, you're one of the chosen"), then drops into the **Candy Kingdom** as a newcomer.
2. **Soft lockdown**: players **cannot leave the Candy Kingdom** until they complete the starter arc. The gates are guarded by Banana Guards who turn you back. This focuses the early game and teaches core mechanics in a controlled space.
3. **Starter arc**: Princess Bubblegum welcomes you, gives tutorial quests (combat, crafting, minigames, reputation). Once you finish the arc, the gates open and the rest of Ooo unlocks.

### 2A.2 Candy-eating mechanic (signature starter system)
- **You can eat Candy People.** This is a real, playable system, not a joke.
- **Eating a Candy Person**:
  - Lowers your **Candy Kingdom reputation** (only Candy Kingdom — no spillover to other kingdoms).
  - Spawns **Banana Guards** who chase you. If they catch you, you're **locked in the Candy Kingdom Dungeon** (a full mini-dungeon — see §2A.4).
  - Each eaten Candy Person fills your **Sugar Meter**.
- **Sugar Rush (tiered)**: the more candy you eat, the stronger the Sugar Rush — and the harder the crash.
  - Tier 1 (1-2 candy): +15% speed/str/parkour for 10s, no crash.
  - Tier 2 (3-4 candy): +30% for 20s, mild crash (slowed 5s).
  - Tier 3 (5-6 candy): +50% for 30s, hard crash (slowed 10s).
  - Tier 4 (7+ candy): +75% for 30s, "Sugar Coma" crash (slowed + screen blur 15s, can't sprint).
- Risk/reward: eating citizens is the fastest way to get Sugar Rush for hard early quests or escaping guards, but tanks your reputation and gets you chased/dungeon'd. Higher tiers are powerful but the crash can get you caught.
- Reputation can be rebuilt via quests, tarts, or community service (Banana Guard duty minigame).

### 2A.3 Reputation system (Candy Kingdom, first of many)
- Reputation tiers: Beloved → Liked → Neutral → Disliked → Wanted → Hunted.
- High reputation: shop discounts, exclusive quests, housing plot, Bubblegum's favor.
- Low reputation: guards attack on sight, vendors refuse service, dungeon escapes.
- Each kingdom has its own reputation meter with similar mechanics (thematic per kingdom — e.g., Fire Kingdom respects duels, Nightosphere respects power).

### 2A.4 Escaping the Candy Kingdom (the unlock)
- Complete the starter arc (story + a small dungeon, e.g., Royal Tart Vault heist or Banana Guard graduation).
- After the arc, the gates open. Bubblegum gives you a **Tree Fort deed** — your first housing/tycoon plot in the Grasslands just outside the kingdom.

### 2A.5 Banana Guard Dungeon (locked design)
- When caught by Banana Guards (from candy-eating infractions), players are sent to the **Candy Kingdom Dungeon** — a **full mini-dungeon**, not a short escape.
- Layout: 3-5 rooms with puzzles, stealth sections, and Banana Guard patrols.
- Secrets: hidden loot (candy contraband, rare recipes, a cosmetic "Dungeon Escapee" title), optional treasure rooms.
- **Boss**: the **Banana Guard Warden** (a tougher Banana Guard variant) at the exit. Defeating him grants bonus loot and a reprieve from guards for a short time.
- Failure (getting KO'd or caught again inside) extends your sentence — you respawn at the dungeon entrance with a longer timeout.
- Players can also voluntarily enter the dungeon as a repeatable PvE challenge once they've completed it once (no longer a punishment, just content).

---

## 2B. Tree Fort Tycoon System (locked design)

### 2B.1 Concept
After the Candy Kingdom starter arc, players get a Tree Fort deed. The Tree Fort is the player's persistent base — a **tycoon-style progression system**: go on quests/adventures, bring back loot, upgrade and expand your fort.

### 2B.2 Loop
```
Adventure (quests, dungeons, world bosses, minigames)
   ↓
Bring back loot (materials, gold, relics, blueprints)
   ↓
Upgrade Tree Fort (new rooms, stations, decor, defenses)
   ↓
Fort unlocks new gameplay (crafting stations, reroll altar, sidekick barracks, mount stable, portal room)
   ↓
Bigger adventures → better loot → bigger fort
```

### 2B.3 Tree Fort rooms/modules (unlock & upgrade tiers)
- **BMO Console Room** — save point, inventory, quest log, stats. (starter, free)
- **Crafting Station** — gear crafting (unlocked first).
- **Kitchen** — cooking consumables (Tree Trunks recipes).
- **Reroll Altar** — your private reroll spot.
- **Sidekick Barracks** — house recruited sidekicks; more beds = more squad.
- **Mount Stable** — house mounts.
- **Treasure Vault** — storage + display cases for relics.
- **Portal Room** — fast-travel to unlocked kingdoms/dimensions.
- **Garden** — farming materials (Tree Trunks-style).
- **Throne Room** — cosmetic flex, titles, leaderboards.
- **Defenses** — tower defenses minigame vs. occasional raider waves (PvE; optional PvP in Nightosphere Mode).

### 2B.4 Tycoon monetization (cosmetic only)
- Decor packs, room themes (Candy, Ice, Fire, Slime, Lumpy, Cosmic, Nightosphere), wallpaper, flooring, lighting, music boxes.
- No pay-to-build — rooms and stations are earned via play. Cosmetics only.

### 2B.5 Tree Fort location model (locked)
- **Two neighborhood types**:
  1. **Shared Grasslands neighborhood** (default for solo/unguilded players): instanced shard of ~8–16 Tree Forts. You see your neighbors' forts, walk between them, visit (if the owner allows). Classic tycoon "allow visitors / deny visitors" toggle per fort.
  2. **Guild-shared neighborhood** (for guilds): guild pools into a shared cluster. Shared decor contributions, shared resource nodes (gardens, mines), guild-vs-guild fort defense events, visible guild identity (banners, themed biome). Acts as the guild's home base.
- **Guild neighborhood scaling (locked)**: the cluster grows with guild size, up to 24 forts max. Small guilds get a small cluster; big guilds get a full 24-fort neighborhood. Empty slots can be filled by new guildmates joining.
- **Visitor controls**: fort owner can set fort to Public / Friends-only / Guild-only / Private. Visitors can interact with crafting stations (if owner allows) and view decor.
- **Guild neighborhood perks**: shared fast-travel portal, shared vault (guild-rank permissions), guild buff shrine, guild leaderboard display.
- **Switching**: solo players can join a guild and migrate their fort into the guild neighborhood (one-time move per season to prevent churn).

---

## 3. Character Creation — The RNG Trinity

On spawn, every player rolls three things. These can be rerolled later with tokens (earnable or purchasable).

### 3.1 Races (rollable, weighted by rarity)

**Tiered rollout (locked):** 19 races at launch (revised up from 15 based on your picks); remaining races added over seasonal updates. Launch roster marked with 🚀.

| Tier | Race | Notes |
|------|------|------|
| Common | 🚀 Candy Person, 🚀 Hot Dog Person, 🚀 Goblin, 🚀 Box Person, Pillow Person | Friendly, social races |
| Uncommon | 🚀 Slime Person, 🚀 Wildberry, 🚀 Cloud Person, Turtle Person, Mushroom Mutant | Kingdom citizens |
| Rare | 🚀 Ice Person (Penguin-kin), 🚀 Fire/Flame Person, 🚀 Lumpy Space Person, 🚀 Tree Folk, 🚀 Crystal Person | Elemental races |
| Epic | 🚀 Dog (Magical, Jake-kin), 🚀 Rainicorn, 🚀 Ghost, 🚀 Wizard-blooded Human, 🚀 Demon (Nightosphere) | Powerful but specialized |
| Legendary | 🚀 Human (Finn-kin), 🚀 Vampire (Marceline-kin), 🚀 Cosmic-touched, Lich-cursed | Extremely rare |
| Mythic | Cosmic Entity (Prismo-adjacent), Pure Demon Lord blood, Lich-blessed/cursed | 0.01% tier |

**Launch roster (19):** Candy Person, Hot Dog Person, Goblin, Box Person, Slime Person, Wildberry, Cloud Person, Ice Person, Fire/Flame Person, Lumpy Space Person, Tree Folk, Crystal Person, Dog (Magical), Rainicorn, Ghost, Wizard-blooded Human, Demon (Nightosphere), Human (Finn-kin), Vampire (Marceline-kin), Cosmic-touched.

**Post-launch rollout (seasonal):** Pillow Person, Turtle Person, Mushroom Mutant, Lich-cursed, Cosmic Entity, Pure Demon Lord blood, Lich-blessed/cursed, + more TBD.

Each race has innate passives (e.g., Fire People immune to fire, Vampires heal at night, Candy People craft faster). None are strictly "best" — each opens different build paths.

### 3.1.1 Lich-cursed race (locked)
- **Rollable at spawn**, ultra-rare (Mythic-tier odds, ~0.01%).
- High risk/reward: massive dark-power potential, but unique drawbacks (e.g., passive reputation loss in "good" kingdoms, hunted by hero NPCs, sanity mechanic).
- Designed as a prestige/challenge race — not for new players, but a flex for veterans.
- Lore justification: a fragment of the Lich's essence leaked into the multiverse during the timeline fracture; rare players are born with it.

### 3.2 Bloodlines (rollable, optional lineage)
- **Abadeer** — demonic, night-power, shadow affinity
- **Petrikov** — crown-cursed, ice affinity, sanity mechanic
- **Bubblegum** — royal candy, science/crafting bonus
- **Mertens** — heroic human, hero-quest XP bonus
- **Flame Royalty** — pyromancy, fire-kingdom reputation
- **Vampire Royalty** — night regen, blood magic
- **Rainicorn** — flight (limited), color magic
- **Dog (Magical)** — stretch powers, family bond buffs
- **Wizard Grandmaster** — extra spell slot, mana regen
- **Cosmic** — reroll luck bonus (meta)
- **Lich-touched** — forbidden power, high risk/reward
- **No Bloodline** (common) — no bonuses, but +1 free talent point

### 3.2.1 Bloodline progression & scaling (locked design)
Bloodlines grant **special traits and abilities**, with power scaled by rarity — but **never break scaling**. A fresh Mythic bloodline is not stronger than a maxed Common bloodline; the Mythic just has a higher ceiling and unique abilities unlocked through play.

**Rarity tiers (per bloodline):** Common → Uncommon → Rare → Epic → Legendary → Mythic

**Progression stages per bloodline:**
1. **Awakened** (Lv 1) — base passive trait only. Weak but flavorful.
2. **Tempered** (Lv 25) — first ability unlock.
3. **Ascended** (Lv 50) — second ability unlock + trait upgrade.
4. **Exalted** (Lv 75) — third ability unlock + unique perk.
5. **Mythic Realization** (Lv 100 + Ascension quest) — signature ultimate + cosmetic flair.

**Ascension quests** are bloodline-specific, lore-tied, repeatable for refinement (e.g., Abadeer → survive a Nightosphere trial; Petrikov → resist the Crown's whispers; Mertens → complete a hero's gauntlet).

**Scaling rule:** bloodline abilities scale off player level + talent tier, not raw bloodline rarity. A maxed Common bloodline ≈ a fresh Mythic at the same player level. Mythic just unlocks more tools and a higher ceiling.

### 3.3 Talents (rollable, pick 1 of 3 shown)
Hero (combat), Magic (spells), Music (buffs/debuffs), Science (crafting), Stealth, Necromancy, Pyromancy, Cryomancy, Demonology, Cosmic, Beast Taming, Healing, Luck (RNG bonus), Crafting, Speech (persuasion quests)

### 3.4 Abilities (earned + rollable)
Each talent tree unlocks ability slots. Abilities themselves are rolled from a pool — you might roll "Demon Blood Curse" or "Ice Ninja Shuriken." Reroll with tokens.

### 3.5 Reroll economy
- **Reroll Tokens** earned from: daily quests, dungeons, world bosses, PvP, achievements.
- **Cosmetic Reroll Tokens** (paid) — same odds, supports the game.
- All rolls server-authoritative, seed published for transparency.

### 3.5.1 Reroll monetization (locked)
- **Single tokens** — sold individually for small top-ups.
- **Token bundles** — discounted bulk packs.
- **Season Pass** — free track grants earnable reroll tokens + cosmetics; premium track grants extra reroll tokens, exclusive seasonal cosmetics, mount skins, decor. No stat items on either track. Same odds whether paid or earned.

---

## 4. World Map — Kingdoms & Locations (Canon + Lore)

### 4.1 Core Kingdoms (full zones)
1. **Candy Kingdom** — Princess Bubblegum, Peppermint Butler, Banana Guards, Cinnamon Bun, Starchy. Capital: Candy Castle. Dungeons: Royal Tarts vault, Secret Royal Dungeon.
2. **Ice Kingdom** — Ice King, Gunter & penguins. Capital: Ice Castle. Dungeon: Ice Caverns.
3. **Fire Kingdom** — Flame Princess (Phoebe), Flame King, Flame Lord. Capital: Flame Palace. Dungeon: Magma Mines.
4. **Slime Kingdom** — Slime Princess. Capital: Slime Castle. Dungeon: Sewer Sluice.
5. **Wildberry Kingdom** — Wildberry Princess. Capital: Wildberry Village.
6. **Cloud Kingdom** — Cloud Princess, Cloud People. Capital: Cloud City (floating).
7. **Lumpy Space** — Lumpy Space Princess. Floating dimension pocket.
8. **Goblin Kingdom** — Goblin King (Xergiok). Capital: Goblin City.
9. **Hot Dog Kingdom** — Hot Dog Princess.
10. **Turtle Kingdom** — Turtle Princess.
11. **Dog Kingdom** — Dog people, Joshua & Margaret references.
12. **Box Kingdom** — Box People.
13. **Pillow Kingdom** — Pillow People (Pillow World adjacent).
14. **Fly Kingdom** — Fly People.
15. **Pig Kingdom** — Pig people, Mr. Pig.
16. **Spooky Ghost Kingdom / Ghost Dimension** — Ghost Princess, spirits.
17. **Crystal Kingdom / Crystal Dimension** — Crystal People, moles.
18. **Mushroom Kingdom ruins** — Mushroom War aftermath, mutants.
19. **Beautopia** — Susan Strong & hyooman tribe.
20. **Lemongrab Earldom** — Lemongrab 1/2/3, lemon people.

### 4.2 Dimensions & Otherworldly Zones
- **Nightosphere** — Hunson Abadeer, demons. Dimension portal.
- **Dead World / Land of the Dead** — Death, Margaret (Death's horse).
- **The Vault / Prismo's Time Room** — Prismo, Cosmic Owl, multiverse hub.
- **Crystal Citadel** — interdimensional prison.
- **City of Thieves** — PvP-free-for-all zone, thief NPCs.
- **The Lich's Well of Power** — endgame dungeon, boss: The Lich.
- **The Cosmic Realm** — Cosmic Owl, Prismo, endgame meta zone.
- **Farmworld** (alternate dimension) — special event zone.
- **Pillow World** — dimension accessed via special quest.
- **The 47th Dead World** — spirit realm dungeon.
- **GOLB's Domain** — ultimate endgame boss.
- **The Spirit World** — shamanic quests.
- **The Glitch / The Void** — special event corruption zone.
- **Orgalorg's Lair** — cosmic horror boss zone.
- **Mars** — Grob Gob Glob Grod, Magic Man's house.

### 4.3 Landmarks & POIs
- **Tree Fort** — Finn & Jake's home (player housing intro / tutorial hub).
- **Grasslands / Bad Lands** — open-world mob zones.
- **Marceline's Cave House** — music quests, vampire lore.
- **Wizard City / Grand Master Wizard's Tower** — Bufo, Abracadaniel, Huntress Wizard, magic school.
- **The Fire Mountains** — fire-elemental wild zone.
- **The Enchiridion Shrine** — lore quest hub.
- **The Mushroom War Ruins** — pre-Ooo flashback zone.
- **The Hall of Justifiers** — hero HQ (PvP arena entrance).
- **The Crystal Mole City** — underground zone.
- **The Royal Tart Trench** — naval/water zone.
- **The Duke of Nuts' Estate** — nut people sub-kingdom.
- **Founders' Island / Minerva's island** — Finn origin lore.
- **The Cosmic Owl's dreamscape** — prophecy quests.
- **The Catalyst Comet** — reincarnation cycle lore event.

[?] — Want me to add fanon/speculation locations, or strictly canon + official lore?

---

## 5. Character Roster

### 5.1 Main Heroes (story NPCs / quest givers / mentors)
- **Finn Mertens** — hero-quest giver, combat mentor
- **Jake the Dog** — companion system tutorial, stretch-power trainer
- **BMO** — UI companion, inventory, save points
- **Princess Bubblegum** — science/crafting trainer, Candy Kingdom quests
- **Marceline Abadeer** — music/bloodline quests, vampire lore
- **Ice King (Simon Petrikov)** — crown-curse questline, ice magic
- **Lumpy Space Princess** — social/drama quests
- **Flame Princess (Phoebe)** — fire kingdom quests
- **Lady Rainicorn** — flight/travel quests (Korean dialogue easter egg)
- **Tree Trunks** — farming/cooking minigames
- **Peppermint Butler** — dark arts, secret quests
- **Choose Goose** — shopkeeper, riddle quests
- **Abracadaniel** — wizard school quests
- **Huntress Wizard** — ranger/beast taming trainer
- **Susan Strong** — Beautopia quests, hyooman tribe
- **Betty Grof** — magic/scholar quests
- **Prismo** — multiverse/time-room hub
- **Cosmic Owl** — prophecy/omen quests

### 5.2 Kingdom Rulers & NPCs
Flame King, Slime Princess, Wildberry Princess, Cloud Princess, Hot Dog Princess, Turtle Princess, Engagement Ring Princess, Ghost Princess, Muscle Princess, Skeleton Princess, Embryo Princess, Frozen Yogurt Princess, Orange Princess, Purple Princess, Lollipop Girl, Mr. Cupcake, Chocoberry, Dr. Ice Cream, Mr. Cream Puff, Root Beer Guy, Starchy, Cinnamon Bun, Banana Guards, Duke & Duchess of Nuts, Marquis of Nuts, Lemongrab 1/2/3, Goblin King (Xergiok), Don John the Flame Lord

### 5.3 Companions / Side characters
Neptr, Shelby, Bebe, Science Cat, Bronwyn, Charlie, Viola, T.V., Kim Kil Whan, Jake Jr., Mr. Pig, Sweet Trunks, The Jiggler, The Door Lord, Key-per, Ricardio, Tiffany, Frieda, Canyon, Kim, Kilowatt, Hambo (Marceline's doll)

### 5.4 Villains & Bosses
- **The Lich** (multiple forms: normal, Farmworld, hand, Sweet P reborn)
- **Hunson Abadeer** (Nightosphere lord)
- **Orgalorg / Gunter's true form**
- **GOLB** (ultimate cosmic boss)
- **Magic Man** (trickster boss)
- **Ricardio** (heart villain)
- **The Door Lord**
- **The Vampire King** + Vampire Court (The Fool, Empress, Hierophant, Moon, King)
- **Ash** (Marceline's ex)
- **Martin Mertens** (anti-hero, trickster)
- **Lemongrab** (antagonist-ally)
- **Xergiok** (goblin king)
- **Big Destiny** (Farmworld boss)
- **The Glitch** (corruption event boss)
- **The Lich's Hand** (mini-boss)
- **Flame Lord** (rival)
- **Grod's pet Squirrel** (joke boss)
- **The Businessmen** (early-game mob)
- **The Hooligans** (street mob)
- **Fruit Witches** (mini-boss pack)
- **The Bear** (betrayal quest)

### 5.5 Mounts / Pets
Lady Rainicorn (mount), Battle Cube, Fire Wolf, Ice Penguin mount, Slime Slug, Cloud Skiff, Lumpy Space Float, Marceline's bike, the Banana Boat, Ghostly Steed, Demon Bat

---

## 6. Items & Gear

### 6.1 Weapons (cosmetic + tiered stats — stats earnable, not buyable)
- **Finn's swords**: Grass Sword, Demon Blood Sword, Scarlet, Finn Sword, Night Sword, Small Sword, Four Sword
- **Jake's fists** (stretchy unarmed tree)
- **Marceline's bass axe** (music + combat hybrid)
- **Ice King's crown** (cosmetic, ice-magic catalyst)
- **Bubblegum's science gun**
- **Flame Princess's fire swords**
- **Wizard staves** (Abracadaniel's, Grand Master's)
- **Huntress Wizard's bow**
- **The Enchiridion** (lore artifact, ultimate quest item)
- **Gumball Guardian's halberd**

### 6.2 Armor / Cosmetics (cosmetic-only by design)
Finn's hat (white, black, gold, rainbow variants), Jake suit, Marceline outfit, PB lab coat, Ice King robe, Flame Princess dress, LSP body, Lemongrab outfit, Peppermint Butler suit, Banana Guard uniform, Tree Trunks' apple dress, Huntress Wizard gear, Susan Strong rags, Choose Goose outfit

### 6.3 Consumables
Royal Tarts (buff food), Apple Pie (Tree Trunks), Bacon pancakes (regen), Hot dog (stamina), Candy (heal), Ice cream (PB's), Demon blood (rare buff), Vampire juice (night buff), Slime smoothie, Cloud fluff, Lumpy Space oil, Wildberry jam

### 6.4 Crafting Materials
Candy crystals, Ice shards, Fire embers, Slime goo, Cloud tufts, Lumpy dust, Wildberry seeds, Goblin iron, Mushroom spores, Crystal fragments, Demon bones, Vampire dust, Cosmic dust, Enchiridion pages, Crown shards

### 6.5 Lore / Quest Items
The Enchiridion (chapters), Ice Crown shards, Marceline's diary, Betty's research, Prismo's notes, Cosmic Owl feathers, Lich's bone fragments

### 6.6 Housing / Decor
Tree Fort rooms, BMO console, Marceline's cave decor, Candy Kingdom furniture, Ice Castle throne, Flame forge, Slime pool, Cloud bed, Lumpy Space hammock

### 6.7 Cosmetics Shop (paid — all cosmetic, no stats)
- Skins (race reskins, e.g., "Finn-look human," "Marceline-look vampire")
- Dyes (color palettes for gear)
- Emotes (Finn arm wave, Jake fist bump, BMO dance, LSP "oh my glob," Marceline guitar riff)
- Mount skins
- Housing decor packs
- Name colors, profile frames, chat tags
- **Reroll tokens** (race/bloodline/talent/ability)

---

## 7. Buildings & Structures (asset list)

### 7.1 Per-Kingdom Architecture Sets
- **Candy Kingdom**: Candy Castle, banana guard barracks, peppermint houses, royal tart vault, bubblegum lab, candy streets/lamp posts
- **Ice Kingdom**: Ice castle, igloos, ice caverns, frozen pillars, penguin huddle huts
- **Fire Kingdom**: Flame palace, lava forges, ember markets, magma bridges
- **Slime Kingdom**: Slime castle, sewer pipes, goo fountains
- **Wildberry Kingdom**: Wildberry huts, vine bridges, berry patches
- **Cloud Kingdom**: Cloud spires, floating bridges, sky docks
- **Lumpy Space**: Lumpy float homes, star hammocks
- **Goblin Kingdom**: Goblin city, Xergiok's tower, scrap markets
- **Hot Dog / Turtle / Box / Pillow / Fly / Pig Kingdoms**: each unique themed set
- **Lemongrab Earldom**: lemon castle, lemon tree orchards, ear-shaped towers

### 7.2 World Structures
- Tree Fort (multi-floor player housing hub)
- Marceline's cave house
- Wizard tower / Wizard City
- The Enchiridion shrine
- The Hall of Justifiers (PvP arena entrance)
- Crystal Citadel (prison)
- Prismo's Time Room (cube)
- Nightosphere gate
- Dead World gate
- Mushroom War ruins (crashed vehicles, broken buildings, craters)
- Beautopia (hyooman underground city)
- Crystal Mole City (underground)
- Royal Tart Trench (naval docks)
- Founders' Island compound

### 7.3 Props & Decor (modular asset kit)
- Trees (candy, ice, fire, slime, wildberry, lumpy, mushroom, dead)
- Rocks, crystals, ice chunks, lava pits, slime pools
- Lamps, signs, banners per kingdom
- Banners & flags for each princess/king
- Market stalls, crates, barrels, food carts
- Dungeon doors, levers, switches, pressure plates
- Save points (BMO terminals)
- Fast-travel shrines (Cosmic Owl statues)
- Reroll altars (Enchiridion pedestals)

---

## 8. Mechanics & Systems

### 8.1 Combat System
- Action combat (melee, ranged, magic) with active dodge/block/dash.
- Talent-based ability bar (4–8 slots depending on talent tier).
- Elemental affinities (fire/ice/slime/candy/cosmic/demon) — rock-paper-scissors between elements.
- Combo system: timed hits build "Hero Meter" for ultimate.
- Race passives activate contextually (Vampires heal on night kills, Fire People ignite on crit, etc.).
- PvP duels (consensual), kingdom arena tournaments, open-world PvP only in City of Thieves & Bad Lands.

### 8.2 Quest System
- **Story quests**: per-kingdom arcs following canon beats (e.g., "Save Princess Bubblegum from Ricardio," "Retrieve the Enchiridion chapters," "Defeat the Lich at the Well of Power").
- **Repeatable daily/weekly quests**: bounties, gather, escort, defend.
- **Dynamic world events**: Lich invasions, Flame Kingdom raids, Nightosphere incursions, Cosmic Owl omens.
- **Dimensional rifts**: rotating portals to Pillow World, Farmworld, Dead World.
- **Companion quests**: recruit Jake-kin dogs, Rainicorns, etc.

### 8.3 Minigames (per kingdom, give Tickets → Cosmetic Shop)
- **Candy Kingdom**: Royal Tart Baking (timing), Banana Guard Drill (rhythm), Science Lab (puzzle)
- **Ice Kingdom**: Penguin Slide Race, Ice Crown Freeze Tag, Snowball Siege
- **Fire Kingdom**: Magma Parkour, Flame Duel arena, Lava Fishing
- **Slime Kingdom**: Sewer Slide, Slime Wrestling
- **Cloud Kingdom**: Sky Race, Cloud Hopping
- **Lumpy Space**: Float Dodgeball
- **Wildberry**: Berry Harvest (timing)
- **Hot Dog Kingdom**: Hot Dog Eating Contest
- **Marceline's**: Music Rhythm (bass guitar), Battle of the Bands
- **Tree Trunks'**: Apple Pie Baking, Apple Orchard Run
- **Wizard City**: Spellcraft Spellcasting, Wizard Duel
- **Beautopia**: Swimming/Survival
- **City of Thieves**: Steal-the-Crown heist minigame
- **Hall of Justifiers**: PvP tournament brackets

### 8.4 Economy
- **Gold** — main currency from quests, mobs, vendors. Used for gear repairs, basic items, fast travel.
- **Tickets** — minigame currency → Cosmetic Shop only.
- **Reroll Tokens** — earned in-game (dailies, dungeons, bosses, PvP) OR bought. Used for race/bloodline/talent/ability rerolls.
- **Cosmic Shards** — premium currency (paid) → cosmetics, mount skins, decor packs, paid reroll tokens. **Never** buys stats.
- **Faith** — meta currency earned by playtime/achievements; spent on luck blessings (small RNG boost to next roll). Thematic, capped daily so it can't be whales'd.

### 8.5 Progression
- XP → Level (cap TBD, e.g., 100). Each level grants talent points + ability slot unlocks.
- Reputation per kingdom — unlocks quests, vendors, housing, mounts.
- Titles (e.g., "Hero of the Candy Kingdom," "Nightosphere Survivor," "Lich Slayer," "Cosmic Touched").
- Achievement system with cosmetic rewards.

### 8.6 Housing
- Tree Fort instanced player housing (free starter room).
- Expandable with decor (paid & earned).
- Kingdom-themed housing plots unlock via reputation.
- Visit other players' forts (social).

### 8.7 Social / MMO Systems
- Friends list, party (up to 6), guilds ("Courts" — themed after kingdoms).
- Trading (cosmetics only — no stat gear trading, prevents RMT/power trading).
- Mail, leaderboards, PvP tournaments, seasonal events.
- Cross-server zones for high-population hubs.

### 8.8 Anti-Pay-to-Win Guardrails
- All stat gear is account-bound & earnable only.
- Reroll tokens have the same odds whether paid or earned.
- No exclusive stat-boosting items in shop. Ever.
- Public drop-rate table & audited RNG seed.
- Whales can look amazing but never out-stat a free player.

---

## 9. Production Roadmap (proposed phases)

> **Updated v0.5:** Beta scope locked at 2 zones (Candy Kingdom + Grasslands/Tree Fort). Full detail in `MVP_BETA_SCOPE.md`, `COMBAT_DOC.md`, `LOCATIONS_DOC.md`. Seasonal cadence: quarterly big update + monthly minor patch.

### Phase 0 — Pre-production (now)
- Lock GDD with you.
- Define art style guide (Roblox-appropriate, AT-faithful).
- Tech stack decisions (Roblox Studio + Luau; data store; anticheat; RNG audit service).

### Phase 1 — Beta MVP (Candy Kingdom + Grasslands)
- 2 zones only: Candy Kingdom (full) + Grasslands/Tree Fort (home base).
- RNG character creation (race/bloodline/talent).
- Candy-eating + reputation + Banana Guard Dungeon + Sugar Rush.
- Deep combat (combos, parry, block, dodge, 3-4 abilities, elemental, hero meter).
- Consensual duels (PvP), no open-world PvP yet.
- Sandbox RPG focus — light story, heavy emergent play.
- Tree Fort basic housing (full tycoon post-beta).

### Phase 2 — Season 1 "Foundations"
- Sidekicks, full Tree Fort tycoon, minigames, reroll tokens, cosmetics shop, season pass, dyes, mystery boxes, mounts.
- New zone: Ice Kingdom.

### Phase 3 — Season 2 "Courts & Conflict"
- Guilds, guild neighborhoods, open-world PvP zones, sidekick Permadeath Mode, bloodline ascension quests.
- New zones: Fire Kingdom, Goblin Kingdom.

### Phase 4 — Season 3 "Beyond Ooo"
- Dimensions: Nightosphere, Dead World. World boss: Hunson Abadeer.
- New zones: Slime Kingdom, Wildberry Kingdom.

### Phase 5 — Season 4 "Cosmic Horrors"
- Prismo's Time Room, Crystal Citadel. World bosses: Lich, Orgalorg.
- New zones: Cloud Kingdom, Lumpy Space.

### Phase 6 — Season 5 "The Vault"
- Farmworld, Pillow World. World boss: GOLB.
- New zones: Hot Dog Kingdom, Turtle Kingdom, Lemongrab Earldom.

### Phase 7 — Season 6+ "Eternal Ooo"
- Remaining kingdoms, Mars, Founders' Island, Cosmic Realm endgame, UGC tools.

---

## 10. Open Questions for You

**Locked from v0.5 input:**
- ✅ Launch roster: 19 races (12 base + Box, Tree Folk, Crystal, Rainicorn, Ghost, Wizard-Human, Demon). *(Confirm if you wanted only 3 of those 7 — otherwise 19 stands.)*
- ✅ Sugar Rush: tiered — more candy = stronger buff + harder crash (4 tiers, top tier = Sugar Coma).
- ✅ Candy-eating reputation: only Candy Kingdom affected, no spillover.
- ✅ Banana Guard Dungeon: full mini-dungeon with 3-5 rooms, secrets, loot, Banana Guard Warden boss.
- ✅ Guild neighborhood size: scaling with guild size, up to 24 forts max.

**Locked from v0.4 input:**
- ✅ Race rollout: tiered. Lich-cursed race: rollable, ultra-rare.
- ✅ Music: original AT-style score. Voice: text + mumbling.
- ✅ Server topology: hybrid.
- ✅ Sidekick system: 1 per player, party of 6 = 12 chars, opt-in Permadeath Mode.
- ✅ Tree Fort location: shared Grasslands + guild-shared neighborhoods.

**Locked from v0.3 input:**
- ✅ Story framing: multiverse via Prismo's Time Room.
- ✅ Age/tone: default all-ages + opt-in Nightosphere Mode.
- ✅ Companions: quest-only cameos + recruited sidekicks.
- ✅ Opening experience: Candy Kingdom starter zone.
- ✅ Progression out: Tree Fort tycoon.

**Locked from v0.2 input:**
- ✅ Canon approach, art style, PvP scope, bloodline design, reroll monetization.

**Still open:**
1. **Permadeath Mode reward scaling** — how much extra loot/XP justifies the risk? (e.g., +50%? +100%? guaranteed rare drop?)
2. **Mumble voice budget** — small set of reusable mumble voices, or unique mumble per named character?
3. **Candy Kingdom starter arc length** — how long should the soft lockdown last? (30 min? 1-2 hours? Until first dungeon cleared?)
4. **Reroll token earn rate** — how many tokens should a casual player earn per week?
5. **Season pass cadence** — monthly? quarterly? tied to in-show episode beats?
6. **Mount acquisition** — earn all in-game, or some paid-only cosmetic mounts?

---

## 11. Next Steps

Once you answer the open questions, I'll:
- Revise the GDD to v0.2.
- Spin off separate asset spreadsheets (CSV): `items.csv`, `characters.csv`, `locations.csv`, `buildings.csv`, `mechanics.csv` — each with status columns (To-Do / Modeled / Scripted / Integrated).
- Draft a technical architecture doc (data stores, anticheat, RNG audit, server topology).
- Draft an art bible & asset list with model counts per zone.

---

*End of v0.1 draft. Awaiting your input.*

