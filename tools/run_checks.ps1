param([switch]$RegenerateAssets)

$ErrorActionPreference = "Stop"
$OutputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

function Invoke-Native {
    param([scriptblock]$Command)
    & $Command
    if ($LASTEXITCODE -ne 0) { throw "Native command failed with exit code $LASTEXITCODE" }
}

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $Root

Write-Host "== Flyingbird checks =="
Write-Host "Workspace: $Root"

Write-Host "`n[1/4] Checking prototype/fb.html syntax and narrative recovery contract..."
Invoke-Native { node -e "const fs=require('fs'); const html=fs.readFileSync('prototype/fb.html','utf8'); const match=html.match(/<script>([\s\S]*)<\/script>/); if(!match) throw new Error('No <script> block found in prototype/fb.html'); new Function(match[1]); console.log('prototype/fb.html script syntax ok');" }
Invoke-Native { node -e "const fs=require('fs'); const source=fs.readFileSync('prototype/fb.html','utf8'); const states=['INTERLUDE','CH05_PLAY','CH05_CHOICE','ENDING_PLAY','ENDING_RESULT']; const missing=states.filter(state=>!source.includes(state)); if(missing.length) throw new Error('Missing narrative states: '+missing.join(', ')); const body=name=>{const start=source.indexOf('function '+name+'('); if(start<0) throw new Error('Missing function: '+name); const open=source.indexOf('{',start); let depth=0; for(let i=open;i<source.length;i++){if(source[i]==='{')depth++; if(source[i]==='}'&&!--depth)return source.slice(open+1,i);} throw new Error('Unclosed function: '+name);}; const requireMatch=(value,pattern,message)=>{if(!pattern.test(value)) throw new Error(message);}; const finish=body('finishChapterTwoInvestigation'), interlude=body('startInterlude'), reset=body('resetRun'), gateRetry=body('resetGate09Build'); requireMatch(source,/let[^;]*\broute\s*=\s*null/, 'Missing route initialization'); requireMatch(reset,/route\s*=\s*null/, 'Missing route reset'); requireMatch(gateRetry,/route\s*=\s*null/, 'Gate 09 retry does not clear route'); ['mods =','cargo = []','equippedRogue = {}','salvage = 0','dropsGiven = 0'].forEach(value=>{if(!gateRetry.includes(value)) throw new Error('Gate 09 retry build reset missing: '+value);}); requireMatch(source,/window\.restartGate09=function\(\)\{[\s\S]*?player\.exp=0;player\.lvl=1;player\.maxExp=5;player\.abilityCharge=0;player\.abilityActive=false/, 'Gate 09 retry does not reset player progression'); requireMatch(finish,/showTransition\('/, 'Blackbox closure transition missing'); requireMatch(finish,/narrativeTimers/, 'Blackbox transition is not tracked'); requireMatch(interlude,/scheduleNarrative\([\s\S]*?startChapterFive/, 'Interlude does not schedule Gate 09'); requireMatch(source,/chapterTwoWaves === CHAPTER_TWO.targetWaves[\s\S]*?finishChapterTwoInvestigation\(\)/, 'B-sector completion does not finish investigation'); requireMatch(reset,/narrativeRun\+\+[\s\S]*?narrativeTimers\.forEach\(timer => clearTimeout\(timer\)\)[\s\S]*?narrativeTimers\.clear\(\)/, 'Reset does not cancel narrative timers'); console.log('narrative structural and reset-timer guards ok');" }
$NarrativeRecoveryContract = @'
const fs = require('fs');
const source = fs.readFileSync('prototype/fb.html', 'utf8');
const body = name => {
    const start = source.indexOf('function ' + name + '(');
    if (start < 0) throw new Error('Missing function: ' + name);
    const open = source.indexOf('{', start);
    let depth = 0;
    for (let index = open; index < source.length; index++) {
        if (source[index] === '{') depth++;
        if (source[index] === '}' && !--depth) return source.slice(open + 1, index);
    }
    throw new Error('Unclosed function: ' + name);
};
const requireMatch = (value, pattern, message) => {
    if (!pattern.test(value)) throw new Error(message);
};
const requireFunction = name => {
    if (!new RegExp('function\\s+' + name + '\\s*\\(').test(source)) {
        throw new Error('Missing required dialogue queue API: ' + name);
    }
};

requireFunction('enqueueDialogue');
requireFunction('advanceDialogue');

