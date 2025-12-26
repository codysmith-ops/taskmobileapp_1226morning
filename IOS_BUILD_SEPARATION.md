# Repository Structure - iOS Build Separation

## Overview
The Mobile Todo List project has been reorganized to support separate iOS builds with independent configurations for Google Cloud, Xcode, and GitHub.

## New Repository Structure

```
taskmobileapp_1226morning/
│
├── MobileTodoList/                    # Original combined project
│   ├── ios/                           # iOS native files
│   ├── android/                       # Android native files (disabled)
│   └── src/                           # Shared source code
│
└── MobileTodoList-iOS/                # NEW: Dedicated iOS build
    ├── ios/                           # iOS native code and Xcode project
    │   ├── MobileTodoList/            # Main iOS app target
    │   ├── MobileTodoList.xcodeproj/  # Xcode project file
    │   ├── MobileTodoList.xcworkspace/# Xcode workspace (with CocoaPods)
    │   └── Podfile                    # CocoaPods dependencies
    ├── src/                           # Shared React Native source code
    │   ├── components/                # UI components
    │   ├── services/                  # API services (store search, etc.)
    │   ├── config/                    # Configuration files
    │   └── hooks/                     # Custom React hooks
    ├── __tests__/                     # Test files
    ├── scripts/                       # Build and deployment scripts
    │   └── setup-gcp.sh              # iOS-specific GCP setup
    ├── App.tsx                        # Main application component
    ├── package.json                   # iOS-specific dependencies and scripts
    ├── app.json                       # iOS app configuration
    ├── README.md                      # iOS build documentation
    └── GITHUB_REPOSITORY_SETUP.md     # GitHub setup guide
```

## Configuration Changes

### 1. Package Configuration (MobileTodoList-iOS/package.json)

**Project Name**: `MobileTodoList-iOS`

**iOS-Only Scripts**:
- `npm run ios` - Run on iOS simulator (Debug)
- `npm run ios:release` - Run release build
- `npm run pod:install` - Install CocoaPods dependencies
- `npm run build:ios` - Build with Xcode CLI
- **Removed**: `android` script (Android disabled)

### 2. App Configuration (MobileTodoList-iOS/app.json)

```json
{
  "name": "MobileTodoList-iOS",
  "displayName": "Mobile Todo List"
}
```

### 3. Google Cloud Platform (scripts/setup-gcp.sh)

**Updated Configuration**:
- **Project ID**: `mobile-todo-list-ios` (was `mobile-todo-list-app`)
- **Project Name**: "Mobile Todo List iOS"
- **Platform**: iOS only
- **Region**: `us-central1`

**GCP Services**:
- Firebase (iOS-specific configuration)
- Cloud Firestore
- Cloud Storage
- Secret Manager
- Cloud Build (iOS CI/CD)
- Container Registry

### 4. Xcode Project

**Location**: `MobileTodoList-iOS/ios/MobileTodoList.xcworkspace`

**Configuration**:
- Bundle Identifier: `com.yourdomain.mobiletodolist.ios`
- Product Name: Mobile Todo List
- Platform: iOS only
- Deployment Target: iOS 13.0+

**Build Settings**:
- All references point to `MobileTodoList-iOS` folder structure
- CocoaPods integration maintained
- Firebase iOS SDK configured

## GitHub Repository Setup

### Recommended Structure

**Option 1: Separate Repositories** (Recommended)
```
Organization/User GitHub Account
├── mobile-todo-list-ios/          # Dedicated iOS repository
└── (future) mobile-todo-list-android/ # If Android is re-enabled
```

**Option 2: Monorepo with Folders**
```
mobile-todo-list/
├── ios-build/                     # iOS project
└── android-build/                 # Android project (when enabled)
```

### iOS Repository Details

**Repository Name**: `mobile-todo-list-ios`
**Description**: "Mobile Todo List - iOS Native Build"
**Visibility**: Private (initially)

**Contents**:
- All files from `MobileTodoList-iOS/` folder
- iOS-specific CI/CD workflows
- Xcode Cloud configuration
- TestFlight deployment scripts

**See**: [GITHUB_REPOSITORY_SETUP.md](MobileTodoList-iOS/GITHUB_REPOSITORY_SETUP.md) for complete setup instructions

## Xcode Integration

### Opening in Xcode

```bash
cd /Users/codysmith/taskmobileapp_1226morning/MobileTodoList-iOS
open ios/MobileTodoList.xcworkspace
```

### Project Settings in Xcode

1. **General Tab**:
   - Display Name: Mobile Todo List
   - Bundle Identifier: com.yourdomain.mobiletodolist.ios
   - Version: 1.0.0
   - Build: 1

2. **Signing & Capabilities**:
   - Team: [Your Development Team]
   - Signing Certificate: iOS Development / iOS Distribution
   - Provisioning Profile: Automatic / Manual

3. **Build Settings**:
   - All paths reference `MobileTodoList-iOS` folder
   - Header search paths updated for new structure
   - Framework search paths updated

