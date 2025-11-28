import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/esp32_device.dart';
import '../../domain/entities/wifi_network.dart';
import '../../domain/entities/provisioning_state.dart';
import '../../domain/repositories/provisioning_repository.dart';
import '../../data/repositories/provisioning_repository_impl.dart';
import '../../data/datasources/provisioning_data_source.dart';
import '../../data/datasources/provisioning_data_source_impl.dart';

part 'provisioning_providers.g.dart';

/// Provider for provisioning data source.
@Riverpod(keepAlive: true)
ProvisioningDataSource provisioningDataSource(ProvisioningDataSourceRef ref) {
  return ProvisioningDataSourceImpl();
}

/// Provider for provisioning repository.
@Riverpod(keepAlive: true)
ProvisioningRepository provisioningRepository(ProvisioningRepositoryRef ref) {
  final dataSource = ref.watch(provisioningDataSourceProvider);
  return ProvisioningRepositoryImpl(dataSource: dataSource);
}

/// Notifier for device provisioning state management.
@riverpod
class ProvisioningNotifier extends _$ProvisioningNotifier {
  Esp32Device? _selectedDevice;
  WiFiNetwork? _selectedNetwork;

  @override
  ProvisioningState build() {
    return const ProvisioningInitial();
  }

  /// Starts scanning for ESP32 devices.
  Future<void> startScan() async {
    state = const ProvisioningScanning();

    final repository = ref.read(provisioningRepositoryProvider);
    final result = await repository.scanForDevices();

    result.fold(
      (failure) {
        state = ProvisioningError(
          message: failure.message,
          previousState: const ProvisioningInitial(),
        );
      },
      (devices) {
        if (devices.isEmpty) {
          state = const ProvisioningDeviceFound([]);
        } else {
          state = ProvisioningDeviceFound(devices);
        }
      },
    );
  }

  /// Selects and connects to an ESP32 device.
  Future<void> selectDevice(Esp32Device device) async {
    _selectedDevice = device;
    state = ProvisioningConnecting(device);

    final repository = ref.read(provisioningRepositoryProvider);
    final result = await repository.connectToDevice(device);

    result.fold(
      (failure) {
        state = ProvisioningError(
          message: failure.message,
          previousState: ProvisioningDeviceFound([device]),
        );
      },
      (connected) {
        if (connected) {
          _fetchWiFiNetworks();
        } else {
          state = ProvisioningError(
            message: 'Failed to connect to device',
            previousState: ProvisioningDeviceFound([device]),
          );
        }
      },
    );
  }

  /// Fetches WiFi networks from the connected device.
  Future<void> _fetchWiFiNetworks() async {
    if (_selectedDevice == null) return;

    state = ProvisioningFetchingWiFi(_selectedDevice!);

    final repository = ref.read(provisioningRepositoryProvider);
    final result = await repository.getAvailableNetworks();

    result.fold(
      (failure) {
        state = ProvisioningError(
          message: failure.message,
          previousState: ProvisioningConnecting(_selectedDevice!),
        );
      },
      (networks) {
        state = ProvisioningWiFiListLoaded(
          device: _selectedDevice!,
          networks: networks,
        );
      },
    );
  }

  /// Selects a WiFi network.
  void selectWiFiNetwork(WiFiNetwork network) {
    if (_selectedDevice == null) return;

    _selectedNetwork = network;
    state = ProvisioningWiFiSelected(
      device: _selectedDevice!,
      network: network,
    );
  }

  /// Starts the provisioning process with WiFi credentials.
  Future<void> provisionDevice({
    required String password,
    String? deviceName,
  }) async {
    if (_selectedDevice == null || _selectedNetwork == null) return;

    state = ProvisioningInProgress(
      device: _selectedDevice!,
      network: _selectedNetwork!,
    );

    final repository = ref.read(provisioningRepositoryProvider);
    final provisionResult = await repository.provisionDevice(
      ssid: _selectedNetwork!.ssid,
      password: password,
      deviceName: deviceName,
    );

    await provisionResult.fold(
      (failure) async {
        state = ProvisioningError(
          message: failure.message,
          previousState: ProvisioningWiFiSelected(
            device: _selectedDevice!,
            network: _selectedNetwork!,
          ),
        );
      },
      (deviceId) async {
        // Register device to cloud
        final registerResult = await repository.registerDeviceToCloud(
          deviceId: deviceId,
          deviceName: deviceName ?? _selectedDevice!.name,
        );

        registerResult.fold(
          (failure) {
            state = ProvisioningError(
              message: 'Device provisioned but cloud registration failed: ${failure.message}',
              previousState: null,
            );
          },
          (cloudId) {
            state = ProvisioningSuccess(
              device: _selectedDevice!,
              deviceId: cloudId,
            );
          },
        );
      },
    );
  }

  /// Resets the provisioning state.
  Future<void> reset() async {
    final repository = ref.read(provisioningRepositoryProvider);
    await repository.disconnectFromDevice();

    _selectedDevice = null;
    _selectedNetwork = null;
    state = const ProvisioningInitial();
  }

  /// Goes back to the previous state.
  void goBack() {
    if (state is ProvisioningError) {
      final previous = (state as ProvisioningError).previousState;
      if (previous != null) {
        state = previous;
        return;
      }
    }

    if (state is ProvisioningWiFiSelected) {
      if (_selectedDevice != null) {
        _fetchWiFiNetworks();
        return;
      }
    }

    if (state is ProvisioningWiFiListLoaded || state is ProvisioningFetchingWiFi) {
      reset();
      return;
    }

    state = const ProvisioningInitial();
  }
}
