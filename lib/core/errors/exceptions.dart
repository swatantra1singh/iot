/// Base exception class for the application.
///
/// All exceptions in the application should extend this class.
class AppException implements Exception {
  final String message;
  final int? code;
  final dynamic originalException;

  const AppException({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Exception for server-related errors.
class ServerException extends AppException {
  const ServerException({
    super.message = 'Server error occurred',
    super.code,
    super.originalException,
  });
}

/// Exception for network connectivity issues.
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection',
    super.code,
    super.originalException,
  });
}

/// Exception for cache-related errors.
class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache error occurred',
    super.code,
    super.originalException,
  });
}

/// Exception for authentication errors.
class AuthException extends AppException {
  const AuthException({
    super.message = 'Authentication failed',
    super.code,
    super.originalException,
  });
}

/// Exception for validation errors.
class ValidationException extends AppException {
  const ValidationException({
    super.message = 'Validation failed',
    super.code,
    super.originalException,
  });
}

/// Exception for IoT device connection errors.
class DeviceConnectionException extends AppException {
  const DeviceConnectionException({
    super.message = 'Failed to connect to device',
    super.code,
    super.originalException,
  });
}

/// Exception for Bluetooth-related errors.
class BluetoothException extends AppException {
  const BluetoothException({
    super.message = 'Bluetooth error occurred',
    super.code,
    super.originalException,
  });
}

/// Exception for MQTT-related errors.
class MqttException extends AppException {
  const MqttException({
    super.message = 'MQTT connection error',
    super.code,
    super.originalException,
  });
}
