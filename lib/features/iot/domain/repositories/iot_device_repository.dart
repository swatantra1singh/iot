import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/iot_device.dart';
import '../entities/sensor_data.dart';

/// Repository interface for IoT device operations.
///
/// This defines the contract that data layer implementations must follow.
/// It uses [Either] to represent success/failure states.
abstract class IotDeviceRepository {
  /// Gets a list of all IoT devices.
  ///
  /// Returns [Right] with list of devices on success,
  /// or [Left] with [Failure] on error.
  Future<Either<Failure, List<IotDevice>>> getDevices();

  /// Gets a specific device by its ID.
  ///
  /// Returns [Right] with device on success,
  /// or [Left] with [Failure] on error.
  Future<Either<Failure, IotDevice>> getDeviceById(String deviceId);

  /// Adds a new device.
  ///
  /// Returns [Right] with the added device on success,
  /// or [Left] with [Failure] on error.
  Future<Either<Failure, IotDevice>> addDevice(IotDevice device);

  /// Updates an existing device.
  ///
  /// Returns [Right] with the updated device on success,
  /// or [Left] with [Failure] on error.
  Future<Either<Failure, IotDevice>> updateDevice(IotDevice device);

  /// Removes a device.
  ///
  /// Returns [Right] with true on success,
  /// or [Left] with [Failure] on error.
  Future<Either<Failure, bool>> removeDevice(String deviceId);

  /// Connects to a device.
  ///
  /// Returns [Right] with the connected device on success,
  /// or [Left] with [Failure] on error.
  Future<Either<Failure, IotDevice>> connectToDevice(String deviceId);

  /// Disconnects from a device.
  ///
  /// Returns [Right] with the disconnected device on success,
  /// or [Left] with [Failure] on error.
  Future<Either<Failure, IotDevice>> disconnectFromDevice(String deviceId);

  /// Sends a command to a device.
  ///
  /// Returns [Right] with true on success,
  /// or [Left] with [Failure] on error.
  Future<Either<Failure, bool>> sendCommand(
    String deviceId,
    String command,
    Map<String, dynamic>? parameters,
  );

  /// Gets sensor data from a device.
  ///
  /// Returns [Right] with list of sensor data on success,
  /// or [Left] with [Failure] on error.
  Future<Either<Failure, List<SensorData>>> getSensorData(
    String deviceId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  });

  /// Streams real-time sensor data from a device.
  ///
  /// Returns a stream of [Either] with sensor data on success,
  /// or [Failure] on error.
  Stream<Either<Failure, SensorData>> streamSensorData(String deviceId);

  /// Scans for nearby devices (Bluetooth/WiFi).
  ///
  /// Returns [Right] with list of discovered devices on success,
  /// or [Left] with [Failure] on error.
  Future<Either<Failure, List<IotDevice>>> scanForDevices();
}
