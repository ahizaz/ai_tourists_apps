# Google Maps API Key Setup Guide
## Setup Guide for Securing Google Maps API Key

Follow this guide to securely configure Google Maps API Key.

---

## ⚠️ Important Note

**Never commit API keys to GitHub or any public repository!**
**Never commit API keys to GitHub or any public repository!**

---

## 🔧 Setup Steps

### 1️⃣ Flutter/Dart Configuration

#### a) Copy the template file:
```bash
# Navigate to lib/core/config/ folder
cd lib/core/config/

# Create a new file from template file
copy api_keys.dart.example api_keys.dart
```

#### b) Add your API key:
Open `lib/core/config/api_keys.dart` file and find this line:
```dart
static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY_HERE';
```

Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual API key:
```dart
static const String googleMapsApiKey = 'AIzaSyCGBj98ytEcJaL7kbXfnXvtAIlSp5MBAxc';
```

---

### 2️⃣ Android Configuration

#### a) Copy the template file:
```bash
# Navigate to android/ folder
cd android/

# Create a new file from template file
copy local.properties.example local.properties
```

#### b) Edit the local.properties file:
Open `android/local.properties` file and add your API key and SDK paths:

```properties
sdk.dir=C:\\Users\\YOUR_USERNAME\\AppData\\Local\\Android\\sdk
flutter.sdk=C:\\src\\flutter

# Your Google Maps API Key
GOOGLE_MAPS_API_KEY=AIzaSyCGBj98ytEcJaL7kbXfnXvtAIlSp5MBAxc
```

**Note:** Correct the `sdk.dir` and `flutter.sdk` paths according to your system.

---

### 3️⃣ iOS Configuration

#### a) Copy the template file:
```bash
# Navigate to ios/Runner/ folder
cd ios/Runner/

# Create a new file from template file
copy GoogleMapsConfig.swift.example GoogleMapsConfig.swift
```

#### b) Edit the GoogleMapsConfig.swift file:
Open `ios/Runner/GoogleMapsConfig.swift` file and find this line:
```swift
static let apiKey = "YOUR_GOOGLE_MAPS_API_KEY_HERE"
```

Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual API key:
```swift
static let apiKey = "AIzaSyCGBj98ytEcJaL7kbXfnXvtAIlSp5MBAxc"
```

---

## ✅ Verify Setup

### Ensure the following files are in `.gitignore`:
```
lib/core/config/api_keys.dart
android/local.properties
ios/Runner/GoogleMapsConfig.swift
```

### Test it:
```bash
flutter clean
flutter pub get
flutter run
```

---

## 🔐 Security Best Practices

1. **Never write API keys directly in source code**
2. **Check `.gitignore` file** - to ensure API key files are included
3. **Use environment variables** for production
4. **Set API key restrictions** in Google Cloud Console:
   - For Android apps: Add package name and SHA-1 fingerprint
   - For iOS apps: Add bundle identifier
5. **Regular monitoring** of API usage in Google Cloud Console

---

## 🚨 If API Key Gets Accidentally Committed

### Immediate steps:

1. **Disable the API Key** from Google Cloud Console
2. **Create a new API Key**
3. **Remove key from Git history:**
   ```bash
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch lib/core/config/api_keys.dart" \
     --prune-empty --tag-name-filter cat -- --all
   ```
4. **Force push** (with caution):
   ```bash
   git push origin --force --all
   ```

---

## 📞 For Help

If you encounter any problems:
1. Check the `.gitignore` file
2. Run `flutter clean` and `flutter pub get`
3. Rebuild the project

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

Then add your API key to each file.

---

✅ **Finally: Test the project and make sure the map works properly!**
