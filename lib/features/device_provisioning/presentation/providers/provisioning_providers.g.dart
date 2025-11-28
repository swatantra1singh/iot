// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provisioning_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$provisioningDataSourceHash() => r'provisioning_data_source_hash';

/// Provider for provisioning data source.
///
/// Copied from [provisioningDataSource].
@ProviderFor(provisioningDataSource)
final provisioningDataSourceProvider =
    Provider<ProvisioningDataSource>.internal(
  provisioningDataSource,
  name: r'provisioningDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$provisioningDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProvisioningDataSourceRef = ProviderRef<ProvisioningDataSource>;

String _$provisioningRepositoryHash() => r'provisioning_repository_hash';

/// Provider for provisioning repository.
///
/// Copied from [provisioningRepository].
@ProviderFor(provisioningRepository)
final provisioningRepositoryProvider =
    Provider<ProvisioningRepository>.internal(
  provisioningRepository,
  name: r'provisioningRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$provisioningRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProvisioningRepositoryRef = ProviderRef<ProvisioningRepository>;

String _$provisioningNotifierHash() => r'provisioning_notifier_hash';

/// Notifier for device provisioning state management.
///
/// Copied from [ProvisioningNotifier].
@ProviderFor(ProvisioningNotifier)
final provisioningNotifierProvider = AutoDisposeNotifierProvider<
    ProvisioningNotifier, ProvisioningState>.internal(
  ProvisioningNotifier.new,
  name: r'provisioningNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$provisioningNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProvisioningNotifier = AutoDisposeNotifier<ProvisioningState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
