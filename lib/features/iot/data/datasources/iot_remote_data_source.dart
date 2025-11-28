import '../models/iot_device_model.dart';
import '../models/sensor_data_model.dart';

/// Remote data source for IoT devices.
///
/// Handles communication with external APIs and services.
abstract class IotRemoteDataSource {
  /// Fetches all devices from the remote server.
  Future<List<IotDeviceModel>> getDevices();

  /// Fetches a specific device by ID.
  Future<IotDeviceModel> getDeviceById(String deviceId);

  /// Adds a new device to the remote server.
  Future<IotDeviceModel> addDevice(IotDeviceModel device);

  /// Updates a device on the remote server.
  Future<IotDeviceModel> updateDevice(IotDeviceModel device);

  /// Removes a device from the remote server.
  Future<bool> removeDevice(String deviceId);

  /// Connects to a device.
  Future<IotDeviceModel> connectToDevice(String deviceId);

  /// Disconnects from a device.
  Future<IotDeviceModel> disconnectFromDevice(String deviceId);

  /// Sends a command to a device.
  Future<bool> sendCommand(
    String deviceId,
    String command,
    Map<String, dynamic>? parameters,
  );

  /// Gets sensor data for a device.
  Future<List<SensorDataModel>> getSensorData(
    String deviceId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  });

  /// Streams real-time sensor data from a device.
  Stream<SensorDataModel> streamSensorData(String deviceId);

  /// Scans for nearby devices.
  Future<List<IotDeviceModel>> scanForDevices();
}
