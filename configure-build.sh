#!/bin/bash
# Build 2 Configuration Script - Morning Build
# Configures taskmobileapp_1226morning with unique identifiers

set -e

BUILD_DIR="/Users/codysmith/taskmobileapp_1226morning/MobileTodoList"
BUNDLE_ID="com.taskmobileapp.morning"
APP_NAME="TaskMobileApp Morning"
GCP_PROJECT="taskmobileapp-morning-1226"

echo "🔧 Configuring Build 2: Morning Build"
echo "Bundle ID: $BUNDLE_ID"
echo "App Name: $APP_NAME"
echo ""

# Update app.json
echo "✓ Updating app.json..."
cd "$BUILD_DIR"
if [ -f "app.json" ]; then
  sed -i '' 's/"name": "MobileTodoList"/"name": "TaskMobileAppMorning"/g' app.json
  sed -i '' 's/"displayName": "MobileTodoList"/"displayName": "TaskMobileApp Morning"/g' app.json
fi

# Update iOS Info.plist
echo "✓ Updating iOS Info.plist..."
if [ -f "ios/MobileTodoList/Info.plist" ]; then
  /usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $BUNDLE_ID" ios/MobileTodoList/Info.plist 2>/dev/null || \
  /usr/libexec/PlistBuddy -c "Add :CFBundleIdentifier string $BUNDLE_ID" ios/MobileTodoList/Info.plist
  
  /usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $APP_NAME" ios/MobileTodoList/Info.plist 2>/dev/null || \
  /usr/libexec/PlistBuddy -c "Add :CFBundleDisplayName string $APP_NAME" ios/MobileTodoList/Info.plist
fi

# Update Android build.gradle
echo "✓ Updating Android build.gradle..."
if [ -f "android/app/build.gradle" ]; then
  sed -i '' "s/applicationId \".*\"/applicationId \"$BUNDLE_ID\"/g" android/app/build.gradle
fi

# Update package.json name
echo "✓ Updating package.json..."
if [ -f "package.json" ]; then
  sed -i '' 's/"name": "MobileTodoList"/"name": "taskmobileapp-morning"/g' package.json
fi

# Create .env file
echo "✓ Creating .env file..."
cat > .env << EOF
# TaskMobileApp Morning Build Configuration
# Google Cloud Project
GCP_PROJECT_ID=$GCP_PROJECT
FIREBASE_PROJECT_ID=$GCP_PROJECT

# API Keys (Replace with your actual keys)
OPENAI_API_KEY=your_openai_key_here
STRIPE_PUBLISHABLE_KEY=your_stripe_key_here
GOOGLE_MAPS_API_KEY=your_maps_key_here

# Build Info
BUILD_VERSION=morning-1226
BUILD_ENVIRONMENT=development
EOF

echo ""
echo "✅ Build 2 configuration complete!"
echo ""
echo "Next steps:"
echo "1. Create Google Cloud project: gcloud projects create $GCP_PROJECT"
echo "2. Create Firebase project at: https://console.firebase.google.com"
echo "3. Download Firebase config files for iOS and Android"
echo "4. Update .env with actual API keys"
echo "5. Run: cd ios && pod install"
