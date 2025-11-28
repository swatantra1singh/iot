import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecases.dart';
import '../entities/iot_device.dart';
import '../repositories/iot_device_repository.dart';

/// Parameters for the GetDeviceById use case.
class GetDeviceByIdParams {
  final String deviceId;

  const GetDeviceByIdParams({required this.deviceId});
}

/// Use case for getting a specific IoT device by ID.
class GetDeviceById implements UseCase<IotDevice, GetDeviceByIdParams> {
  final IotDeviceRepository repository;

  GetDeviceById(this.repository);

  @override
  Future<Either<Failure, IotDevice>> call(GetDeviceByIdParams params) {
    return repository.getDeviceById(params.deviceId);
  }
}
