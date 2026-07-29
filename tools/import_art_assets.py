from __future__ import annotations

from collections import Counter, deque
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw, ImageEnhance, ImageFilter


ROOT = Path(__file__).resolve().parents[1]
ART = ROOT / "art"
ASSETS = ROOT / "assets" / "ch01"


def open_rgba(name: str) -> Image.Image:
    return Image.open(ART / name).convert("RGBA")


def color_dist(a: tuple[int, int, int], b: tuple[int, int, int]) -> int:
    return abs(a[0] - b[0]) + abs(a[1] - b[1]) + abs(a[2] - b[2])


def border_palette(img: Image.Image, limit: int = 10) -> list[tuple[int, int, int]]:
    w, h = img.size
    pts = []
    step = max(1, min(w, h) // 80)
    for x in range(0, w, step):
        pts.append(img.getpixel((x, 0))[:3])
        pts.append(img.getpixel((x, h - 1))[:3])
    for y in range(0, h, step):
        pts.append(img.getpixel((0, y))[:3])
        pts.append(img.getpixel((w - 1, y))[:3])
    quantized = [(r // 16 * 16, g // 16 * 16, b // 16 * 16) for r, g, b in pts]
    return [color for color, _ in Counter(quantized).most_common(limit)]


def remove_generated_background(img: Image.Image) -> Image.Image:
    img = img.convert("RGBA")
    palette = border_palette(img)
    px = img.load()
    w, h = img.size

    def is_backdrop(x: int, y: int) -> bool:
        r, g, b, a = px[x, y]
        rgb = (r // 16 * 16, g // 16 * 16, b // 16 * 16)
        near_border = any(color_dist(rgb, c) < 58 for c in palette)
        bright_flat = r > 220 and g > 220 and b > 220
        near_black = max(r, g, b) < 18 and abs(r - g) < 8 and abs(g - b) < 8
        checker_gray = abs(r - g) < 12 and abs(g - b) < 12 and 24 <= r <= 245
        return a == 0 or (near_border and (bright_flat or checker_gray or near_black))

    # Only erase background connected to the image boundary. This avoids
    # punching transparent holes through dark armor and internal machinery.
    queue = deque()
    seen = set()
    for x in range(w):
        queue.extend(((x, 0), (x, h - 1)))
    for y in range(1, h - 1):
        queue.extend(((0, y), (w - 1, y)))
    while queue:
        x, y = queue.popleft()
        if (x, y) in seen or not is_backdrop(x, y):
            continue
        seen.add((x, y))
        r, g, b, _ = px[x, y]
        px[x, y] = (r, g, b, 0)
        for nx, ny in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)):
            if 0 <= nx < w and 0 <= ny < h:
                queue.append((nx, ny))
    return img


def trim_alpha(img: Image.Image) -> Image.Image:
    bbox = img.getchannel("A").getbbox()
    return img.crop(bbox) if bbox else img


def fit_canvas(img: Image.Image, size: tuple[int, int], pad: float = 0.9) -> Image.Image:
    img = trim_alpha(img)
    canvas = Image.new("RGBA", size, (0, 0, 0, 0))
    max_w = int(size[0] * pad)
    max_h = int(size[1] * pad)
    img.thumbnail((max_w, max_h), Image.Resampling.LANCZOS)
    canvas.alpha_composite(img, ((size[0] - img.width) // 2, (size[1] - img.height) // 2))
    return canvas


def solidify_alpha(img: Image.Image, threshold: int = 12) -> Image.Image:
    img = img.convert("RGBA")
    px = img.load()
    w, h = img.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if a >= threshold:
                px[x, y] = (r, g, b, 255 if a > 60 else min(210, a * 4))
            else:
                px[x, y] = (r, g, b, 0)
    return img


def suppress_white_artifacts(img: Image.Image) -> Image.Image:
    img = img.convert("RGBA")
    px = img.load()
    w, h = img.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if a == 0:
                continue
            mx, mn = max(r, g, b), min(r, g, b)
            low_saturation = mx - mn < 28
            near_white = r > 218 and g > 218 and b > 218
            if near_white and low_saturation:
                px[x, y] = (r, g, b, 0)
            elif mx > 235 and low_saturation:
                scale = 214 / mx
                px[x, y] = (round(r * scale), round(g * scale), round(b * scale), a)
    return img


def reinforce_player_sprite(
    img: Image.Image,
    boost: float = 1.0,
    accent: tuple[int, int, int] = (255, 160, 76),
) -> Image.Image:
    img = suppress_white_artifacts(img)
    img = solidify_alpha(img, threshold=16)
    px = img.load()
    w, h = img.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if a == 0:
                continue
            mx, mn = max(r, g, b), min(r, g, b)
            if mn > 214 and mx - mn < 92:
                mix = 0.68
                px[x, y] = (
                    round(accent[0] * mix + r * (1 - mix)),
                    round(accent[1] * mix + g * (1 - mix)),
                    round(accent[2] * mix + b * (1 - mix)),
                    min(a, 225),
                )
    rgb = img.convert("RGB")
    rgb = ImageEnhance.Contrast(rgb).enhance(1.18 + 0.06 * boost)
    rgb = ImageEnhance.Color(rgb).enhance(1.08 + 0.04 * boost)
    rgb = ImageEnhance.Brightness(rgb).enhance(0.96 + 0.03 * boost)
    img = Image.merge("RGBA", (*rgb.split(), img.getchannel("A")))

    alpha = img.getchannel("A")
    outer = alpha.filter(ImageFilter.MaxFilter(13))
    inner = alpha.filter(ImageFilter.MinFilter(5))
    outline_alpha = ImageChops.subtract(outer, inner).point(lambda v: min(235, v * 2))
    outline = Image.new("RGBA", img.size, (4, 7, 10, 0))
    outline.putalpha(outline_alpha)
    outline.alpha_composite(img)
    return outline


def fit_background(img: Image.Image, size: tuple[int, int]) -> Image.Image:
    img = img.convert("RGB")
    scale = max(size[0] / img.width, size[1] / img.height)
    resized = img.resize((round(img.width * scale), round(img.height * scale)), Image.Resampling.LANCZOS)
    x = (resized.width - size[0]) // 2
    y = (resized.height - size[1]) // 2
    out = resized.crop((x, y, x + size[0], y + size[1])).convert("RGBA")
    # Gameplay sprites and projectiles provide the visual emphasis; backgrounds stay subdued.
    out = ImageEnhance.Brightness(out).enhance(0.86)
    out = ImageEnhance.Contrast(out).enhance(1.06)
    return out


def export_transparent(src: str, dest: str, size: tuple[int, int], rotate: int = 0, pad: float = 0.9, solid_alpha: bool = False) -> None:
    img = remove_generated_background(open_rgba(src))
    if rotate:
        img = img.rotate(rotate, expand=True)
    out = fit_canvas(img, size, pad)
    if solid_alpha:
        accent = (255, 92, 56)
        if "bob" in src:
            accent = (60, 210, 255)
        elif "charlie" in src:
            accent = (93, 232, 132)
        out = reinforce_player_sprite(out, 1.0 if "alice" in src else 0.35, accent)
    out.save(ROOT / dest)
    print(dest)


def export_background(src: str, dest: str, size: tuple[int, int]) -> None:
    out = fit_background(open_rgba(src), size)
    out.save(ROOT / dest)
    print(dest)


def export_boss_phase03(src: str, dest: str) -> None:
    out = fit_canvas(remove_generated_background(open_rgba(src)), (2048, 1024), 0.9)
    d = ImageDraw.Draw(out, "RGBA")
    cx, cy = 1024, 512
    for r, alpha in [(190, 42), (120, 90), (62, 210)]:
        d.ellipse((cx-r, cy-r, cx+r, cy+r), fill=(255, 216, 78, alpha))
    d.ellipse((cx-38, cy-38, cx+38, cy+38), fill=(255, 255, 220, 245))
    out.save(ROOT / dest)
    print(dest)


def main() -> None:
    if not ART.exists():
        raise SystemExit("art directory not found")

    exports = [
        ("sf_ch01_player_alice_top_512.png", "assets/ch01/player/sf_ch01_player_alice_top_512.png", (512, 512), 0, 0.98, True),
        ("sf_ch01_player_bob_top_512.png", "assets/ch01/player/sf_ch01_player_bob_top_512.png", (512, 512), 0, 0.9, True),
        ("sf_ch01_player_charlie_top_source.png", "assets/ch01/player/sf_ch01_player_charlie_top_512.png", (512, 512), 0, 0.9, True),
        ("sf_ch01_enemy_empire_drone_a_source.png", "assets/ch01/enemy/sf_ch01_enemy_empire_drone_a_256.png", (256, 256), 180, 0.82, False),
        ("sf_ch01_enemy_rebel_skiff_a_source.png", "assets/ch01/enemy/sf_ch01_enemy_rebel_skiff_a_256.png", (256, 256), 180, 0.84, False),
        ("sf_ch01_boss_stitched_carrier_phase03_core_source.png", "assets/ch01/enemy/sf_ch01_enemy_rebel_elite_salvager_512.png", (512, 512), 180, 0.86, False),
        ("sf_ch01_boss_stitched_carrier_phase02_damaged_source.png", "assets/ch01/boss/sf_ch01_boss_stitched_carrier_phase02_damaged_2048.png", (2048, 1024), 0, 0.9, False),
        ("sf_ch01_boss_stitched_carrier_phase01_source.png", "assets/ch01/boss/sf_ch01_boss_stitched_carrier_phase01_2048.png", (2048, 1024), 0, 0.9, False),
        ("sf_ch01_fx_laser_core_source.png", "assets/ch01/fx/sf_ch01_fx_laser_core_512.png", (512, 512), 0, 0.95, False),
        ("sf_ch01_portrait_alice_comm_512.png", "assets/ch01/portrait/sf_ch01_portrait_alice_comm_512.png", (512, 512), 0, 0.96, False),
        ("sf_ch01_portrait_bob_comm_512.png", "assets/ch01/portrait/sf_ch01_portrait_bob_comm_512.png", (512, 512), 0, 0.96, False),
        ("sf_ch01_portrait_charlie_comm_512.png", "assets/ch01/portrait/sf_ch01_portrait_charlie_comm_512.png", (512, 512), 0, 0.96, False),
        ("sf_ch01_portrait_rebel_commander_512.png", "assets/ch01/portrait/sf_ch01_portrait_rebel_commander_512.png", (512, 512), 0, 0.96, False),
        ("sf_ch01_ui_card_module_frame_512.png", "assets/ch01/ui/sf_ch01_ui_card_module_frame_512.png", (512, 512), 0, 0.96, False),
        ("sf_ch01_ui_route_control_256.png", "assets/ch01/ui/sf_ch01_ui_route_control_256.png", (256, 256), 0, 0.9, False),
        ("sf_ch01_ui_route_defense_256.png", "assets/ch01/ui/sf_ch01_ui_route_defense_256.png", (256, 256), 0, 0.9, False),
    ]

    for src, dest, size, rotate, pad, solid_alpha in exports:
        export_transparent(src, dest, size, rotate, pad, solid_alpha)

    export_background(
        "sf_ch01_bg_sector_a_scrapyard_source.png",
        "assets/ch01/bg/sf_ch01_bg_sector_a_scrapyard_2048x1152.png",
        (2048, 1152),
    )
    export_boss_phase03(
        "sf_ch01_boss_stitched_carrier_phase02_damaged_source.png",
        "assets/ch01/boss/sf_ch01_boss_stitched_carrier_phase03_core_2048.png",
    )


if __name__ == "__main__":
    main()

