param(
    [switch]$RegenerateAssets
)

$ErrorActionPreference = "Stop"

function Invoke-Native {
    param([scriptblock]$Command)

    & $Command
    if ($LASTEXITCODE -ne 0) {
        throw "Native command failed with exit code $LASTEXITCODE"
    }
}

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $Root

Write-Host "== Flyingbird checks =="
Write-Host "Workspace: $Root"

Write-Host "`n[1/5] Checking prototype/fb.html script syntax..."
Invoke-Native { node -e "const fs=require('fs'); const html=fs.readFileSync('prototype/fb.html','utf8'); const match=html.match(/<script>([\s\S]*)<\/script>/); if(!match) throw new Error('No <script> block found in prototype/fb.html'); new Function(match[1]); console.log('prototype/fb.html script syntax ok');" }

Write-Host "`n[2/5] Validating dialogue source..."
Invoke-Native { node -e "const fs=require('fs'); const source=fs.readFileSync('docs/dialogue-story.md','utf8'); const marker=String.fromCharCode(96).repeat(3); const fences=[...source.matchAll(new RegExp('^'+marker+'yaml\\s*\\r?\\n([\\s\\S]*?)^'+marker+'\\s*$','gm'))]; if(fences.length!==1) throw new Error('Expected exactly one yaml fence in docs/dialogue-story.md'); const ids=[...fences[0][1].matchAll(/^\s*-\s+id:\s*([^\s#]+)\s*$/gm)].map(match=>match[1]); if(!ids.length) throw new Error('No dialogue id entries found in yaml fence'); const duplicates=ids.filter((id,index)=>ids.indexOf(id)!==index); if(duplicates.length) throw new Error('Duplicate dialogue IDs: '+[...new Set(duplicates)].join(', ')); const required=['ch01.deploy','ch01.pilot_status','ch01.mission_brief','ch01.distress_signal','ch01.rescue_scan','ch01.rescue_order','ch01.boss_intro','ch01.debrief','ch02.quartermaster.armor','ch02.quartermaster.manifest','ch02.rescue_float','ch02.scan.1','ch02.scan.2','ch02.scan.3','ch02.outro.alice','ch02.outro.bob','ch02.outro.charlie','prologue.01','prologue.02','prologue.03','interlude.rust','interlude.location','ch05.intro','ch05.mara','ch05.choice.seal_gate','ch05.choice.break_blockade','ch05.choice.deep_rock','ending.empire.intro','ending.empire.result','ending.rebel.intro','ending.rebel.result','ending.deep_rock.intro','ending.deep_rock.result','ch03.intro','ch03.result','ch04.intro','ch04.result','ch06.intro','ch06.result','ch07.intro','ch07.result','ch08.intro','ch08.result','ch09.rebel.intro','ch09.empire.intro','ch09.deep.intro']; const missing=required.filter(id=>!ids.includes(id)); if(missing.length) throw new Error('Missing required dialogue IDs: '+missing.join(', ')); console.log('dialogue source ok');" }

Invoke-Native { node -e "const fs=require('fs'); const source=fs.readFileSync('docs/dialogue-story.md','utf8'); const required=['ch01.pilot_status','ch01.mission_brief','ch01.distress_signal','ch01.rescue_scan','ch01.rescue_order']; const missing=required.filter(id=>!source.includes('id: '+id)); if(missing.length) throw new Error('Missing Chapter 1 opening dialogue IDs: '+missing.join(', ')); console.log('chapter 01 opening dialogue ok');" }

Write-Host "`n[3/5] Validating narrative state contract..."
Invoke-Native { node -e "const fs=require('fs'); const html=fs.readFileSync('prototype/fb.html','utf8'); const states=['PROLOGUE','INTERLUDE','CH03_PLAY','CH04_PLAY','CH05_PLAY','CH05_CHOICE','CH06_PLAY','CH07_PLAY','CH08_PLAY','CH09_PLAY','ENDING_PLAY','ENDING_RESULT']; const missing=states.filter(state=>!html.includes(state)); if(missing.length) throw new Error('Missing narrative states: '+missing.join(', ')); const routes=['seal_gate','break_blockade','deep_rock']; const missingRoutes=routes.filter(route=>!html.includes(route)); if(missingRoutes.length) throw new Error('Missing Gate 09 routes: '+missingRoutes.join(', ')); const legacy=['branch','chooseBranch','startChapterTwoBoss','PurifierBoss','RunnerBoss','sf_ch02_boss_purification_cruiser','sf_ch02_boss_convoy_runner','sf_ch02_ui_route_execute']; const stale=legacy.filter(token=>html.includes(token)); if(stale.length) throw new Error('Legacy B-sector branch flow remains: '+stale.join(', ')); console.log('narrative state contract ok');" }

if ($RegenerateAssets) {
    Write-Host "`n[4/5] Regenerating chapter 01 assets..."
    Invoke-Native { python tools\generate_ch01_assets.py }
} else {
    Write-Host "`n[4/5] Skipping asset regeneration. Pass -RegenerateAssets to rebuild."
}

Write-Host "`n[5/5] Validating chapter 01 assets..."
Invoke-Native { python tools\validate_ch01_assets.py }

Write-Host "`nAll checks passed."
