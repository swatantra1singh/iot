import 'dart:async';

import '../models/iot_device_model.dart';
import '../models/sensor_data_model.dart';
import 'iot_remote_data_source.dart';

/// Mock implementation of [IotRemoteDataSource].
///
/// Returns stub data for development and testing. Replace with a real
/// implementation when the backend API is available.
class IotRemoteDataSourceImpl implements IotRemoteDataSource {
  IotRemoteDataSourceImpl();

  // In-memory store for mock devices
  final List<IotDeviceModel> _devices = [
    IotDeviceModel(
      id: 'device-001',
      name: 'Living Room Thermostat',
      type: 'thermostat',
      status: 'online',
      lastUpdated: DateTime.now().toIso8601String(),
      metadata: {'temperature': 22.5, 'humidity': 45},
    ),
    IotDeviceModel(
      id: 'device-002',
      name: 'Front Door Lock',
      type: 'smart_lock',
      status: 'online',
      lastUpdated: DateTime.now().toIso8601String(),
      metadata: {'locked': true},
    ),
    IotDeviceModel(
      id: 'device-003',
      name: 'Kitchen Light',
      type: 'light',
      status: 'offline',
      lastUpdated:
          DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      metadata: {'brightness': 0, 'color': '#FFFFFF'},
    ),
  ];

  @override
  Future<List<IotDeviceModel>> getDevices() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_devices);
  }

  @override
  Future<IotDeviceModel> getDeviceById(String deviceId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _devices.firstWhere(
      (d) => d.id == deviceId,
      orElse: () => throw Exception('Device not found: $deviceId'),
    );
  }

  @override
  Future<IotDeviceModel> addDevice(IotDeviceModel device) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _devices.add(device);
    return device;
  }

  @override
  Future<IotDeviceModel> updateDevice(IotDeviceModel device) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _devices.indexWhere((d) => d.id == device.id);
    if (index == -1) {
      throw Exception('Device not found: ${device.id}');
    }
    _devices[index] = device;
    return device;
  }

  @override
  Future<bool> removeDevice(String deviceId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final initialLength = _devices.length;
    _devices.removeWhere((d) => d.id == deviceId);
    return _devices.length < initialLength;
  }

  @override
  Future<IotDeviceModel> connectToDevice(String deviceId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final index = _devices.indexWhere((d) => d.id == deviceId);
    if (index == -1) {
      throw Exception('Device not found: $deviceId');
    }
    final updated = IotDeviceModel(
      id: _devices[index].id,
      name: _devices[index].name,
      type: _devices[index].type,
      status: 'online',
      lastUpdated: DateTime.now().toIso8601String(),
      metadata: _devices[index].metadata,
    );
    _devices[index] = updated;
    return updated;
  }

  @override
  Future<IotDeviceModel> disconnectFromDevice(String deviceId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _devices.indexWhere((d) => d.id == deviceId);
    if (index == -1) {
      throw Exception('Device not found: $deviceId');
    }
    final updated = IotDeviceModel(
      id: _devices[index].id,
      name: _devices[index].name,
      type: _devices[index].type,
      status: 'offline',
      lastUpdated: DateTime.now().toIso8601String(),
      metadata: _devices[index].metadata,
    );
    _devices[index] = updated;
    return updated;
  }

  @override
  Future<bool> sendCommand(
    String deviceId,
    String command,
    Map<String, dynamic>? parameters,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate command execution
    final device = _devices.firstWhere(
      (d) => d.id == deviceId,
      orElse: () => throw Exception('Device not found: $deviceId'),
    );
    // In a real implementation, you would send the command to the device
    return device.status == 'online';
  }

  @override
  Future<List<SensorDataModel>> getSensorData(
    String deviceId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Return mock sensor data
    final now = DateTime.now();
    final count = limit ?? 10;
    return List.generate(
      count,
      (i) => SensorDataModel(
        id: 'sensor-$deviceId-$i',
        deviceId: deviceId,
        sensorType: 'temperature',
        value: 20.0 + (i % 5),
        unit: '°C',
        timestamp: now.subtract(Duration(minutes: i * 5)).toIso8601String(),
      ),
    );
  }

  @override
  Stream<SensorDataModel> streamSensorData(String deviceId) {
    // Emit mock sensor readings every 2 seconds
    return Stream.periodic(const Duration(seconds: 2), (i) {
      return SensorDataModel(
        id: 'stream-$deviceId-$i',
        deviceId: deviceId,
        sensorType: 'temperature',
        value: 20.0 + (i % 10),
        unit: '°C',
        timestamp: DateTime.now().toIso8601String(),
      );
    });
  }

  @override
  Future<List<IotDeviceModel>> scanForDevices() async {
    await Future.delayed(const Duration(seconds: 2));
    // Return the existing devices as "discovered"
    return List.unmodifiable(_devices);
  }
}
