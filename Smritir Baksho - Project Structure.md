# Smritir Baksho - Project Structure

This document outlines the complete structure of the Smritir Baksho Flutter application.

## 📁 Root Directory Structure

```
smritir_baksho/
├── 📁 android/                    # Android-specific configuration
│   └── 📁 app/src/main/
│       └── AndroidManifest.xml    # Android permissions and config
├── 📁 assets/                     # App assets
│   ├── 📁 fonts/                  # Bengali fonts
│   │   └── fonts_readme.txt       # Font installation guide
│   └── 📁 images/                 # Images and textures
│       └── paper_texture_placeholder.txt
├── 📁 lib/                        # Main Dart code
│   ├── 📁 core/                   # Core app configuration
│   │   └── 📁 theme/
│   │       └── theme_config.dart  # App theming and styling
│   ├── 📁 models/                 # Data models
│   │   ├── memory_model.dart      # Memory data model
│   │   └── memory_model.g.dart    # Generated Hive adapter
│   ├── 📁 providers/              # State management
│   │   └── memory_provider.dart   # Main app state provider
│   ├── 📁 screens/                # UI screens
│   │   ├── home_screen.dart       # Main home screen
│   │   ├── add_memory_screen.dart # Add/edit memory screen
│   │   ├── memory_details_screen.dart # Memory details view
│   │   └── settings_screen.dart   # App settings
│   ├── 📁 utils/                  # Utility classes
│   │   └── hive_boxes.dart        # Database operations
│   ├── 📁 widgets/                # Reusable widgets
│   │   ├── memory_card.dart       # Memory display card
│   │   └── voice_recorder_widget.dart # Voice recording widget
│   └── main.dart                  # App entry point
├── 📁 scripts/                    # Build and utility scripts
│   └── build.sh                   # Development build script
├── analysis_options.yaml          # Dart analysis configuration
├── build.yaml                     # Build configuration
├── CHANGELOG.md                   # Version history
├── PROJECT_STRUCTURE.md           # This file
├── pubspec.yaml                   # Dependencies and configuration
└── README.md                      # Main documentation
```

## 🏗️ Architecture Overview

### **State Management**
- **Provider Pattern**: Used for app-wide state management
- **MemoryProvider**: Central state management for memories, settings, and authentication

### **Data Layer**
- **Hive Database**: Local NoSQL database for offline storage
- **Memory Model**: Core data structure with Hive annotations
- **HiveBoxes Utility**: Database operations and queries

### **UI Layer**
- **Screens**: Full-page views for different app sections
- **Widgets**: Reusable UI components
- **Theme System**: Centralized styling with vintage aesthetic

### **Core Features**
- **Authentication**: Biometric authentication using local_auth
- **Media Handling**: Image picker and voice recording
- **Notifications**: Local notifications for reminders
- **Backup/Restore**: JSON export/import functionality

## 📱 Screen Flow

```
Splash/Auth → Home Screen → Add Memory Screen
     ↓              ↓              ↓
Settings Screen ← Memory Details ← Voice Recorder
```

## 🎨 Design System

### **Theme Configuration**
- **Colors**: Vintage brown palette with customizable primary colors
- **Typography**: Bengali fonts (SolaimanLipi, Nikosh) with fallbacks
- **Spacing**: Consistent spacing system (small, medium, large, extra-large)
- **Components**: Styled cards, buttons, and form elements

### **Visual Elements**
- **Paper Texture**: Background overlay for vintage feel
- **Memory Cards**: Grid and list view layouts
- **Animations**: Smooth transitions and micro-interactions

## 🔧 Key Dependencies

### **Core Flutter Packages**
- `provider`: State management
- `hive` & `hive_flutter`: Local database
- `local_auth`: Biometric authentication

### **Media & File Handling**
- `image_picker`: Camera and gallery access
- `flutter_sound`: Audio recording and playback
- `file_picker`: File selection for backup/restore
- `path_provider`: File system access

### **UI & UX**
- `google_fonts`: Typography
- `share_plus`: Content sharing
- `flutter_local_notifications`: Push notifications

### **Utilities**
- `intl`: Internationalization and date formatting
- `permission_handler`: Runtime permissions

## 🛠️ Development Workflow

### **Setup Commands**
```bash
# Install dependencies
flutter pub get

# Generate code
flutter packages pub run build_runner build

# Run app
flutter run

# Build for production
flutter build apk  # Android
flutter build ios  # iOS
```

### **Code Generation**
- **Hive Adapters**: Auto-generated from model annotations
- **Build Runner**: Handles code generation pipeline

### **Testing Strategy**
- **Unit Tests**: Model and utility testing
- **Widget Tests**: UI component testing
- **Integration Tests**: Full app flow testing

## 📊 Data Flow

```
User Input → Provider → Hive Database → UI Update
     ↑                                      ↓
Settings/Auth ← File System ← Media Files ←
```

## 🔒 Security Features

### **Local Authentication**
- Biometric unlock (fingerprint/face)
- Secure storage of authentication preferences

### **Data Protection**
- Offline-first architecture
- Local encryption via Hive
- No external data transmission

### **Permissions**
- Microphone: Voice recording
- Camera: Photo capture
- Storage: File access for backup/restore
- Biometric: Authentication

## 🌐 Localization

### **Primary Language**: Bengali (বাংলা)
- All UI text in Bengali
- Bengali date formatting
- Cultural context in design

### **Font Support**
- SolaimanLipi: Primary Bengali font
- Nikosh: Alternative Bengali font
- Fallback to system fonts

## 📈 Performance Considerations

### **Optimization Strategies**
- Lazy loading of images
- Efficient list rendering with builders
- Memory management for audio files
- Optimized database queries

### **Storage Management**
- Compressed image storage
- Efficient audio encoding (AAC)
- Database cleanup utilities

## 🚀 Deployment

### **Android**
- Minimum SDK: API 21 (Android 5.0)
- Target SDK: API 34 (Android 14)
- Permissions configured in AndroidManifest.xml

### **iOS**
- Minimum iOS: 12.0
- Info.plist configuration required
- App Store compliance ready

---

This structure ensures maintainability, scalability, and follows Flutter best practices while delivering a feature-rich memory keeping application.

