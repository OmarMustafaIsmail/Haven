"""Export Haven logo assets from Figma using the REST API.

Prerequisites:
  1. Figma personal access token: https://www.figma.com/developers/api#access-tokens
  2. Set environment variable: FIGMA_TOKEN

Usage:
  python scripts/figma_export_logos.py

Source file:
  https://www.figma.com/design/qJe22LWuxcsQ0bcLxg0eov/Haven-Brand-Assets
"""

from __future__ import annotations

import json
import os
import sys
import urllib.request
from pathlib import Path

FILE_KEY = "qJe22LWuxcsQ0bcLxg0eov"
ROOT = Path(__file__).resolve().parent.parent
LOGO_DIR = ROOT / "assets" / "brand" / "logo"
APP_ICON_DIR = ROOT / "assets" / "brand" / "app-icon"
ICON_PNG_DIR = LOGO_DIR / "png" / "icon-only"

# Node IDs discovered from Figma file structure
EXPORTS = [
    # SVG — icon variants
    ("2:5", "svg", 1, LOGO_DIR / "haven-icon-primary.svg"),
    ("2:6", "svg", 1, LOGO_DIR / "haven-icon-light.svg"),
    ("2:8", "svg", 1, LOGO_DIR / "haven-icon-dark.svg"),
    # PNG — app icon
    ("2:16", "png", 1, APP_ICON_DIR / "icon-light-1024.png"),
    # PNG — icon at multiple scales (from primary component)
    ("2:5", "png", 1, ICON_PNG_DIR / "haven-icon-1024.png"),
    ("2:5", "png", 0.5, ICON_PNG_DIR / "haven-icon-512.png"),
    ("2:5", "png", 0.25, ICON_PNG_DIR / "haven-icon-256.png"),
    ("2:5", "png", 0.125, ICON_PNG_DIR / "haven-icon-128.png"),
    ("2:5", "png", 0.0625, ICON_PNG_DIR / "haven-icon-64.png"),
    ("2:5", "png", 0.03125, ICON_PNG_DIR / "haven-icon-32.png"),
    ("2:5", "png", 0.015625, ICON_PNG_DIR / "haven-icon-16.png"),
]


def figma_request(url: str, token: str) -> dict:
    req = urllib.request.Request(url, headers={"X-Figma-Token": token})
    with urllib.request.urlopen(req) as resp:
        return json.loads(resp.read().decode())


def download_file(url: str, dest: Path) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    with urllib.request.urlopen(url) as resp:
        dest.write_bytes(resp.read())


def export_node(
    token: str, node_id: str, fmt: str, scale: float, dest: Path
) -> None:
    node_param = node_id.replace(":", "-")
    url = (
        f"https://api.figma.com/v1/images/{FILE_KEY}"
        f"?ids={node_param}&format={fmt}&scale={scale}"
    )
    data = figma_request(url, token)
    if data.get("err"):
        raise RuntimeError(data["err"])

    image_url = data["images"].get(node_param)
    if not image_url:
        raise RuntimeError(f"No image URL returned for {node_id}")

    download_file(image_url, dest)
    print(f"  ✓ {dest.relative_to(ROOT)}")


def main() -> None:
    token = os.environ.get("FIGMA_TOKEN")
    if not token:
        print("Error: Set FIGMA_TOKEN environment variable.")
        print("Get a token at: https://www.figma.com/developers/api#access-tokens")
        sys.exit(1)

    print(f"Exporting from Figma file {FILE_KEY}...")
    for node_id, fmt, scale, dest in EXPORTS:
        export_node(token, node_id, fmt, scale, dest)

    print("\nDone. Review exports in assets/brand/")


if __name__ == "__main__":
    main()
