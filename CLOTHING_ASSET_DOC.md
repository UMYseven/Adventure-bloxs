# Adventure Time: Ooo MMORPG — Clothing & Cosmetics Asset Document (v0.2)

> **Companion to:** `GAME_DESIGN_DOCUMENT.md` (v0.5)
> **Focus:** Character clothing / cosmetic assets for the 19 launch races
> **Rig standard:** R16 (Roblox 16-part rig) — hybrid: community base + custom tweaks per archetype
> **Status:** Draft for review. `[?]` marks items needing your input.
>
> **v0.2 changes:** Locked R16 source (hybrid), archetype mapping (hybrid — 5 base + race-specific signature pieces), slot count (core 8), cosplay policy (inspired-by only), mystery box (earnable-only), dye system (tiered).

---

## 1. Rig Standard — R16 (locked)

### 1.1 Why R16
R16 is a 16-segment Roblox character rig (extended from R15) that splits the torso and limbs into more granular parts, enabling:
- Better deformation for fitted clothing (no more "pillow case" shirts).
- More accurate Adventure Time character silhouettes (Finn's hat, Jake's jowls, Marceline's dress drape).
- Per-limb clothing pieces (sleeves, gloves, boots, greaves) that move with animations.
- Support for non-humanoid body shapes (Rainicorn's long body, Dog's stretchy limbs, Slime's blob form).

### 1.2 R16 body part list (16 segments)
1. Head
2. Hair (accessory layer)
3. Hat (accessory layer)
4. Face / Eyes (UV layer on head)
5. Torso (upper)
6. Torso (lower / waist)
7. Left Upper Arm
8. Left Lower Arm
9. Left Hand
10. Right Upper Arm
11. Right Lower Arm
12. Right Hand
13. Left Upper Leg
14. Left Lower Leg
15. Left Foot
16. Right Upper Leg + Right Lower Leg + Right Foot (mirrored)

> **Note:** R16 standardizes 16 named parts; legs/arms are mirrored pairs. Some races (Rainicorn, Dog, Slime) use custom rigs derived from R16 with the same slot count for clothing compatibility.

### 1.3 Rig variants per body archetype
To keep clothing production manageable, all 19 launch races map onto **5 body archetypes**. Each archetype shares a base rig + UV layout so clothing can be reused across races in the same archetype. **Hybrid approach (locked):** 5 archetype base rigs + race-specific signature pieces only (e.g., Dog's jowls, Rainicorn's neck rings, Slime's drip) — not full per-race rigs.

| Archetype | Rig | Races |
|-----------|-----|-------|
| **A — Humanoid** | Standard R16 | Human, Wizard-blooded Human, Vampire, Cosmic-touched, Ghost (manifested), Demon (humanoid form) |
| **B — Stubby** | R16 short torso, short limbs | Candy Person, Hot Dog Person, Goblin, Box Person, Wildberry, Mushroom Mutant |
| **C — Lanky** | R16 elongated limbs, thin torso | Ice Person, Lumpy Space Person, Tree Folk, Crystal Person |
| **D — Beast** | R16-derived, 4-leg optional, stretchy arms | Dog (Magical), Rainicorn |
| **E — Blob / Amorphous** | R16-derived, no leg split, fluid torso | Slime Person, Cloud Person, Ghost (true form) |

> Clothing is built **per archetype**, not per race. A "Finn-inspired hat" works on Archetype A; a "Candy crown" works on Archetype B. Race-specific signature pieces (horns, tails, manes, drips) are separate accessory meshes layered on top.

---

## 2. Clothing Slot Taxonomy (R16) — Core 8 (locked)

### 2.1 Core slots (every race has these 8)
| # | Slot | R16 parts covered | Notes |
|---|------|-------------------|-------|
| 1 | **Hat** | Head (accessory) | Finn-inspired hat, Ice crown, crowns, helmets |
| 2 | **Hair** | Head (accessory, layer 2) | Marceline drape, PB ponytail, Jake mane |
| 3 | **Top** | Torso upper + lower + shoulders + neck (merged) | Shirts, dresses, robes, armor chest, capes attached |
| 4 | **Back** | Torso upper (back) | Backpacks, wings, BMO pack, quivers, staffs |
| 5 | **Gloves** | Hands + lower arms (merged) | Gloves, claws, rings, sleeve cuffs |
| 6 | **Legs** | Upper + lower legs + belt (merged) | Pants, shorts, skirts, robe lower, sashes |
| 7 | **Boots** | Feet | Boots, sandals, paws |
| 8 | **Aura** | Full body (VFX layer) | Glows, fire, slime drip, cosmic shimmer |

### 2.2 Race-inherent body features (NOT clothing slots)
These are part of the race body mesh, not clothing. They can be toggled or have cosmetic variants, but they don't occupy a clothing slot:
- **Tail** (Dog, Demon, Rainicorn) — race body feature
- **Face / Eyes** — UV layer on head, customizable via face presets (not clothing)
- **Horns** (Demon) — race body feature, hat slot can still equip over/around them
- **Wings** (Vampire, Cosmic-touched) — back slot item, not inherent
- **Slime drip / Cloud tuft** — Aura slot item for those races

### 2.3 Optional archetype-specific FX (Aura slot variants)
| FX | Archetype | Notes |
|------|----------|-------|
| Stretchy arms shimmer | D (Dog) | Visual stretch FX |
| Slime drip | E (Slime) | Animated drip layer |
| Cloud tuft | E (Cloud) | Cloud Person body fluff |
| Ghost transparency | E (Ghost) | Sheet-style opacity |
| Vampire mist | A (Vampire) | Floating mist aura |
| Cosmic shimmer | A (Cosmic-touched) | Star-pattern glow |

### 2.4 Slot layering order (render priority)
1. Body skin (race base, includes tail/horns if applicable)
2. Legs
3. Boots
4. Top (includes shoulders/neck/belt merged)
5. Gloves (includes lower arms)
6. Back
7. Hair
8. Hat
9. Aura / FX (top layer)

### 2.5 Skin color customization (locked)
- **Customizable within race palette** — each race has 3-5 curated skin tones (e.g., Candy Person: pink, blue, green, yellow, purple; Vampire: pale white, grey, lavender; Demon: red, maroon, charcoal).
- Not full freedom (preserves race identity) but enough variety that two same-race players don't look identical.
- Unlocks via character creation + dyes (post-beta for skin dyes; beta uses creation-time pick only).

### 2.6 Aura stacking (locked)
- **Stack up to 2 auras** (e.g., vampire mist + cosmic shimmer).
- Each aura has a render priority; if both have VFX, they blend.
- More than 2 = visual noise; capped at 2 for performance + readability.

### 2.7 Transmog system (locked — in beta)
- **Yes, transmog in beta.** Players can transmog stat gear appearance to any owned cosmetic.
- Stat gear (earned in-game) has its own appearance; transmog lets you override it with a cosmetic you own without losing stats.
- Encourages collecting cosmetics without sacrificing build viability.

---

## 3. Per-Race Clothing Considerations

### 3.1 Archetype A — Humanoid
- **Human (Finn-kin)**: classic AT hero look. Signature: white bear hat, blue shirt, green backpack, blue shorts, black boots.
- **Wizard-blooded Human**: robe-leaning. Wizard hats, staves on back slot.
- **Vampire (Marceline-kin)**: pale skin base, floating animation. Signature: grey tank top, dark boots, bass-axe on back. Vampire wings optional.
- **Cosmic-touched**: shimmer aura, star-pattern clothing, Prismo color palette (pink/blue/yellow).
- **Ghost (manifested)**: translucent body base, tattered clothing layers, optional legs-off hover.
- **Demon (humanoid form)**: red/dark skin base, horns (hat slot), tail (tail slot), Nightosphere aesthetic.

### 3.2 Archetype B — Stubby
- **Candy Person**: rounded body, candy-color skin. Signature: candy-themed clothing (gumdrop buttons, peppermint stripes). PB lab coat is a top variant.
- **Hot Dog Person**: sausage body, bun-arms. Clothing is mostly condiment-themed (mustard stripes, ketchup scarf) + Hot Dog Princess dress variant.
- **Goblin**: hunched, green skin. Tattered rags, Xergiok-style armor, scrap-metal pauldrons.
- **Box Person**: cardboard body. Clothing = paper wraps, stamps, "FRAGILE" stickers as chest decals. Box flaps as hat slot.
- **Wildberry**: berry-shaped body. Leafy clothing, vine sashes, Wildberry Princess gown.
- **Mushroom Mutant**: cap head (built-in hat slot). Spore-themed clothing, tattered Mushroom War remnants.

### 3.3 Archetype C — Lanky
- **Ice Person (Penguin-kin)**: penguin body. Ice-themed clothing, Ice King robe variant, crown as hat.
- **Lumpy Space Person**: floating blob-limbed. LSP aesthetic = star patterns, glitter, "oh my glob" tees.
- **Tree Folk**: bark skin. Leafy clothing, Tree Trunks' apple dress, orchard aprons.
- **Crystal Person**: faceted body. Crystal-themed translucent clothing, Crystal Dimension royalty wear.

### 3.4 Archetype D — Beast
- **Dog (Magical, Jake-kin)**: quadruped-capable. Signature: Jake's yellow fur (skin), no clothing needed by default but supports hats, backpacks, capes. Stretchy arms overlay as FX slot.
- **Rainicorn**: long serpentine body. Korean-rainbow color base. Clothing = collar accessories, saddle bags, Lady Rainicorn-style neck rings.

### 3.5 Archetype E — Blob / Amorphous
- **Slime Person**: blob body, no leg split. Clothing = embedded accessories (glasses, hats floating on surface), Slime Princess crown.
- **Cloud Person**: floating cloud body. Clothing = weather accessories (lightning bolt necklace, sun hat), Cloud Princess tiara.
- **Ghost (true form)**: floating sheet-style. Clothing = sheet variants, ghostly chains, transparent overlays.

---

## 4. Clothing Asset Lists (per archetype, per slot — core 8)

> **Cosplay policy (locked):** All canon-character clothing is **inspired-by** — variants that evoke but don't duplicate canon characters. No exact 1:1 Finn/Marceline/PB outfits. This preserves character identity while letting players feel the part.

### 4.1 Archetype A — Humanoid clothing sets
**Hats:** Hero bear hat (white, black, gold, rainbow variants — inspired by Finn), Ice-inspired crown, Wizard hat (pointed, wide-brim, star-tipped), Hero helmet, Nightosphere horn-crown, Cosmic halo, Lich skull helm (Nightosphere Mode only).

**Hair:** Vampire drape (inspired by Marceline), Royal ponytail (inspired by PB), Wizard beard, Lumpy lumps, Hero mop, Flame hair, Ranger braid.

**Tops:** Hero blue shirt (inspired by Finn), Lab coat (inspired by PB), Vampire tank (inspired by Marceline), Ice robe (inspired by Ice King), Flame dress (inspired by Flame Princess), Wizard robe (color variants), Nightosphere tunic, Cosmic cloak, Hero tunic.

**Backs:** Hero green backpack (inspired by Finn), BMO-style pack, quiver, wizard staff back-sheath, cape (kingdom banners), wings (vampire, cosmic, demon), Lich bone wings (Nightosphere Mode).

**Gloves:** Hero bare arms, gauntlets, wizard sleeves, demon claws, vampire gloves, cosmic bracers.

**Legs:** Hero blue shorts (inspired by Finn), wizard robe lower, knight greaves, vampire pants, Nightosphere greaves.

**Boots:** Hero black boots (inspired by Finn), wizard boots, knight boots, vampire boots, demon hooves.

**Auras:** Hero glow, vampire mist, cosmic shimmer, demon smoke, Lich corruption (Nightosphere Mode).

### 4.2 Archetype B — Stubby clothing sets
**Hats:** Candy crown (inspired by PB), Hot Dog cap, Goblin hood, Box lid, Wildberry leaf-cap, Mushroom cap variants.

**Tops:** Lab coat stubby (inspired by PB), Bun wrapper, Hot Dog dress (inspired by Hot Dog Princess), Goblin rags, Box stamps, Wildberry gown (inspired by Wildberry Princess), Mushroom tunic.

**Backs:** Mini backpacks, candy quivers, banana-sticker decals.

**Gloves:** Stubby gauntlets, leaf gloves, bun-arms wraps.

**Legs:** Stubby pants, robe lower, vine wraps.

**Boots:** Stubby boots, bare stubby, sandal wraps.

**Auras:** Candy shimmer, hot dog steam, goblin stink, wildberry sparkle.

### 4.3 Archetype C — Lanky clothing sets
**Hats:** Ice crown (inspired by Ice King), Lumpy star, Tree bandana, Crystal tiara.

**Tops:** Ice robe lanky (inspired by Ice King), LSP tee ("OH MY GLOB"), Apple dress (inspired by Tree Trunks), Crystal royalty robe.

**Backs:** Ice staff, Lumpy float-ring, Apple basket.

**Gloves:** Ice gauntlets, crystal claws, leaf gloves.

**Legs:** Ice robe lower, lumpy float skirt, tree bark pants.

**Boots:** Ice boots, crystal heels, bare lanky.

**Auras:** Ice mist, lumpy glitter, leaf swirl, crystal shimmer.

### 4.4 Archetype D — Beast clothing sets
**Hats (Dog):** Hero cap (dog-sized, inspired by Jake), crown, banana hat.
**Hats (Rainicorn):** Neck rings, flower collar, ribbon.
**Hair (Dog):** Mane variants, jowl tufts.
**Tops (Dog):** Cape, vest. **Tops (Rainicorn):** Saddle blanket, neck wrap.
**Backs (Dog):** Mini backpack, cape. **Backs (Rainicorn):** Saddle bags, saddle.
**Gloves (Dog):** Paw wraps. **Gloves (Rainicorn):** (none — no hands).
**Legs (Dog):** Bare. **Legs (Rainicorn):** (none — serpentine).
**Boots (Dog):** Bare paws, booties. **Boots (Rainicorn):** (none).
**Auras (Dog):** Stretchy arms shimmer, jowl bounce. **Auras (Rainicorn):** Rainbow trail.

### 4.5 Archetype E — Blob / Amorphous clothing sets
**Hats (Slime):** Slime crown (inspired by Slime Princess), floating glasses, embedded accessories.
**Hats (Cloud):** Cloud tiara (inspired by Cloud Princess), sun hat, lightning bolt.
**Hats (Ghost):** Sheet variants, ghostly chains.
**Hair (Slime/Cloud/Ghost):** Drip tufts, cloud fluff, ghost wisps.
**Tops (Slime):** Embedded badges, slime apron. **Tops (Cloud):** Cloud shawl. **Tops (Ghost):** Sheet tunic.
**Backs (Ghost):** Chains, wisps.
**Gloves/Legs/Boots:** (none — blob bodies, no limbs or fused limbs).
**Auras:** Slime drip, cloud puff, ghost transparency.

---

## 5. Cosmetic Shop Structure

### 5.1 Rarity tiers (cosmetic only — no stats)
| Tier | Drop / Price weight | Examples |
|------|--------------------|---------|
| Common | Cheap, frequent | Basic tees, plain hats, simple boots |
| Uncommon | Mid | Kingdom citizen outfits, colored variants |
| Rare | Higher | Named-character-inspired outfits (Finn, Jake, PB) |
| Epic | Premium | Marceline, Ice King, Flame Princess sets |
| Legendary | Rare / season-exclusive | Cosmic, Lich-themed, Prismo sets |
| Mythic | Ultra-rare | Full character-accurate cosplay sets, animated auras |

### 5.2 Purchase models (locked)
- **Single item** — direct purchase, one piece (hat, top, etc.).
- **Outfit bundle** — full set at a discount vs. buying pieces.
- **Season pass track** — earnable via free track + premium track exclusives.
- **Mystery box** — **earnable in-game only** (quests, dungeons, events). Paid path is **direct purchase only** — no paid RNG boxes. Duplicates from mystery boxes convert to dye currency.
- **Dye system (tiered, locked)**:
  - **Common items**: full recolor freedom (any dye on any item).
  - **Uncommon/Rare**: curated palettes (wider selection, still flexible).
  - **Epic/Legendary/Mythic**: curated palettes only (3–5 colorways each) — preserves the visual identity of premium cosmetics.

### 5.3 Earnable vs. paid (locked)
- **All clothing is earnable in-game** through quests, minigames, dungeons, reputation, events, and mystery boxes.
- **Paid cosmetics** are direct-purchase shortcuts or exclusive seasonal variants — never stat-boosting, never gameplay-locked, never RNG-gated behind a paywall.
- **No exclusive-content clothing** — if a paid cosmetic exists, an earnable equivalent (visually different) exists too.

---

## 6. Production Notes (R16 clothing pipeline)

### 6.1 Modeling spec
- Build in Blender / Studio, export as `.fbx` or `.gltf` per Roblox clothing standard.
- Each clothing piece is a **separate mesh** rigged to the R16 armature.
- Poly budget per piece: 200–800 tris (hats/accessories), 500–2000 tris (tops/robes), 200–600 tris (boots/gloves).
- UVs: 1 UV map per piece, 256x256 or 512x512 texture (512 for robes/capes).

### 6.2 Texture spec
- Diffuse + opacity (for capes, hair fringes, slime drip).
- Normal map optional for high-tier cosmetics (crystal facets, demon scales).
- Emission map for auras / cosmic / Lich items.

### 6.3 R16 wrapping rules
- Clothing must deform cleanly on all 16 parts — no clipping at torso split, arm bends, leg splits.
- Test on the rig's idle, walk, run, jump, attack, sit animations.
- **Clothing shares standard animations (locked)** — no unique walk animations per clothing piece in beta (cheaper, faster). Post-beta may add unique anims for legendary+ robes/capes.
- Capes / robes use a secondary bone chain or cloth sim-lite (Roblox doesn't ship cloth sim — use segmented mesh bones).
- **Hat + hair combos (locked)**: equipping a hat auto-swaps to a compatible hair preset (prevents clipping). Manual override available for players who want to manage combos themselves.

### 6.4 Archetype reuse
- Build clothing on the archetype base rig first.
- Validate fit on all races in that archetype.
- Race-specific variants (e.g., Dog's hat vs. Humanoid's hat) get a separate mesh but share the slot + texture where possible.

### 6.5 Naming convention
`CLOTH_[Archetype]_[Slot]_[Name]_[Rarity]_[Variant]`
Example: `CLOTH_A_HAT_FinnBearHat_R_white_v01`

### 6.6 Production order (recommended)
1. Archetype A core slots (hat, top, legs, boots, back) — covers Humanoid races first.
2. Archetype B core slots — covers Candy Kingdom starter races (most-seen early).
3. Archetype C, D, E core slots.
4. Rare / Epic / Legendary sets per archetype.
5. Dyes, auras, FX layers.
6. Seasonal / event cosmetics.

---

## 7. Open Questions for You

**Locked from v0.3 input:**
- ✅ Skin color: customizable within race palette (3-5 skin tones per race).
- ✅ Clothing animations: share standard animations (cheaper, faster). Unique anims post-beta for legendary+.
- ✅ Hat + hair: auto-swap to compatible hair preset when hat equipped, manual override available.
- ✅ Aura stacking: stack up to 2 auras.
- ✅ Transmog: yes, in beta — stat gear appearance can be transmogged to any owned cosmetic.

**Locked from v0.2 input:**
- ✅ R16 rig source: hybrid — community base + custom tweaks per archetype.
- ✅ Archetype mapping: hybrid — 5 archetype base rigs + race-specific signature pieces only.
- ✅ Clothing slots: core 8 (hat, hair, top, back, gloves, legs, boots, aura). Tail/face/horns are race body features, not slots.
- ✅ Cosplay policy: inspired-by only — no exact 1:1 canon character outfits.
- ✅ Mystery box: earnable in-game only; paid path is direct purchase only (no paid RNG).
- ✅ Dye system: tiered — common = full freedom, legendary = curated palettes only.

**Clothing doc is now fully locked.** Remaining tuning happens in production.

---
