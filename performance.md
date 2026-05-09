# Performance Guide — Maximising Render Farm Speed

## Network Bandwidth

### Use Ethernet, Not WiFi
WiFi introduces latency and packet loss that slows file transfers between machines.
- Connect both machines to your router via ethernet cable
- Gigabit ethernet (1Gbps) is ideal — standard on most modern routers and motherboards
- Even 100Mbps ethernet is significantly more reliable than WiFi for render farm use

### Check Your Network Speed
Run this between machines to test actual throughput:
```
# On the receiving machine, note how fast large files copy:
robocopy \\[MANAGER-IP]\BlenderFarm C:\SpeedTest /E /NP
```
Aim for 50MB/s+ on a gigabit network.

---

## GPU vs CPU Rendering

### Enable GPU Rendering on Both Machines
By default Blender may use CPU. Force GPU for dramatically faster renders:
- Edit → Preferences → System → Cycles Render Devices
- Select your GPU (CUDA for Nvidia, HIP for AMD, Metal for Apple)
- In Render Properties → Device → select GPU Compute

### Check GPU is Actually Being Used
In the task log you should see your GPU name during rendering, not "CPU".

---

## Cycles Sample Count

For farm rendering, balance quality vs speed:
- **Test renders:** 32-64 samples — quick feedback
- **Final renders:** 128-512 samples depending on scene complexity
- **Denoising:** Enable Intel OIDN or OptiX denoising — lets you use fewer samples with similar quality

---

## Tile Size

Blender 3.0+ handles tile size automatically. Leave it on Auto unless you have a specific reason to change it.

---

## Worker Sleep Schedules

In the Flamenco dashboard → Workers → click a worker → Sleep Schedule:
- Set workers to sleep during hours you use the machines
- Wake them up automatically overnight for batch renders
- Useful if one machine is your daily workstation

---

## Frame Distribution

Flamenco distributes frames across workers automatically. For a 300 frame animation with 2 workers:
- Worker 1 renders odd frames
- Worker 2 renders even frames
- Both finish roughly simultaneously

For maximum efficiency, ensure both machines have similar GPU performance. A fast machine paired with a slow one will be bottlenecked by the slower worker on the final frames.

---

## Shared Storage Performance

The shared folder on the manager machine is accessed by the worker over the network. To maximise performance:
- Keep `C:\BlenderFarm` on an SSD, not a spinning HDD
- Ensure the share has Full Control permissions — read-only causes silent failures
- Avoid OneDrive or cloud sync on the BlenderFarm folder — it causes file locking issues

---

## Multiple Workers Per Machine

If you have a machine with multiple GPUs you can run multiple worker instances, each targeting a different GPU. See the Flamenco FAQ for details on configuring this.

---

## Auto-Start on Boot

To avoid manually starting manager and workers after a reboot:

### Method 1 — Startup Folder
1. Press Win+R → type `shell:startup`
2. Copy shortcuts to `start-manager.bat` and `start-worker.bat` into that folder
3. They'll run automatically when Windows starts

### Method 2 — Task Scheduler (runs before login)
1. Open Task Scheduler
2. Create Basic Task → set trigger to "At startup"
3. Action: Start a program → browse to the .bat file
4. Tick "Run with highest privileges"

Method 2 is more reliable for headless/always-on render machines.
