#!/usr/bin/env bash
# One-Command Project Creator for Flutter + AI Starter Kit (Bash / macOS / Linux / Git Bash)
set -e

PROJECT_NAME="$1"
APP_TITLE="$2"
ORG="${3:-com.example}"
TARGET_DIR="${4:-./$PROJECT_NAME}"
REPO_URL="${5:-https://github.com/KNkai/base_flutter_ai.git}"

if [ -z "$PROJECT_NAME" ]; then
  echo "Usage: ./scripts/create_app.sh <project_name> [app_title] [org] [target_dir]"
  echo "Example: ./scripts/create_app.sh my_new_app 'My New App' com.company"
  exit 1
fi

if [ -z "$APP_TITLE" ]; then
  APP_TITLE="$PROJECT_NAME"
fi

echo "=========================================================="
echo " Flutter + AI One-Command Project Creator"
echo " Project Name: $PROJECT_NAME"
echo " App Title:    $APP_TITLE"
echo " Bundle ID:    $ORG.$PROJECT_NAME"
echo " Target Dir:   $TARGET_DIR"
echo "=========================================================="

# 1. Clone
echo "[1/4] Cloning base repository..."
git clone "$REPO_URL" "$TARGET_DIR"
cd "$TARGET_DIR"

# 2. Rename in pubspec.yaml
echo "[2/4] Updating project identifiers..."
sed -i.bak "s/name: base_flutter_ai/name: $PROJECT_NAME/g" pubspec.yaml && rm -f pubspec.yaml.bak

# Update Dart imports
grep -rl "package:base_flutter_ai/" lib/ test/ | xargs sed -i.bak "s/package:base_flutter_ai\//package:$PROJECT_NAME\//g" 2>/dev/null || true
find lib test -name "*.bak" -delete 2>/dev/null || true

# Update Android build.gradle.kts
if [ -f "android/app/build.gradle.kts" ]; then
  sed -i.bak "s/com.yourcompany.base_flutter_ai/$ORG.$PROJECT_NAME/g" android/app/build.gradle.kts && rm -f android/app/build.gradle.kts.bak
fi

# Update Android Manifest label
if [ -f "android/app/src/main/AndroidManifest.xml" ]; then
  sed -i.bak "s/android:label=\"base_flutter_ai\"/android:label=\"$APP_TITLE\"/g" android/app/src/main/AndroidManifest.xml && rm -f android/app/src/main/AndroidManifest.xml.bak
fi

# Update iOS Info.plist
if [ -f "ios/Runner/Info.plist" ]; then
  sed -i.bak "s/<string>Base Flutter Ai<\/string>/<string>$APP_TITLE<\/string>/g" ios/Runner/Info.plist && rm -f ios/Runner/Info.plist.bak
  sed -i.bak "s/<string>base_flutter_ai<\/string>/<string>$PROJECT_NAME<\/string>/g" ios/Runner/Info.plist && rm -f ios/Runner/Info.plist.bak
fi

# Reset git
rm -rf .git
git init
git add .
git commit -m "chore: initial commit from base_flutter_ai template"

# 3. Dependencies & CodeGen
echo "[3/4] Installing dependencies and running build_runner..."
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# 4. Verify
echo "[4/4] Verifying code quality..."
dart format --output=none --set-exit-if-changed .
flutter analyze --no-fatal-infos
flutter test

echo "=========================================================="
echo " SUCCESS! Project created at: $TARGET_DIR"
echo " Next: cd '$TARGET_DIR' && flutter run -t lib/main_dev.dart"
echo "=========================================================="

