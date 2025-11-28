import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/provisioning_state.dart';
import '../providers/provisioning_providers.dart';
import '../widgets/device_scan_widget.dart';
import '../widgets/wifi_selection_widget.dart';
import '../widgets/provisioning_progress_widget.dart';
import '../widgets/provisioning_success_widget.dart';

/// Main provisioning screen that handles the ESP32 device provisioning flow.
class ProvisioningScreen extends ConsumerWidget {
  const ProvisioningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provisioningState = ref.watch(provisioningNotifierProvider);
    final provisioningNotifier = ref.read(provisioningNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle(provisioningState)),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _handleClose(context, provisioningState, provisioningNotifier),
        ),
        actions: [
          if (_canGoBack(provisioningState))
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: provisioningNotifier.goBack,
              tooltip: 'Previous step',
            ),
        ],
      ),
      body: _buildBody(context, provisioningState, provisioningNotifier),
    );
  }

  String _getAppBarTitle(ProvisioningState state) {
    return switch (state) {
      ProvisioningInitial() => 'Add Device',
      ProvisioningScanning() => 'Scanning...',
      ProvisioningDeviceFound() => 'Select Device',
      ProvisioningConnecting() => 'Connecting...',
      ProvisioningFetchingWiFi() => 'Loading Networks...',
      ProvisioningWiFiListLoaded() => 'Select WiFi',
      ProvisioningWiFiSelected() => 'Enter Password',
      ProvisioningInProgress() => 'Provisioning...',
      ProvisioningSuccess() => 'Success!',
      ProvisioningError() => 'Error',
    };
  }

  bool _canGoBack(ProvisioningState state) {
    return state is ProvisioningWiFiListLoaded ||
        state is ProvisioningWiFiSelected ||
        state is ProvisioningError;
  }

  void _handleClose(
    BuildContext context,
    ProvisioningState state,
    ProvisioningNotifier notifier,
  ) {
    if (state is ProvisioningSuccess) {
      notifier.reset();
      context.go('/devices');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Provisioning'),
        content: const Text(
          'Are you sure you want to cancel the device setup?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              notifier.reset();
              context.pop();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ProvisioningState state,
    ProvisioningNotifier notifier,
  ) {
    return switch (state) {
      ProvisioningInitial() => _buildInitialState(notifier),
      ProvisioningScanning() => _buildScanningState(),
      ProvisioningDeviceFound(:final devices) => DeviceScanWidget(
          devices: devices,
          onDeviceSelected: notifier.selectDevice,
          onRescan: notifier.startScan,
        ),
      ProvisioningConnecting(:final device) => _buildConnectingState(device.name),
      ProvisioningFetchingWiFi(:final device) => _buildFetchingWiFiState(device.name),
      ProvisioningWiFiListLoaded(:final networks) => WiFiSelectionWidget(
          networks: networks,
          onNetworkSelected: notifier.selectWiFiNetwork,
        ),
      ProvisioningWiFiSelected(:final network) => WiFiSelectionWidget(
          networks: const [],
          selectedNetwork: network,
          onNetworkSelected: notifier.selectWiFiNetwork,
          onProvision: (password, deviceName) => notifier.provisionDevice(
            password: password,
            deviceName: deviceName,
          ),
        ),
      ProvisioningInProgress(:final device, :final network) =>
        ProvisioningProgressWidget(
          deviceName: device.name,
          networkName: network.ssid,
        ),
      ProvisioningSuccess(:final device, :final deviceId) =>
        ProvisioningSuccessWidget(
          deviceName: device.name,
          deviceId: deviceId,
          onDone: () {
            notifier.reset();
            context.go('/devices');
          },
        ),
      ProvisioningError(:final message) => _buildErrorState(message, notifier),
    };
  }

  Widget _buildInitialState(ProvisioningNotifier notifier) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_tethering,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Add New Device',
              style: AppTextStyles.headline2,
            ),
            const SizedBox(height: 8),
            Text(
              'Scan for nearby ESP32 devices to begin the provisioning process.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: notifier.startScan,
                icon: const Icon(Icons.bluetooth_searching),
                label: const Text('Start Scanning'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanningState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(),
          ),
          const SizedBox(height: 24),
          Text(
            'Scanning for devices...',
            style: AppTextStyles.headline4,
          ),
          const SizedBox(height: 8),
          Text(
            'Please ensure your ESP32 device is powered on and in pairing mode.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConnectingState(String deviceName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(),
          ),
          const SizedBox(height: 24),
          Text(
            'Connecting to device...',
            style: AppTextStyles.headline4,
          ),
          const SizedBox(height: 8),
          Text(
            deviceName,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFetchingWiFiState(String deviceName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(),
          ),
          const SizedBox(height: 24),
          Text(
            'Loading WiFi networks...',
            style: AppTextStyles.headline4,
          ),
          const SizedBox(height: 8),
          Text(
            'Fetching available networks from $deviceName',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message, ProvisioningNotifier notifier) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: AppTextStyles.headline4,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: notifier.goBack,
                  child: const Text('Go Back'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: notifier.startScan,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
