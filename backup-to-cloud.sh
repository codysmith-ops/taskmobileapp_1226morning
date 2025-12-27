#!/bin/bash
# Automated Cloud Backup Script for MobileTodoList Project
# Backs up to both iCloud Drive and Google Cloud Storage

set -e

PROJECT_DIR="/Users/codysmith/taskmobileapp_1226morning"
ICLOUD_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Projects/taskmobileapp_1226morning"
GCS_BUCKET="gs://taskmobileapp-backup"  # You can change this bucket name
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

echo "🔄 Starting Cloud Backup - $TIMESTAMP"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 1. ICLOUD BACKUP
echo "📦 Backing up to iCloud Drive..."
mkdir -p "$ICLOUD_DIR"

rsync -av \
  --exclude='node_modules' \
  --exclude='ios/Pods' \
  --exclude='ios/build' \
  --exclude='ios/DerivedData' \
  --exclude='android/build' \
  --exclude='android/.gradle' \
  --exclude='.git' \
  --exclude='*.log' \
  --exclude='.DS_Store' \
  "$PROJECT_DIR/" "$ICLOUD_DIR/" \
  | grep -E "^(sent|total)" || true

echo "✅ iCloud backup complete: $ICLOUD_DIR"
echo ""

# 2. GOOGLE CLOUD STORAGE BACKUP
echo "☁️  Backing up to Google Cloud Storage..."

# Check if gcloud is authenticated
if ! gcloud auth list 2>&1 | grep -q "ACTIVE"; then
  echo "⚠️  Google Cloud SDK not authenticated."
  echo "   Run: gcloud auth login"
  echo "   Then re-run this script."
  exit 1
fi

# Create bucket if it doesn't exist (will fail gracefully if it exists)
gcloud storage buckets create "$GCS_BUCKET" \
  --location=us-central1 \
  --uniform-bucket-level-access 2>/dev/null || echo "  (Bucket already exists)"

# Create timestamped archive
ARCHIVE_NAME="taskmobileapp_backup_$TIMESTAMP.tar.gz"
TEMP_ARCHIVE="/tmp/$ARCHIVE_NAME"

echo "  Creating archive: $ARCHIVE_NAME"
tar -czf "$TEMP_ARCHIVE" \
  --exclude='node_modules' \
  --exclude='ios/Pods' \
  --exclude='ios/build' \
  --exclude='ios/DerivedData' \
  --exclude='android/build' \
  --exclude='.git' \
  -C "$(dirname $PROJECT_DIR)" \
  "$(basename $PROJECT_DIR)"

# Upload to GCS
echo "  Uploading to $GCS_BUCKET..."
gcloud storage cp "$TEMP_ARCHIVE" "$GCS_BUCKET/$ARCHIVE_NAME"

# Also sync current state (for easy browsing)
echo "  Syncing current project state..."
gcloud storage rsync \
  --recursive \
  --exclude='node_modules/**' \
  --exclude='ios/Pods/**' \
  --exclude='ios/build/**' \
  --exclude='android/build/**' \
  --exclude='.git/**' \
  "$PROJECT_DIR" "$GCS_BUCKET/current/"

# Cleanup
rm "$TEMP_ARCHIVE"

echo "✅ Google Cloud backup complete: $GCS_BUCKET"
echo ""

# 3. SUMMARY
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Backup Complete!"
echo ""
echo "📍 iCloud:        $ICLOUD_DIR"
echo "📍 Google Cloud:  $GCS_BUCKET"
echo "📦 Archive:       $GCS_BUCKET/$ARCHIVE_NAME"
echo ""
echo "To restore from Google Cloud:"
echo "  gcloud storage cp $GCS_BUCKET/$ARCHIVE_NAME ."
echo "  tar -xzf $ARCHIVE_NAME"
echo ""
echo "To list all backups:"
echo "  gcloud storage ls $GCS_BUCKET"
