# Installing the Flamenco Addon on Blender 5.1

Blender 5.1 introduced a new extensions platform that is incompatible with legacy addons that lack a `blender_manifest.toml` file. The Flamenco 3.9 addon does not include this file, causing a "missing manifest" error on installation.

## Fix

### Step 1 — Download the correct addon

Download the addon from your **running Flamenco Manager dashboard**, not from the Flamenco website zip.

- Open browser → `http://[MANAGER-IP]`
- Top right corner → click **add-on**
- Save the downloaded zip

### Step 2 — Create the extensions folder

Navigate to (enable hidden files in File Explorer first — View → Show → Hidden items):

```
C:\Users\[YOUR USERNAME]\AppData\Roaming\Blender Foundation\Blender\5.1\extensions\user_default\
```

Create a new folder called exactly: `flamenco` (all lowercase)

### Step 3 — Extract the addon

Extract the contents of the addon zip into the `flamenco` folder.

Do NOT extract the zip itself — extract the contents inside it.

### Step 4 — Add the manifest

Copy `blender_manifest.toml` from this repo's `config/` folder into the same `flamenco` folder.

Your folder should now contain:
```
flamenco\
├── blender_manifest.toml    ← from this repo
├── __init__.py
├── comms.py
├── dependencies.py
├── gui.py
├── job_submission.py
├── job_types.py
├── job_types_propgroup.py
├── manager\
├── wheels\
├── bat\
└── [other files...]
```

### Step 5 — Enable in Blender

- Restart Blender
- Edit → Preferences → Add-ons
- Search for Flamenco
- Tick the checkbox to enable it
- Restart Blender again

### Step 6 — Configure

- Edit → Preferences → Add-ons → Flamenco
- Set Manager URL to: `http://[MANAGER-IP]` (no port needed if using port 80)
- Click the refresh button next to the URL
- Should show "Flamenco version 3.9 found"

### Step 7 — Find the panel

The Flamenco panel is in **Output Properties** (printer icon in the Properties panel), NOT in Render Properties. Scroll down to find it.

---

## Common Errors

**"Missing manifest"** — The `blender_manifest.toml` is missing or in the wrong location. Check Step 4.

**"Manager not reachable"** — The manager isn't running, or the URL/port is wrong. Ensure `flamenco-manager.exe` is running and the URL matches.

**Panel not visible** — Check Output Properties (printer icon), not Render Properties. Also ensure the addon is enabled and Blender has been restarted.
