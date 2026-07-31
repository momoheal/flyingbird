param([switch]$RegenerateAssets)

$ErrorActionPreference = "Stop"

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

const forbiddenLegacyFlow = [
    /\bCH02_CHOICE\b/,
    /\bchooseBranch\b/,
    /\bshowChapterTwoChoice\b/,
    /\bspawnChapterTwoBoss\b/,
    /\bstartChapterTwoBoss\b/
];
if (forbiddenLegacyFlow.some(pattern => pattern.test(source))) {
    throw new Error('Obsolete B-sector choice or Boss flow remains');
}

if (/\bstory-choice-screen\b|\bstory-choice-panel\b|\brenderStoryChoice\b/.test(source)) {
    throw new Error('Obsolete story choice overlay remains');
}

const englishGateLabels = [
    'GATE_09', 'GATE 09', 'SHELTER 09', 'OPEN CHANNEL', 'MEDICAL SUPPLY',
    'EVAC CONVOY', 'TEMP FILTER', 'ENDING', 'REDEPLOY', 'COST:', 'TARGETS'
];
const visibleEnglishLabels = englishGateLabels.filter(label => source.includes(label));
if (visibleEnglishLabels.length) {
    throw new Error('English-visible old Gate labels remain: ' + visibleEnglishLabels.join(', '));
}

const finish = body('finishChapterTwoInvestigation');
const interlude = body('startInterlude');
const reset = body('resetRun');
requireMatch(finish, /showTransition\('BLACKBOX_RECOVERED'/, 'Blackbox closure transition missing');
requireMatch(finish, /narrativeTimers/, 'Blackbox transition is not tracked');
requireMatch(interlude, /scheduleNarrative\([\s\S]*?startChapterFive/, 'Interlude does not schedule Gate 09');
requireMatch(source, /chapterTwoWaves === CHAPTER_TWO.targetWaves[\s\S]*?finishChapterTwoInvestigation\(\)/, 'B-sector completion does not finish investigation');
requireMatch(reset, /narrativeRun\+\+[\s\S]*?narrativeTimers\.forEach\(timer => clearTimeout\(timer\)\)[\s\S]*?narrativeTimers\.clear\(\)/, 'Reset does not cancel narrative timers');
console.log('narrative recovery contract ok');
'@
Invoke-Native { $NarrativeRecoveryContract | node - }

Write-Host "`n[2/4] Validating dialogue source..."
Invoke-Native { node -e "const fs=require('fs'); const source=fs.readFileSync('docs/dialogue-story.md','utf8'); const marker=String.fromCharCode(96).repeat(3); const fences=[...source.matchAll(new RegExp('^'+marker+'yaml\\s*\\r?\\n([\\s\\S]*?)^'+marker+'\\s*$','gm'))]; if(fences.length!==1) throw new Error('Expected exactly one yaml fence in docs/dialogue-story.md'); const entries=fences[0][1].split(String.fromCharCode(10)).map(line=>line.trim()).filter(line=>line.startsWith('- id: ')).map(line=>line.slice(6)); if(!entries.length) throw new Error('No dialogue id entries found in yaml fence'); const duplicates=entries.filter((id,index)=>entries.indexOf(id)!==index); if(duplicates.length) throw new Error('Duplicate dialogue IDs: '+[...new Set(duplicates)].join(', ')); const required=['ch01.deploy','ch01.boss_intro','ch01.debrief','ch02.quartermaster.armor','ch02.quartermaster.manifest','ch02.scan.1','ch02.scan.2','ch02.scan.3','ch02.rescue_float','prologue.01','prologue.02','prologue.03','ch02.outro.alice','ch02.outro.bob','ch02.outro.charlie','interlude.rust','interlude.location','ch05.intro','ch05.mara','ch05.choice.seal_gate','ch05.choice.break_blockade','ch05.choice.deep_rock','ending.empire.intro','ending.empire.result','ending.rebel.intro','ending.rebel.result','ending.deep_rock.intro','ending.deep_rock.result']; const missing=required.filter(id=>!entries.includes(id)); if(missing.length) throw new Error('Missing required dialogue IDs: '+missing.join(', ')); console.log('dialogue source ok');" }

$RuntimeDialogueParserCheck = @'
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

for (const line of fences[0][1].split(/\r?\n/)) {
    let match = line.match(/^\s*-\s+id:\s*([^\s#]+)\s*$/);
    if (match) {
        if (entries.has(match[1])) throw new Error('Duplicate dialogue ID: ' + match[1]);
        entry = { speaker: '', default: '', pilots: {} };
        entries.set(match[1], entry);
        inPilots = false;
        continue;
    }
    if (!entry) continue;
    match = line.match(/^\s{4}speaker:\s*(.+)$/);
    if (match) { entry.speaker = readScalar(match[1]); inPilots = false; continue; }
    match = line.match(/^\s{4}default:\s*(.+)$/);
    if (match) { entry.default = readScalar(match[1]); inPilots = false; continue; }
    if (/^\s{4}pilots:\s*$/.test(line)) { inPilots = true; continue; }
    match = inPilots && line.match(/^\s{6}([^:\s]+):\s*(.+)$/);
    if (match) entry.pilots[match[1]] = readScalar(match[2]);
}

for (const [id, parsed] of entries) {
    if (!parsed.speaker || !parsed.default) throw new Error('Incomplete dialogue entry: ' + id);
}
if (!entries.size) throw new Error('No dialogue entries found');
console.log('dialogue runtime parser compatibility ok');
'@
Invoke-Native { $RuntimeDialogueParserCheck | node - }

Invoke-Native { node -e "const fs=require('fs'); const source=fs.readFileSync('docs/dialogue-story.md','utf8'); const required=['ch01.pilot_status','ch01.mission_brief','ch01.distress_signal','ch01.rescue_scan','ch01.rescue_order']; const missing=required.filter(id=>!source.includes('id: '+id)); if(missing.length) throw new Error('Missing Chapter 1 opening dialogue IDs: '+missing.join(', ')); console.log('chapter 01 opening dialogue ok');" }

if ($RegenerateAssets) {
    Write-Host "`n[3/4] Regenerating chapter 01 assets..."
    Invoke-Native { python tools\generate_ch01_assets.py }
} else {
    Write-Host "`n[3/4] Skipping asset regeneration. Pass -RegenerateAssets to rebuild."
}

Write-Host "`n[4/4] Validating chapter 01 assets..."
Invoke-Native { python tools\validate_ch01_assets.py }
Write-Host "`nAll checks passed."
