import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecases.dart';
import '../repositories/auth_repository.dart';

/// Parameters for confirm sign up use case.
class ConfirmSignUpParams {
  final String email;
  final String confirmationCode;

  const ConfirmSignUpParams({
    required this.email,
    required this.confirmationCode,
  });
}

/// Use case for confirming user sign up with verification code.
class ConfirmSignUp implements UseCase<bool, ConfirmSignUpParams> {
  final AuthRepository repository;

  const ConfirmSignUp(this.repository);

  @override
  Future<Either<Failure, bool>> call(ConfirmSignUpParams params) {
    return repository.confirmSignUp(
      email: params.email,
      confirmationCode: params.confirmationCode,
    );
  }
}
