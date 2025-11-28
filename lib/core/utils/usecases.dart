import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Base class for use cases with parameters.
///
/// Every use case should extend this class and implement the [call] method.
/// The [call] method should return an [Either] with a [Failure] on the left
/// or the expected result [Type] on the right.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Base class for use cases without parameters.
///
/// Use [NoParams] as the parameter type when the use case doesn't need any input.
abstract class UseCaseNoParams<Type> {
  Future<Either<Failure, Type>> call();
}

/// Base class for stream-based use cases.
///
/// Use this for use cases that return a stream of values, such as
/// real-time data from IoT devices.
abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}

/// Class representing no parameters for use cases.
class NoParams {
  const NoParams();
}
