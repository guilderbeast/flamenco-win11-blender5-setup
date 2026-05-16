!{License: GPL
⚠️ VERSION COMPATIBILITY ALERT.
⚠️ VERSION & PROTOCOL COMPATIBILITY ALERT
Please check your Blender MCP add-on version before setting up this pipeline. Google search results frequently point users toward older, high-traffic forks (such as the ahujasid repository) which utilize different communication logic.

The Trap: Older or alternative versions (like v1.2) rely on watching local JSON folder structures or complex file exchanges. If you use those with this script, Blender will remain silent.

The Reality: The current official stable fallback is Blender MCP v1.0.0, which acts as a pure network listener.

Why this Pipeline Uses Sockets
To bypass the file-locking "race conditions" common in Windows 11 and ensure instant execution, Open Conduit avoids folder-watching middle-men. Instead, our script utilizes a Socket Teleportation method to push Python scripts directly to Blender over a local network port:

[ Your Prompt ] 
       │
       ▼
 [ Ollama (Brain) ] ─► Generates raw bpy code
       │
       ▼
 [ Wizard Script ]  ─► Cleans code & opens a network socket
       │
       ▼
 [ Blender MCP 1.0.0 ] ◄─ Listens on localhost:9876
       │
       ▼
( 3D Viewport Object Spawns Instantly! )
Make sure your Blender add-on is set to version 1.0.0, hit "Start MCP Server" (Port 9876), and you are ready to drop text files into your inbox.
v3}(https://img.shields.io/badge/License-GPLv3-blue.svg)
# Flamenco 3.9 + Blender 5.1 on Windows 11 Pro — Complete Setup Guide

> A battle-tested guide for setting up a local Blender render farm using Flamenco 3.9 on Windows 11 Pro. Every problem documented here was hit in the real world so you don't have to.
This tool is a part of the Open Conduit project—an open-source charity mission. Watch the setup guide here:https://youtu.be/_4os3ZGyDf4
---

## What This Solves

The official Flamenco docs assume a clean Linux environment. Windows 11 Pro introduces several obstacles that aren't documented anywhere:

- Blender 5.1's new extension system breaks the Flamenco addon (missing manifest error)
- Windows 11 Pro GPO blocks local firewall rules silently
- Flamenco uses a relative working directory causing "file not found" errors
- The setup wizard overwrites your yaml changes on every restart
- Port 8080 may be blocked by GPO even when firewall rules are set correctly

This repo provides ready-made fixes for all of the above.

---

## Requirements

- Two machines running Windows 11 Pro on the same local network
- Blender 5.1.x installed on both machines (must match exactly)
- Flamenco 3.9 downloaded from flamenco.blender.org
- Python 3.x installed on both machines (python.org — tick "Add to PATH"!)

---

## Quick Start

### 1. Folder Structure

Create this on BOTH machines:

```
C:\BlenderFarm\
├── flamenco-3.9-windows-amd64\    ← extract Flamenco here
├── flamenco-manager-storage\      ← auto-created by manager
└── output\                        ← rendered frames go here
```

### 2. Share the Folder (Manager machine only)

Right-click `C:\BlenderFarm` → Properties → Sharing → Advanced Sharing:
- Tick "Share this folder"
- Share name: `BlenderFarm`
- Permissions: Full Control for your user

On the Worker machine, map it as a network drive:
- File Explorer → Right-click This PC → Map network drive
- Path: `\\[MANAGER-IP]\BlenderFarm`
- Also copy the `.blend` file to `C:\BlenderFarm` locally on the worker

### 3. Fix the Flamenco Addon for Blender 5.1

Blender 5.1 uses a new extensions platform that requires a manifest file. The Flamenco 3.9 addon doesn't include one.

**Step 1:** Download the addon from your running Flamenco Manager dashboard (top right → add-on link). Do NOT use the addon from the main Flamenco zip.

**Step 2:** Create this folder:
```
C:\Users\[USERNAME]\AppData\Roaming\Blender Foundation\Blender\5.1\extensions\user_default\flamenco\
```

**Step 3:** Extract the addon zip contents into that folder.

**Step 4:** Copy the included `blender_manifest.toml` from this repo into that same folder.

**Step 5:** Restart Blender → Edit → Preferences → Add-ons → enable Flamenco.

### 4. Fix the Port (Windows 11 Pro GPO Issue)

Windows 11 Pro GPO silently blocks local firewall rules. Port 8080 will not work regardless of what firewall rules you create.

**Solution:** Change Flamenco Manager to use port 80 instead.

Edit `C:\BlenderFarm\flamenco-3.9-windows-amd64\flamenco-manager.yaml`:
```yaml
listen: :80
```

See `config/flamenco-manager.yaml` in this repo for a complete pre-configured template.

**IMPORTANT:** Always run the manager from its own folder, not from `C:\BlenderFarm`:
```
cd C:\BlenderFarm\flamenco-3.9-windows-amd64
flamenco-manager.exe
```

### 5. Start Everything

Use the included batch scripts for reliable startup every time.

**On the Manager machine (run first):**
```
scripts\start-manager.bat
```

**On both machines (run after manager is up):**
```
scripts\start-worker.bat
```

Edit `start-worker.bat` to set your manager's IP address before running.

### 6. Auto-Start on Boot

Without auto-start, the Manager and Workers need to be manually launched every time 
a machine restarts. These startup scripts fix that permanently.

**On the Manager machine (laptop):**

Create `C:\BlenderFarm\startup-laptop.bat` containing:

```batch
cd C:\BlenderFarm\flamenco-3.9-windows-amd64
start flamenco-manager.exe
timeout /t 10
cd C:\BlenderFarm
flamenco-worker.exe -manager http://[YOUR-MANAGER-IP]
```

**On the Worker machine (desktop):**

Create `C:\BlenderFarm\startup-desktop.bat` containing:

```batch
cd C:\BlenderFarm
C:\BlenderFarm\flamenco-3.9-windows-amd64\flamenco-worker.exe -manager http://[YOUR-MANAGER-IP]
```

**Add to Windows startup on both machines:**
- Press **Win+R** → type `shell:startup` → Enter
- Right click the .bat file → Send to → Desktop (create shortcut)
- Cut the shortcut from Desktop and paste into the startup folder

Both machines will now automatically start their Flamenco roles on every boot.
Note: Blender does NOT need to be open — workers launch it headlessly when needed.
---

## Configuration

The pre-configured `config/flamenco-manager.yaml` includes:

- Port 80 (bypasses GPO firewall issues)
- 120 minute task timeout (essential for complex scenes)
- 10 minute worker timeout
- Correct absolute storage paths
- Blender 5.1 executable path

Copy it to `C:\BlenderFarm\flamenco-3.9-windows-amd64\flamenco-manager.yaml` and edit the paths to match your setup.

---

## Submitting Your First Render

1. Save your `.blend` file inside `C:\BlenderFarm\` with **no spaces in the filename**
2. Copy it to `C:\BlenderFarm\` on the worker machine as well
3. In Blender → Output Properties → set output path to `C:\BlenderFarm\output\`
4. In Blender → Output Properties → Flamenco section → set Manager URL to `http://[MANAGER-IP]`
5. Click **Refresh from Manager**
6. Select job type and click **Submit to Flamenco**

---

## Troubleshooting

| Problem | Cause | Fix |
|---|---|---|
| Missing manifest error | Blender 5.1 extension system | Add `blender_manifest.toml` from this repo |
| Port 8080 blocked | Windows 11 Pro GPO | Change to port 80 in yaml |
| "File not found" error | Wrong working directory | Run manager from its own subfolder |
| yaml changes not saved | Setup wizard overwrites yaml | Edit yaml after wizard, before restarting |
| Workers can't connect | Manager not running | Start manager before workers |
| Worker loses connection | Manager stopped | Keep manager CMD window open |
| Task timeout | Default 10min too short | Set task_timeout: 120m0s in yaml |
| LocalFirewallRules: N/A | GPO override | Switch to port 80, bypass firewall entirely |

---

## Performance Tips

See `docs/performance.md` for tips on maximising render speed across both machines including:
- GPU vs CPU rendering selection
- Network bandwidth optimisation
- Sample count tuning for farm rendering
- Tile size optimisation

---

## Contributing

If you hit a problem not covered here, please open an issue or PR. This guide exists because the existing documentation left too many Windows users stranded.

---

## License

MIT — use freely, credit appreciated.
