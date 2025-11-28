import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/usecases.dart';
import '../repositories/iot_device_repository.dart';

/// Parameters for the SendCommand use case.
class SendCommandParams {
  final String deviceId;
  final String command;
  final Map<String, dynamic>? parameters;

  const SendCommandParams({
    required this.deviceId,
    required this.command,
    this.parameters,
  });
}

/// Use case for sending a command to an IoT device.
class SendCommand implements UseCase<bool, SendCommandParams> {
  final IotDeviceRepository repository;

  SendCommand(this.repository);

  @override
  Future<Either<Failure, bool>> call(SendCommandParams params) {
    return repository.sendCommand(
      params.deviceId,
      params.command,
      params.parameters,
    );
  }
}
