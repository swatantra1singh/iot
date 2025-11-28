# IoT App

A production-grade Flutter IoT application built with Clean Architecture and Riverpod state management.

## Features

- 📱 Cross-platform support (iOS and Android)
- 🏗️ Clean Architecture with strict layer separation
- 🔄 State management with Riverpod (code generation)
- 📡 IoT device management (Bluetooth, WiFi, MQTT)
- 🎨 Modern Material Design 3 UI
- 🌓 Light and Dark theme support
- ✅ Comprehensive test coverage

## Architecture

This project follows Clean Architecture principles with the following structure:

```
lib/
├── core/                    # Core utilities and shared code
│   ├── constants/           # App constants
│   ├── errors/              # Error handling (Failures & Exceptions)
│   ├── theme/               # App theming
│   ├── router/              # Navigation routing
│   └── utils/               # Shared utilities
│
├── features/                # Feature modules
│   └── iot/                 # IoT feature
│       ├── data/            # Data layer
│       │   ├── datasources/ # Remote and local data sources
│       │   ├── models/      # Data models with JSON serialization
│       │   └── repositories/# Repository implementations
│       │
│       ├── domain/          # Domain layer
│       │   ├── entities/    # Business entities
│       │   ├── repositories/# Repository interfaces
│       │   └── usecases/    # Use cases
│       │
│       └── presentation/    # Presentation layer
│           ├── providers/   # Riverpod providers
│           ├── screens/     # UI screens
│           └── widgets/     # Reusable widgets
│
└── app.dart                 # App configuration
```

## Getting Started

### Prerequisites

- Flutter SDK (>= 3.10.0)
- Dart SDK (>= 3.0.0)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/your-repo/iot-app.git
cd iot-app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code (Riverpod, JSON serialization):
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

## State Management

This project uses [Riverpod](https://riverpod.dev/) with code generation for type-safe state management.

### Providers

```dart
// Using providers
final deviceState = ref.watch(iotDeviceNotifierProvider);
final deviceNotifier = ref.read(iotDeviceNotifierProvider.notifier);

// Load devices
await deviceNotifier.loadDevices();

// Connect to a device
await deviceNotifier.connectDevice(deviceId);
```

### Code Generation

Providers are generated using `riverpod_generator`. After making changes to providers, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Testing

Run all tests:
```bash
flutter test
```

Run tests with coverage:
```bash
flutter test --coverage
```

## Dependencies

### Main Dependencies

| Package | Description |
|---------|-------------|
| `hooks_riverpod` | State management |
| `riverpod_annotation` | Riverpod code generation annotations |
| `freezed_annotation` | Immutable data classes |
| `dartz` | Functional programming utilities |
| `dio` | HTTP client |
| `retrofit` | Type-safe HTTP client with code generation |
| `go_router` | Declarative routing |
| `mqtt_client` | MQTT protocol support |
| `flutter_blue_plus` | Bluetooth support |
| `connectivity_plus` | Network connectivity |

### Dev Dependencies

| Package | Description |
|---------|-------------|
| `build_runner` | Code generation |
| `riverpod_generator` | Riverpod provider generation |
| `retrofit_generator` | Retrofit code generation |
| `freezed` | Immutable data class generation |
| `json_serializable` | JSON serialization generation |
| `mockito` | Mocking for tests |

## Project Structure

### Core Layer

- **Constants**: API endpoints, app configuration, storage keys
- **Errors**: Failure and Exception classes for error handling
- **Theme**: App colors, text styles, and theme configuration
- **Router**: GoRouter configuration for navigation
- **Utils**: Base use case classes and shared utilities

### Feature Layers

Each feature follows the Clean Architecture pattern:

1. **Data Layer**: Implements repositories, contains data sources and models
2. **Domain Layer**: Contains business logic (entities, repository interfaces, use cases)
3. **Presentation Layer**: UI components and state management

## IoT Capabilities

- **Device Discovery**: Scan for nearby Bluetooth/WiFi devices
- **Device Connection**: Connect to and manage IoT devices
- **Command Sending**: Send commands to connected devices
- **Sensor Data**: Receive and display real-time sensor data
- **Device Status**: Monitor device connection status

## Network Layer (Retrofit + Dio)

This project uses **Retrofit** with **Dio** for type-safe HTTP API calls:

### API Service Definition

```dart
@RestApi()
abstract class IotApiService {
  factory IotApiService(Dio dio, {String baseUrl}) = _IotApiService;

  @GET('/devices')
  Future<List<IotDeviceModel>> getDevices();

  @POST('/devices')
  Future<IotDeviceModel> createDevice(@Body() IotDeviceModel device);

  @PUT('/devices/{id}')
  Future<IotDeviceModel> updateDevice(
    @Path('id') String deviceId,
    @Body() IotDeviceModel device,
  );
}
```

### Using the API Service

```dart
// Create the service
final dio = DioClient.instance;
final apiService = IotApiService(dio);

// Make API calls
final devices = await apiService.getDevices();
final device = await apiService.getDeviceById('device-123');
```

### Error Handling

The `IotRetrofitDataSource` automatically maps `DioException` to application-specific exceptions:
- Network timeouts → `NetworkException`
- Connection errors → `NetworkException`
- 401/403 errors → `AuthException`
- Other server errors → `ServerException`

## AWS Amplify Setup for Flutter

This section provides a comprehensive guide on setting up AWS Amplify for Flutter authentication.

### Prerequisites

1. An AWS account
2. Node.js (v14 or later) and npm installed
3. Flutter SDK installed
4. Amplify CLI installed globally:
   ```bash
   npm install -g @aws-amplify/cli
   ```

### Step 1: Configure Amplify CLI

```bash
amplify configure
```

Follow the prompts to:
1. Sign in to your AWS account
2. Specify the AWS region
3. Create an IAM user with appropriate permissions
4. Save the access keys

### Step 2: Initialize Amplify in Your Project

```bash
cd /path/to/your/flutter/project
amplify init
```

Answer the prompts:
- **Project name**: Your app name
- **Environment**: `dev` (or your preferred environment)
- **Default editor**: Your preferred code editor
- **App type**: Flutter
- **Configuration file**: Accept defaults

### Step 3: Add Authentication

```bash
amplify add auth
```

Recommended configuration for this IoT app:
- **Default configuration**: `Default configuration`
- **Sign-in method**: `Email`
- **Advanced settings**: Configure MFA, password requirements as needed

### Step 4: Deploy Backend

```bash
amplify push
```

This creates the AWS Cognito resources in your AWS account.

### Step 5: Add Flutter Dependencies

Add these dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  amplify_flutter: ^2.2.0
  amplify_auth_cognito: ^2.2.0
```

### Step 6: Configure Amplify in Flutter

Create or update `lib/main.dart`:

```dart
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'amplifyconfiguration.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await _configureAmplify();
  } catch (e) {
    print('Error configuring Amplify: $e');
  }
  
  runApp(const MyApp());
}

