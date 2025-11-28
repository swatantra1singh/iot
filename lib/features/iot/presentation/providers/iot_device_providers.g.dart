// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iot_device_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6';

/// Provider for SharedPreferences instance.
///
/// Copied from [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = FutureProvider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesRef = FutureProviderRef<SharedPreferences>;

String _$iotLocalDataSourceHash() => r'q1r2s3t4u5v6w7x8y9z0a1b2c3d4e5f6';

/// Provider for IoT local data source.
///
/// Copied from [iotLocalDataSource].
@ProviderFor(iotLocalDataSource)
final iotLocalDataSourceProvider = Provider<IotLocalDataSource>.internal(
  iotLocalDataSource,
  name: r'iotLocalDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$iotLocalDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IotLocalDataSourceRef = ProviderRef<IotLocalDataSource>;

String _$iotRemoteDataSourceHash() => r'g1h2i3j4k5l6m7n8o9p0q1r2s3t4u5v6';

/// Provider for IoT remote data source.
///
/// Copied from [iotRemoteDataSource].
@ProviderFor(iotRemoteDataSource)
final iotRemoteDataSourceProvider = Provider<IotRemoteDataSource>.internal(
  iotRemoteDataSource,
  name: r'iotRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$iotRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IotRemoteDataSourceRef = ProviderRef<IotRemoteDataSource>;

String _$iotDeviceRepositoryHash() => r'w1x2y3z4a5b6c7d8e9f0g1h2i3j4k5l6';

/// Provider for IoT device repository.
///
/// Copied from [iotDeviceRepository].
@ProviderFor(iotDeviceRepository)
final iotDeviceRepositoryProvider = Provider<IotDeviceRepository>.internal(
  iotDeviceRepository,
  name: r'iotDeviceRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$iotDeviceRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IotDeviceRepositoryRef = ProviderRef<IotDeviceRepository>;

String _$getDevicesHash() => r'm1n2o3p4q5r6s7t8u9v0w1x2y3z4a5b6';

/// Provider for GetDevices use case.
///
/// Copied from [getDevices].
@ProviderFor(getDevices)
final getDevicesProvider = AutoDisposeProvider<GetDevices>.internal(
  getDevices,
  name: r'getDevicesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getDevicesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetDevicesRef = AutoDisposeProviderRef<GetDevices>;

String _$connectToDeviceHash() => r'c1d2e3f4g5h6i7j8k9l0m1n2o3p4q5r6';

/// Provider for ConnectToDevice use case.
///
/// Copied from [connectToDevice].
@ProviderFor(connectToDevice)
final connectToDeviceProvider = AutoDisposeProvider<ConnectToDevice>.internal(
  connectToDevice,
  name: r'connectToDeviceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$connectToDeviceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConnectToDeviceRef = AutoDisposeProviderRef<ConnectToDevice>;

String _$sendCommandHash() => r's1t2u3v4w5x6y7z8a9b0c1d2e3f4g5h6';

/// Provider for SendCommand use case.
///
/// Copied from [sendCommand].
@ProviderFor(sendCommand)
final sendCommandProvider = AutoDisposeProvider<SendCommand>.internal(
  sendCommand,
  name: r'sendCommandProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sendCommandHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SendCommandRef = AutoDisposeProviderRef<SendCommand>;

String _$scanForDevicesHash() => r'i1j2k3l4m5n6o7p8q9r0s1t2u3v4w5x6';

/// Provider for ScanForDevices use case.
///
/// Copied from [scanForDevices].
@ProviderFor(scanForDevices)
final scanForDevicesProvider = AutoDisposeProvider<ScanForDevices>.internal(
  scanForDevices,
  name: r'scanForDevicesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scanForDevicesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScanForDevicesRef = AutoDisposeProviderRef<ScanForDevices>;

String _$iotDeviceNotifierHash() => r'y1z2a3b4c5d6e7f8g9h0i1j2k3l4m5n6';

/// Notifier for IoT device state management.
///
/// Copied from [IotDeviceNotifier].
@ProviderFor(IotDeviceNotifier)
final iotDeviceNotifierProvider =
    AutoDisposeNotifierProvider<IotDeviceNotifier, IotDeviceState>.internal(
  IotDeviceNotifier.new,
  name: r'iotDeviceNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$iotDeviceNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IotDeviceNotifier = AutoDisposeNotifier<IotDeviceState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
