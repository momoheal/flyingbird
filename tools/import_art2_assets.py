from __future__ import annotations

from collections import deque
from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
ART2 = ROOT / "art2"
OUT = ROOT / "assets" / "ch02"

SOURCES = {
    "bg": "Gemini_Generated_Image_12g95d12g95d12g9.png",
    "runner": "Gemini_Generated_Image_57zmsk57zmsk57zm.png",
    "purifier": "Gemini_Generated_Image_91whzw91whzw91wh.png",
    "drone": "Gemini_Generated_Image_9sqv8b9sqv8b9sqv.png",
    "convoy": "Gemini_Generated_Image_ch4m58ch4m58ch4m.png",
    "beacon": "Gemini_Generated_Image_cm0be6cm0be6cm0b.png",
    "route_protect": "Gemini_Generated_Image_k2ovmfk2ovmfk2ov.png",
    "route_execute": "Gemini_Generated_Image_rfjjcurfjjcurfjj (1).png",
    "interceptor": "Gemini_Generated_Image_tdlb06tdlb06tdlb.png",
    "scan": "Gemini_Generated_Image_xk4nitxk4nitxk4n.png",
}


def open_source(key: str) -> Image.Image:
    return Image.open(ART2 / SOURCES[key]).convert("RGBA")


def remove_generated_backdrop(image: Image.Image) -> Image.Image:
    image = image.convert("RGBA")
    pixels = image.load()

    def is_backdrop(x: int, y: int) -> bool:
        r, g, b, _ = pixels[x, y]
        chroma_green = g > 80 and g > r * 1.25 and g > b * 1.15
        checker = r < 80 and g < 100 and b < 120 and b >= g and g >= r
        return chroma_green or checker

    # Background removal is restricted to pixels connected to an outer edge.
    # Similar colors inside a hull, icon, or effect remain opaque.
    queue = deque()
    seen = set()
    for x in range(image.width):
        queue.extend(((x, 0), (x, image.height - 1)))
    for y in range(1, image.height - 1):
        queue.extend(((0, y), (image.width - 1, y)))
    while queue:
        x, y = queue.popleft()
        if (x, y) in seen or not is_backdrop(x, y):
            continue
        seen.add((x, y))
        r, g, b, _ = pixels[x, y]
        pixels[x, y] = (r, g, b, 0)
        for nx, ny in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)):
            if 0 <= nx < image.width and 0 <= ny < image.height:
                queue.append((nx, ny))
    return image


def trim_alpha(image: Image.Image) -> Image.Image:
    box = image.getchannel("A").getbbox()
    return image.crop(box) if box else image


def export_sprite(key: str, relative_dest: str, size: tuple[int, int], pad: float = 0.9) -> None:
    image = trim_alpha(remove_generated_backdrop(open_source(key)))
    image.thumbnail((round(size[0] * pad), round(size[1] * pad)), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", size, (0, 0, 0, 0))
    canvas.alpha_composite(image, ((size[0] - image.width) // 2, (size[1] - image.height) // 2))
    destination = ROOT / relative_dest
    destination.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(destination)
    print(relative_dest)


def export_sheet(key: str, relative_dest: str, size: tuple[int, int]) -> None:
    image = trim_alpha(remove_generated_backdrop(open_source(key)))
    image.thumbnail(size, Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", size, (0, 0, 0, 0))
    canvas.alpha_composite(image, ((size[0] - image.width) // 2, (size[1] - image.height) // 2))
    destination = ROOT / relative_dest
    destination.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(destination)
    print(relative_dest)


def export_background() -> None:
    destination = OUT / "bg" / "sf_ch02_bg_b_sector_mining_route_768x1376.png"
    destination.parent.mkdir(parents=True, exist_ok=True)
    open_source("bg").save(destination)
    print(destination.relative_to(ROOT))


def main() -> None:
    export_background()
    export_sprite("convoy", "assets/ch02/convoy/sf_ch02_convoy_refugee_hauler_1024.png", (1024, 1024), 0.96)
    export_sprite("interceptor", "assets/ch02/enemy/sf_ch02_enemy_quarantine_interceptor_512.png", (512, 512))
    export_sprite("drone", "assets/ch02/enemy/sf_ch02_enemy_inspection_drone_512.png", (512, 512))
    export_sprite("purifier", "assets/ch02/boss/sf_ch02_boss_purification_cruiser_2048.png", (2048, 1024), 0.95)
    export_sprite("runner", "assets/ch02/boss/sf_ch02_boss_convoy_runner_2048.png", (2048, 1024), 0.95)
    export_sheet("beacon", "assets/ch02/fx/sf_ch02_fx_distress_beacon_sheet_1024x512.png", (1024, 512))
    export_sheet("scan", "assets/ch02/fx/sf_ch02_fx_quarantine_scan_sheet_1024x512.png", (1024, 512))
    export_sprite("route_protect", "assets/ch02/ui/sf_ch02_ui_route_protect_256.png", (256, 256), 0.92)
    export_sprite("route_execute", "assets/ch02/ui/sf_ch02_ui_route_execute_256.png", (256, 256), 0.92)


if __name__ == "__main__":
    main()
