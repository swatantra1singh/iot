import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/esp32_device.dart';
import '../entities/wifi_network.dart';

/// Abstract repository for device provisioning operations.
abstract class ProvisioningRepository {
  /// Scans for nearby ESP32 devices via BLE/WiFi.
  Future<Either<Failure, List<Esp32Device>>> scanForDevices();

  /// Connects to a specific ESP32 device.
  Future<Either<Failure, bool>> connectToDevice(Esp32Device device);

  /// Disconnects from the current device.
  Future<Either<Failure, void>> disconnectFromDevice();

  /// Fetches available WiFi networks from the connected ESP32 device.
  Future<Either<Failure, List<WiFiNetwork>>> getAvailableNetworks();

  /// Provisions the device with WiFi credentials.
  Future<Either<Failure, String>> provisionDevice({
    required String ssid,
    required String password,
    String? deviceName,
  });

  /// Registers the provisioned device to the cloud backend.
  Future<Either<Failure, String>> registerDeviceToCloud({
    required String deviceId,
    required String deviceName,
    Map<String, dynamic>? metadata,
  });
}
