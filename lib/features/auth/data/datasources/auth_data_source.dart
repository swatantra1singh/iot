import '../models/user_model.dart';

/// Abstract data source for authentication operations.
///
/// This is a placeholder for AWS Amplify Auth integration.
/// In production, this would integrate with AWS Amplify Auth SDK.
abstract class AuthDataSource {
  /// Signs in a user with email and password.
  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  /// Signs up a new user.
  Future<UserModel> signUp({
    required String email,
    required String password,
    String? displayName,
  });

  /// Confirms user sign up with verification code.
  Future<bool> confirmSignUp({
    required String email,
    required String confirmationCode,
  });

  /// Signs out the current user.
  Future<void> signOut();

  /// Gets the currently authenticated user.
  Future<UserModel?> getCurrentUser();

  /// Resends the confirmation code to the user's email.
  Future<bool> resendConfirmationCode({
    required String email,
  });

  /// Initiates password reset flow.
  Future<bool> forgotPassword({
    required String email,
  });

  /// Confirms password reset with code and new password.
  Future<bool> confirmForgotPassword({
    required String email,
    required String confirmationCode,
    required String newPassword,
  });
}
