import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecases.dart';
import '../entities/iot_device.dart';
import '../repositories/iot_device_repository.dart';

/// Use case for getting all IoT devices.
class GetDevices implements UseCaseNoParams<List<IotDevice>> {
  final IotDeviceRepository repository;

  GetDevices(this.repository);

  @override
  Future<Either<Failure, List<IotDevice>>> call() {
    return repository.getDevices();
  }
}
