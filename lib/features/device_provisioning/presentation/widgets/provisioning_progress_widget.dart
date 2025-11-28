import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Widget showing provisioning progress.
class ProvisioningProgressWidget extends StatelessWidget {
  final String deviceName;
  final String networkName;

  const ProvisioningProgressWidget({
    super.key,
    required this.deviceName,
    required this.networkName,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                strokeWidth: 4,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Provisioning Device...',
              style: AppTextStyles.headline3,
            ),
            const SizedBox(height: 16),
            Text(
              'Configuring $deviceName to connect to $networkName',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _ProgressStep(
              icon: Icons.bluetooth_connected,
              label: 'Connected to device',
              isCompleted: true,
            ),
            const SizedBox(height: 16),
            _ProgressStep(
              icon: Icons.wifi,
              label: 'Sending WiFi credentials',
              isCompleted: false,
              isActive: true,
            ),
            const SizedBox(height: 16),
            _ProgressStep(
              icon: Icons.cloud_upload_outlined,
              label: 'Registering to cloud',
              isCompleted: false,
            ),
          ],
        ),
      ),
    );
  }
}

/// A single progress step indicator.
class _ProgressStep extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isCompleted;
  final bool isActive;

  const _ProgressStep({
    required this.icon,
    required this.label,
    required this.isCompleted,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isCompleted
                ? AppColors.success
                : isActive
                    ? AppColors.primary
                    : AppColors.textHint,
            borderRadius: BorderRadius.circular(20),
          ),
          child: isCompleted
              ? const Icon(Icons.check, color: Colors.white, size: 24)
              : isActive
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyLarge.copyWith(
              color: isCompleted || isActive
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
