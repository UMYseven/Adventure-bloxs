# Adventure Time: Ooo MMORPG — Combat Document (v0.1)

> **Companion to:** `GAME_DESIGN_DOCUMENT.md` (v0.5), `MVP_BETA_SCOPE.md` (v0.1)
> **Focus:** Deep combat system — PvE + PvP duels (beta scope) + roadmap to full PvP post-beta
> **Status:** Draft for review. `[?]` marks items needing your input.

---

## 1. Combat Design Goals

1. **Accessible but deep** — easy to pick up (light/heavy/dodge), hard to master (combos, parry timing, elemental affinity).
2. **Mobile-friendly** — works on touch controls without losing depth on PC/console.
3. **Race-aware** — your race passives change how you play (Vampire heals at night, Fire People ignite on crit, etc.).
4. **Bloodline-flavored** — bloodline abilities are the "ultimate" layer, not the base loop.
5. **Sandbox-friendly** — combat integrates with emergent systems (knock a guard into a candy cart, Sugar Rush + parkour + combat chain).

---

## 2. Controls (default scheme)

### 2.1 PC / Console
| Input | Action |
|-------|--------|
| LMB / RT | Light attack |
| RMB / LT | Heavy attack |
| Space / A | Dodge roll (i-frames) |
| Shift / LS-click | Block (hold) |
| Q / RB | Ability 1 |
| E / LB | Ability 2 |
| R / Y | Ability 3 |
| F / X | Ability 4 (unlock at level 20) |
| Middle / LS | Hero Meter ultimate (when full) |
| Tab | Lock-on target |
| Ctrl / B | Crouch / stealth |

### 2.2 Mobile
- Virtual joystick (left) for movement
- Tap buttons (right) for light, heavy, dodge, block, 4 abilities, ultimate
- **Auto-target assist: ON for mobile (locked)**, OFF for PC (skill-based). Toggle in settings on both.
- Swipe to dodge direction

---

## 3. Core Combat Mechanics

### 3.1 Light / Heavy attacks
- **Light**: fast, low damage, builds combo counter. Chains into 3-4 hit combos.
- **Heavy**: slow, high damage, breaks guard, launches enemies. End-of-combo finisher.
- **Combo counter**: consecutive hits without taking damage build a multiplier (up to x3). Resets on hit taken.

### 3.2 Dodge / Block / Parry
- **Dodge roll**: i-frames (invincibility) for ~0.4s. Stamina cost. Direction matters.
- **Block**: reduces damage by 70%, holds against light attacks, breaks against heavy. Stamina drain.
- **Parry**: tap block just before hit lands (**0.3s window — locked**) → stagger enemy, open for crit. High skill ceiling but accessible.

### 3.3 Stamina
- Every combat action costs stamina (attack, dodge, block, ability).
- Stamina regens when not attacking/blocking at **medium rate (locked)** — balanced, neither spammy nor punishing.
- Out of stamina = slowed, can't dodge, can't block. Punishes spam.

### 3.4 Hero Meter
- Builds as you deal/take damage and land combos/parries.
- At full, triggers **Hero Mode for 10s (locked)**: +50% damage, infinite stamina, ability cooldowns halved, signature hero attack available.
- Hero attack is talent-themed (Hero talent = "Heroic Strike," Magic = "Arcane Nova," Music = "Bardic Finale," etc.).

