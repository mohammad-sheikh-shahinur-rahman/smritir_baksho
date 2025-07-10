# Bengali Fonts for Smritir Baksho

This directory should contain Bengali fonts for the app. Please add the following font files:

## Required Fonts:

1. **SolaimanLipi.ttf**
   - A popular Bengali Unicode font
   - Download from: https://fonts.google.com/specimen/Solaiman+Lipi
   - Or from Ekushey fonts collection

2. **Nikosh.ttf**
   - Another beautiful Bengali font
   - Download from Ekushey fonts or similar sources

## Installation:

1. Download the font files
2. Place them in this directory (assets/fonts/)
3. Make sure the file names match exactly:
   - SolaimanLipi.ttf
   - Nikosh.ttf

## Usage:

The fonts are already configured in pubspec.yaml and will be available throughout the app. Users can switch between fonts in the Settings screen.

## Alternative Fonts:

If you can't find the exact fonts, you can use any Bengali Unicode fonts and update the font family names in:
- pubspec.yaml (fonts section)
- lib/core/theme/theme_config.dart
- lib/providers/memory_provider.dart (font picker options)

## License:

Make sure to check the license of any fonts you use and comply with their terms.

