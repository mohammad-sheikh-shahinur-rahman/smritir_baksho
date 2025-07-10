#!/bin/bash

# Smritir Baksho Build Script
# This script helps developers build and run the app easily

echo "🏗️  Building Smritir Baksho (স্মৃতির বাক্স)"
echo "=============================================="

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo "Please install Flutter from https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -n 1)"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Generate code (Hive adapters)
echo "🔧 Generating code..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Check for analysis issues
echo "🔍 Running code analysis..."
flutter analyze

# Run tests if they exist
if [ -d "test" ] && [ "$(ls -A test)" ]; then
    echo "🧪 Running tests..."
    flutter test
else
    echo "⚠️  No tests found, skipping test phase"
fi

echo ""
echo "🎉 Build completed successfully!"
echo ""
echo "Available commands:"
echo "  flutter run                    # Run on connected device"
echo "  flutter run -d chrome          # Run on Chrome (web)"
echo "  flutter build apk              # Build Android APK"
echo "  flutter build appbundle        # Build Android App Bundle"
echo "  flutter build ios              # Build iOS app"
echo ""
echo "For development:"
echo "  flutter run --hot               # Run with hot reload"
echo "  flutter run --profile          # Run in profile mode"
echo "  flutter run --release          # Run in release mode"
echo ""

# Ask if user wants to run the app
read -p "Do you want to run the app now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Starting the app..."
    flutter run
fi

