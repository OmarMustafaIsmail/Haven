# Figma Logo Export Guide

**Source file:** [Haven Brand Assets](https://www.figma.com/design/qJe22LWuxcsQ0bcLxg0eov/Haven-Brand-Assets)

This is the master source for all Haven logo assets. Do not use AI-generated or traced logos.

---

## Figma structure

| Node ID | Name | Export as |
|---|---|---|
| `2:5` | Logo/ H primary (component) | `haven-icon-primary.svg` |
| `2:6` | Logo/ H light (instance) | `haven-icon-light.svg` |
| `2:8` | Logo/ H dark (instance) | `haven-icon-dark.svg` |
| `2:16` | App logo (1024×1024 frame) | `icon-light-1024.png` |
| `2:2` | Master Logo (reference frame) | Optional reference PNG |

Light and dark instances override the primary component — export instances, not just the component, to capture color variants.

---

## Option A — Automated (recommended)

1. Create a [Figma personal access token](https://www.figma.com/developers/api#access-tokens)
2. Run:

```powershell
$env:FIGMA_TOKEN = "your-token-here"
python scripts/figma_export_logos.py
```

3. Review files in `assets/brand/logo/` and `assets/brand/app-icon/`

---

## Option B — Manual export from Figma

### SVG (icon)

1. Select **Logo/ H primary** (`2:5`) → Export → SVG → `haven-icon-primary.svg`
2. Select **Logo/ H light** instance (`2:6`) → Export → SVG → `haven-icon-light.svg`
3. Select **Logo/ H dark** instance (`2:8`) → Export → SVG → `haven-icon-dark.svg`

Save to `assets/brand/logo/`

### PNG (app icon)

1. Select **App logo** frame (`2:16`) → Export → PNG 1x → `icon-light-1024.png`
2. Copy to `assets/brand/app-icon/`

### PNG (icon sizes)

Select **Logo/ H primary** → Add export presets:

| Scale | Output height | Filename |
|---|---|---|
| 1x | ~253px | `haven-icon-256.png` (resize in script) |
| 4x | ~1024px | `haven-icon-1024.png` |

Or use the automated script for all sizes.

---

## After export

1. Replace old AI-generated files in `assets/brand/logo/`
2. Update `pubspec.yaml` assets if using in Flutter
3. Lock logo source in `PRODUCT_DECISIONS.md` once verified

---

## Next HDL milestone

Once logos are in the repo → **HDL/08 Typography**
