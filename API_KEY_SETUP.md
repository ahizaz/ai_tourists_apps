# Google Maps API Key সেটআপ গাইড
## Setup Guide for Securing Google Maps API Key

এই গাইড অনুসরণ করে আপনি Google Maps API Key সুরক্ষিতভাবে configure করতে পারবেন।

---

## ⚠️ গুরুত্বপূর্ণ নোট / Important Note

**API key গুলো কখনোই GitHub বা অন্য কোনো public repository তে commit করবেন না!**
**Never commit API keys to GitHub or any public repository!**

---

## 🔧 সেটআপ পদক্ষেপ / Setup Steps

### 1️⃣ Flutter/Dart Configuration

#### ক) Template file copy করুন:
```bash
# lib/core/config/ ফোল্ডারে যান
cd lib/core/config/

# Template file থেকে নতুন file তৈরি করুন
copy api_keys.dart.example api_keys.dart
```

#### খ) আপনার API key দিন:
`lib/core/config/api_keys.dart` ফাইল খুলুন এবং এই লাইন খুঁজুন:
```dart
static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY_HERE';
```

`YOUR_GOOGLE_MAPS_API_KEY_HERE` এর জায়গায় আপনার আসল API key বসান:
```dart
static const String googleMapsApiKey = 'AIzaSyCGBj98ytEcJaL7kbXfnXvtAIlSp5MBAxc';
```

---

### 2️⃣ Android Configuration

#### ক) Template file copy করুন:
```bash
# android/ ফোল্ডারে যান
cd android/

# Template file থেকে নতুন file তৈরি করুন
copy local.properties.example local.properties
```

#### খ) local.properties ফাইল সম্পাদনা করুন:
`android/local.properties` ফাইল খুলুন এবং আপনার API key এবং SDK paths দিন:

```properties
sdk.dir=C:\\Users\\YOUR_USERNAME\\AppData\\Local\\Android\\sdk
flutter.sdk=C:\\src\\flutter

# আপনার Google Maps API Key
GOOGLE_MAPS_API_KEY=AIzaSyCGBj98ytEcJaL7kbXfnXvtAIlSp5MBAxc
```

**নোট:** `sdk.dir` এবং `flutter.sdk` পথ আপনার সিস্টেম অনুযায়ী ঠিক করুন।

---

### 3️⃣ iOS Configuration

#### ক) Template file copy করুন:
```bash
# ios/Runner/ ফোল্ডারে যান
cd ios/Runner/

# Template file থেকে নতুন file তৈরি করুন
copy GoogleMapsConfig.swift.example GoogleMapsConfig.swift
```

#### খ) GoogleMapsConfig.swift ফাইল সম্পাদনা করুন:
`ios/Runner/GoogleMapsConfig.swift` ফাইল খুলুন এবং এই লাইন খুঁজুন:
```swift
static let apiKey = "YOUR_GOOGLE_MAPS_API_KEY_HERE"
```

`YOUR_GOOGLE_MAPS_API_KEY_HERE` এর জায়গায় আপনার আসল API key বসান:
```swift
static let apiKey = "AIzaSyCGBj98ytEcJaL7kbXfnXvtAIlSp5MBAxc"
```

---

## ✅ যাচাই করুন / Verify Setup

### নিশ্চিত করুন যে নিচের files গুলো `.gitignore` এ আছে:
```
lib/core/config/api_keys.dart
android/local.properties
ios/Runner/GoogleMapsConfig.swift
```

### Test করুন:
```bash
flutter clean
flutter pub get
flutter run
```

---

## 🔐 Security Best Practices

1. **কখনোই API keys সরাসরি source code এ লিখবেন না**
2. **`.gitignore` ফাইল check করুন** - API key files যাতে include হয়
3. **Environment variables ব্যবহার করুন** production এর জন্য
4. **API key restrictions সেট করুন** Google Cloud Console এ:
   - Android apps জন্য: Package name এবং SHA-1 fingerprint যোগ করুন
   - iOS apps জন্য: Bundle identifier যোগ করুন
5. **Regular monitoring করুন** API usage Google Cloud Console এ

---

## 🚨 যদি ভুলবশত API Key Commit হয়ে যায়

### তাৎক্ষণিক পদক্ষেপ:

1. **API Key নিষ্ক্রিয় করুন** Google Cloud Console থেকে
2. **নতুন API Key তৈরি করুন**
3. **Git history থেকে key সরান:**
   ```bash
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch lib/core/config/api_keys.dart" \
     --prune-empty --tag-name-filter cat -- --all
   ```
4. **Force push করুন** (সাবধানতার সাথে):
   ```bash
   git push origin --force --all
   ```

---

## 📞 সাহায্যের জন্য / For Help

যদি কোনো সমস্যা হয়, তাহলে:
1. `.gitignore` ফাইল চেক করুন
2. `flutter clean` এবং `flutter pub get` চালান
3. Project rebuild করুন

---

## 📁 File Structure

```
lib/core/config/
├── api_keys.dart.example    # Template file (committed)
└── api_keys.dart            # Your actual keys (gitignored)

android/
├── local.properties.example # Template file (committed)
└── local.properties         # Your actual keys (gitignored)

ios/Runner/
├── GoogleMapsConfig.swift.example  # Template file (committed)
└── GoogleMapsConfig.swift          # Your actual keys (gitignored)
```

---

## ⚡ Quick Setup (One-liner)

Windows:
```powershell
copy lib\core\config\api_keys.dart.example lib\core\config\api_keys.dart; copy android\local.properties.example android\local.properties; copy ios\Runner\GoogleMapsConfig.swift.example ios\Runner\GoogleMapsConfig.swift
```

Linux/macOS:
```bash
cp lib/core/config/api_keys.dart.example lib/core/config/api_keys.dart && cp android/local.properties.example android/local.properties && cp ios/Runner/GoogleMapsConfig.swift.example ios/Runner/GoogleMapsConfig.swift
```

তারপর প্রতিটি ফাইলে আপনার API key বসান।

---

✅ **সব শেষে: প্রজেক্ট test করুন এবং নিশ্চিত করুন map ঠিকমত কাজ করছে!**
