# AWS Amplify Setup Guide for Flutter

This comprehensive guide walks you through setting up AWS Amplify for authentication in this Flutter IoT application.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [AWS Account Setup](#aws-account-setup)
3. [Install Amplify CLI](#install-amplify-cli)
4. [Initialize Amplify Project](#initialize-amplify-project)
5. [Add Authentication](#add-authentication)
6. [Flutter Integration](#flutter-integration)
7. [Platform Configuration](#platform-configuration)
8. [Implementation Guide](#implementation-guide)
9. [Testing](#testing)
10. [Troubleshooting](#troubleshooting)

## Prerequisites

Before starting, ensure you have:

- ✅ Flutter SDK (>= 3.10.0) installed
- ✅ Dart SDK (>= 3.0.0) installed
- ✅ Node.js (v14 or later) and npm installed
- ✅ An AWS account (free tier available)
- ✅ A code editor (VS Code recommended)

## AWS Account Setup

1. **Create an AWS Account** (if you don't have one):
   - Go to [aws.amazon.com](https://aws.amazon.com)
   - Click "Create an AWS Account"
   - Follow the registration process

2. **Enable MFA** (recommended):
   - Sign in to AWS Console
   - Go to IAM → Security credentials
   - Enable MFA for your root account

## Install Amplify CLI

Install the Amplify CLI globally:

```bash
npm install -g @aws-amplify/cli
```

Verify installation:

```bash
amplify --version
```

## Initialize Amplify Project

### Step 1: Configure Amplify CLI

```bash
amplify configure
```

This will:
1. Open the AWS Console in your browser
2. Ask you to sign in
3. Guide you to create an IAM user

Follow these prompts:
```
? region: us-east-1 (or your preferred region)
? user name: amplify-iot-user
```

The CLI will open the AWS Console to create an IAM user:
1. Keep the default settings
2. Click "Next: Permissions"
3. Add "AdministratorAccess-Amplify" policy
4. Create the user and download credentials

Enter the access keys when prompted:
```
? accessKeyId: <YOUR_ACCESS_KEY>
? secretAccessKey: <YOUR_SECRET_KEY>
? Profile Name: default
```

### Step 2: Initialize Amplify in Your Project

Navigate to your Flutter project and run:

```bash
cd /path/to/iot-app
amplify init
```

Answer the prompts:
```
? Enter a name for the project: iotapp
? Initialize the project with the above configuration? No
? Enter a name for the environment: dev
? Choose your default editor: Visual Studio Code
? Choose the type of app that you're building: flutter
? Where do you want to store your configuration file: ./lib/
? Select the authentication method: AWS profile
? Please choose the profile: default
```

## Add Authentication

### Step 1: Add Auth Category

```bash
amplify add auth
```

Recommended configuration:
```
? Do you want to use the default authentication and security configuration? 
  > Default configuration

? How do you want users to be able to sign in?
  > Email

? Do you want to configure advanced settings?
  > No, I am done.
```

### Step 2: Deploy Backend

```bash
amplify push
```

Confirm the changes:
```
? Are you sure you want to continue? Yes
```

This creates:
- AWS Cognito User Pool
- Identity Pool
- IAM roles

### Step 3: Verify Resources

```bash
amplify status
```

You should see:
```
Current Environment: dev

| Category | Resource name   | Operation | Provider plugin   |
| -------- | --------------- | --------- | ----------------- |
| Auth     | iotappxxxxxx    | No Change | awscloudformation |
```

## Flutter Integration

### Step 1: Add Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  amplify_flutter: ^2.2.0
  amplify_auth_cognito: ^2.2.0
```

Run:
```bash
flutter pub get
```

### Step 2: Configure Amplify

The `amplify push` command generated `lib/amplifyconfiguration.dart`. This file contains your AWS configuration.

Update `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'amplifyconfiguration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _amplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito();
      await Amplify.addPlugins([auth]);
      await Amplify.configure(amplifyconfig);
      
      setState(() {
        _amplifyConfigured = true;
      });
    } on AmplifyAlreadyConfiguredException {
      debugPrint('Amplify was already configured.');
      setState(() {
        _amplifyConfigured = true;
      });
    } catch (e) {
      debugPrint('Error configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT App',
      home: _amplifyConfigured
          ? const HomeScreen()
          : const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
```

## Platform Configuration

### iOS Configuration

1. Update minimum iOS version in `ios/Podfile`:
```ruby
platform :ios, '13.0'
```

2. Add URL scheme in `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>iotapp</string>
    </array>
  </dict>
</array>
```

3. Run pod install:
```bash
cd ios && pod install && cd ..
```

### Android Configuration

1. Update `android/app/build.gradle`:
```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 24
        targetSdkVersion 34
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
}
```

2. Add redirect activity in `android/app/src/main/AndroidManifest.xml`:
```xml
<manifest ...>
    <application ...>
        <!-- Existing activities -->
        
        <activity
            android:name="com.amplifyframework.auth.cognito.activities.HostedUIRedirectActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="iotapp" />
            </intent-filter>
        </activity>
    </application>
</manifest>
```

## Implementation Guide

### Auth Data Source Implementation

Replace the mock `AuthDataSourceImpl` with Amplify:

```dart
// lib/features/auth/data/datasources/amplify_auth_data_source.dart

import 'package:amplify_flutter/amplify_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';
import 'auth_data_source.dart';

class AmplifyAuthDataSource implements AuthDataSource {
  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );

      if (result.isSignedIn) {
        return await _getCurrentUserData();
      }

      // Handle additional sign-in steps (MFA, etc.)
      if (result.nextStep.signInStep == AuthSignInStep.confirmSignInWithSmsMfaCode) {
        throw const AuthException(
          message: 'MFA code required',
          code: 1001,
        );
      }

      throw const AuthException(message: 'Sign in incomplete');
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw AuthException(message: 'Sign in failed: $e');
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final userAttributes = {
        AuthUserAttributeKey.email: email,
        if (displayName != null) AuthUserAttributeKey.name: displayName,
      };

      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(userAttributes: userAttributes),
      );

      return UserModel(
        id: email,
        email: email,
        displayName: displayName,
        isEmailVerified: result.isSignUpComplete,
        createdAt: DateTime.now(),
      );
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw AuthException(message: 'Sign up failed: $e');
    }
  }

  @override
  Future<bool> confirmSignUp({
    required String email,
    required String confirmationCode,
  }) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: confirmationCode,
      );
      return result.isSignUpComplete;
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw AuthException(message: 'Confirmation failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw AuthException(message: 'Sign out failed: $e');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      if (!session.isSignedIn) {
        return null;
      }
      return await _getCurrentUserData();
    } on SignedOutException {
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> resendConfirmationCode({required String email}) async {
    try {
      await Amplify.Auth.resendSignUpCode(username: email);
      return true;
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw AuthException(message: 'Resend failed: $e');
    }
  }

  @override
  Future<bool> forgotPassword({required String email}) async {
    try {
      await Amplify.Auth.resetPassword(username: email);
      return true;
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw AuthException(message: 'Password reset failed: $e');
    }
  }

  @override
  Future<bool> confirmForgotPassword({
    required String email,
    required String confirmationCode,
    required String newPassword,
  }) async {
    try {
      await Amplify.Auth.confirmResetPassword(
        username: email,
        newPassword: newPassword,
        confirmationCode: confirmationCode,
      );
      return true;
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw AuthException(message: 'Password reset confirmation failed: $e');
    }
  }

  Future<UserModel> _getCurrentUserData() async {
    final user = await Amplify.Auth.getCurrentUser();
    final attributes = await Amplify.Auth.fetchUserAttributes();

    String? email;
    String? name;
    bool emailVerified = false;

    for (final attr in attributes) {
      switch (attr.userAttributeKey.key) {
        case 'email':
          email = attr.value;
          break;
        case 'name':
          name = attr.value;
          break;
        case 'email_verified':
          emailVerified = attr.value.toLowerCase() == 'true';
          break;
      }
    }

    return UserModel(
      id: user.userId,
      email: email ?? '',
      displayName: name,
      isEmailVerified: emailVerified,
      createdAt: DateTime.now(),
    );
  }
}
```

### Provider Setup

Update the auth provider to use Amplify:

```dart
// lib/features/auth/presentation/providers/auth_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/amplify_auth_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(
    dataSource: AmplifyAuthDataSource(),
  );
}
```

## Testing

### Local Testing

1. Run the app:
```bash
flutter run
```

2. Test authentication flow:
   - Sign up with a valid email
   - Check your email for verification code
   - Enter the code to verify
   - Sign in with your credentials

### Unit Testing

Mock Amplify for unit tests:

```dart
// test/features/auth/auth_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

// Create mock classes for Amplify Auth
class MockAmplifyAuth extends Mock implements AuthCategory {}

void main() {
  group('Auth Tests', () {
    test('should sign in successfully', () async {
      // Your test implementation
    });
  });
}
```

## Troubleshooting

### Common Issues

#### 1. "Amplify has already been configured"
**Solution**: Check if `Amplify.configure()` is called multiple times. Wrap in try-catch:
```dart
try {
  await Amplify.configure(amplifyconfig);
} on AmplifyAlreadyConfiguredException {
  // Already configured, continue
}
```

#### 2. "User not found"
**Solution**: Verify the user exists in Cognito:
1. Go to AWS Console → Cognito
2. Select your User Pool
3. Check "Users" tab

#### 3. iOS Build Errors
**Solution**:
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

#### 4. Android Gradle Issues
**Solution**: Update Gradle wrapper:
```bash
cd android
./gradlew wrapper --gradle-version=8.0
cd ..
```

#### 5. "Missing configuration file"
**Solution**: Run `amplify push` to generate the configuration file.

### Getting Help

- [AWS Amplify Flutter Documentation](https://docs.amplify.aws/flutter/)
- [AWS Amplify GitHub Issues](https://github.com/aws-amplify/amplify-flutter/issues)
- [Stack Overflow - amplify-flutter tag](https://stackoverflow.com/questions/tagged/amplify-flutter)

## Security Best Practices

1. **Never commit `amplifyconfiguration.dart`** if it contains sensitive information
2. **Enable MFA** for production apps
3. **Use strong password policies** in Cognito
4. **Implement token refresh** for long-running sessions
5. **Handle session expiry** gracefully in the UI

## Next Steps

After setting up authentication:

1. Implement token-based API authentication
2. Add social sign-in (Google, Apple, Facebook)
3. Configure user groups for access control
4. Set up push notifications with Amazon Pinpoint
5. Add analytics with Amazon Pinpoint
