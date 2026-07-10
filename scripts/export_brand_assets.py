"""Export Haven brand assets as PNG from geometric spec.

Run: python scripts/export_brand_assets.py
"""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
LOGO_DIR = ROOT / "assets" / "brand" / "logo" / "png"
ICON_DIR = LOGO_DIR / "icon-only"
APP_ICON_DIR = ROOT / "assets" / "brand" / "app-icon"

PRIMARY = (0x1D, 0x54, 0x4E)
PRIMARY_DARK = (0x14, 0x3D, 0x39)
WHITE = (0xFF, 0xFF, 0xFF)
BLACK = (0x00, 0x00, 0x00)

SIZES = [1024, 512, 256, 128, 64, 32, 16]


def draw_h_icon(size: int, color: tuple[int, int, int], bg: tuple[int, int, int] | None = None) -> Image.Image:
    """Draw the Hidden Compass H icon at the given pixel size."""
    img = Image.new("RGBA", (size, size), (*bg, 255) if bg else (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    unit = size / 50.0
    rx = max(1, int(unit * 4))

    def rect(x: float, y: float, w: float, h: float) -> None:
        draw.rounded_rectangle(
            [x * unit, y * unit, (x + w) * unit, (y + h) * unit],
            radius=rx,
            fill=color,
        )

    # Vertical bars (2X wide, full height)
    rect(0, 0, 20, 50)
    rect(30, 0, 20, 50)

    # Compass needle (diamond pointing north)
    cx, cy = 25 * unit, 25 * unit
    r = 7 * unit
    draw.polygon(
        [(cx, cy - r), (cx + r, cy), (cx, cy + r), (cx - r, cy)],
        fill=color,
    )

    return img


def save_icon_variants() -> None:
    ICON_DIR.mkdir(parents=True, exist_ok=True)
    for size in SIZES:
        icon = draw_h_icon(size, PRIMARY)
        icon.save(ICON_DIR / f"haven-icon-{size}.png")


def save_app_icons() -> None:
    APP_ICON_DIR.mkdir(parents=True, exist_ok=True)

    configs = [
        ("icon-light", PRIMARY, WHITE, 1024),
        ("icon-light", PRIMARY, WHITE, 512),
        ("icon-light", PRIMARY, WHITE, 180),
        ("icon-dark", WHITE, PRIMARY_DARK, 1024),
        ("icon-dark", WHITE, PRIMARY_DARK, 192),
        ("icon-mono", WHITE, BLACK, 1024),
        ("icon-mono", WHITE, BLACK, 32),
    ]

    for name, fg, bg, size in configs:
        icon = draw_h_icon(int(size * 0.55), fg)
        canvas = Image.new("RGBA", (size, size), (*bg, 255))
        offset = (size - icon.width) // 2
        canvas.paste(icon, (offset, offset), icon)
        canvas.save(APP_ICON_DIR / f"{name}-{size}.png")


def main() -> None:
    save_icon_variants()
    save_app_icons()
    print(f"Exported icon PNGs to {ICON_DIR}")
    print(f"Exported app icons to {APP_ICON_DIR}")


if __name__ == "__main__":
    main()
