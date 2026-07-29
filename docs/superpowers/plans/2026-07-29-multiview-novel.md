# Multiview Novel Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Write a 20,000-plus Chinese-character original novel for *Spark Spreads* that provides the game narrative foundation.

**Architecture:** One canonical Markdown manuscript, ordered by the game's chapter sequence. Third-person limited narration rotates among Alice, Bob, and Charlie; the manuscript ends with mirrored Empire and Rebel routes and a Deep Rock collective hook.

**Tech Stack:** Markdown, PowerShell text inspection.

---

### Task 1: Establish the manuscript frame and character contracts

**Files:**
- Create: `docs/星火燎原-多视角剧情小说.md`
- Reference: `docs/superpowers/specs/2026-07-29-multiview-novel-design.md`

- [ ] **Step 1: Write title, premise, and character introductions**

Include Alice's ardent but reckless compassion, Bob's human-machine autonomy conflict, and Charlie's loss of his former squad.

- [ ] **Step 2: Write the shared-rescue prologue**

Show the three pilots saving one another in the Zelios escort battle through action and dialogue, establishing an emotional debt before their political split.

- [ ] **Step 3: Inspect the character contract**

Run: `rg -n "炽热|鲁莽|协处理器|小队|撤离" "docs/星火燎原-多视角剧情小说.md"`

Expected: each required trait appears in the manuscript as narrative material, not a bare checklist.

### Task 2: Write the common chapter arc and disclose the first lies

**Files:**
- Modify: `docs/星火燎原-多视角剧情小说.md`
- Reference: `docs/背景故事与台词文档.md`

- [ ] **Step 1: Write Chapters 1 and 2**

Cover the stitched carrier's protective flight path, the disguised refugee convoy, and the evidence that the quarantine well erases people rather than merely treats disease.

- [ ] **Step 2: Give every pivotal choice a live dialogue exchange**

Each exchange must include a person at immediate risk, a wider system risk, and a private cost between the pilots.

- [ ] **Step 3: Inspect chapter anchors**

Run: `rg -n "镇压与谎言|检疫井|缝合航母|转运舰队" "docs/星火燎原-多视角剧情小说.md"`

Expected: all four anchors occur in ordered chapters.

### Task 3: Write the split, rust epidemic, and Gate 09 confrontation

**Files:**
- Modify: `docs/星火燎原-多视角剧情小说.md`

- [ ] **Step 1: Write Chapters 3 through 5 with rotating viewpoints**

Make the former teammates diverge while each retains a defensible fear: Alice of abandonment, Bob of unbounded collapse and machine control, Charlie of repeating an irreversible loss.

- [ ] **Step 2: Make the disease morally complex**

Use records and field evidence to connect the rust epidemic to long-term human expansion, deep-space materials, and brain-machine infrastructure without exonerating the Empire's fabricated infection lists.

- [ ] **Step 3: Write the Gate 09 decision scene**

Stage the permanent lockdown, rebel breach, and shelter collapse at once. Alice must choose a route in dialogue with Bob and Charlie; neither can be reduced to a villain.

- [ ] **Step 4: Inspect the confrontation**

Run: `rg -n "第 09|永久锁定|隔离墙|塌方|锈蚀" "docs/星火燎原-多视角剧情小说.md"`

Expected: the decision's three simultaneous pressures and disease evidence are present.

### Task 4: Write the mirrored endings and third-path foundation

**Files:**
- Modify: `docs/星火燎原-多视角剧情小说.md`

- [ ] **Step 1: Write the Rebel-route ending**

The protagonist confronts the teammate who chose the Empire. The Empire's security argument must be concrete, and the result must preserve the costs of uncontrolled movement.

- [ ] **Step 2: Write the Empire-route ending**

The protagonist confronts the teammate who chose the rebels. The rebel argument must be concrete, and the result must preserve the costs of purification and silence.

- [ ] **Step 3: Write Deep Rock as a consequence, not a perfect answer**

Show workers, doctors, and engineers attempting local isolation, attenuation, repair, and mutual aid while facing scarcity and contamination.

- [ ] **Step 4: Inspect the ending symmetry**

Run: `rg -n "叛军线|帝国线|深岩联合体|黑匣协议|净化名单" "docs/星火燎原-多视角剧情小说.md"`

Expected: both routes, the third-path foundation, and the Empire evidence occur.

### Task 5: Validate manuscript completeness

**Files:**
- Modify: `docs/星火燎原-多视角剧情小说.md`

- [ ] **Step 1: Confirm the manuscript length**

Run: `(Get-Content -Raw -Encoding UTF8 "docs/星火燎原-多视角剧情小说.md").Length`

Expected: at least `20000` characters.

- [ ] **Step 2: Scan for placeholders and structural omissions**

Run: `rg -n "TBD|TODO|待补|待定" "docs/星火燎原-多视角剧情小说.md"`

Expected: no matches.

- [ ] **Step 3: Confirm all primary chapters exist**

Run: `rg -n "^## (序章|第一章|第二章|第三章|第四章|第五章|第六章|第七章|第八章|第九章)" "docs/星火燎原-多视角剧情小说.md"`

Expected: ten ordered headings, including the prologue.