Future<void> _configureAmplify() async {
  final auth = AmplifyAuthCognito();
  await Amplify.addPlugins([auth]);
  await Amplify.configure(amplifyconfig);
}
```

### Step 7: Implement Auth Repository

The auth repository implementation in this project (`AuthDataSourceImpl`) is a placeholder. Replace it with AWS Amplify calls:

```dart
import 'package:amplify_flutter/amplify_flutter.dart';

class AmplifyAuthDataSource implements AuthDataSource {
  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final result = await Amplify.Auth.signIn(
      username: email,
      password: password,
    );
    
    if (result.isSignedIn) {
      final user = await Amplify.Auth.getCurrentUser();
      return UserModel(
        id: user.userId,
        email: email,
        isEmailVerified: true,
      );
    }
    throw const AuthException(message: 'Sign in failed');
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final userAttributes = {
      AuthUserAttributeKey.email: email,
      if (displayName != null) AuthUserAttributeKey.name: displayName,
    };
    
    await Amplify.Auth.signUp(
      username: email,
      password: password,
      options: SignUpOptions(userAttributes: userAttributes),
    );
    
    return UserModel(
      id: email,
      email: email,
      displayName: displayName,
      isEmailVerified: false,
    );
  }

  @override
  Future<bool> confirmSignUp({
    required String email,
    required String confirmationCode,
  }) async {
    final result = await Amplify.Auth.confirmSignUp(
      username: email,
      confirmationCode: confirmationCode,
    );
    return result.isSignUpComplete;
  }

  @override
  Future<void> signOut() async {
    await Amplify.Auth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      final attributes = await Amplify.Auth.fetchUserAttributes();
      
      String? email;
      String? name;
      
      for (final attr in attributes) {
        if (attr.userAttributeKey == AuthUserAttributeKey.email) {
          email = attr.value;
        }
        if (attr.userAttributeKey == AuthUserAttributeKey.name) {
          name = attr.value;
        }
      }
      
      return UserModel(
        id: user.userId,
        email: email ?? '',
        displayName: name,
        isEmailVerified: true,
      );
    } on SignedOutException {
      return null;
    }
  }

  @override
  Future<bool> forgotPassword({required String email}) async {
    await Amplify.Auth.resetPassword(username: email);
    return true;
  }

  @override
  Future<bool> confirmForgotPassword({
    required String email,
    required String confirmationCode,
    required String newPassword,
  }) async {
    await Amplify.Auth.confirmResetPassword(
      username: email,
      newPassword: newPassword,
      confirmationCode: confirmationCode,
    );
    return true;
  }

  @override
  Future<bool> resendConfirmationCode({required String email}) async {
    await Amplify.Auth.resendSignUpCode(username: email);
    return true;
  }
}
```

### Step 8: iOS Configuration

For iOS, add the Amplify configuration:

1. Add to `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>myapp</string>
    </array>
  </dict>
</array>
```

2. Update the minimum iOS version in `ios/Podfile`:
```ruby
platform :ios, '13.0'
```

### Step 9: Android Configuration

1. Update `android/app/build.gradle`:
```gradle
android {
    compileSdkVersion 34
    defaultConfig {
        minSdkVersion 24
        targetSdkVersion 34
    }
}
```

2. Add to `android/app/src/main/AndroidManifest.xml` (inside `<application>`):
```xml
<activity
    android:name="com.amplifyframework.auth.cognito.activities.HostedUIRedirectActivity"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="myapp" />
    </intent-filter>
</activity>
```

### Troubleshooting

**Common Issues:**

1. **Configuration not found**: Ensure `amplifyconfiguration.dart` exists in your lib folder
2. **Plugin not registered**: Make sure you call `Amplify.addPlugins()` before `Amplify.configure()`
3. **iOS build errors**: Update CocoaPods and run `pod install` in the ios directory
4. **Android build errors**: Ensure minimum SDK version is 24 or higher

### Further Resources

- [Amplify Flutter Documentation](https://docs.amplify.aws/flutter/)
- [AWS Amplify GitHub](https://github.com/aws-amplify/amplify-flutter)
- [Amplify Auth Getting Started](https://docs.amplify.aws/flutter/build-a-backend/auth/set-up-auth/)

For a detailed step-by-step guide, see [docs/AWS_AMPLIFY_SETUP.md](docs/AWS_AMPLIFY_SETUP.md).

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
