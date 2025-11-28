import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/esp32_device.dart';

/// Widget for displaying scanned ESP32 devices.
class DeviceScanWidget extends StatelessWidget {
  final List<Esp32Device> devices;
  final ValueChanged<Esp32Device> onDeviceSelected;
  final VoidCallback onRescan;

  const DeviceScanWidget({
    super.key,
    required this.devices,
    required this.onDeviceSelected,
    required this.onRescan,
  });

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                '${devices.length} device${devices.length > 1 ? 's' : ''} found',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: onRescan,
                icon: const Icon(Icons.refresh),
                label: const Text('Rescan'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              return _DeviceListTile(
                device: device,
                onTap: () => onDeviceSelected(device),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bluetooth_disabled,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 24),
            Text(
              'No devices found',
              style: AppTextStyles.headline4,
            ),
            const SizedBox(height: 8),
            Text(
              'Make sure your ESP32 device is powered on and in pairing mode.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onRescan,
              icon: const Icon(Icons.refresh),
              label: const Text('Scan Again'),
            ),
          ],
        ),
      ),
    );
  }
}

/// List tile for a single ESP32 device.
class _DeviceListTile extends StatelessWidget {
  final Esp32Device device;
  final VoidCallback onTap;

  const _DeviceListTile({
    required this.device,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.memory,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          device.name,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              device.address,
              style: AppTextStyles.bodySmall,
            ),
            if (device.rssi != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    _getSignalIcon(device.rssi!),
                    size: 16,
                    color: _getSignalColor(device.rssi!),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${device.rssi} dBm',
                    style: AppTextStyles.caption.copyWith(
                      color: _getSignalColor(device.rssi!),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: device.isConnectable ? onTap : null,
      ),
    );
  }

  IconData _getSignalIcon(int rssi) {
    if (rssi >= -50) return Icons.signal_wifi_4_bar;
    if (rssi >= -60) return Icons.network_wifi_3_bar;
    if (rssi >= -70) return Icons.network_wifi_2_bar;
    return Icons.network_wifi_1_bar;
  }

  Color _getSignalColor(int rssi) {
    if (rssi >= -50) return AppColors.success;
    if (rssi >= -60) return AppColors.success;
    if (rssi >= -70) return AppColors.warning;
    return AppColors.error;
  }
}
