# GAL Dialogue and Level Recovery Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Deliver a Chinese-only playable path from B-sector investigation to Gate 09, with pause-and-advance bottom GAL dialogue.

**Architecture:** Keep the existing single-file Canvas prototype and Markdown dialogue source. Replace the single-speaker notification path with a guarded dialogue queue that renders the selected pilot on the left and the active speaker on the right. Make B-sector close through one timer-guarded transition chain, then render Gate 09 choice actions beneath the final dialogue rather than through the old communications-theatre overlay.

**Tech Stack:** HTML, CSS, browser JavaScript, Markdown/YAML-like dialogue data, PowerShell, Node.js browser checks.

---

### Task 1: Establish recovery contracts

**Files:**
- Modify: `tools/run_checks.ps1`
- Test: `tools/run_checks.ps1`

- [ ] **Step 1: Add failing source-contract assertions**

Add the following Node check after the existing narrative contract. It must fail against the legacy source if an old B-sector choice/Boss state, English visible labels, or the old story overlay remains:

```powershell
Invoke-Native { node -e "const fs=require('fs'); const s=fs.readFileSync('prototype/fb.html','utf8'); const banned=['CH02_CHOICE','startChapterTwoBoss','showChapterTwoChoice','story-choice-screen','MEDICAL SUPPLY','EVAC CONVOY','TEMP FILTER']; const found=banned.filter(token=>s.includes(token)); if(found.length) throw new Error('Obsolete visible flow remains: '+found.join(', ')); const required=['finishChapterTwoInvestigation','startInterlude','startChapterFive','enqueueDialogue','advanceDialogue']; const missing=required.filter(token=>!s.includes(token)); if(missing.length) throw new Error('Missing recovery APIs: '+missing.join(', ')); console.log('recovery source contract ok');" }
```

- [ ] **Step 2: Run the check before implementation**

Run: `powershell -NoProfile -ExecutionPolicy Bypass -File tools\run_checks.ps1`

Expected: FAIL with `Obsolete visible flow remains` or `Missing recovery APIs`.

- [ ] **Step 3: Commit the failing contract**

```powershell
git add tools/run_checks.ps1
git commit -m "test: define narrative recovery contract"
```

### Task 2: Replace runtime dialogue data with Chinese scene records

**Files:**
- Modify: `docs/dialogue-story.md`
- Modify: `tools/run_checks.ps1`
- Test: `tools/run_checks.ps1`

- [ ] **Step 1: Add failing dialogue-shape assertions**

Extend the parser test to require each entry to have a quoted Chinese `speaker`, a quoted Chinese `default`, and a `portrait` key. Require the IDs `ch02.outro.alice`, `ch02.outro.bob`, `ch02.outro.charlie`, `interlude.rust`, `interlude.location`, `ch05.intro`, `ch05.mara`, `ch05.choice.seal_gate`, `ch05.choice.break_blockade`, `ch05.choice.deep_rock`, and every `ending.*` record.

```javascript
if (!parsed.portrait) throw new Error('Missing portrait key: ' + id);
if (/[A-Za-z]{3,}/.test(parsed.speaker) || /[A-Za-z]{3,}/.test(parsed.default)) {
  throw new Error('Visible English text in dialogue: ' + id);
}
```

- [ ] **Step 2: Run the check before data changes**

Run: `powershell -NoProfile -ExecutionPolicy Bypass -File tools\run_checks.ps1`

Expected: FAIL because current entries do not have `portrait` keys.

- [ ] **Step 3: Normalize the dialogue source**

Rewrite the one YAML fence so each scene record follows this exact shape:

```yaml
  - id: ch05.mara
    speaker: "玛拉"
    portrait: "mara"
    default: "姐姐，下面没有灯。妈妈说别跑，可是地板一直在动。"
    pilots:
      alice: "玛拉，听着我的声音，贴着墙走。我们正在给你打开一条路。"
      bob: "震动频率还在上升。玛拉，离开有裂纹的地面，站到黄色标线内。"
      charlie: "别一个人跑。抓住你身边大人的手，数到十，我们就会到。"
```

Use Chinese portrait keys `alice`, `bob`, `charlie`, `command`, `rebel`, `quartermaster`, `scanner`, `mara`, `system`, and map missing art to emoji in runtime code.

- [ ] **Step 4: Run data validation**

Run: `powershell -NoProfile -ExecutionPolicy Bypass -File tools\run_checks.ps1`

Expected: `dialogue source ok` and `dialogue runtime parser compatibility ok`.

- [ ] **Step 5: Commit dialogue data**

```powershell
git add docs/dialogue-story.md tools/run_checks.ps1
git commit -m "feat: normalize Chinese narrative dialogue"
```

### Task 3: Build the bottom two-sided GAL dialogue queue

**Files:**
- Modify: `prototype/fb.html`
- Test: `tools/run_checks.ps1`

- [ ] **Step 1: Add queue markup and CSS**

Replace the old single `#dialogue-box` contents with left pilot portrait/name, central text, right speaker portrait/name, and an advance affordance. Use the selected `PILOTS[pKey]` on the left and the dialogue record portrait on the right. The key selectors are `#dialogue-box`, `#dialogue-pilot`, `#dialogue-speaker`, `#dialogue-advance`, and `.dialogue-avatar`.

