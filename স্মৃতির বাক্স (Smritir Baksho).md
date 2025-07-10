# স্মৃতির বাক্স (Smritir Baksho)

একটি সুন্দর এবং নিরাপদ অফলাইন মেমোরি কিপার অ্যাপ যা আপনার প্রিয় স্মৃতিগুলো সংরক্ষণ করে।

## বৈশিষ্ট্য

### 🔐 নিরাপত্তা
- বায়োমেট্রিক লক (ফিঙ্গারপ্রিন্ট/ফেস আনলক)
- সম্পূর্ণ অফলাইন ডেটা স্টোরেজ
- স্থানীয় এনক্রিপশন

### 📝 স্মৃতি ব্যবস্থাপনা
- টেক্সট, ছবি এবং ভয়েস মেমো সহ স্মৃতি সংরক্ষণ
- ক্যাটেগরি অনুযায়ী সংগঠন
- শক্তিশালী সার্চ এবং ফিল্টার
- তারিখ অনুযায়ী সাজানো

### 🎨 ডিজাইন
- ভিনটেজ/পুরানো কাগজের অনুভূতি
- বাংলা হস্তাক্ষর স্টাইল ফন্ট
- ডার্ক/লাইট মোড সাপোর্ট
- কাস্টমাইজেবল থিম

### 🔊 মাল্টিমিডিয়া
- ইমেজ পিকার (গ্যালারি/ক্যামেরা)
- ভয়েস রেকর্ডিং এবং প্লেব্যাক
- ইমেজ প্রিভিউ এবং জুম

### 📤 ব্যাকআপ ও শেয়ার
- JSON ফরম্যাটে ডেটা এক্সপোর্ট/ইমপোর্ট
- স্মৃতি শেয়ার করার সুবিধা
- ক্রস-ডিভাইস ব্যাকআপ

### 🔔 নোটিফিকেশন
- সাপ্তাহিক স্মৃতি রিমাইন্ডার
- অতীতের স্মৃতি থেকে নোটিফিকেশন

## প্রযুক্তিগত বিবরণ

### ব্যবহৃত প্রযুক্তি
- **Framework**: Flutter 3.x
- **State Management**: Provider
- **Local Database**: Hive
- **Authentication**: local_auth
- **Audio**: flutter_sound
- **Images**: image_picker
- **Notifications**: flutter_local_notifications

### প্রজেক্ট স্ট্রাকচার
```
lib/
├── core/
│   └── theme/
│       └── theme_config.dart
├── models/
│   ├── memory_model.dart
│   └── memory_model.g.dart
├── providers/
│   └── memory_provider.dart
├── screens/
│   ├── home_screen.dart
│   ├── add_memory_screen.dart
│   ├── memory_details_screen.dart
│   └── settings_screen.dart
├── widgets/
│   ├── memory_card.dart
│   └── voice_recorder_widget.dart
├── utils/
│   └── hive_boxes.dart
└── main.dart
```

## সেটআপ নির্দেশনা

### প্রয়োজনীয়তা
- Flutter SDK 3.0+
- Dart 3.0+
- Android Studio / VS Code
- Android SDK (Android এর জন্য)
- Xcode (iOS এর জন্য)

### ইনস্টলেশন

1. **রিপোজিটরি ক্লোন করুন**
```bash
git clone <repository-url>
cd smritir_baksho
```

2. **Dependencies ইনস্টল করুন**
```bash
flutter pub get
```

3. **Hive Adapters জেনারেট করুন**
```bash
flutter packages pub run build_runner build
```

4. **অ্যাপ রান করুন**
```bash
flutter run
```

### Android সেটআপ

1. **Minimum SDK**: API 21 (Android 5.0)
2. **Target SDK**: API 34 (Android 14)
3. **Permissions**: AndroidManifest.xml এ সব প্রয়োজনীয় পারমিশন যোগ করা আছে

### iOS সেটআপ

1. **Minimum iOS**: 12.0
2. **Info.plist এ যোগ করুন**:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>ভয়েস মেমো রেকর্ড করার জন্য মাইক্রোফোন প্রয়োজন</string>
<key>NSCameraUsageDescription</key>
<string>ছবি তোলার জন্য ক্যামেরা প্রয়োজন</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>ছবি নির্বাচনের জন্য ফটো লাইব্রেরি প্রয়োজন</string>
```

## ব্যবহারের নির্দেশনা

### প্রথম ব্যবহার
1. অ্যাপ খুলুন
2. প্রয়োজনীয় পারমিশন দিন
3. বায়োমেট্রিক লক সেট করুন (ঐচ্ছিক)
4. আপনার প্রথম স্মৃতি যোগ করুন

### স্মৃতি যোগ করা
1. হোম স্ক্রিনে + বাটনে ট্যাপ করুন
2. শিরোনাম এবং বিবরণ লিখুন
3. ক্যাটেগরি নির্বাচন করুন
4. তারিখ সেট করুন
5. ছবি যোগ করুন (ঐচ্ছিক)
6. ভয়েস মেমো রেকর্ড করুন (ঐচ্ছিক)
7. সংরক্ষণ করুন

### ব্যাকআপ তৈরি
1. সেটিংস > ডেটা ব্যবস্থাপনা
2. "ব্যাকআপ তৈরি করুন" এ ট্যাপ করুন
3. JSON ফাইল শেয়ার করুন বা সংরক্ষণ করুন

## কন্ট্রিবিউশন

এই প্রজেক্টে কন্ট্রিবিউট করতে চাইলে:

1. Fork করুন
2. Feature branch তৈরি করুন
3. Changes commit করুন
4. Pull request পাঠান

## লাইসেন্স

এই প্রজেক্টটি MIT লাইসেন্সের অধীনে প্রকাশিত।

## সাপোর্ট

কোন সমস্যা বা প্রশ্ন থাকলে GitHub Issues এ জানান।

---

**স্মৃতির বাক্স** - আপনার প্রিয় মুহূর্তগুলো চিরকালের জন্য সংরক্ষণ করুন 💝

