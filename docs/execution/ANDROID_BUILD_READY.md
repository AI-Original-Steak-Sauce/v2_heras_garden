# Android Build Precursors

**Date Created:** 2025-12-30
**Status:** Configuration Complete - Build Pending

This document tracks the setup completed for future Android APK builds and remaining prerequisites.

---

## Configuration Complete

### 1. Export Presets (`export_presets.cfg`)

Created export preset templates for:
- **Android Debug** - `exports/circes_garden_debug.apk`
- **Android Release** - `exports/circes_garden_release.apk`
- **Windows** - `exports/CircesGarden.exe`

### 2. Project Settings (`project.godot`)

Added `[android]` section with:
- Package name: `com.yourname.circesgarden`
- Min SDK: 24 (Android 7.0)
- Target SDK: 34 (Android 14)
- Landscape orientation
- Immersive mode enabled
- Keep screen on

---

## Android Build Environment Setup

**Status:** Requires manual setup (needs admin privileges)

### Option 1: Automated Setup (Recommended)

Run the setup script **as Administrator**:

```powershell
# Open PowerShell as Administrator, then run:
cd "C:\Users\Sam\Documents\GitHub\v2_heras_garden"
.\tools\setup_android_build.cmd
```

### Option 2: Manual Setup

If the automated script doesn't work, install manually:

| Software | Download URL | Installation Notes |
|----------|--------------|-------------------|
| OpenJDK 17 | https://aka.ms/download-jdk/microsoft-jdk-17.0.17-windows-x64.msi | Run MSI as Administrator |
| Android SDK | `winget install Google.AndroidSDK` | Or download Android Studio |
| Godot Templates | In Godot: Editor → Manage Export Templates | Download v4.5.1 |

### Environment Variables (Set After Installation)

Run these in PowerShell (Admin):

```powershell
# Set JAVA_HOME
[Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Microsoft\jdk\jdk-17.0.17.10-hotspot", "Machine")

# Set ANDROID_HOME
[Environment]::SetEnvironmentVariable("ANDROID_HOME", "C:\Users\$env:USERNAME\AppData\Local\Android\Sdk", "Machine")

# Add to PATH
$env:PATH = "$env:JAVA_HOME\bin;$env:ANDROID_HOME\cmdline-tools\latest\bin;$env:ANDROID_HOME\platform-tools;$env:PATH"
```

### Verification Commands

After setup, verify with:

```powershell
# Check Java
java -version
# Should show: openjdk version "17.0.x"

# Check Android SDK
sdkmanager --version
# Should show version number

# Check environment
echo $env:JAVA_HOME
echo $env:ANDROID_HOME
```

### Common Issues

| Issue | Solution |
|-------|----------|
| "java not recognized" | Restart terminal after installation |
| "sdkmanager not found" | Add Android SDK to PATH manually |
| Godot "Export templates not found" | Download via Editor → Manage Export Templates |
| UAC prompt blocked | Run installer manually as Administrator |

### Godot Editor Configuration

1. **Download Export Templates:**
   - Open Godot 4.5.1
   - Editor → Manage Export Templates
   - Download and install v4.5.1 templates

2. **Set Android SDK Path:**
   - Editor → Editor Settings → Export → Android
   - Set `Android SDK Path` to your SDK location

3. **Import Export Presets:**
   - Project → Export
   - The `export_presets.cfg` should auto-load
   - Configure signing key (for release builds)

---

## Package Name Configuration

**Current:** `com.yourname.circesgarden`

**Before Release Build,** update to your actual package name:
- Reverse domain format: `com.yourname.circesgarden`
- Edit in `project.godot` line 108

---

## Signing Keys (Release Build)

For release APK, you need a keystore file:

```bash
# Generate release keystore (run once, save securely)
keytool -genkeypair -v -storetype PKCS12 -keyalg RSA -keysize 2048 \
  -validity 10000 -keystore circes_garden.keystore \
  -alias circesgarden -storepass YOUR_PASSWORD -keypass YOUR_PASSWORD
```

**Store this keystore securely** - required for all future updates.

---

## Build Commands (Future)

Once prerequisites are installed:

```powershell
# Debug build
.\Godot_v4.5.1-stable_win64.exe --headless --export-release "Android Debug"

# Or use Godot editor:
# Project → Export → Android Debug → Export Project
```

---

## Current Game Status

**Phases Complete:**
- Phase 0-6.5: Core systems, playability, visual polish, visual fixes
- **Total Tests:** 123/123 passing

**Remaining Work Before Android Build:**
See `docs/execution/ANDROID_BUILD_GAMEWORK.md` for complete list.

---

## Quick Start Checklist (When Ready)

- [ ] Install OpenJDK 17+
- [ ] Install Android SDK
- [ ] Set ANDROID_HOME environment variable
- [ ] Download Godot 4.5.1 export templates
- [ ] Open Godot → Export → Verify Android preset loads
- [ ] Generate/release keystore for signing
- [ ] Build debug APK
- [ ] Test on Retroid Pocket Classic
- [ ] Fix any issues
- [ ] Build release APK
- [ ] Install on device
