#!/usr/bin/env bash
# CITADEL iOS patch — orientation-free game shell, hidden status bar, clean upgrades.
set -euo pipefail
PLIST="ios/App/App/Info.plist"
PB() { /usr/libexec/PlistBuddy -c "$1" "$PLIST" 2>/dev/null || true; }
PB "Add :UIStatusBarHidden bool true";            PB "Set :UIStatusBarHidden true"
PB "Add :UIViewControllerBasedStatusBarAppearance bool false"; PB "Set :UIViewControllerBasedStatusBarAppearance false"
PB "Add :CADisableMinimumFrameDurationOnPhone bool true"; PB "Set :CADisableMinimumFrameDurationOnPhone true"
PB "Add :ITSAppUsesNonExemptEncryption bool false"; PB "Set :ITSAppUsesNonExemptEncryption false"
# both orientations — the game handles portrait and landscape
PB "Delete :UISupportedInterfaceOrientations"
PB "Add :UISupportedInterfaceOrientations array"
PB "Add :UISupportedInterfaceOrientations:0 string UIInterfaceOrientationPortrait"
PB "Add :UISupportedInterfaceOrientations:1 string UIInterfaceOrientationLandscapeLeft"
PB "Add :UISupportedInterfaceOrientations:2 string UIInterfaceOrientationLandscapeRight"
# monotonic build number — every OTA reinstall is a clean upgrade
BUILD_NO=$(date +%y%m%d%H%M)
PB "Set :CFBundleVersion $BUILD_NO"; PB "Add :CFBundleVersion string $BUILD_NO"
echo "patched Info.plist · build $BUILD_NO"
