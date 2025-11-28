import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';
import 'auth_data_source.dart';

/// Implementation of AuthDataSource.
///
/// This is a placeholder implementation for development/testing.
/// In production, this would integrate with AWS Amplify Auth SDK.
class AuthDataSourceImpl implements AuthDataSource {
  // Simulated user storage for development purposes
  final Map<String, _MockUser> _users = {};
  String? _currentUserEmail;
  final Map<String, String> _pendingConfirmations = {};

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final user = _users[email];
    if (user == null) {
      throw const AuthException(message: 'User not found');
    }

    if (user.password != password) {
      throw const AuthException(message: 'Invalid password');
    }

    if (!user.isVerified) {
      throw const AuthException(message: 'Email not verified');
    }

    _currentUserEmail = email;

    return UserModel(
      id: user.id,
      email: email,
      displayName: user.displayName,
      isEmailVerified: user.isVerified,
      createdAt: user.createdAt,
    );
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (_users.containsKey(email)) {
      throw const AuthException(message: 'User already exists');
    }

    final user = _MockUser(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      password: password,
      displayName: displayName,
      isVerified: false,
      createdAt: DateTime.now(),
    );

    _users[email] = user;
    // Generate a mock confirmation code
    _pendingConfirmations[email] = '123456';

    return UserModel(
      id: user.id,
      email: email,
      displayName: displayName,
      isEmailVerified: false,
      createdAt: user.createdAt,
    );
  }

  @override
  Future<bool> confirmSignUp({
    required String email,
    required String confirmationCode,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final expectedCode = _pendingConfirmations[email];
    if (expectedCode == null) {
      throw const AuthException(message: 'No pending confirmation for this email');
    }

    if (confirmationCode != expectedCode) {
      throw const AuthException(message: 'Invalid confirmation code');
    }

    final user = _users[email];
    if (user == null) {
      throw const AuthException(message: 'User not found');
    }

    _users[email] = user.copyWith(isVerified: true);
    _pendingConfirmations.remove(email);

    return true;
  }

  @override
  Future<void> signOut() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUserEmail = null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    if (_currentUserEmail == null) {
      return null;
    }

    final user = _users[_currentUserEmail];
    if (user == null) {
      return null;
    }

    return UserModel(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      isEmailVerified: user.isVerified,
      createdAt: user.createdAt,
    );
  }

  @override
  Future<bool> resendConfirmationCode({
    required String email,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (!_users.containsKey(email)) {
      throw const AuthException(message: 'User not found');
    }

    // Generate new mock confirmation code
    _pendingConfirmations[email] = '123456';
    return true;
  }

  @override
  Future<bool> forgotPassword({
    required String email,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (!_users.containsKey(email)) {
      throw const AuthException(message: 'User not found');
    }

    // Generate mock reset code
    _pendingConfirmations[email] = '654321';
    return true;
  }

  @override
  Future<bool> confirmForgotPassword({
    required String email,
    required String confirmationCode,
    required String newPassword,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final expectedCode = _pendingConfirmations[email];
    if (expectedCode == null || confirmationCode != expectedCode) {
      throw const AuthException(message: 'Invalid confirmation code');
    }

    final user = _users[email];
    if (user == null) {
      throw const AuthException(message: 'User not found');
    }

    _users[email] = user.copyWith(password: newPassword);
    _pendingConfirmations.remove(email);

    return true;
  }
}

/// Mock user class for development purposes.
class _MockUser {
  final String id;
  final String email;
  final String password;
  final String? displayName;
  final bool isVerified;
  final DateTime createdAt;

  const _MockUser({
    required this.id,
    required this.email,
    required this.password,
    this.displayName,
    required this.isVerified,
    required this.createdAt,
  });

  _MockUser copyWith({
    String? id,
    String? email,
    String? password,
    String? displayName,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return _MockUser(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      displayName: displayName ?? this.displayName,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
