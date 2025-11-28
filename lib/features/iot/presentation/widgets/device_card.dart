import 'package:flutter/material.dart';
import '../../domain/entities/iot_device.dart';
import '../../../../core/theme/app_theme.dart';
import 'device_status_indicator.dart';

/// Card widget displaying IoT device information.
class DeviceCard extends StatelessWidget {
  final IotDevice device;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onConnect;

  const DeviceCard({
    super.key,
    required this.device,
    this.isSelected = false,
    this.onTap,
    this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? const BorderSide(color: AppColors.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildDeviceIcon(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          device.name,
                          style: AppTextStyles.headline4,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            DeviceStatusIndicator(status: device.status),
                            const SizedBox(width: 8),
                            Text(
                              _getStatusText(),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: _getStatusColor(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildActionButton(),
                ],
              ),
              if (_hasAdditionalInfo()) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (device.batteryLevel != null) ...[
                      BatteryIndicator(level: device.batteryLevel!),
                      const SizedBox(width: 8),
                      Text(
                        '${device.batteryLevel}%',
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(width: 16),
                    ],
                    if (device.signalStrength != null) ...[
                      SignalStrengthIndicator(strength: device.signalStrength!),
                      const SizedBox(width: 8),
                      Text(
                        '${device.signalStrength}%',
                        style: AppTextStyles.caption,
                      ),
                    ],
                    const Spacer(),
                    Text(
                      device.type.name.toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
              if (device.lastValue != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.sensors,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Last value: ${device.lastValue}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _getTypeColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _getTypeIcon(),
        color: _getTypeColor(),
        size: 24,
      ),
    );
  }

  IconData _getTypeIcon() {
    switch (device.type) {
      case DeviceType.sensor:
        return Icons.sensors;
      case DeviceType.actuator:
        return Icons.settings_remote;
      case DeviceType.gateway:
        return Icons.router;
      case DeviceType.controller:
        return Icons.developer_board;
      case DeviceType.unknown:
        return Icons.device_unknown;
    }
  }

  Color _getTypeColor() {
    switch (device.type) {
      case DeviceType.sensor:
        return AppColors.info;
      case DeviceType.actuator:
        return AppColors.accent;
      case DeviceType.gateway:
        return AppColors.secondary;
      case DeviceType.controller:
        return AppColors.primary;
      case DeviceType.unknown:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText() {
    switch (device.status) {
      case DeviceStatus.online:
        return 'Online';
      case DeviceStatus.offline:
        return 'Offline';
      case DeviceStatus.connecting:
        return 'Connecting...';
      case DeviceStatus.error:
        return 'Error';
    }
  }

  Color _getStatusColor() {
    switch (device.status) {
      case DeviceStatus.online:
        return AppColors.deviceOnline;
      case DeviceStatus.offline:
        return AppColors.deviceOffline;
      case DeviceStatus.connecting:
        return AppColors.deviceWarning;
      case DeviceStatus.error:
        return AppColors.deviceError;
    }
  }

  Widget _buildActionButton() {
    if (device.status == DeviceStatus.connecting) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return IconButton(
      onPressed: onConnect,
      icon: Icon(
        device.status == DeviceStatus.online
            ? Icons.link_off
            : Icons.link,
        color: device.status == DeviceStatus.online
            ? AppColors.error
            : AppColors.primary,
      ),
      tooltip: device.status == DeviceStatus.online
          ? 'Disconnect'
          : 'Connect',
    );
  }

  bool _hasAdditionalInfo() {
    return device.batteryLevel != null || device.signalStrength != null;
  }
}
