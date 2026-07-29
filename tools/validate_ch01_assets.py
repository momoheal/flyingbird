from __future__ import annotations

from pathlib import Path
import json

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]

EXPECTED = {
    "assets/ch01/player/sf_ch01_player_alice_top_512.png": ((512, 512), True),
    "assets/ch01/player/sf_ch01_player_bob_top_512.png": ((512, 512), True),
    "assets/ch01/player/sf_ch01_player_charlie_top_512.png": ((512, 512), True),
    "assets/ch01/enemy/sf_ch01_enemy_rebel_skiff_a_256.png": ((256, 256), True),
    "assets/ch01/enemy/sf_ch01_enemy_empire_drone_a_256.png": ((256, 256), True),
    "assets/ch01/enemy/sf_ch01_enemy_rebel_elite_salvager_512.png": ((512, 512), True),
    "assets/ch01/boss/sf_ch01_boss_stitched_carrier_phase01_2048.png": ((2048, 1024), True),
    "assets/ch01/boss/sf_ch01_boss_stitched_carrier_phase02_damaged_2048.png": ((2048, 1024), True),
    "assets/ch01/boss/sf_ch01_boss_stitched_carrier_phase03_core_2048.png": ((2048, 1024), True),
    "assets/ch01/bg/sf_ch01_bg_sector_a_scrapyard_2048x1152.png": ((2048, 1152), False),
    "assets/ch01/fx/sf_ch01_fx_laser_core_512.png": ((512, 512), True),
    "assets/ch01/fx/sf_ch01_fx_explosion_spark_512.png": ((512, 512), True),
    "assets/ch01/portrait/sf_ch01_portrait_alice_comm_512.png": ((512, 512), True),
    "assets/ch01/portrait/sf_ch01_portrait_bob_comm_512.png": ((512, 512), True),
    "assets/ch01/portrait/sf_ch01_portrait_charlie_comm_512.png": ((512, 512), True),
    "assets/ch01/portrait/sf_ch01_portrait_rebel_commander_512.png": ((512, 512), True),
    "assets/ch01/ui/sf_ch01_ui_card_module_frame_512.png": ((512, 512), True),
    "assets/ch01/ui/sf_ch01_ui_route_control_256.png": ((256, 256), True),
    "assets/ch01/ui/sf_ch01_ui_route_defense_256.png": ((256, 256), True),
}


def has_transparent_pixels(img: Image.Image) -> bool:
    if img.mode != "RGBA":
        return False
    alpha = img.getchannel("A")
    return alpha.getextrema()[0] == 0 and alpha.getextrema()[1] > 0


def main() -> None:
    failures: list[str] = []
    manifest_path = ROOT / "assets/ch01/assets_manifest.json"
    if not manifest_path.exists():
        failures.append("missing: assets/ch01/assets_manifest.json")
    else:
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        manifest_paths = {item["path"] for item in manifest.get("assets", [])}
        expected_paths = set(EXPECTED.keys())
        if manifest_paths != expected_paths:
            failures.append("manifest paths do not match expected ch01 assets")
    preview_path = ROOT / "assets/ch01/_previews/ch01_asset_contact_sheet.png"
    if not preview_path.exists():
        failures.append("missing preview: assets/ch01/_previews/ch01_asset_contact_sheet.png")
    for rel, (size, needs_alpha) in EXPECTED.items():
        path = ROOT / rel
        if not path.exists():
            failures.append(f"missing: {rel}")
            continue
        with Image.open(path) as img:
            if img.size != size:
                failures.append(f"wrong size: {rel} got {img.size}, expected {size}")
            if needs_alpha and not has_transparent_pixels(img.convert("RGBA")):
                failures.append(f"missing useful alpha: {rel}")
            if not needs_alpha and img.size != size:
                failures.append(f"background invalid: {rel}")
    if failures:
        print("\n".join(failures))
        raise SystemExit(1)
    print(f"validated {len(EXPECTED)} ch01 assets")


if __name__ == "__main__":
    main()
