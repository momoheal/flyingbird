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

Write-Host "`n[1/4] Checking prototype/fb.html script syntax and narrative flow..."
Invoke-Native { node -e "const fs=require('fs'); const html=fs.readFileSync('prototype/fb.html','utf8'); const match=html.match(/<script>([\s\S]*)<\/script>/); if(!match) throw new Error('No <script> block found in prototype/fb.html'); new Function(match[1]); console.log('prototype/fb.html script syntax ok');" }
Invoke-Native { node -e "const fs=require('fs'); const source=fs.readFileSync('prototype/fb.html','utf8'); const states=['INTERLUDE','CH05_PLAY','CH05_CHOICE','ENDING_PLAY','ENDING_RESULT']; const missing=states.filter(state=>!source.includes(state)); if(missing.length) throw new Error('Missing narrative states: '+missing.join(', ')); const requireMatch=(pattern,message)=>{if(!pattern.test(source)) throw new Error(message);}; requireMatch(/let[^;]*\broute\s*=\s*null/, 'Missing route initialization'); requireMatch(/function resetRun\(\)[\s\S]*?route\s*=\s*null/, 'Missing route reset'); if(/\bchooseBranch\b|\bshowChapterTwoChoice\b/.test(source)) throw new Error('Obsolete B-sector choice flow remains'); requireMatch(/function finishChapterTwoInvestigation\(\)[\s\S]*?showTransition\('BLACKBOX_RECOVERED'/, 'Blackbox closure transition missing'); requireMatch(/function startInterlude\(\)[\s\S]*?setTimeout\(startChapterFive/, 'Interlude does not start Gate 09'); requireMatch(/chapterTwoWaves === CHAPTER_TWO.targetWaves[\s\S]*?finishChapterTwoInvestigation\(\)/, 'B-sector completion does not finish investigation'); console.log('narrative structural contract ok');" }

Write-Host "`n[2/4] Validating dialogue source..."
Invoke-Native { node -e "const fs=require('fs'); const source=fs.readFileSync('docs/dialogue-story.md','utf8'); const marker=String.fromCharCode(96).repeat(3); const fences=[...source.matchAll(new RegExp('^'+marker+'yaml\\s*\\r?\\n([\\s\\S]*?)^'+marker+'\\s*$','gm'))]; if(fences.length!==1) throw new Error('Expected exactly one yaml fence in docs/dialogue-story.md'); const entries=fences[0][1].split(String.fromCharCode(10)).map(line=>line.trim()).filter(line=>line.startsWith('- id: ')).map(line=>line.slice(6)); if(!entries.length) throw new Error('No dialogue id entries found in yaml fence'); const duplicates=entries.filter((id,index)=>entries.indexOf(id)!==index); if(duplicates.length) throw new Error('Duplicate dialogue IDs: '+[...new Set(duplicates)].join(', ')); const required=['ch01.deploy','ch01.boss_intro','ch01.debrief','ch02.quartermaster.armor','ch02.quartermaster.manifest','ch02.scan.1','ch02.scan.2','ch02.scan.3','ch02.rescue_float','prologue.01','prologue.02','prologue.03','ch02.outro.alice','ch02.outro.bob','ch02.outro.charlie','interlude.rust','interlude.location','ch05.intro','ch05.mara','ch05.choice.seal_gate','ch05.choice.break_blockade','ch05.choice.deep_rock','ending.empire.intro','ending.empire.result','ending.rebel.intro','ending.rebel.result','ending.deep_rock.intro','ending.deep_rock.result']; const missing=required.filter(id=>!entries.includes(id)); if(missing.length) throw new Error('Missing required dialogue IDs: '+missing.join(', ')); console.log('dialogue source ok');" }
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
