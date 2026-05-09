# GitHub Repo Blurb

## Short Description (used in the "About" section — 350 chars max)

Complete setup guide, pre-configured files and scripts for running a Flamenco 3.9 render farm on Windows 11 Pro with Blender 5.1. Fixes GPO firewall blocks, missing manifest errors, working directory issues and yaml timeouts. Everything the official docs don't tell you.

---

## Topics / Tags (paste these into the Topics field on GitHub)

blender, flamenco, render-farm, windows-11, blender-5, cycles, network-rendering, windows-11-pro, blender-addon, render-pipeline, 3d-rendering, visual-effects, animation, home-studio

---

## Full Repository Description (for the README header or GitHub repo description tab)

Setting up Flamenco on Windows 11 Pro with Blender 5.1 should take an afternoon. Instead it takes a day of fighting Group Policy firewalls that silently ignore your rules, a missing manifest file that breaks addon installation, a working directory bug that makes Blender think your files don't exist, and a setup wizard that cheerfully overwrites your config every time it runs.

This repository documents every one of those problems and provides ready-to-use fixes so you don't have to rediscover them yourself.

It was built from a real world setup session — two Windows 11 Pro machines, fresh installs, local network, Blender 5.1.1, Flamenco 3.9. Every issue in this repo was actually hit, debugged and solved. Nothing is theoretical.

---

## What's Included

| File | What it does |
|---|---|
| `config/blender_manifest.toml` | Fixes the "missing manifest" error on Blender 5.1 |
| `config/flamenco-manager.yaml` | Pre-configured manager with port 80, 120min timeouts, correct paths |
| `scripts/start-manager.bat` | One-click manager startup with correct working directory |
| `scripts/start-worker.bat` | One-click worker startup — edit your manager IP and go |
| `docs/addon-installation.md` | Step by step Blender 5.1 addon installation guide |
| `docs/performance.md` | GPU rendering, ethernet, bandwidth and auto-start tips |

---

## Social / Forum Post Version (for Blender Artists, Reddit r/blender, etc.)

**Finally got Flamenco 3.9 working on Windows 11 Pro with Blender 5.1 — here's everything that went wrong and how to fix it**

After a full day of debugging I've put together a GitHub repo with pre-configured files and a complete troubleshooting guide for anyone trying to set up a Flamenco render farm on Windows 11 Pro with Blender 5.1.

The main issues we hit that aren't documented anywhere:

- **Blender 5.1 won't install the Flamenco addon** — the new extensions platform requires a `blender_manifest.toml` that Flamenco 3.9 doesn't include. Repo includes the fix.
- **Port 8080 is silently blocked on Windows 11 Pro** — Group Policy overrides local firewall rules completely. Switching to port 80 bypasses this entirely.
- **"File not found" errors despite the file being there** — Flamenco uses a relative working directory. Running the manager from the wrong folder breaks everything.
- **Config resets on every restart** — The setup wizard overwrites your yaml. Repo includes a pre-configured template to restore settings quickly.

Repo: [link]

Hope it saves someone a day of pain.
