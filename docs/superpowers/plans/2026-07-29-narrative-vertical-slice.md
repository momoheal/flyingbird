# Narrative Vertical Slice Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the prototype deliver the novel-aligned vertical slice: prologue, A/B-sector investigation, Gate 09 three-way choice, and three short route finales with concrete Chinese dialogue.

**Architecture:** The novel is the fact source, `docs/剧情设计文档.md` is the runtime mapping, and `docs/dialogue-story.md` is the only dialogue source. Extend the current Canvas state machine. B sector ends with evidence; only Gate 09 sets `route`. The approved UI is communications theatre: a concrete call first, action-and-cost buttons second.

**Tech Stack:** HTML5 Canvas, vanilla JavaScript, Markdown YAML-like data, Node checks, PowerShell.

---

## Audit Baseline

- `showChapterTwoChoice` writes `protection` or `execute` in B sector, contradicting the approved Gate 09 decision.
- Dialogue data has no prologue, interlude, Gate 09, or ending IDs; B-sector cards name factions and permissions instead of people and costs.
- `prototype/fb.html` lacks `INTERLUDE`, `CH05_PLAY`, `CH05_CHOICE`, `ENDING_PLAY`, and `ENDING_RESULT` states.
- Upgrade cards cannot express Mara's call, simultaneous danger, or immediate cost.

## Files

| File | Responsibility |
| --- | --- |
| `docs/dialogue-story.md` | All runtime dialogue. |
| `prototype/fb.html` | State machine, story overlay, encounters, finales. |
| `tools/run_checks.ps1` | Syntax, dialogue-ID, state-contract validation. |
| `docs/worklog.md` | Changes and verified route results. |

### Task 1: Dialogue Contract

**Files:** Modify `tools/run_checks.ps1`, `docs/dialogue-story.md`.

- [ ] Add the following IDs to the existing `required` array: `prologue.01`, `prologue.02`, `prologue.03`, `ch02.outro.alice`, `ch02.outro.bob`, `ch02.outro.charlie`, `interlude.rust`, `interlude.location`, `ch05.intro`, `ch05.mara`, `ch05.choice.seal_gate`, `ch05.choice.break_blockade`, `ch05.choice.deep_rock`, `ending.empire.intro`, `ending.empire.result`, `ending.rebel.intro`, `ending.rebel.result`, `ending.deep_rock.intro`, `ending.deep_rock.result`.
- [ ] Run `powershell -NoProfile -ExecutionPolicy Bypass -File tools\run_checks.ps1`; expect all those IDs to be reported missing.
- [ ] Add every required record to the existing YAML fence using `speaker`, `default`, and optional `pilots`. The following two records are mandatory:

    ```yaml
      - id: ch05.mara
        speaker: 避难所频道
        default: "姐姐，下面没有灯。妈妈说别跑，可是地板一直在动。"
      - id: ch05.choice.deep_rock
        speaker: Bob
        default: "打穿塌方区外壁。我能把通风系统改成单向过滤，但我们会错过封锁线的最后窗口。"
    ```

- [ ] Write Alice, Bob, and Charlie variants where they speak. Every line must name an observed object, person, action, or consequence. Do not use a slogan as a complete line.
- [ ] Re-run `tools/run_checks.ps1`; expect `dialogue source ok` and `chapter 01 opening dialogue ok`.
- [ ] Commit using `git add docs/dialogue-story.md tools/run_checks.ps1` and `git commit -m "test: define narrative slice dialogue contract"`.

### Task 2: B-Sector Investigation Closure

**Files:** Modify `prototype/fb.html`, `tools/run_checks.ps1`, `docs/worklog.md`.

- [ ] Add a state contract after the syntax check. It must fail when any of `INTERLUDE`, `CH05_PLAY`, `CH05_CHOICE`, `ENDING_PLAY`, `ENDING_RESULT` is absent from `prototype/fb.html`.
- [ ] Run checks; expect `Missing narrative states` with all five names.
- [ ] Replace persistent `branch` with persistent `route`, initialized to `null`. Remove `showChapterTwoChoice`, `chooseBranch`, `startChapterTwoBoss`, `showChapterTwoOutro`, `PurifierBoss`, and `RunnerBoss`. Preserve B-sector convoy, scans, player, projectiles, retry, and asset paths.
- [ ] Add this closure and call it only after all scans, all four waves, and enemy cleanup:

    ```javascript
    function finishChapterTwoInvestigation() {
        if (state !== 'CH02_PLAY') return;
        state = 'INTERLUDE';
        showDialogueId('ch02.outro.' + pKey);
        showTransition('BLACKBOX_RECOVERED', '货单、生命读数和注销名单已写入离线黑匣。第 09 隔离关口发来塌方警报。', 2800, startInterlude);
    }
    function startInterlude() {
        state = 'INTERLUDE';
        showDialogueId('interlude.rust');
        setTimeout(() => showDialogueId('interlude.location'), 1700);
        setTimeout(startChapterFive, 3600);
    }
    ```

