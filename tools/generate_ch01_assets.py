from __future__ import annotations

import math
import random
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter


ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "assets" / "ch01"


def ensure_dirs() -> None:
    for name in ["bg", "boss", "enemy", "fx", "player", "portrait", "ui"]:
        (OUT / name).mkdir(parents=True, exist_ok=True)


def save_rgba(img: Image.Image, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    img.save(path)


def glow_layer(size: tuple[int, int]) -> tuple[Image.Image, ImageDraw.ImageDraw]:
    layer = Image.new("RGBA", size, (0, 0, 0, 0))
    return layer, ImageDraw.Draw(layer, "RGBA")


def polygon(draw: ImageDraw.ImageDraw, pts, fill, outline=None, width=3) -> None:
    draw.polygon(pts, fill=fill)
    if outline:
        draw.line(pts + [pts[0]], fill=outline, width=width, joint="curve")


def draw_engine(draw: ImageDraw.ImageDraw, x: int, y: int, r: int, color) -> None:
    draw.ellipse((x - r, y - r, x + r, y + r), fill=color)
    draw.ellipse((x - r // 2, y - r // 2, x + r // 2, y + r // 2), fill=(255, 255, 255, 220))


def make_alice() -> Image.Image:
    img = Image.new("RGBA", (512, 512), (0, 0, 0, 0))
    glow, gd = glow_layer(img.size)
    d = ImageDraw.Draw(img, "RGBA")
    gd.polygon([(256, 46), (338, 220), (468, 156), (344, 332), (306, 428), (256, 396), (206, 428), (168, 332), (44, 156), (174, 220)], fill=(255, 40, 95, 90))
    glow = glow.filter(ImageFilter.GaussianBlur(18))
    img.alpha_composite(glow)
    polygon(d, [(256, 46), (322, 214), (448, 154), (336, 318), (300, 418), (256, 382), (212, 418), (176, 318), (64, 154), (190, 214)], (22, 23, 26, 255), (255, 54, 102, 255), 5)
    polygon(d, [(256, 70), (292, 228), (256, 350), (220, 228)], (44, 46, 52, 255), (255, 96, 130, 220), 3)
    d.ellipse((226, 168, 286, 268), fill=(235, 250, 255, 235), outline=(255, 54, 102, 255), width=3)
    draw_engine(d, 256, 417, 27, (255, 160, 30, 220))
    return img


def make_bob() -> Image.Image:
    img = Image.new("RGBA", (512, 512), (0, 0, 0, 0))
    d = ImageDraw.Draw(img, "RGBA")
    glow, gd = glow_layer(img.size)
    pts = [(256, 52), (462, 372), (302, 330), (256, 386), (210, 330), (50, 372)]
    gd.polygon(pts, fill=(40, 210, 255, 85))
    glow = glow.filter(ImageFilter.GaussianBlur(16))
    img.alpha_composite(glow)
    polygon(d, pts, (7, 9, 14, 255), (80, 238, 255, 255), 4)
    for x1, y1, x2, y2 in [(256, 96, 256, 326), (126, 308, 386, 308), (176, 242, 336, 242), (216, 180, 296, 180)]:
        d.line((x1, y1, x2, y2), fill=(65, 236, 255, 230), width=4)
    d.ellipse((228, 172, 284, 226), outline=(150, 255, 255, 240), width=4)
    d.rectangle((104, 363, 188, 382), fill=(70, 230, 255, 230))
    d.rectangle((324, 363, 408, 382), fill=(70, 230, 255, 230))
    return img


def make_charlie() -> Image.Image:
    img = Image.new("RGBA", (512, 512), (0, 0, 0, 0))
    d = ImageDraw.Draw(img, "RGBA")
    glow, gd = glow_layer(img.size)
    gd.rounded_rectangle((76, 110, 202, 444), radius=24, fill=(70, 210, 80, 65))
    gd.rounded_rectangle((310, 110, 436, 444), radius=24, fill=(70, 210, 80, 65))
    glow = glow.filter(ImageFilter.GaussianBlur(14))
    img.alpha_composite(glow)
    for box in [(76, 104, 202, 424), (310, 104, 436, 424)]:
        d.rounded_rectangle(box, radius=22, fill=(43, 58, 43, 255), outline=(126, 154, 118, 255), width=5)
    polygon(d, [(256, 58), (320, 172), (300, 410), (256, 454), (212, 410), (192, 172)], (29, 40, 32, 255), (122, 150, 114, 255), 4)
    d.rectangle((226, 176, 286, 224), fill=(255, 178, 66, 230), outline=(60, 35, 12, 255), width=3)
    draw_engine(d, 139, 430, 24, (67, 255, 99, 210))
    draw_engine(d, 373, 430, 24, (67, 255, 99, 210))
    return img


def make_rebel_skiff() -> Image.Image:
    img = Image.new("RGBA", (256, 256), (0, 0, 0, 0))
    d = ImageDraw.Draw(img, "RGBA")
    pts = [(116, 22), (190, 54), (220, 128), (180, 222), (96, 204), (38, 138), (66, 62)]
    polygon(d, pts, (74, 45, 30, 255), (175, 82, 38, 255), 4)
    d.rectangle((88, 94, 152, 144), fill=(110, 49, 28, 255), outline=(40, 24, 18, 255), width=3)
    d.line((64, 172, 192, 72), fill=(215, 112, 55, 200), width=4)
    draw_engine(d, 130, 216, 15, (255, 86, 30, 220))
    return img


def make_empire_drone() -> Image.Image:
    img = Image.new("RGBA", (256, 256), (0, 0, 0, 0))
    d = ImageDraw.Draw(img, "RGBA")
    glow, gd = glow_layer(img.size)
    gd.polygon([(128, 18), (208, 128), (128, 230), (48, 128)], fill=(60, 220, 255, 70))
    glow = glow.filter(ImageFilter.GaussianBlur(12))
    img.alpha_composite(glow)
    polygon(d, [(128, 18), (208, 128), (128, 230), (48, 128)], (210, 217, 220, 255), (116, 238, 255, 255), 4)
    polygon(d, [(128, 54), (166, 128), (128, 184), (90, 128)], (36, 42, 48, 255), (255, 255, 255, 180), 2)
    draw_engine(d, 128, 213, 13, (56, 224, 255, 230))
    return img


def make_elite() -> Image.Image:
    img = Image.new("RGBA", (512, 512), (0, 0, 0, 0))
    d = ImageDraw.Draw(img, "RGBA")
    pts = [(250, 42), (390, 102), (458, 246), (392, 440), (254, 396), (126, 456), (58, 246), (124, 88)]
    polygon(d, pts, (65, 48, 36, 255), (214, 102, 50, 255), 6)
    for box in [(96, 180, 202, 266), (300, 166, 420, 270), (194, 252, 314, 350)]:
        d.rectangle(box, fill=(92, 57, 39, 255), outline=(35, 24, 18, 255), width=4)
    d.ellipse((218, 184, 294, 260), fill=(255, 112, 39, 210), outline=(255, 210, 96, 230), width=4)
    for x in [126, 386]:
        d.rectangle((x - 18, 290, x + 18, 424), fill=(42, 35, 30, 255), outline=(170, 81, 38, 230), width=3)
    return img


def make_boss(phase: int) -> Image.Image:
    img = Image.new("RGBA", (2048, 1024), (0, 0, 0, 0))
    d = ImageDraw.Draw(img, "RGBA")
    hull = [(168, 426), (420, 196), (760, 248), (1004, 136), (1428, 232), (1860, 420), (1690, 746), (1180, 830), (864, 746), (482, 862), (230, 654)]
    fill = (45, 36, 30, 255) if phase == 1 else (56, 39, 31, 255)
    polygon(d, hull, fill, (156, 92, 55, 255), 12)
    random.seed(phase)
    for _ in range(28):
        x = random.randint(260, 1720)
        y = random.randint(260, 740)
        w = random.randint(90, 220)
        h = random.randint(34, 90)
        d.rectangle((x, y, x + w, y + h), fill=(34 + random.randint(0, 35), 32, 30, 235), outline=(112, 78, 56, 210), width=3)
    for x in [520, 710, 1390, 1580]:
        d.ellipse((x - 46, 650, x + 46, 742), outline=(95, 226, 255, 180), width=8)
    core_color = (95, 20, 14, 255) if phase == 1 else ((255, 206, 82, 245) if phase == 2 else (255, 255, 214, 255))
    core_r = 70 if phase == 1 else (102 if phase == 2 else 132)
    d.ellipse((1024 - core_r, 482 - core_r, 1024 + core_r, 482 + core_r), fill=core_color, outline=(255, 95, 52, 255), width=9)
    if phase >= 2:
        for x1, y1, x2, y2 in [(830, 340, 1180, 650), (1220, 294, 1510, 628), (550, 344, 750, 690)]:
            d.line((x1, y1, x2, y2), fill=(255, 188, 83, 220), width=10)
    if phase == 3:
        for x in [760, 890, 1180, 1300]:
            d.ellipse((x - 42, 620, x + 42, 690), fill=(58, 206, 255, 160), outline=(180, 246, 255, 220), width=5)
    return img


def make_bg() -> Image.Image:
    w, h = 2048, 1152
    img = Image.new("RGB", (w, h), (3, 5, 12))
    d = ImageDraw.Draw(img, "RGBA")
    random.seed(42)
    for _ in range(700):
        x, y = random.randrange(w), random.randrange(h)
        c = random.randint(80, 230)
        d.point((x, y), fill=(c, c, c, random.randint(80, 230)))
    for cx, cy, r, col in [(460, 310, 520, (80, 18, 26, 80)), (1510, 720, 640, (12, 68, 92, 70)), (1060, 530, 800, (35, 24, 60, 55))]:
        for i in range(22, 0, -1):
            a = int(col[3] * i / 22)
            d.ellipse((cx - r*i/22, cy - r*i/22, cx + r*i/22, cy + r*i/22), fill=(*col[:3], a))
    for _ in range(42):
        x, y = random.randint(80, w - 260), random.randint(80, h - 120)
        length = random.randint(100, 360)
        d.line((x, y, x + length, y + random.randint(-40, 40)), fill=(82, 96, 100, 130), width=random.randint(3, 9))
        d.rectangle((x + length//3, y - 8, x + length//3 + 80, y + 8), fill=(105, 72, 58, 90))
    return img


def make_laser_core() -> Image.Image:
    img = Image.new("RGBA", (512, 512), (0, 0, 0, 0))
    d = ImageDraw.Draw(img, "RGBA")
    for width, alpha in [(150, 25), (98, 45), (54, 90), (22, 210)]:
        d.rounded_rectangle((256 - width//2, 12, 256 + width//2, 500), radius=width//3, fill=(64, 236, 255, alpha))
    d.rectangle((248, 4, 264, 508), fill=(255, 255, 255, 245))
    return img.filter(ImageFilter.GaussianBlur(0.4))


def make_explosion() -> Image.Image:
    img = Image.new("RGBA", (512, 512), (0, 0, 0, 0))
    d = ImageDraw.Draw(img, "RGBA")
    random.seed(8)
    for _ in range(60):
        a = random.random() * math.tau
        r = random.randint(20, 220)
        x = 256 + math.cos(a) * r
        y = 256 + math.sin(a) * r
        d.line((256, 256, x, y), fill=(255, random.randint(86, 210), 32, random.randint(80, 190)), width=random.randint(2, 8))
    for r, col in [(180, (255, 78, 18, 70)), (112, (255, 150, 42, 150)), (54, (255, 240, 180, 230))]:
        d.ellipse((256 - r, 256 - r, 256 + r, 256 + r), fill=col)
    return img.filter(ImageFilter.GaussianBlur(1.2))


def main() -> None:
    ensure_dirs()
    assets = {
        OUT / "player" / "sf_ch01_player_alice_top_512.png": make_alice(),
        OUT / "player" / "sf_ch01_player_bob_top_512.png": make_bob(),
        OUT / "player" / "sf_ch01_player_charlie_top_512.png": make_charlie(),
        OUT / "enemy" / "sf_ch01_enemy_rebel_skiff_a_256.png": make_rebel_skiff(),
        OUT / "enemy" / "sf_ch01_enemy_empire_drone_a_256.png": make_empire_drone(),
        OUT / "enemy" / "sf_ch01_enemy_rebel_elite_salvager_512.png": make_elite(),
        OUT / "boss" / "sf_ch01_boss_stitched_carrier_phase01_2048.png": make_boss(1),
        OUT / "boss" / "sf_ch01_boss_stitched_carrier_phase02_damaged_2048.png": make_boss(2),
        OUT / "boss" / "sf_ch01_boss_stitched_carrier_phase03_core_2048.png": make_boss(3),
        OUT / "bg" / "sf_ch01_bg_sector_a_scrapyard_2048x1152.png": make_bg(),
        OUT / "fx" / "sf_ch01_fx_laser_core_512.png": make_laser_core(),
        OUT / "fx" / "sf_ch01_fx_explosion_spark_512.png": make_explosion(),
    }
    for path, img in assets.items():
        save_rgba(img, path)
        print(path.relative_to(ROOT))


if __name__ == "__main__":
    main()
