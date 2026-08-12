# Adventure Time: Ooo MMORPG — MVP / Beta Scope Document (v0.2)

> **Companion to:** `GAME_DESIGN_DOCUMENT.md` (v0.5), `CLOTHING_ASSET_DOC.md` (v0.2)
> **Focus:** Beta release scope — what's IN, what's OUT, sandbox RPG focus, emergent systems, seasonal update roadmap
> **Status:** Draft for review. `[?]` marks items needing your input.
>
> **v0.2 changes:** Locked beta access (paid founder's pack), beta wipe (partial — keep cosmetics/titles, wipe levels/gold), Tree Fort depth (mid — enter + decor + 2-3 upgrade rooms), level cap (20), beta map size (larger Grasslands with multiple sub-areas).

---

## 1. Beta Vision

A focused, polished slice of Ooo that delivers the **core fantasy** — spawn into a random body, run around the Candy Kingdom, eat its citizens, cause chaos, dodge Banana Guards, escape the dungeon, chain Sugar Rush parkour, interact with the environment, take light story quests, and duel other players. Sandbox RPG first; deep systems come post-beta via seasonal updates.

**Beta = vibe check.** Prove the loop is fun before building the rest of Ooo.

---

## 2. Beta Scope — IN

### 2.1 Zones (2)
1. **Candy Kingdom** (full zone) — capital, citizens, guards, dungeon, gates, shops, Bubblegum's castle, starter quests.
2. **Grasslands + Tree Fort** (home base zone) — open grassland outside Candy Kingdom gates, Tree Fort as basic home (enter, light decor), fast-travel shrine, a few wild mobs.

### 2.2 Systems IN beta
| System | Beta state | Notes |
|--------|-----------|------|
| **RNG character creation** | Full | Roll race/bloodline/talent at spawn. 19 launch races. |
| **Candy-eating mechanic** | Full | Eat Candy People → reputation drop → Banana Guards chase → dungeon. |
| **Reputation system** | Candy Kingdom only | Other kingdoms' reputation meters come post-beta. |
| **Banana Guard Dungeon** | Full | 3-5 rooms, secrets, Banana Guard Warden boss. |
| **Sugar Rush** | Full | Tiered (4 tiers, top = Sugar Coma). |
| **Combat (deep)** | Full | Combos, parry (0.3s window), block, dodge, 3-4 abilities, elemental affinities, hero meter. See `COMBAT_DOC.md`. |
| **PvP (duels)** | Consensual only | 1v1 duels anywhere in beta zones; no open-world PvP zones yet. |
| **Sandbox RPG** | Light story | Branching-light story quests + heavy emergent play. |
| **Emergent systems** | 4 systems | Candy-eating, guard interactions, Sugar Rush parkour, environmental interaction. |
| **Tree Fort housing (mid)** | Enter + decor + 2-3 upgrade rooms | Full tycoon loop is post-beta; beta gets a mid-tier taste. |
| **Save / progress** | Full | XP, level (cap 20), gold, inventory, reputation all persist. |
| **Mumble voice + text dialogue** | Full | All NPC dialogue uses mumble + text. |
| **Day/night cycle** | Full | Affects Vampire racial, NPC schedules, guard patrols. |

### 2.3 Beta access & wipe (locked)
- **Access**: Paid beta via **Founder's Pack ($5)** — cheap entry, broad access.
- **Founder's Pack contents (locked)**:
  - Exclusive beta **hat cosmetic** (never returns post-beta)
  - Exclusive beta **aura cosmetic** (never returns post-beta)
  - Small **Cosmic Shards** premium currency bonus (for Season 1 cosmetics shop)
  - Exclusive **Tree Fort decor pack** (beta-themed, carries into Season 1)
  - "Founder" title (permanent, carries into Season 1)
- **Wipe at Season 1 launch**: **Partial** — keep cosmetics + titles earned in beta; wipe levels, gold, reputation, inventory. Rewards early testers without giving them a permanent stat advantage.
- **Beta length**: **Open-ended** — runs until Season 1 is ready (no fixed deadline; ship Season 1 when quality bar met + metrics green).
- **Beta ending**: **Live "Lich omen" weekend finale event (locked)** — Friday-Sunday event where the Lich's influence seeps into Candy Kingdom, culminating in a server-wide finale on Sunday that closes beta and ushers in Season 1.

### 2.3 Quests IN beta
- **Starter arc** (Candy Kingdom): Bubblegum welcome → tutorial combat → first dungeon (Royal Tart Vault OR Banana Guard graduation) → gates open to Grasslands.
- **Repeatable bounties**: Banana Guard captain posts bounties on wild Grasslands mobs.
- **Light story quests**: **~10 short quests (locked)** from Candy Kingdom NPCs (Peppermint Butler, Starchy, Cinnamon Bun, Tree Trunks visits).
- **Sandbox objectives**: "eat 10 candy people without getting caught," "escape the dungeon 3 times," "chain Sugar Rush across the rooftops" — achievement-style, no quest giver needed.

### 2.4 Mounts in beta (locked)
- **1 basic mount: Battle Cube** — earnable early in beta via a short quest. For Grasslands traversal (faster than on-foot, no combat use). No paid mounts in beta.

---

## 3. Beta Scope — OUT (post-beta)

These systems are designed in the GDD but **not built for beta**. They come in seasonal updates.

| System | Target season |
|--------|---------------|
| Sidekick recruit system | Season 1 |
| Tree Fort tycoon upgrade loop (full) | Season 1 |
| Minigames (per-kingdom) | Season 1+ |
| Reroll tokens + altar | Season 1 |
| Cosmetics shop (paid) + season pass | Season 1 (monetization launch) |
| Guild system + guild neighborhoods | Season 2 |
| Open-world PvP zones (City of Thieves, Bad Lands) | Season 2 |
| Permadeath Mode (sidekick) | Season 2 |
| Dye system (full) | Season 1 |
| Mystery boxes (earnable) | Season 1 |
| 17 remaining kingdoms | Season 1+ (one per season roughly) |
| Dimensions (Nightosphere, Dead World, Prismo's, etc.) | Season 2+ |
| World bosses (Lich, Hunson, Orgalorg, GOLB) | Season 3+ |
| Mounts | Season 1 |
| Bloodline ascension quests (full) | Season 2 |

---

## 4. Sandbox RPG Focus (locked)

### 4.1 Design philosophy
- **Light story, heavy emergence.** A short starter arc teaches mechanics; after that, players make their own fun.
- **No hand-holding quest chains.** Quests are short, optional, and reward exploration/chaos, not linear progression.
- **Reputation is the main RPG lever.** Your Candy Kingdom reputation shifts based on what you do (eat citizens, help guards, bribe, etc.), unlocking/closing access to NPCs and areas.
- **Environmental storytelling.** The world itself tells the story — signs, NPC reactions, guard chatter, candy citizen panic states.

### 4.2 Emergent systems (4 in beta)

#### 4.2.1 Candy-eating (already locked)
Eat Candy People → reputation drop → guards chase → dungeon if caught. Sugar Rush tiers. See GMD §2A.2.

#### 4.2.2 Banana Guard interactions
Beyond just running from guards, players can:
- **Bribe** guards (gold) to look the other way for a time.
- **Fight** guards (knock them out — temporary reprieve, bigger bounty).
- **Sneak** past guards (stealth — line-of-sight, distraction throws).
- **Impersonate** a guard (steal a uniform, walk past — high risk if caught).
- **Snitch** on other players (in multiplayer, report a candy-eater for a reward).

#### 4.2.3 Sugar Rush parkour
- Sugar Rush tier 2+ boosts jump height and parkour speed.
- Hidden rooftop paths across Candy Kingdom only reachable with Sugar Rush.
- Speedrun-style achievements: "circumnavigate the kingdom in Sugar Rush without crashing."
- Crash landing in a guard patrol = caught.

#### 4.2.4 Environmental interaction
- **Push / pull / throw** objects (crates, barrels, candy carts).
- **Break** breakables (windows, pots, candy lamps) — makes noise, attracts guards.
- **Climb** certain surfaces (rope, ladders, ivy).
- **Hide** in barrels, hay piles, closets (stealth).
- **Trigger** environmental hazards (knock over a candy cart onto a guard, drop a chandelier).

---

## 5. Seasonal Update Roadmap (locked cadence)

### 5.1 Cadence
- **Quarterly big update** (every 3 months): new zone/kingdom + major system + season pass.
- **Monthly minor patch**: balance, bug fixes, small content (cosmetics, a quest, an event).
- **Live events** between patches: limited-time world events (e.g., "Lich omen week," "Candy Festival").

### 5.2 Season plan (post-beta)

#### Season 1 — "Foundations"
- Sidekick recruit system
- Tree Fort full tycoon loop
- Minigames (Candy Kingdom set: 3 minigames)
- Reroll tokens + altar
- Cosmetics shop + first season pass
- Dye system (full)
- Mystery boxes (earnable)
- Mounts (basic)
- **New zone**: Ice Kingdom (3rd kingdom)

#### Season 2 — "Courts & Conflict"
- Guild system + guild neighborhoods
- Open-world PvP zones (City of Thieves, Bad Lands)
- Sidekick Permadeath Mode
- Bloodline ascension quests (full)
- **New zones**: Fire Kingdom, Goblin Kingdom

#### Season 3 — "Beyond Ooo"
- Dimensions: Nightosphere, Dead World
- First world boss: Hunson Abadeer
- **New zones**: Slime Kingdom, Wildberry Kingdom

#### Season 4 — "Cosmic Horrors"
- Prismo's Time Room, Crystal Citadel
- World bosses: Lich, Orgalorg
- **New zones**: Cloud Kingdom, Lumpy Space

#### Season 5 — "The Vault"
- Farmworld, Pillow World dimensions
- World boss: GOLB (ultimate)
- **New zones**: Hot Dog Kingdom, Turtle Kingdom, Lemongrab Earldom

#### Season 6+ — "Eternal Ooo"
- Remaining kingdoms (Box, Fly, Pig, Pillow, Crystal, Mushroom ruins, Beautopia, Dog Kingdom)
- Mars, Founders' Island
- Cosmic Realm endgame
- Player-created content tools (UGC cosmetics review)

### 5.3 Monthly minor patch template
- Balance pass (combat, RNG odds, economy)
- Bug fixes
- 1-2 new cosmetics
- 1 new repeatable quest or bounty
- 1 limited-time event (weekend or week-long)

---

## 6. Beta Success Metrics

Before greenlighting Season 1 production:
- **D1 retention** > 30%
- **D7 retention** > 15%
- **Average session** > 20 min
- **Candy-eating engagement** — > 60% of players try it at least once
- **Dungeon completion** — > 40% of caught players complete the dungeon
- **Duel participation** — > 20% of players try a duel
- **Player sentiment** — net positive on sandbox feel, combat depth, chaos freedom

---

## 7. Open Questions for You

**Locked from v0.4 input:**
- ✅ Founder's Pack contents: exclusive beta hat + aura, small Cosmic Shards, Tree Fort decor pack, Founder title.
- ✅ Quest count: ~10 short quests.
- ✅ Mounts in beta: 1 basic mount (Battle Cube), earnable, no paid mounts.
- ✅ Lich omen event length: weekend finale (Friday-Sunday).

**Locked from v0.3 input:**
- ✅ Founder's Pack price: $5.
- ✅ Beta length: open-ended.
- ✅ Beta ending: live "Lich omen" weekend event.

**Locked from v0.2 input:**
- ✅ Beta access: paid Founder's Pack.
- ✅ Beta wipe: partial — keep cosmetics + titles, wipe levels/gold/inventory/reputation.
- ✅ Tree Fort in beta: mid — enter + decor + 2-3 upgrade rooms.
- ✅ Beta level cap: 20.
- ✅ Beta map size: larger Grasslands with multiple sub-areas.
- ✅ Day/night cycle: full.
- ✅ Parry window: 0.3s medium.
- ✅ Death penalty: harsh — 10% gold + XP debt.

**MVP/Beta Scope doc is now fully locked.** Remaining tuning happens in playtesting.

---
