# Changelog

All notable changes to the Smritir Baksho app will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-XX

### Added
- **Core Features**
  - Memory storage with title, description, category, and date
  - Image attachment support (camera/gallery)
  - Voice memo recording and playback
  - Category-based organization with predefined Bengali categories
  - Search functionality across titles and descriptions
  - Grid and list view modes for memories

- **Security & Authentication**
  - Biometric authentication (fingerprint/face unlock)
  - Local data encryption with Hive database
  - Completely offline operation for privacy

- **User Interface**
  - Vintage/old paper themed design
  - Bengali language support throughout the app
  - Custom Bengali fonts (SolaimanLipi, Nikosh)
  - Dark and light theme modes
  - Customizable primary color themes
  - Responsive design for all screen sizes

- **Data Management**
  - Local Hive database for offline storage
  - JSON export/import for backup and restore
  - Memory statistics and analytics
  - Cross-device backup capability

- **Multimedia Support**
  - High-quality image storage and preview
  - Voice recording with waveform visualization
  - Audio playback with progress tracking
  - Image sharing functionality

- **Notifications**
  - Weekly memory reminder notifications
  - "Memory from the past" notifications
  - Customizable notification settings

- **Settings & Customization**
  - Biometric lock toggle
  - Theme customization (colors, fonts, dark/light mode)
  - Data export/import options
  - App statistics and usage information
  - About section with app information

### Technical Details
- **Framework**: Flutter 3.x with Dart 3.x
- **State Management**: Provider pattern
- **Database**: Hive (NoSQL, offline)
- **Authentication**: local_auth package
- **Audio**: flutter_sound package
- **Images**: image_picker package
- **Notifications**: flutter_local_notifications
- **File Operations**: file_picker, path_provider
- **Sharing**: share_plus package

### Supported Platforms
- Android 5.0+ (API 21+)
- iOS 12.0+

### Languages
- Bengali (বাংলা) - Primary
- English - Secondary support

### Security Features
- Local biometric authentication
- Offline-first architecture
- No data transmission to external servers
- Local encryption of sensitive data

---

## Future Releases

### Planned Features for v1.1.0
- [ ] PDF export of memories with custom layouts
- [ ] Advanced search with date ranges and filters
- [ ] Memory tagging system
- [ ] Bulk operations (delete, export multiple memories)
- [ ] Memory templates for quick creation
- [ ] Enhanced voice memo features (transcription)

### Planned Features for v1.2.0
- [ ] Memory timeline view
- [ ] Photo collage creation
- [ ] Memory sharing with QR codes
- [ ] Advanced statistics and insights
- [ ] Memory reminders based on location
- [ ] Multi-language support expansion

### Long-term Goals
- [ ] Cloud backup integration (optional)
- [ ] Collaborative memory books
- [ ] AI-powered memory suggestions
- [ ] Advanced photo editing tools
- [ ] Video memory support
- [ ] Memory book printing service integration

---

## Development Notes

### Build Requirements
- Flutter SDK 3.0+
- Dart 3.0+
- Android SDK 21+ / iOS 12.0+
- Hive code generation setup

### Key Dependencies
- provider: ^6.1.1
- hive: ^2.2.3
- local_auth: ^2.1.6
- flutter_sound: ^9.2.13
- image_picker: ^1.0.4
- flutter_local_notifications: ^16.1.0

### Architecture
- Clean architecture with separation of concerns
- Provider for state management
- Repository pattern for data access
- Custom theming system
- Modular widget structure

---

*For technical support or feature requests, please visit our GitHub repository.*

