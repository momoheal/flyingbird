from __future__ import annotations

from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ART = ROOT / "art"


RENAMES = {
    "Gemini_Generated_Image_1dqe4o1dqe4o1dqe.png": "sf_ch01_ui_route_control_256.png",
    "Gemini_Generated_Image_2nikhv2nikhv2nik.png": "sf_ch01_boss_stitched_carrier_phase02_damaged_source.png",
    "Gemini_Generated_Image_3wpwwm3wpwwm3wpw.png": "sf_ch01_player_charlie_top_source.png",
    "Gemini_Generated_Image_48b8m248b8m248b8.png": "sf_ch01_bg_sector_a_scrapyard_source.png",
    "Gemini_Generated_Image_60p8sd60p8sd60p8.png": "sf_ch01_portrait_rebel_commander_512.png",
    "Gemini_Generated_Image_awg6l2awg6l2awg6.png": "sf_ch01_portrait_alice_comm_512.png",
    "Gemini_Generated_Image_cd646ocd646ocd64 (1).png": "sf_ch01_fx_laser_glow_alt_512.png",
    "Gemini_Generated_Image_cd646ocd646ocd64.png": "sf_ch01_fx_laser_glow_512.png",
    "Gemini_Generated_Image_dqpm14dqpm14dqpm.png": "sf_ch01_ui_card_module_frame_512.png",
    "Gemini_Generated_Image_eiwumheiwumheiwu.png": "sf_ch01_boss_stitched_carrier_phase01_source.png",
    "Gemini_Generated_Image_etty6yetty6yetty.png": "sf_ch01_bg_escape_pods_silhouette_source.png",
    "Gemini_Generated_Image_euql5deuql5deuql.png": "sf_ch01_portrait_alice_helmet_alt_512.png",
    "Gemini_Generated_Image_fqptgtfqptgtfqpt.png": "sf_ch01_enemy_rebel_skiff_a_source.png",
    "Gemini_Generated_Image_g125n5g125n5g125.png": "sf_ch01_ui_route_control_alt_256.png",
    "Gemini_Generated_Image_g8oxubg8oxubg8ox.png": "sf_ch01_portrait_charlie_comm_512.png",
    "Gemini_Generated_Image_maixgrmaixgrmaix.png": "sf_ch01_boss_weakpoint_core_256.png",
    "Gemini_Generated_Image_mox3osmox3osmox3.png": "sf_ch01_portrait_bob_comm_512.png",
    "Gemini_Generated_Image_mtozcamtozcamtoz.png": "sf_ch01_portrait_rebel_commander_alt_512.png",
    "Gemini_Generated_Image_nujb97nujb97nujb.png": "sf_ch01_fx_laser_core_source.png",
    "Gemini_Generated_Image_shn6ptshn6ptshn6.png": "sf_ch01_boss_stitched_carrier_phase03_core_source.png",
    "Gemini_Generated_Image_uin567uin567uin5.png": "sf_ch01_ui_route_defense_256.png",
    "Gemini_Generated_Image_xyp2s2xyp2s2xyp2.png": "sf_ch01_fx_shield_ring_512.png",
}


def unique_dest(path: Path) -> Path:
    if not path.exists():
        return path
    stem = path.stem
    suffix = path.suffix
    index = 2
    while True:
        candidate = path.with_name(f"{stem}_v{index}{suffix}")
        if not candidate.exists():
            return candidate
        index += 1


def main() -> None:
    if not ART.exists():
        raise SystemExit("art directory not found")
    for old_name, new_name in RENAMES.items():
        src = ART / old_name
        if not src.exists():
            continue
        dest = unique_dest(ART / new_name)
        src.rename(dest)
        print(f"{old_name} -> {dest.name}")


if __name__ == "__main__":
    main()
