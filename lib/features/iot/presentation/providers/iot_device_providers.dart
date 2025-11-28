import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/iot_device.dart';
import '../../domain/usecases/get_devices.dart';
import '../../domain/usecases/connect_to_device.dart';
import '../../domain/usecases/send_command.dart';
import '../../domain/usecases/scan_for_devices.dart';
import '../../domain/repositories/iot_device_repository.dart';
import '../../data/repositories/iot_device_repository_impl.dart';
import '../../data/datasources/iot_remote_data_source.dart';
import '../../data/datasources/iot_local_data_source.dart';
import '../../data/datasources/iot_local_data_source_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'iot_device_providers.g.dart';

/// State class for IoT devices.
class IotDeviceState {
  final List<IotDevice> devices;
  final bool isLoading;
  final String? errorMessage;
  final IotDevice? selectedDevice;
  final bool isScanning;

  const IotDeviceState({
    this.devices = const [],
    this.isLoading = false,
    this.errorMessage,
    this.selectedDevice,
    this.isScanning = false,
  });

  IotDeviceState copyWith({
    List<IotDevice>? devices,
    bool? isLoading,
    String? errorMessage,
    IotDevice? selectedDevice,
    bool? isScanning,
    bool clearError = false,
    bool clearSelectedDevice = false,
  }) {
    return IotDeviceState(
      devices: devices ?? this.devices,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedDevice: clearSelectedDevice
          ? null
          : (selectedDevice ?? this.selectedDevice),
      isScanning: isScanning ?? this.isScanning,
    );
  }
}

/// Provider for SharedPreferences instance.
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) async {
  return SharedPreferences.getInstance();
}

/// Provider for IoT local data source.
@Riverpod(keepAlive: true)
IotLocalDataSource iotLocalDataSource(IotLocalDataSourceRef ref) {
  throw UnimplementedError(
    'iotLocalDataSource must be overridden with a valid implementation',
  );
}

/// Provider for IoT remote data source.
@Riverpod(keepAlive: true)
IotRemoteDataSource iotRemoteDataSource(IotRemoteDataSourceRef ref) {
  throw UnimplementedError(
    'iotRemoteDataSource must be overridden with a valid implementation',
  );
}

/// Provider for IoT device repository.
@Riverpod(keepAlive: true)
IotDeviceRepository iotDeviceRepository(IotDeviceRepositoryRef ref) {
  final remoteDataSource = ref.watch(iotRemoteDataSourceProvider);
  final localDataSource = ref.watch(iotLocalDataSourceProvider);

  return IotDeviceRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
}

/// Provider for GetDevices use case.
@riverpod
GetDevices getDevices(GetDevicesRef ref) {
  final repository = ref.watch(iotDeviceRepositoryProvider);
  return GetDevices(repository);
}

/// Provider for ConnectToDevice use case.
@riverpod
ConnectToDevice connectToDevice(ConnectToDeviceRef ref) {
  final repository = ref.watch(iotDeviceRepositoryProvider);
  return ConnectToDevice(repository);
}

/// Provider for SendCommand use case.
@riverpod
SendCommand sendCommand(SendCommandRef ref) {
  final repository = ref.watch(iotDeviceRepositoryProvider);
  return SendCommand(repository);
}

/// Provider for ScanForDevices use case.
@riverpod
ScanForDevices scanForDevices(ScanForDevicesRef ref) {
  final repository = ref.watch(iotDeviceRepositoryProvider);
  return ScanForDevices(repository);
}

/// Notifier for IoT device state management.
@riverpod
class IotDeviceNotifier extends _$IotDeviceNotifier {
  @override
  IotDeviceState build() {
    return const IotDeviceState();
  }

  /// Loads all devices.
  Future<void> loadDevices() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final getDevicesUseCase = ref.read(getDevicesProvider);
    final result = await getDevicesUseCase();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (devices) {
        state = state.copyWith(
          isLoading: false,
          devices: devices,
        );
      },
    );
  }

  /// Connects to a device.
  Future<void> connectDevice(String deviceId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final connectToDeviceUseCase = ref.read(connectToDeviceProvider);
    final result = await connectToDeviceUseCase(
      ConnectToDeviceParams(deviceId: deviceId),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (device) {
        final updatedDevices = state.devices.map((d) {
          return d.id == deviceId ? device : d;
        }).toList();

        state = state.copyWith(
          isLoading: false,
          devices: updatedDevices,
          selectedDevice: device,
        );
      },
    );
  }

  /// Sends a command to a device.
  Future<bool> sendCommandToDevice(
    String deviceId,
    String command, {
    Map<String, dynamic>? parameters,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final sendCommandUseCase = ref.read(sendCommandProvider);
    final result = await sendCommandUseCase(
      SendCommandParams(
        deviceId: deviceId,
        command: command,
        parameters: parameters,
      ),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (success) {
        state = state.copyWith(isLoading: false);
        return success;
      },
    );
  }

  /// Scans for nearby devices.
  Future<void> scanDevices() async {
    state = state.copyWith(isScanning: true, clearError: true);

    final scanForDevicesUseCase = ref.read(scanForDevicesProvider);
    final result = await scanForDevicesUseCase();

    result.fold(
      (failure) {
        state = state.copyWith(
          isScanning: false,
          errorMessage: failure.message,
        );
      },
      (devices) {
        state = state.copyWith(
          isScanning: false,
          devices: devices,
        );
      },
    );
  }

  /// Selects a device.
  void selectDevice(IotDevice? device) {
    state = state.copyWith(
      selectedDevice: device,
      clearSelectedDevice: device == null,
    );
  }

  /// Clears any error messages.
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
