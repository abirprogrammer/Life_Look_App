# LifeLoop — Google Play Store Release Guide

## 1. Prerequisites & Environment Setup
- Flutter SDK (>=3.0.0)
- Android SDK & Java 17

## 2. Firebase & Gemini API Configuration
1. **Firebase**:
   - Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com).
   - Add an Android app with package name `com.example.lifeloop` (or your custom package name).
   - Download `google-services.json` and place it in `android/app/`.
2. **Gemini API**:
   - Get an API key from Google AI Studio.
   - Configure your environment variable before building:
     ```bash
     flutter build appbundle --dart-define=GEMINI_API_KEY=your_api_key_here
     ```

## 3. Generating Release Keystore
Never commit signing credentials to source control. Generate your keystore using keytool:
```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
Configure `android/key.properties`:
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=upload
storeFile=upload-keystore.jks
```

## 4. Building the Android App Bundle (.aab)
```bash
flutter clean
flutter pub get
flutter build appbundle --release
```
Your release bundle will be located at:
`build/app/outputs/bundle/release/app-release.aab`

## 5. Play Store Release Checklist
- [ ] App Icon & Splash Screen verified
- [ ] Privacy Policy published and linked
- [ ] Tested on physical Android devices
- [ ] Accessibility (TalkBack & contrast) verified
- [ ] Signed App Bundle uploaded to Google Play Console
