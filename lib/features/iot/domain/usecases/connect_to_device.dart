import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecases.dart';
import '../entities/iot_device.dart';
import '../repositories/iot_device_repository.dart';

/// Parameters for the ConnectToDevice use case.
class ConnectToDeviceParams {
  final String deviceId;

  const ConnectToDeviceParams({required this.deviceId});
}

/// Use case for connecting to an IoT device.
class ConnectToDevice implements UseCase<IotDevice, ConnectToDeviceParams> {
  final IotDeviceRepository repository;

  ConnectToDevice(this.repository);

  @override
  Future<Either<Failure, IotDevice>> call(ConnectToDeviceParams params) {
    return repository.connectToDevice(params.deviceId);
  }
}
