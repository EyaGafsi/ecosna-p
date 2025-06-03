# EcoSnap 🌱

EcoSnap is an eco-friendly mobile application built with Flutter that helps users identify waste materials and learn how to recycle them properly. The app uses image recognition to scan waste items and provides recycling information to promote environmental responsibility.

## Features ✨

- **Waste Scanning**: Take photos of waste items to identify them
- **Recycling Information**: Get detailed information about how to recycle different materials
- **User Authentication**: Secure login and registration system
- **Scan History**: Keep track of your previous scans
- **News Feed**: Stay updated with eco-friendly news and tips
- **User Profile**: Manage your account and view statistics
- **Firebase Integration**: Real-time notifications and cloud storage

## Screenshots 📱

The app features a modern, eco-friendly design with:
- Clean green color scheme (#2E7D32)
- Intuitive navigation with bottom tab bar
- Beautiful gradient backgrounds
- Custom logo integration
- Responsive design for all screen sizes

## Prerequisites 📋

Before running this project, make sure you have the following installed:

### Required Software
- **Flutter SDK** (3.6.1 or higher)
- **Dart SDK** (included with Flutter)
- **Android Studio** or **VS Code** with Flutter extensions
- **Git**

### For Android Development
- **Android Studio** with Android SDK
- **Android Emulator** or physical Android device
- **Java Development Kit (JDK)** 8 or higher

### For iOS Development (macOS only)
- **Xcode** (latest version)
- **iOS Simulator** or physical iOS device
- **CocoaPods**

### Backend Requirements
- **Django Backend Server** running on port 8000
- **Firebase Project** configured for the app

## Installation & Setup 🚀

### 1. Clone the Repository
```bash
git clone <repository-url>
cd ecosnap
```

### 2. Install Flutter Dependencies
```bash
flutter pub get
```

### 3. Firebase Setup

#### Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project named "ecosnap-app"
3. Enable Authentication and Cloud Messaging

#### Configure Firebase for Android
1. Add Android app to your Firebase project
2. Download `google-services.json`
3. Place it in `android/app/` directory

#### Configure Firebase for iOS (if targeting iOS)
1. Add iOS app to your Firebase project
2. Download `GoogleService-Info.plist`
3. Add it to `ios/Runner/` directory

#### Generate Firebase Options
```bash
# Install Firebase CLI if not already installed
npm install -g firebase-tools

# Login to Firebase
firebase login

# Configure Firebase for Flutter
dart pub global activate flutterfire_cli
flutterfire configure
```

### 4. Backend Setup

The app requires a Django backend server. Make sure your backend is running on:
- **Android Emulator**: `http://10.0.2.2:8000`
- **iOS Simulator/Web**: `http://127.0.0.1:8000`

To change the backend URL, edit `lib/utils/constants.dart`:
```dart
const String baseUrl = 'http://your-backend-url:8000';
```

### 5. Assets Setup

Ensure the logo file is present:
```
assets/
  └── logo.png
```

## Running the Application 🏃‍♂️

### Development Mode

#### Android
```bash
# Start Android emulator or connect Android device
flutter run
```

#### iOS (macOS only)
```bash
# Start iOS simulator or connect iOS device
flutter run
```

#### Web
```bash
flutter run -d chrome
```

### Production Build

#### Android APK
```bash
flutter build apk --release
```

#### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

#### iOS (macOS only)
```bash
flutter build ios --release
```

## Project Structure 📁

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── models/                   # Data models
│   ├── feed.dart
│   ├── scan.dart
│   └── user.dart
├── screens/                  # UI screens
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── profile_screen.dart
│   ├── scan_screen.dart
│   └── MyScansScreen.dart
├── services/                 # API and business logic
│   ├── api_service.dart
│   └── auth_service.dart
├── utils/                    # Utilities and constants
│   └── constants.dart
└── widgets/                  # Reusable UI components
    ├── custom_appbar.dart
    ├── eco_logo.dart
    └── feed_card.dart
```

## Dependencies 📦

### Main Dependencies
- **flutter**: Flutter SDK
- **cupertino_icons**: iOS-style icons
- **image_picker**: Camera and gallery access for scanning
- **http**: HTTP client for API calls
- **shared_preferences**: Local data storage
- **go_router**: Navigation and routing
- **firebase_core**: Firebase core functionality
- **firebase_messaging**: Push notifications
- **intl**: Internationalization support

### Dev Dependencies
- **flutter_test**: Testing framework
- **flutter_lints**: Code analysis and linting

## Configuration ⚙️

### Environment Variables

The app uses different backend URLs based on the platform:

```dart
// For Android Emulator
const String baseUrl = 'http://10.0.2.2:8000';

// For iOS Simulator or Web
// const String baseUrl = 'http://127.0.0.1:8000';
```

### Firebase Configuration

The app is configured to work with Firebase project ID: `ecosnap-app`

Supported platforms:
- Android: `1:267113823084:android:846057bc4643df2706d149`
- iOS: `1:267113823084:ios:a8f9b89b12c0c12306d149`
- Web: `1:267113823084:web:4fe6fdea5502ced006d149`

## API Endpoints 🌐

The app communicates with a Django backend server. Main endpoints include:

- **Authentication**
  - `POST /auth/login/` - User login
  - `POST /auth/register/` - User registration

- **User Management**
  - `GET /api/profile/` - Get user profile
  - `POST /api/device-token/` - Save device token for notifications

- **Scanning**
  - `POST /api/scan/` - Upload and analyze waste image
  - `GET /api/scans/` - Get user's scan history

- **Feed**
  - `GET /api/feeds/` - Get news feed

## Troubleshooting 🔧

### Common Issues

#### 1. Flutter Doctor Issues
```bash
flutter doctor
```
Run this command to check for any setup issues.

#### 2. Dependency Conflicts
```bash
flutter clean
flutter pub get
```

#### 3. Firebase Configuration Issues
- Ensure `google-services.json` is in the correct location
- Verify Firebase project configuration
- Check internet connectivity

#### 4. Backend Connection Issues
- Verify backend server is running on port 8000
- Check the correct IP address in `constants.dart`
- For Android emulator, use `10.0.2.2:8000`
- For iOS simulator/web, use `127.0.0.1:8000`

#### 5. Build Issues
```bash
# For Android
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter run

# For iOS
flutter clean
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
flutter pub get
flutter run
```

### Platform-Specific Issues

#### Android
- Ensure minimum SDK version is 21 or higher
- Check Android licenses: `flutter doctor --android-licenses`
- Verify USB debugging is enabled on physical devices

#### iOS
- Ensure Xcode is properly installed and updated
- Check iOS deployment target (iOS 12.0+)
- Verify developer account setup for physical devices

## Testing 🧪

### Running Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

### Test Structure
```
test/
├── widget_test.dart          # Widget tests
├── unit/                     # Unit tests
└── integration/              # Integration tests
```

## Contributing 🤝

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter analyze` to check for issues
- Format code with `dart format .`

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support 💬

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the [Flutter documentation](https://docs.flutter.dev/)

## Acknowledgments 🙏

- Flutter team for the amazing framework
- Firebase for backend services
- The open-source community for various packages used

---

**Happy Coding! 🚀🌱**
