import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/entities/iot_device.dart';
import '../providers/iot_device_providers.dart';
import '../widgets/device_card.dart';
import '../widgets/device_status_indicator.dart';
import '../../../../core/theme/app_theme.dart';

/// Main screen displaying IoT devices dashboard.
class DevicesScreen extends HookConsumerWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceState = ref.watch(iotDeviceNotifierProvider);
    final deviceNotifier = ref.read(iotDeviceNotifierProvider.notifier);

    // Load devices on first build
    useEffect(() {
      Future.microtask(() => deviceNotifier.loadDevices());
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('IoT Devices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: deviceState.isLoading ? null : deviceNotifier.loadDevices,
            tooltip: 'Refresh devices',
          ),
          IconButton(
            icon: deviceState.isScanning
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.bluetooth_searching),
            onPressed: deviceState.isScanning ? null : deviceNotifier.scanDevices,
            tooltip: 'Scan for devices',
          ),
        ],
      ),
      body: _buildBody(context, deviceState, deviceNotifier),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDeviceDialog(context),
        tooltip: 'Add device',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    IotDeviceState state,
    IotDeviceNotifier notifier,
  ) {
    if (state.isLoading && state.devices.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.errorMessage != null && state.devices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              state.errorMessage!,
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: notifier.loadDevices,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.devices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.devices_other,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No devices found',
              style: AppTextStyles.headline4.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the scan button to discover nearby devices',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => notifier.loadDevices(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.devices.length,
        itemBuilder: (context, index) {
          final device = state.devices[index];
          return DeviceCard(
            device: device,
            isSelected: state.selectedDevice?.id == device.id,
            onTap: () => _onDeviceTap(context, device, notifier),
            onConnect: () => notifier.connectDevice(device.id),
          );
        },
      ),
    );
  }

  void _onDeviceTap(
    BuildContext context,
    IotDevice device,
    IotDeviceNotifier notifier,
  ) {
    notifier.selectDevice(device);
    _showDeviceDetailsBottomSheet(context, device);
  }

  void _showDeviceDetailsBottomSheet(BuildContext context, IotDevice device) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.25,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => _DeviceDetailsSheet(
          device: device,
          scrollController: scrollController,
        ),
      ),
    );
  }

  void _showAddDeviceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Device'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Device Name',
                hintText: 'Enter device name',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Device Address',
                hintText: 'Enter device address',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement add device logic
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet showing device details.
class _DeviceDetailsSheet extends StatelessWidget {
  final IotDevice device;
  final ScrollController scrollController;

  const _DeviceDetailsSheet({
    required this.device,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.textHint,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                DeviceStatusIndicator(status: device.status),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    device.name,
                    style: AppTextStyles.headline3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildInfoRow('ID', device.id),
            _buildInfoRow('Type', device.type.name.toUpperCase()),
            _buildInfoRow('Status', device.status.name.toUpperCase()),
            if (device.address != null)
              _buildInfoRow('Address', device.address!),
            if (device.batteryLevel != null)
              _buildInfoRow('Battery', '${device.batteryLevel}%'),
            if (device.signalStrength != null)
              _buildInfoRow('Signal', '${device.signalStrength}%'),
            if (device.lastUpdated != null)
              _buildInfoRow(
                'Last Updated',
                device.lastUpdated!.toLocal().toString(),
              ),
            if (device.lastValue != null)
              _buildInfoRow('Last Value', device.lastValue.toString()),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: device.status == DeviceStatus.online
                        ? () {
                            // TODO: Implement disconnect
                            Navigator.pop(context);
                          }
                        : () {
                            // TODO: Implement connect
                            Navigator.pop(context);
                          },
                    icon: Icon(
                      device.status == DeviceStatus.online
                          ? Icons.link_off
                          : Icons.link,
                    ),
                    label: Text(
                      device.status == DeviceStatus.online
                          ? 'Disconnect'
                          : 'Connect',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement settings
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.settings),
                    label: const Text('Settings'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