```html
<div id="dialogue-box" class="hidden" role="dialog" aria-live="polite">
  <section class="dialogue-party dialogue-party-left"><div id="dialogue-pilot-avatar" class="dialogue-avatar"></div><strong id="dialogue-pilot"></strong></section>
  <section class="dialogue-copy"><div id="dialogue-speaker"></div><div id="dialogue-text"></div><div id="dialogue-advance">点击或按空格继续</div></section>
  <section class="dialogue-party dialogue-party-right"><div id="dialogue-speaker-avatar" class="dialogue-avatar"></div><strong id="dialogue-speaker-name"></strong></section>
</div>
```

- [ ] **Step 2: Replace `showDialogue` with a queue**

Implement `enqueueDialogue(entry, { blocking = true, onDone = null } = {})`, `renderDialogue()`, `advanceDialogue()`, and `clearDialogueQueue()`. Blocking entries set `state` aside as `DIALOGUE` and restore the saved playable state only after the queue drains. Keyboard and click handlers call `advanceDialogue()` exactly once per input.

```javascript
function showDialogueId(id, options) {
  const dialogue = resolveDialogue(id);
  enqueueDialogue(dialogue, options);
}
```

Map missing portrait keys to `{ label: '系统终端', emoji: '📡' }`; use `🛠️`, `⚠️`, and `📟` for quartermaster, warning, and scanner records.

- [ ] **Step 3: Route short combat barks away from the queue**

Keep `showToast()` for `maybeCombatBark`, skill readiness, and scan progress. Only ID-driven plot scenes call `showDialogueId` with blocking behavior.

- [ ] **Step 4: Run the contract**

Run: `powershell -NoProfile -ExecutionPolicy Bypass -File tools\run_checks.ps1`

Expected: `recovery source contract ok` and all existing checks pass.

- [ ] **Step 5: Commit UI queue**

```powershell
git add prototype/fb.html tools/run_checks.ps1
git commit -m "feat: add bottom GAL dialogue queue"
```

### Task 4: Remove B-sector branches and make Gate 09 a single continuation

**Files:**
- Modify: `prototype/fb.html`
- Modify: `tools/run_checks.ps1`
- Test: `tools/run_checks.ps1`

- [ ] **Step 1: Remove obsolete B-sector paths**

Delete `CH02_CHOICE`, `chooseBranch`, B-sector Boss classes/calls, branch-card markup, and all second-chapter branch result methods. `finishChapterTwoInvestigation()` must be the only successful B-sector exit.

- [ ] **Step 2: Make the closure queue-driven**

After scan three, wave four, no enemies, and no enemy projectiles, call `finishChapterTwoInvestigation()`. Queue B-sector outro, then enqueue `interlude.rust`, `interlude.location`, `ch05.intro`, and finally call `startChapterFive()` in the queue completion callback. Keep `narrativeRun` checks around every delayed transition.

```javascript
enqueueDialogue(resolveDialogue('interlude.location'), {
  onDone: () => startChapterFive(run)
});
```

- [ ] **Step 3: Replace Gate 09 communications theatre**

Remove `renderStoryChoice` and `#story-choice-screen`. After `ch05.mara` drains, render an accessible `#gate-choice-actions` directly beneath the bottom dialogue box. Its three Chinese buttons call `chooseGateRoute`; its labels and costs are Chinese.

- [ ] **Step 4: Localize HUD and route targets**

Replace visible labels such as `WAVE`, `SHELTER`, `TARGETS`, `PHASE`, `REDEPLOY`, `MISSION_FAILED`, and all route target labels with Chinese equivalents. Keep only CSS classes and JavaScript identifiers in English.

- [ ] **Step 5: Run full automated validation**

Run: `powershell -NoProfile -ExecutionPolicy Bypass -File tools\run_checks.ps1`

Expected: all four check groups pass.

- [ ] **Step 6: Commit narrative flow**

```powershell
git add prototype/fb.html tools/run_checks.ps1
git commit -m "feat: route B sector to Gate 09"
```

### Task 5: Browser acceptance and main-branch handoff

**Files:**
- Modify: `docs/worklog.md`
- Test: `prototype/fb.html` at an isolated local HTTP port

- [ ] **Step 1: Serve the feature worktree**

Run: `python -m http.server 4173 --directory D:\codexprojects\flyingbird\.worktrees\narrative-vertical-slice`

Expected: `http://127.0.0.1:4173/prototype/fb.html` returns HTTP 200.

- [ ] **Step 2: Verify dialogue presentation**

Use the browser to select each pilot, deploy, and advance the first blocking scene. Confirm the bottom box has both party columns, the left label matches the selected pilot, the right portrait is real art or an emoji, and no visible English label appears.

- [ ] **Step 3: Verify the recovery path**

Drive or inspect the B-sector completion path. Confirm no B-sector choice/Boss screen appears; the blackbox and two interlude dialogue scenes occur; Gate 09 begins; complete one Gate 09 route and verify its result dialogue and restart action.

- [ ] **Step 4: Record only observed browser results**

Append a dated `docs/worklog.md` entry containing the actual pilots/routes tested, console errors if any, and unresolved paths.

- [ ] **Step 5: Final validation and commit**

Run: `powershell -NoProfile -ExecutionPolicy Bypass -File tools\run_checks.ps1`

Run: `git diff --check`

Expected: all checks pass and no whitespace errors.

```powershell
git add docs/worklog.md
git commit -m "docs: record narrative recovery verification"
git push origin codex/narrative-vertical-slice
```
