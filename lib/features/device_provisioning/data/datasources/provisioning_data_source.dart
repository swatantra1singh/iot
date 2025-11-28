import '../../domain/entities/esp32_device.dart';
import '../../domain/entities/wifi_network.dart';

/// Abstract data source for ESP32 device provisioning.
///
/// This is a platform channel abstraction for BLE/WiFi provisioning.
/// Implementations should handle platform-specific BLE/WiFi operations.
abstract class ProvisioningDataSource {
  /// Scans for nearby ESP32 devices.
  Future<List<Esp32Device>> scanForDevices();

  /// Connects to an ESP32 device.
  Future<bool> connectToDevice(Esp32Device device);

  /// Disconnects from the current device.
  Future<void> disconnectFromDevice();

  /// Gets available WiFi networks from the connected device.
  Future<List<WiFiNetwork>> getAvailableNetworks();

  /// Provisions the device with WiFi credentials.
  Future<String> provisionDevice({
    required String ssid,
    required String password,
    String? deviceName,
  });

  /// Registers the device to the cloud.
  Future<String> registerDeviceToCloud({
    required String deviceId,
    required String deviceName,
    Map<String, dynamic>? metadata,
  });
}
