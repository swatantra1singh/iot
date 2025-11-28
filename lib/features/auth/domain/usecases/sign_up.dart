import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecases.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Parameters for sign up use case.
class SignUpParams {
  final String email;
  final String password;
  final String? displayName;

  const SignUpParams({
    required this.email,
    required this.password,
    this.displayName,
  });
}

/// Use case for signing up a new user.
class SignUp implements UseCase<User, SignUpParams> {
  final AuthRepository repository;

  const SignUp(this.repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) {
    return repository.signUp(
      email: params.email,
      password: params.password,
      displayName: params.displayName,
    );
  }
}
