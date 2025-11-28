import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecases.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Parameters for sign in use case.
class SignInParams {
  final String email;
  final String password;

  const SignInParams({
    required this.email,
    required this.password,
  });
}

/// Use case for signing in a user.
class SignIn implements UseCase<User, SignInParams> {
  final AuthRepository repository;

  const SignIn(this.repository);

  @override
  Future<Either<Failure, User>> call(SignInParams params) {
    return repository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}