### 3.5 Elemental affinities
| Element | Strong vs | Weak vs | Status effect |
|---------|----------|---------|--------------|
| Fire | Ice, Slime | — (Water post-beta) | Burn (DoT) |
| Ice | Fire, Plant | Blunt | Freeze (slow) |
| Slime | Ice | Fire | Stick (slow + can't dodge) |
| Candy | Demon (post-beta) | None | Sugar (heal on hit) |

- **Beta has 4 elements: Fire, Ice, Slime, Candy (locked — core 4).** Demon and Cosmic come post-beta.
- Weapons and abilities have an element. Race passives can add element to unarmed.

---

## 4. Abilities

### 4.1 Ability slots
- 4 ability slots total (slots 1-3 from level 1, slot 4 unlocks at level 20).
- **Beta: only 2 ability slots active (locked — minimal, easy to learn).** Slots 3-4 unlock post-beta (Season 1).
- Abilities come from your **talent tree** + **bloodline** + **race**.
- Each ability has a cooldown and stamina/mana cost.

### 4.2 Ability sources
- **Talent abilities**: 6-8 per talent tree, pick 3-4 to slot.
- **Bloodline abilities**: unlock at bloodline progression stages (Awakened → Tempered → etc.). See GMD §3.2.1.
- **Race abilities**: 1-2 innate per race (e.g., Vampire "Bat Form" dodge, Fire Person "Ignite" passive-on-crit).

### 4.3 Ability rolling
- At each unlock, you roll an ability from your talent's pool. Reroll with tokens (post-beta; in beta, fixed picks for simplicity).

---

## 5. PvE Combat

### 5.1 Enemy types in beta
| Enemy | Location | Behavior |
|-------|----------|----------|
| Candy Bandit | Grasslands | melee, runs when low HP |
| Wild Berry Wolf | Grasslands | pack hunter, flanks |
| Sugar Sprout | Grasslands edge | slow, swarms |
| Banana Guard (hostile) | Candy Kingdom (when Wanted) | chases, calls reinforcements |
| Banana Guard Warden | Banana Guard Dungeon (boss) | heavy attacks, summons guards |
| Royal Tart Golem | Royal Tart Vault (mini-boss) | tanky, knockback |

### 5.2 Enemy AI states
- **Patrol** — walks route, spots player on sight cone.
- **Investigate** — moves to noise/distraction.
- **Chase** — pursues player, calls reinforcements if line-of-sight held.
- **Attack** — light/heavy mix, telegraphs heavy attacks.
- **Flee** — runs at low HP (some enemies).
- **Alert** — calls guards, raises local alarm.

### 5.2.1 Enemy telegraphing (locked)
- **Bright red flashes** on heavy attacks — clear, accessible, easy to read.
- Subtle wind-up animations accompany the flash for flavor.
- Optional "Colorblind-friendly" palette swap in settings (red → blue outline).

### 5.2.2 Combat camera (locked)
- **Default: fixed behind player** (simpler, mobile-friendly).
- **Opt-in: lock-on** (free-look with target lock, modern action RPG style).
- Toggle in settings; can swap mid-combat.
- Mobile defaults to fixed; PC/console defaults to lock-on.

### 5.3 Aggro & stealth
- Sight cones + hearing radius. Sneaking behind enemies avoids aggro.
- Sugar Rush tier 2+ increases noise (footsteps) — trade-off.
- Environmental noise (breaking pots) alerts enemies.

### 5.4 Difficulty scaling
- Overworld mobs scale to player level ±2.
- Dungeon mobs scale to party leader level.
- **Beta level cap: 20 (locked)**. Post-beta cap raises per season (30 → 50 → 75 → 100).

---

## 6. PvP Combat (Beta — Duels Only)

### 6.1 Duel rules (beta)
- **Consensual only** — both players must accept a duel request.
- **1v1** in beta. 2v2/3v3 come post-beta with arenas.
- **Anywhere in beta zones** — open a duel in Candy Kingdom or Grasslands. No dedicated arena yet.
- **No loot loss** — loser keeps all items. Winner gets a small gold + cosmetic title chance.
- **No reputation impact** — duels are honorable, don't trigger guards.
- **Time limit** — 3 min. If neither wins, draw.

### 6.2 Duel flow
1. Player A targets Player B → sends duel request.
2. Player B accepts (or declines).
3. 3-2-1 countdown, both players flagged for PvP.
4. Fight. Spectators can watch but not interfere.
5. Winner declared. Both players' PvP flags drop.

### 6.3 Balance for duels
- All racial passives active.
- Bloodline abilities active.
- Hero Meter builds normally (10s Hero Mode).
- **Friendly fire**: toggle — party leader chooses (off by default for clean duels, on for chaos duels).
- **Consumables: allowed (locked)** — chaos, prep matters. Both players can use food/buffs in duels.

### 6.4 Anti-grief
- Duel spam = cooldown (can't re-challenge same player for 5 min).
- Can't duel in mid-combat with PvE (prevents griefing via duel interrupt).
- Can't duel in dungeon instances.

---

## 7. Post-Beta PvP Roadmap

### 7.1 Season 2 — Open-world PvP zones
- **City of Thieves**: full loot rules (winner takes a % of loser's gold), flagged zone.
- **Bad Lands**: team-based territory control, kingdom banners.
- **Hall of Justifiers**: dedicated arena with 1v1, 2v2, 3v3, 5v5 brackets.
- **Tournaments**: weekly, leaderboard, seasonal cosmetics.

### 7.2 PvP modes (post-beta)
- Arena duel (1v1, 2v2, 3v3, 5v5)
- Capture the Flag (kingdom banners)
- King of the Hill (Bad Lands nodes)
- Battle Royale (limited-time event, 50 players)
- Guild vs Guild fort defense (Tree Fort neighborhoods)

### 7.3 PvP rewards (cosmetic only)
- Titles ("Duelist," "Champion of the Bad Lands")
- Cosmetic skins (kingdom banners as capes)
- Mount skins
- Leaderboard placement

---

## 8. Combat-Adjacent Systems

### 8.1 Status effects (beta)
- Burn (DoT, fire)
- Freeze (slow, ice)
- Stick (can't dodge, slime)
- Sugar (heal on hit, candy)
- Curse (reduced healing, demon)
- Stagger (interrupt, cosmic)
- Stun (parry follow-up)
- Knockback (heavy attack)

### 8.2 Healing
- Food consumables (Royal Tarts, Bacon Pancakes) — channel time, can be interrupted.
- Vampire racial: heal on night kill.
- Candy racial: craft food faster.
- No in-combat full heal — fights are commitments.

### 8.3 Death
- **PvE death (locked — harsh)**: respawn at last BMO save point, lose **10% gold** (recoverable by returning to death spot) + **XP debt** (slows next level-ups until paid off).
- **PvP duel loss**: no death, just loss.
- **Beta**: no perma-death for players. Sidekick perma-death is post-beta opt-in.
- **XP debt mechanic**: does not block leveling — instead, a portion of XP earned goes to paying off debt before advancing the level bar. Prevents rage-quit spiral while keeping the sting.

---

## 9. Combat Progression

### 9.1 Talent trees (beta has all 15, but only ~3-4 abilities per tree unlocked)
- Each talent tree has 6-8 abilities total; beta unlocks the first 3-4 per tree.
- Talent points gained per level (1 point/level).
- Spend on ability unlocks + passive nodes (damage, stamina, crit, etc.).

### 9.2 Weapon proficiency
- Use a weapon type → gain proficiency XP → unlock combos for that weapon.
- **Beta weapon types (locked — 5): sword, axe, staff, unarmed, bow.** Bass-axe (music) post-beta.
- Bow adds ranged combat option for beta players who prefer distance.

### 9.3 Hero Meter upgrades
- Hero Meter capacity grows with level.
- Hero Mode duration grows with level.
- Hero Attack unlocks per talent tree.

---

## 10. Open Questions for You

**Locked from v0.4 input:**
- ✅ Auto-target assist: OFF on PC (skill-based), ON for mobile. Toggle in settings.
- ✅ Duel consumables: allowed (chaos, prep matters).
- ✅ Beta ability slots: 2 active in beta (minimal, easy to learn). Slots 3-4 post-beta.
- ✅ Beta elements: core 4 only (Fire, Ice, Slime, Candy). Demon/Cosmic post-beta.
- ✅ Beta weapons: 5 types (sword, axe, staff, unarmed, bow). Bass-axe post-beta.

**Locked from v0.3 input:**
- ✅ Friendly fire: toggle — party leader chooses (off by default).
- ✅ Hero Mode duration: 10s.
- ✅ Enemy telegraphing: bright red flashes + colorblind palette swap.
- ✅ Combat camera: toggle — default fixed behind player, opt-in lock-on (mobile = fixed, PC/console = lock-on).
- ✅ Stamina regen: medium (balanced).

**Locked from v0.2 input:**
- ✅ Parry window: 0.3s medium.
- ✅ Death penalty: harsh — 10% gold + XP debt (debt slows, doesn't block).
- ✅ Beta level cap: 20.

**Combat doc is now fully locked.** Remaining combat-adjacent tuning can happen in playtesting.

---
