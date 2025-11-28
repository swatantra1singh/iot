import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecases.dart';
import '../entities/iot_device.dart';
import '../repositories/iot_device_repository.dart';

/// Use case for scanning for nearby IoT devices.
class ScanForDevices implements UseCaseNoParams<List<IotDevice>> {
  final IotDeviceRepository repository;

  ScanForDevices(this.repository);

  @override
  Future<Either<Failure, List<IotDevice>>> call() {
    return repository.scanForDevices();
  }
}