- [ ] Mention the real rust risk, Bob's unauthorized location packet, and Gate 09 collapse alarm. Do not choose a route in the interlude.
- [ ] Run checks and one B-sector playthrough; expect three evidence messages, blackbox transition, no faction card, then Gate 09.
- [ ] Commit using `git add prototype/fb.html tools/run_checks.ps1 docs/worklog.md` and `git commit -m "feat: move route choice from B sector to Gate 09"`.

### Task 3: Gate 09 Communications Theatre

**Files:** Modify `prototype/fb.html`, `docs/worklog.md`.

- [ ] Add `CHAPTER_FIVE` with title `第五章：第 09 隔离关口`, subtitle `避难所外环 // 塌方、封门与爆破船`, `targetWaves: 3`, `waveIntervalFrames: 180`, `shelterHp: 210`; add `let gate09 = null`.
- [ ] Implement `startChapterFive`, `spawnGateWave`, `updateGate09Hud`. Reuse current Enemy, Projectile, Player, and particle primitives. Three mixed drone/rust waves damage a shelter marker and its integrity bar. Player or shelter failure offers Gate 09 retry and preserves pilot only.
- [ ] Add `#story-choice-screen` outside `#rogue-screen`, with channel, quote, situation, and three buttons. At 320px width, controls stack without clipping; buttons are keyboard accessible and use text plus shape/icon rather than colour alone.
- [ ] Implement this choice:

    ```javascript
    function showGateChoice() {
        if (state !== 'CH05_PLAY' || gate09.choiceShown) return;
        gate09.choiceShown = true;
        state = 'CH05_CHOICE';
        showDialogueId('ch05.mara');
        renderStoryChoice({
            channel: 'OPEN CHANNEL // SHELTER 09',
            quote: '"姐姐，下面没有灯。妈妈说别跑，可是地板一直在动。"',
            situation: '永久封门、余烬爆破船与塌方区同时进入倒计时。',
            choices: [
                { id: 'seal_gate', label: '守住医疗门', cost: '阻止爆破船，但门内部分人将被永久隔离。' },
                { id: 'break_blockade', label: '打开封锁', cost: '为船队撕开窗口，但锈蚀可能进入主航道。' },
                { id: 'deep_rock', label: '去塌方区', cost: '建立临时过滤舱，但无法阻止全部封门或冲关。' }
            ]
        });
    }
    ```

- [ ] Implement `chooseGateRoute(routeId)`, which writes `route`, closes the overlay, plays `ch05.choice.${routeId}`, then calls `startEnding(routeId)`.
- [ ] Give each route an exclusive objective: `seal_gate`: destroy explosive-ship weapon nodes while medical supply survives; `break_blockade`: remove three tractor locks while convoy survives; `deep_rock`: protect temporary filter, recover filter cores, upload blackbox.
- [ ] Show matching `ending.empire.*`, `ending.rebel.*`, or `ending.deep_rock.*` result cards. `resetRun()` clears route, `gate09`, targets, timers, and overlay HTML.
- [ ] Run checks; expect syntax, dialogue, Chapter 01, narrative-state, and asset checks all pass. Commit with `git add prototype/fb.html docs/worklog.md` and `git commit -m "feat: add Gate 09 narrative routes"`.

### Task 4: Narrative QA

**Files:** Modify `docs/worklog.md`; test `prototype/fb.html` via `tools/serve_prototype.ps1`.

- [ ] Review every added line: it must reveal a fact, change a relationship, or require action. Rewrite disconnected fragments and moral labels.
- [ ] Play `seal_gate`, `break_blockade`, `deep_rock`. In each route confirm Mara precedes choice, cost appears before action, objective differs, result matches action, restart clears state.
- [ ] Run `tools/run_checks.ps1`; record only actually verified routes and remaining limitations in `docs/worklog.md`; commit using `git add docs/worklog.md` and `git commit -m "docs: record narrative slice validation"`.

## Plan Self-Review

- Task 1 solves dialogue availability and grounded language.
- Task 2 removes the B-sector narrative contradiction.
- Task 3 implements the selected UI, Gate 09, unique finales, and cleanup.
- Task 4 audits dialogue quality and all route outcomes. The only final route keys are `seal_gate`, `break_blockade`, and `deep_rock`.
