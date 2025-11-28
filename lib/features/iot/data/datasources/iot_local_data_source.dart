import '../models/iot_device_model.dart';

/// Local data source for IoT devices.
///
/// Handles caching and local storage of device data.
abstract class IotLocalDataSource {
  /// Gets cached devices.
  Future<List<IotDeviceModel>> getCachedDevices();

  /// Caches a list of devices.
  Future<void> cacheDevices(List<IotDeviceModel> devices);

  /// Gets a cached device by ID.
  Future<IotDeviceModel?> getCachedDeviceById(String deviceId);

  /// Caches a single device.
  Future<void> cacheDevice(IotDeviceModel device);

  /// Removes a device from cache.
  Future<void> removeCachedDevice(String deviceId);

  /// Clears all cached devices.
  Future<void> clearCache();
}
