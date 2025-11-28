import 'user.dart';

/// Sealed class representing authentication states.
sealed class AuthState {
  const AuthState();
}

/// Initial authentication state.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state during authentication operations.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authenticated state with user information.
class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);
}

/// Unauthenticated state.
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// Error state during authentication.
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}

/// State indicating email verification is required.
class AuthNeedsVerification extends AuthState {
  final String email;

  const AuthNeedsVerification(this.email);
}
