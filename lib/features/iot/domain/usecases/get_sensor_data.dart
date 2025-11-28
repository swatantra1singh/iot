import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecases.dart';
import '../entities/sensor_data.dart';
import '../repositories/iot_device_repository.dart';

/// Parameters for the GetSensorData use case.
class GetSensorDataParams {
  final String deviceId;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? limit;

  const GetSensorDataParams({
    required this.deviceId,
    this.startDate,
    this.endDate,
    this.limit,
  });
}

/// Use case for getting sensor data from an IoT device.
class GetSensorData implements UseCase<List<SensorData>, GetSensorDataParams> {
  final IotDeviceRepository repository;

  GetSensorData(this.repository);

  @override
  Future<Either<Failure, List<SensorData>>> call(GetSensorDataParams params) {
    return repository.getSensorData(
      params.deviceId,
      startDate: params.startDate,
      endDate: params.endDate,
      limit: params.limit,
    );
  }
}
