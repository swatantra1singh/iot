import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

/// Abstract repository for authentication operations.
abstract class AuthRepository {
  /// Signs in a user with email and password.
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });

  /// Signs up a new user.
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    String? displayName,
  });

  /// Confirms user sign up with verification code.
  Future<Either<Failure, bool>> confirmSignUp({
    required String email,
    required String confirmationCode,
  });

  /// Signs out the current user.
  Future<Either<Failure, void>> signOut();

  /// Gets the currently authenticated user.
  Future<Either<Failure, User?>> getCurrentUser();

  /// Resends the confirmation code to the user's email.
  Future<Either<Failure, bool>> resendConfirmationCode({
    required String email,
  });

  /// Initiates password reset flow.
  Future<Either<Failure, bool>> forgotPassword({
    required String email,
  });

  /// Confirms password reset with code and new password.
  Future<Either<Failure, bool>> confirmForgotPassword({
    required String email,
    required String confirmationCode,
    required String newPassword,
  });
}
