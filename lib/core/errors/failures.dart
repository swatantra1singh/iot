import 'package:equatable/equatable.dart';

/// Base class for application failures.
///
/// All failures in the application should extend this class.
/// Failures represent expected error conditions that the application
/// can handle gracefully.
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Failure for server-related errors.
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Server error occurred',
    super.code,
  });
}

/// Failure for network connectivity issues.
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection',
    super.code,
  });
}

/// Failure for cache-related errors.
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Cache error occurred',
    super.code,
  });
}

/// Failure for authentication errors.
class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Authentication failed',
    super.code,
  });
}

/// Failure for validation errors.
class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message = 'Validation failed',
    super.code,
  });
}

/// Failure for IoT device connection errors.
class DeviceConnectionFailure extends Failure {
  const DeviceConnectionFailure({
    super.message = 'Failed to connect to device',
    super.code,
  });
}

/// Failure for Bluetooth-related errors.
class BluetoothFailure extends Failure {
  const BluetoothFailure({
    super.message = 'Bluetooth error occurred',
    super.code,
  });
}

/// Failure for MQTT-related errors.
class MqttFailure extends Failure {
  const MqttFailure({
    super.message = 'MQTT connection error',
    super.code,
  });
}