const finish = body('finishChapterTwoInvestigation');
const interlude = body('startInterlude');
const reset = body('resetRun');
const parse = body('parseDialogueMarkdown');
const resolve = body('resolveDialogue');
const enqueue = body('enqueueDialogue');
const advance = body('advanceDialogue');
requireMatch(parse, /portrait/, 'Dialogue parser does not read portrait');
requireMatch(resolve, /portrait:\s*entry\.portrait/, 'resolveDialogue does not return portrait');
requireMatch(enqueue, /dlgQueue\.push[\s\S]*?state\s*=\s*'DIALOGUE'/, 'Dialogue enqueue does not pause game state');
requireMatch(advance, /dlgQueue\.shift[\s\S]*?state\s*=\s*dialogueReturnState/, 'Dialogue advance does not restore prior state');
requireMatch(source, /id=["']dialogue-pilot-avatar["'][\s\S]*?id=["']dialogue-avatar["']/, 'Two-sided dialogue portraits are missing');
requireMatch(source, /dialogue-box.*addEventListener\('click', advanceDialogue\)/, 'Dialogue click advance is missing');
requireMatch(source, /state === 'DIALOGUE'.*e\.code === 'Space'.*e\.code === 'Enter'/, 'Dialogue keyboard advance is missing');
if (/\bshowDialogue\s*\(/.test(source)) throw new Error('Blocking dialogue calls remain outside the queue');
requireMatch(finish, /showTransition\('/, 'Blackbox closure transition missing');
requireMatch(finish, /narrativeTimers/, 'Blackbox transition is not tracked');
requireMatch(interlude, /scheduleNarrative\([\s\S]*?startChapterFive/, 'Interlude does not schedule Gate 09');
requireMatch(source, /chapterTwoWaves === CHAPTER_TWO.targetWaves[\s\S]*?finishChapterTwoInvestigation\(\)/, 'B-sector completion does not finish investigation');
requireMatch(reset, /narrativeRun\+\+[\s\S]*?narrativeTimers\.forEach\(timer => clearTimeout\(timer\)\)[\s\S]*?narrativeTimers\.clear\(\)/, 'Reset does not cancel narrative timers');
requireMatch(reset, /dlgQueue\s*=\s*\[\][\s\S]*?dialogueReturnState\s*=\s*null/, 'Reset does not clear dialogue queue');
if (/renderStoryChoice|story-choice-screen/.test(source)) throw new Error('Legacy story-choice screen remains');
if (/CH02_CHOICE|chooseChapterTwo|chapterTwoBoss|startChapterTwoBoss/.test(source)) throw new Error('Legacy B-sector choice or boss flow remains');
requireMatch(source, /id=["']gate-choice-actions["']/, 'Gate 09 action container is missing');
const gateChoice = body('showGateChoice');
requireMatch(gateChoice, /showDialogueId\('ch05\.mara'\)/, 'Gate choice does not present Mara dialogue');
requireMatch(gateChoice, /onDialogueQueueDrained/, 'Gate actions are not deferred until dialogue drains');
const choose = body('chooseGateRoute');
requireMatch(choose, /gate-choice-actions/, 'Gate choice does not use the bottom dialogue action container');
if (/BLACKBOX_RECOVERED|GATE_09|DEPLOY_TO_SECTOR_A|CHAPTER_CLEAR/.test(source)) throw new Error('Player-visible English transition title remains');
if (/GATE 09 collapse alert|SHELTER 09 integrity|TARGETS |MEDICAL SUPPLY|EVAC CONVOY|TEMP FILTER|Route objective complete|REDEPLOY|RETRY GATE 09/.test(source)) throw new Error('Player-visible English Gate 09 text remains');
console.log('narrative recovery contract ok');
'@

Write-Host "`n[2/4] Validating dialogue source..."
Invoke-Native { node -e "const fs=require('fs'); const source=fs.readFileSync('docs/dialogue-story.md','utf8'); const marker=String.fromCharCode(96).repeat(3); const fences=[...source.matchAll(new RegExp('^'+marker+'yaml\\s*\\r?\\n([\\s\\S]*?)^'+marker+'\\s*$','gm'))]; if(fences.length!==1) throw new Error('Expected exactly one yaml fence in docs/dialogue-story.md'); const entries=fences[0][1].split(String.fromCharCode(10)).map(line=>line.trim()).filter(line=>line.startsWith('- id: ')).map(line=>line.slice(6)); if(!entries.length) throw new Error('No dialogue id entries found in yaml fence'); const duplicates=entries.filter((id,index)=>entries.indexOf(id)!==index); if(duplicates.length) throw new Error('Duplicate dialogue IDs: '+[...new Set(duplicates)].join(', ')); const required=['ch01.deploy','ch01.boss_intro','ch01.debrief','ch02.quartermaster.armor','ch02.quartermaster.manifest','ch02.scan.1','ch02.scan.2','ch02.scan.3','ch02.rescue_float','prologue.01','prologue.02','prologue.03','ch02.outro.alice','ch02.outro.bob','ch02.outro.charlie','interlude.rust','interlude.location','ch05.intro','ch05.mara','ch05.choice.seal_gate','ch05.choice.break_blockade','ch05.choice.deep_rock','ending.empire.intro','ending.empire.result','ending.rebel.intro','ending.rebel.result','ending.deep_rock.intro','ending.deep_rock.result']; const missing=required.filter(id=>!entries.includes(id)); if(missing.length) throw new Error('Missing required dialogue IDs: '+missing.join(', ')); console.log('dialogue source ok');" }

$DialogueDataSchemaCheck = @'
const fs = require('fs');
const source = fs.readFileSync('docs/dialogue-story.md', 'utf8');
const fences = [...source.matchAll(/^```yaml\s*\r?\n([\s\S]*?)^```\s*$/gm)];
if (fences.length !== 1) throw new Error('Expected exactly one yaml fence in docs/dialogue-story.md');

const entries = new Map();
let entry = null;
let inPilots = false;
const quote = String.fromCharCode(34);
const readScalar = value => {
    const trimmed = value.trim();
    return trimmed.startsWith(quote) && trimmed.endsWith(quote) ? JSON.parse(trimmed) : trimmed;
};
const readQuotedScalar = (value, field, id) => {
    const trimmed = value.trim();
    if (!trimmed.startsWith(quote) || !trimmed.endsWith(quote)) {
        throw new Error('Dialogue field must be quoted: ' + id + '.' + field);
    }
    return JSON.parse(trimmed);
};

for (const line of fences[0][1].split(/\r?\n/)) {
    let match = line.match(/^\s*-\s+id:\s*([^\s#]+)\s*$/);
    if (match) {
        if (entries.has(match[1])) throw new Error('Duplicate dialogue ID: ' + match[1]);
        entry = { speaker: '', default: '', portrait: '', pilots: {} };
        entries.set(match[1], entry);
        inPilots = false;
        continue;
    }
    if (!entry) continue;
    match = line.match(/^\s{4}speaker:\s*(.+)$/);
    if (match) { entry.speaker = readQuotedScalar(match[1], 'speaker', [...entries.keys()].at(-1)); inPilots = false; continue; }
    match = line.match(/^\s{4}default:\s*(.+)$/);
    if (match) { entry.default = readQuotedScalar(match[1], 'default', [...entries.keys()].at(-1)); inPilots = false; continue; }
    match = line.match(/^\s{4}portrait:\s*(.+)$/);
    if (match) { entry.portrait = readQuotedScalar(match[1], 'portrait', [...entries.keys()].at(-1)); inPilots = false; continue; }
    if (/^\s{4}pilots:\s*$/.test(line)) { inPilots = true; continue; }
    match = inPilots && line.match(/^\s{6}([^:\s]+):\s*(.+)$/);
    if (match) entry.pilots[match[1]] = readScalar(match[2]);
}

for (const [id, parsed] of entries) {
    if (!parsed.speaker || !parsed.default || !parsed.portrait) {
        throw new Error('Incomplete dialogue entry: ' + id);
    }
    const visibleText = [parsed.speaker, parsed.default, ...Object.values(parsed.pilots)];
    if (visibleText.some(value => /[A-Za-z]{3,}/.test(value))) {
        throw new Error('Visible ASCII English in dialogue entry: ' + id);
    }
}
if (!entries.size) throw new Error('No dialogue entries found');
const portraits = new Set(['alice', 'bob', 'charlie', 'command', 'rebel', 'quartermaster', 'scanner', 'mara', 'system']);
for (const [id, parsed] of entries) {
    if (!portraits.has(parsed.portrait)) throw new Error('Unsupported dialogue portrait: ' + id);
}
console.log('dialogue data schema validation ok');
'@
Invoke-Native { $DialogueDataSchemaCheck | node - }

Invoke-Native { node -e "const fs=require('fs'); const source=fs.readFileSync('docs/dialogue-story.md','utf8'); const required=['ch01.pilot_status','ch01.mission_brief','ch01.distress_signal','ch01.rescue_scan','ch01.rescue_order']; const missing=required.filter(id=>!source.includes('id: '+id)); if(missing.length) throw new Error('Missing Chapter 1 opening dialogue IDs: '+missing.join(', ')); console.log('chapter 01 opening dialogue ok');" }

Invoke-Native { $NarrativeRecoveryContract | node - }

if ($RegenerateAssets) {
    Write-Host "`n[3/4] Regenerating chapter 01 assets..."
    Invoke-Native { python tools\generate_ch01_assets.py }
} else {
    Write-Host "`n[3/4] Skipping asset regeneration. Pass -RegenerateAssets to rebuild."
}

Write-Host "`n[4/4] Validating chapter 01 assets..."
Invoke-Native { python tools\validate_ch01_assets.py }
Write-Host "`nAll checks passed."
