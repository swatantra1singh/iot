import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/wifi_network.dart';

/// Widget for displaying and selecting WiFi networks.
class WiFiSelectionWidget extends HookWidget {
  final List<WiFiNetwork> networks;
  final WiFiNetwork? selectedNetwork;
  final ValueChanged<WiFiNetwork> onNetworkSelected;
  final void Function(String password, String? deviceName)? onProvision;

  const WiFiSelectionWidget({
    super.key,
    required this.networks,
    this.selectedNetwork,
    required this.onNetworkSelected,
    this.onProvision,
  });

  @override
  Widget build(BuildContext context) {
    // If a network is selected, show the password entry form
    if (selectedNetwork != null && onProvision != null) {
      return _PasswordEntryForm(
        network: selectedNetwork!,
        onProvision: onProvision!,
      );
    }

    // Otherwise show the network list
    if (networks.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: networks.length,
      itemBuilder: (context, index) {
        final network = networks[index];
        return _WiFiNetworkTile(
          network: network,
          onTap: () => onNetworkSelected(network),
        );
      },
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
              Icons.wifi_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 24),
            Text(
              'No networks found',
              style: AppTextStyles.headline4,
            ),
            const SizedBox(height: 8),
            Text(
              'The device could not find any WiFi networks.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Tile for a single WiFi network.
class _WiFiNetworkTile extends StatelessWidget {
  final WiFiNetwork network;
  final VoidCallback onTap;

  const _WiFiNetworkTile({
    required this.network,
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
          child: Icon(
            _getSignalIcon(network.signalStrength),
            color: AppColors.primary,
          ),
        ),
        title: Text(
          network.ssid,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Row(
          children: [
            if (network.isSecured) ...[
              const Icon(Icons.lock, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                network.securityType ?? 'Secured',
                style: AppTextStyles.caption,
              ),
            ] else ...[
              const Icon(Icons.lock_open, size: 14, color: AppColors.warning),
              const SizedBox(width: 4),
              Text(
                'Open',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.warning,
                ),
              ),
            ],
            const SizedBox(width: 16),
            Text(
              '${network.signalStrength}%',
              style: AppTextStyles.caption,
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  IconData _getSignalIcon(int strength) {
    if (strength >= 75) return Icons.wifi;
    if (strength >= 50) return Icons.wifi_2_bar;
    return Icons.wifi_1_bar;
  }
}

/// Form for entering WiFi password.
class _PasswordEntryForm extends HookWidget {
  final WiFiNetwork network;
  final void Function(String password, String? deviceName) onProvision;

  const _PasswordEntryForm({
    required this.network,
    required this.onProvision,
  });

  @override
  Widget build(BuildContext context) {
    final passwordController = useTextEditingController();
    final deviceNameController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final obscurePassword = useState(true);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Selected network info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.wifi,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            network.ssid,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (network.securityType != null)
                            Text(
                              network.securityType!,
                              style: AppTextStyles.bodySmall,
                            ),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_circle, color: AppColors.success),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Password field
            if (network.isSecured) ...[
              TextFormField(
                controller: passwordController,
                obscureText: obscurePassword.value,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'WiFi Password',
                  hintText: 'Enter the network password',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      obscurePassword.value = !obscurePassword.value;
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the WiFi password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
            ],

            // Device name field (optional)
            TextFormField(
              controller: deviceNameController,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Device Name (Optional)',
                hintText: 'Give your device a friendly name',
                prefixIcon: Icon(Icons.label_outlined),
              ),
            ),
            const SizedBox(height: 32),

            // Provision button
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    onProvision(
                      passwordController.text,
                      deviceNameController.text.isEmpty
                          ? null
                          : deviceNameController.text.trim(),
                    );
                  }
                },
                icon: const Icon(Icons.send),
                label: const Text('Start Provisioning'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
