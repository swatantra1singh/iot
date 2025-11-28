import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/esp32_device.dart';
import '../../domain/entities/wifi_network.dart';
import 'provisioning_data_source.dart';

/// Mock implementation of ProvisioningDataSource for development.
///
/// In production, this would use flutter_blue_plus or similar
/// to interact with ESP32 devices via BLE.
class ProvisioningDataSourceImpl implements ProvisioningDataSource {
  Esp32Device? _connectedDevice;
  bool _isScanning = false;

  @override
  Future<List<Esp32Device>> scanForDevices() async {
    if (_isScanning) {
      throw const DeviceConnectionException(
        message: 'Already scanning for devices',
      );
    }

    _isScanning = true;

    // Simulate scanning delay
    await Future.delayed(const Duration(seconds: 2));

    _isScanning = false;

    // Return mock ESP32 devices for development
    return const [
      Esp32Device(
        id: 'esp32_001',
        name: 'ESP32-IoT-Sensor-01',
        address: 'AA:BB:CC:DD:EE:01',
        rssi: -45,
        isConnectable: true,
      ),
      Esp32Device(
        id: 'esp32_002',
        name: 'ESP32-IoT-Sensor-02',
        address: 'AA:BB:CC:DD:EE:02',
        rssi: -60,
        isConnectable: true,
      ),
      Esp32Device(
        id: 'esp32_003',
        name: 'ESP32-IoT-Controller',
        address: 'AA:BB:CC:DD:EE:03',
        rssi: -75,
        isConnectable: true,
      ),
    ];
  }

  @override
  Future<bool> connectToDevice(Esp32Device device) async {
    // Simulate connection delay
    await Future.delayed(const Duration(seconds: 1));

    if (!device.isConnectable) {
      throw const DeviceConnectionException(
        message: 'Device is not connectable',
      );
    }

    _connectedDevice = device;
    return true;
  }

  @override
  Future<void> disconnectFromDevice() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _connectedDevice = null;
  }

  @override
  Future<List<WiFiNetwork>> getAvailableNetworks() async {
    if (_connectedDevice == null) {
      throw const DeviceConnectionException(
        message: 'Not connected to any device',
      );
    }

    // Simulate network scan delay
    await Future.delayed(const Duration(seconds: 1));

    // Return mock WiFi networks
    return const [
      WiFiNetwork(
        ssid: 'Home_WiFi_5G',
        signalStrength: 85,
        isSecured: true,
        securityType: 'WPA2',
      ),
      WiFiNetwork(
        ssid: 'Home_WiFi_2.4G',
        signalStrength: 92,
        isSecured: true,
        securityType: 'WPA2',
      ),
      WiFiNetwork(
        ssid: 'Office_Network',
        signalStrength: 60,
        isSecured: true,
        securityType: 'WPA2-Enterprise',
      ),
      WiFiNetwork(
        ssid: 'Guest_WiFi',
        signalStrength: 45,
        isSecured: false,
        securityType: null,
      ),
    ];
  }

  @override
  Future<String> provisionDevice({
    required String ssid,
    required String password,
    String? deviceName,
  }) async {
    if (_connectedDevice == null) {
      throw const DeviceConnectionException(
        message: 'Not connected to any device',
      );
    }

    // Simulate provisioning delay
    await Future.delayed(const Duration(seconds: 2));

    // Return mock device ID
    return 'provisioned_${_connectedDevice!.id}_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<String> registerDeviceToCloud({
    required String deviceId,
    required String deviceName,
    Map<String, dynamic>? metadata,
  }) async {
    // Simulate cloud registration delay
    await Future.delayed(const Duration(seconds: 1));

    // Return mock cloud device ID
    return 'cloud_$deviceId';
  }
}
