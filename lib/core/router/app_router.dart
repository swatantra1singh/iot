import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/iot/presentation/screens/devices_screen.dart';

/// Application router configuration.
final GoRouter appRouter = GoRouter(
  initialLocation: '/devices',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/devices',
      name: 'devices',
      builder: (context, state) => const DevicesScreen(),
    ),
    GoRoute(
      path: '/device/:id',
      name: 'device-details',
      builder: (context, state) {
        final deviceId = state.pathParameters['id']!;
        return DeviceDetailsPlaceholder(deviceId: deviceId);
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsPlaceholder(),
    ),
  ],
);

/// Placeholder for device details screen.
/// TODO: Implement full device details screen.
class DeviceDetailsPlaceholder extends StatelessWidget {
  final String deviceId;

  const DeviceDetailsPlaceholder({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device: $deviceId'),
      ),
      body: Center(
        child: Text('Device details for: $deviceId'),
      ),
    );
  }
}

/// Placeholder for settings screen.
/// TODO: Implement full settings screen.
class SettingsPlaceholder extends StatelessWidget {
  const SettingsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Center(
        child: Text('Settings Screen'),
      ),
    );
  }
}
