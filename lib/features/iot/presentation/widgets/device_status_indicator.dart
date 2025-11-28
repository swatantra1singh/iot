import 'package:flutter/material.dart';
import '../../domain/entities/iot_device.dart';
import '../../../../core/theme/app_theme.dart';

/// Indicator showing the connection status of a device.
class DeviceStatusIndicator extends StatelessWidget {
  final DeviceStatus status;
  final double size;

  const DeviceStatusIndicator({
    super.key,
    required this.status,
    this.size = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getColor(),
        boxShadow: [
          BoxShadow(
            color: _getColor().withValues(alpha: 0.4),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (status) {
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
}

/// Widget showing battery level indicator.
class BatteryIndicator extends StatelessWidget {
  final int level;
  final double width;
  final double height;

  const BatteryIndicator({
    super.key,
    required this.level,
    this.width = 28,
    this.height = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(
              color: _getColor(),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: FractionallySizedBox(
              widthFactor: level / 100,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: _getColor(),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ),
        ),
        Container(
          width: 2,
          height: height * 0.5,
          decoration: BoxDecoration(
            color: _getColor(),
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(1),
            ),
          ),
        ),
      ],
    );
  }

  Color _getColor() {
    if (level > 60) return AppColors.deviceOnline;
    if (level > 20) return AppColors.deviceWarning;
    return AppColors.deviceError;
  }
}

/// Widget showing signal strength indicator.
class SignalStrengthIndicator extends StatelessWidget {
  final int strength;
  final double size;

  const SignalStrengthIndicator({
    super.key,
    required this.strength,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    final bars = _getBars();

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(4, (index) {
        final isActive = index < bars;
        final barHeight = (index + 1) * (size / 4);

        return Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Container(
            width: 4,
            height: barHeight,
            decoration: BoxDecoration(
              color: isActive ? _getColor() : AppColors.textHint,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        );
      }),
    );
  }

  int _getBars() {
    if (strength >= 80) return 4;
    if (strength >= 60) return 3;
    if (strength >= 40) return 2;
    if (strength >= 20) return 1;
    return 0;
  }

  Color _getColor() {
    if (strength >= 60) return AppColors.deviceOnline;
    if (strength >= 40) return AppColors.deviceWarning;
    return AppColors.deviceError;
  }
}
