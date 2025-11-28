import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecases.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for getting the currently authenticated user.
class GetCurrentUser implements UseCase<User?, NoParams> {
  final AuthRepository repository;

  const GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, User?>> call(NoParams params) {
    return repository.getCurrentUser();
  }
}
