import 'esp32_device.dart';
import 'wifi_network.dart';

/// Sealed class representing device provisioning states.
sealed class ProvisioningState {
  const ProvisioningState();
}

/// Initial state before provisioning starts.
class ProvisioningInitial extends ProvisioningState {
  const ProvisioningInitial();
}

/// Scanning for ESP32 devices.
class ProvisioningScanning extends ProvisioningState {
  const ProvisioningScanning();
}

/// Found ESP32 devices during scanning.
class ProvisioningDeviceFound extends ProvisioningState {
  final List<Esp32Device> devices;

  const ProvisioningDeviceFound(this.devices);
}

/// Connecting to selected ESP32 device.
class ProvisioningConnecting extends ProvisioningState {
  final Esp32Device device;

  const ProvisioningConnecting(this.device);
}

/// Fetching available WiFi networks from ESP32.
class ProvisioningFetchingWiFi extends ProvisioningState {
  final Esp32Device device;

  const ProvisioningFetchingWiFi(this.device);
}

/// WiFi networks list loaded from ESP32.
class ProvisioningWiFiListLoaded extends ProvisioningState {
  final Esp32Device device;
  final List<WiFiNetwork> networks;

  const ProvisioningWiFiListLoaded({
    required this.device,
    required this.networks,
  });
}

/// WiFi network selected, waiting for credentials.
class ProvisioningWiFiSelected extends ProvisioningState {
  final Esp32Device device;
  final WiFiNetwork network;

  const ProvisioningWiFiSelected({
    required this.device,
    required this.network,
  });
}

/// Sending provisioning data to ESP32.
class ProvisioningInProgress extends ProvisioningState {
  final Esp32Device device;
  final WiFiNetwork network;

  const ProvisioningInProgress({
    required this.device,
    required this.network,
  });
}

/// Provisioning completed successfully.
class ProvisioningSuccess extends ProvisioningState {
  final Esp32Device device;
  final String? deviceId;

  const ProvisioningSuccess({
    required this.device,
    this.deviceId,
  });
}

/// Error state during provisioning.
class ProvisioningError extends ProvisioningState {
  final String message;
  final ProvisioningState? previousState;

  const ProvisioningError({
    required this.message,
    this.previousState,
  });
}
