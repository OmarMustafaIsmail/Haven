"""Trace reference logo PNG to SVG using potrace."""

from __future__ import annotations

from pathlib import Path

import potrace
from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
REFERENCE = ROOT / "assets" / "brand" / "logo" / "reference" / "icon-mono-1024.png"
OUTPUT = ROOT / "assets" / "brand" / "logo" / "haven-icon-only.svg"


def trace_bitmap(src: Path, fill: str = "currentColor") -> str:
    img = Image.open(src).convert("L")
    bbox = img.getbbox()
    if not bbox:
        raise ValueError(f"No content in {src}")
    img = img.crop(bbox)
    w, h = img.size

    bitmap = potrace.Bitmap(img)
    path = bitmap.trace(
        turdsize=2,
        turnpolicy=potrace.POTRACE_TURNPOLICY_MINORITY,
        alphamax=0.8,
        opticurve=True,
        opttolerance=0.2,
    )

    parts: list[str] = []
    for curve in path:
        start = curve.start_point
        d = f"M {start.x:.3f} {start.y:.3f}"
        for segment in curve:
            if segment.is_corner:
                d += (
                    f" L {segment.c.x:.3f} {segment.c.y:.3f}"
                    f" L {segment.end_point.x:.3f} {segment.end_point.y:.3f}"
                )
            else:
                d += (
                    f" C {segment.c1.x:.3f} {segment.c1.y:.3f}"
                    f" {segment.c2.x:.3f} {segment.c2.y:.3f}"
                    f" {segment.end_point.x:.3f} {segment.end_point.y:.3f}"
                )
        d += " Z"
        parts.append(d)

    return f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" fill="none">
  <path d="{' '.join(parts)}" fill="{fill}"/>
</svg>
"""


def main() -> None:
    svg = trace_bitmap(REFERENCE, fill="#1D544E")
    OUTPUT.write_text(svg, encoding="utf-8")
    print(f"Traced {REFERENCE.name} -> {OUTPUT}")


if __name__ == "__main__":
    main()
