# 34tools: Delete Nearest Marker

**Line:** 34tools Edit  
**Category:** Editing Utility / Markers

## Overview
A tiny REAPER Lua action that deletes the **nearest project marker** (not a region) to the **edit cursor**.  
“Nearest” is measured by absolute distance: `abs(marker_pos - cursor_pos)`.

## Features
- Deletes the nearest **marker** to the edit cursor
- **Ignores regions**
- Safe no-op if there are no markers in the project
- Undo-friendly (single undo step)

## Who is it for
- Podcast editors and dialogue editors
- Anyone who works with dense marker layouts and wants a quick “delete nearest marker” hotkey

## Installation
1. Download the script: `34tools_DeleteNearestMarker_v1.0.0.lua`
2. In REAPER: **Actions → Show action list…**
3. Click **ReaScript → Load…** and select the script file
4. Find the loaded action in the list and assign a shortcut via **Add…** in *Shortcuts for selected action*

## License
MIT — see `LICENSE`.
