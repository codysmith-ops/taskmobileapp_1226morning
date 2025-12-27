# Cloud Backup Guide

## 📦 Project Backup Status

Your project is automatically backed up to:
- **iCloud Drive**: `~/Library/Mobile Documents/com~apple~CloudDocs/Projects/taskmobileapp_1226morning/`
- **Google Cloud Storage**: `gs://taskmobileapp-backup/`

## 🚀 Quick Backup

Run the automated backup script:

```bash
./backup-to-cloud.sh
```

This will:
1. ✅ Sync to iCloud Drive (instant sync)
2. ✅ Create timestamped archive and upload to GCS
3. ✅ Sync current state to GCS for easy browsing

## ☁️ Google Cloud Setup

### Already Configured:
- ✅ Google Cloud SDK installed
- ✅ Authenticated as: cody.c.smith91@gmail.com
- ✅ Backup script created

### First Time Backup:
```bash
# Run the backup script
./backup-to-cloud.sh
```

The script will create a GCS bucket: `gs://taskmobileapp-backup`

## 📁 What Gets Backed Up

**Included:**
- All source code (`src/`, `App.tsx`, etc.)
- Configuration files (`package.json`, `tsconfig.json`, etc.)
- Documentation (`.md` files)
- iOS project files (`ios/*.xcodeproj`, `Podfile`)
- Scripts and build configurations

**Excluded (to save space):**
- `node_modules/` (1056 packages - 500MB+)
- `ios/Pods/` (60 pods - 200MB+)
- `ios/build/` (build artifacts - 300MB+)
- `android/build/` (if present)
- `.git/` (GitHub is already backing this up)
- `*.log` files

## 🔄 Restore from Backup

### From iCloud:
```bash
# Files are already synced to iCloud Drive
# Just access them from Finder or copy back:
cp -r ~/Library/Mobile\ Documents/com~apple~CloudDocs/Projects/taskmobileapp_1226morning/ ./restored-project/
cd restored-project
npm install  # Reinstall dependencies
cd ios && pod install  # Reinstall pods
```

### From Google Cloud:
```bash
# List available backups
gcloud storage ls gs://taskmobileapp-backup/

# Download specific archive
gcloud storage cp gs://taskmobileapp-backup/taskmobileapp_backup_YYYYMMDD_HHMMSS.tar.gz .
tar -xzf taskmobileapp_backup_YYYYMMDD_HHMMSS.tar.gz

# Or sync current state
gcloud storage rsync --recursive gs://taskmobileapp-backup/current/ ./restored-project/

# Reinstall dependencies
cd restored-project
npm install
cd ios && pod install
```

## 🔐 Security & Access

### iCloud:
- Automatic encryption in transit and at rest
- Accessible from any Mac signed into your Apple ID
- 5GB free (or iCloud+ storage plan)

### Google Cloud Storage:
- Private bucket (only you can access)
- Encrypted at rest by default
- Versioning enabled (keeps historical copies)
- Pay-as-you-go pricing (~$0.02/GB/month)

## 📊 Backup Size Estimate

- **Full project**: ~1.2GB (with node_modules, Pods, build)
- **Smart backup**: ~50MB (source code only)
- **iCloud sync**: ~50MB (excludes dependencies)
- **GCS archive**: ~50MB compressed

## ⚙️ Automated Backups

### Option 1: Manual (Recommended)
Run before major changes:
```bash
./backup-to-cloud.sh
```

### Option 2: Scheduled (macOS Launchd)
Create `~/Library/LaunchAgents/com.user.backup.plist`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.backup</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/codysmith/taskmobileapp_1226morning/backup-to-cloud.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>22</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
</dict>
</plist>
```

Load the schedule:
```bash
launchctl load ~/Library/LaunchAgents/com.user.backup.plist
```

## 🆘 Troubleshooting

### iCloud Not Syncing:
```bash
# Check iCloud status
ls -la ~/Library/Mobile\ Documents/com~apple~CloudDocs/

# Force sync
killall bird  # Restart iCloud sync daemon
```

### Google Cloud Authentication:
```bash
# Re-authenticate
gcloud auth login

# Set project (if needed)
gcloud config set project YOUR_PROJECT_ID
```

### Bucket Already Exists:
If `gs://taskmobileapp-backup` is taken, edit the script and change:
```bash
GCS_BUCKET="gs://taskmobileapp-backup-YOUR_UNIQUE_SUFFIX"
```

## 📝 Notes

- iCloud backup runs continuously in the background
- GCS backups are timestamped archives (won't overwrite)
- Git commits are still the primary version control
- Cloud backups are disaster recovery (hardware failure, accidental deletion)
- Keep at least 3 backups: Local + iCloud + Google Cloud ✅

## 🔗 Resources

- [Google Cloud Storage Pricing](https://cloud.google.com/storage/pricing)
- [iCloud Storage Plans](https://support.apple.com/en-us/HT201238)
- [Backup Best Practices](https://en.wikipedia.org/wiki/Backup#3-2-1_rule)

---

**Last Updated**: December 27, 2025
**Backup Script**: [backup-to-cloud.sh](./backup-to-cloud.sh)