## Google Cloud Platform Integration

### Setup Process

```bash
cd /Users/codysmith/taskmobileapp_1226morning/MobileTodoList-iOS/scripts
chmod +x setup-gcp.sh
./setup-gcp.sh
```

### Created Resources

1. **GCP Project**: `mobile-todo-list-ios`
2. **Cloud Storage Buckets**:
   - `mobile-todo-list-ios-uploads`
   - `mobile-todo-list-ios-backups`
3. **Firebase Project**: Linked to GCP project
4. **APIs Enabled**:
   - Secret Manager
   - Cloud Build
   - Cloud Run
   - Cloud Functions
   - Firestore
   - Cloud Storage

### Cloud Build Integration

**Trigger Configuration**:
- Repository: `mobile-todo-list-ios` (GitHub)
- Branch: `main`
- Build Config: `cloudbuild.yaml`
- Platform: iOS

## CI/CD Workflows

### GitHub Actions (Recommended)

Location: `.github/workflows/ios-build.yml`

**Triggers**:
- Push to `main` branch
- Pull requests to `main`

**Jobs**:
1. Install dependencies
2. Run tests
3. Build iOS app
4. Archive for distribution

### Xcode Cloud (Alternative)

**Workflow**:
1. Run tests on PR
2. Archive on `main` push
3. Distribute to TestFlight

## Deployment Targets

### Development
- **Local**: Xcode simulator via `npm run ios`
- **Device**: Connect iPhone via USB, build from Xcode

### Beta (TestFlight)
- Archive in Xcode
- Upload to App Store Connect
- Distribute to internal/external testers

### Production (App Store)
- Archive release build
- Submit through App Store Connect
- App Review → Release

## Migration Checklist

- [x] Create `MobileTodoList-iOS` folder
- [x] Copy iOS native files (`ios/` directory)
- [x] Copy shared source code (`src/`, `App.tsx`, etc.)
- [x] Copy configuration files (package.json, app.json, etc.)
- [x] Update package.json with iOS-only scripts
- [x] Update app.json with iOS project name
- [x] Update GCP setup script for iOS project
- [x] Create GitHub repository setup documentation
- [x] Create comprehensive iOS README

### Next Steps

- [ ] Initialize Git repository in `MobileTodoList-iOS/`
- [ ] Create GitHub repository `mobile-todo-list-ios`
- [ ] Push initial commit to GitHub
- [ ] Configure GitHub Actions workflow
- [ ] Set up Xcode Cloud (optional)
- [ ] Run GCP setup script
- [ ] Configure Firebase for iOS
- [ ] Test build in Xcode
- [ ] Create TestFlight build
- [ ] Set up App Store Connect

## Benefits of Separation

### 1. Independent Version Control
- Separate commit history for iOS
- Platform-specific branching strategies
- Clearer code review process

### 2. Optimized CI/CD
- iOS-specific build pipelines
- Faster build times (no Android overhead)
- Xcode Cloud integration
- GitHub Actions optimized for macOS runners

### 3. Simplified Dependency Management
- iOS-only CocoaPods
- No Android Gradle conflicts
- Cleaner package.json

### 4. Better Organization
- Clear separation of concerns
- Easier onboarding for iOS developers
- Focused issue tracking

### 5. Flexible Deployment
- Independent release cycles
- Platform-specific versioning
- Separate TestFlight and App Store presence

## Support and Documentation

### iOS Build Documentation
- [README.md](MobileTodoList-iOS/README.md) - Main documentation
- [GITHUB_REPOSITORY_SETUP.md](MobileTodoList-iOS/GITHUB_REPOSITORY_SETUP.md) - Git setup
- [API_SETUP_GUIDE.md](MobileTodoList-iOS/API_SETUP_GUIDE.md) - API configuration
- [STORE_API_INTEGRATION.md](MobileTodoList-iOS/STORE_API_INTEGRATION.md) - Store APIs
- [FEATURE_SUMMARY.md](MobileTodoList-iOS/FEATURE_SUMMARY.md) - Features

### Quick Reference

**Build Commands**:
```bash
cd MobileTodoList-iOS
npm install
npm run pod:install
npm run ios
```

**Xcode**:
```bash
open MobileTodoList-iOS/ios/MobileTodoList.xcworkspace
```

**GCP Setup**:
```bash
cd MobileTodoList-iOS/scripts
./setup-gcp.sh
```

**GitHub Setup**:
```bash
cd MobileTodoList-iOS
git init
gh repo create mobile-todo-list-ios --private --source=. --push
```

## Summary

The Mobile Todo List project now has a dedicated iOS build structure that is:

✅ **Separated** from Android (disabled)
✅ **Configured** for Google Cloud Platform with iOS-specific project
✅ **Ready** for Xcode with proper workspace structure
✅ **Documented** for GitHub repository setup with CI/CD workflows
✅ **Optimized** for iOS development and deployment

All repository references in Google Cloud, Xcode, and GitHub will use the new `MobileTodoList-iOS` folder structure.
