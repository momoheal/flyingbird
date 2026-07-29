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

Write-Host "`n[1/4] Checking prototype/fb.html script syntax..."
Invoke-Native { node -e "const fs=require('fs'); const html=fs.readFileSync('prototype/fb.html','utf8'); const match=html.match(/<script>([\s\S]*)<\/script>/); if(!match) throw new Error('No <script> block found in prototype/fb.html'); new Function(match[1]); console.log('prototype/fb.html script syntax ok');" }

Write-Host "`n[2/4] Validating dialogue source..."
Invoke-Native { node -e "const fs=require('fs'); const source=fs.readFileSync('docs/dialogue-story.md','utf8'); const marker=String.fromCharCode(96).repeat(3); const fences=[...source.matchAll(new RegExp('^'+marker+'yaml\\s*\\r?\\n([\\s\\S]*?)^'+marker+'\\s*$','gm'))]; if(fences.length!==1) throw new Error('Expected exactly one yaml fence in docs/dialogue-story.md'); const ids=[...fences[0][1].matchAll(/^\s*-\s+id:\s*([^\s#]+)\s*$/gm)].map(match=>match[1]); if(!ids.length) throw new Error('No dialogue id entries found in yaml fence'); const duplicates=ids.filter((id,index)=>ids.indexOf(id)!==index); if(duplicates.length) throw new Error('Duplicate dialogue IDs: '+[...new Set(duplicates)].join(', ')); const required=['ch01.deploy','ch01.boss_intro','ch01.debrief','ch02.quartermaster.armor','ch02.quartermaster.manifest','ch02.scan.1','ch02.scan.2','ch02.scan.3','ch02.choice.order','ch02.choice.rebel','ch02.choice.empire','ch02.rescue_float','ch02.rebel_boss.intro','ch02.rebel_boss.phase2','ch02.rebel_boss.defeat','ch02.empire_boss.intro','ch02.empire_boss.phase2','ch02.empire_boss.defeat']; const missing=required.filter(id=>!ids.includes(id)); if(missing.length) throw new Error('Missing required dialogue IDs: '+missing.join(', ')); console.log('dialogue source ok');" }

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
