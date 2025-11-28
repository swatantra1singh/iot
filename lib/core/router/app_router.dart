import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/iot/presentation/screens/devices_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/confirm_signup_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/device_provisioning/presentation/screens/provisioning_screen.dart';

/// Application router configuration.
final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  debugLogDiagnostics: true,
  routes: [
    // Auth routes
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/confirm-signup',
      name: 'confirm-signup',
      builder: (context, state) {
        final email = state.extra as String? ?? '';
        return ConfirmSignUpScreen(email: email);
      },
    ),
    GoRoute(
      path: '/forgot-password',
      name: 'forgot-password',
      builder: (context, state) => const ForgotPasswordPlaceholder(),
    ),

    // Main app routes
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
      builder: (context, state) => const SettingsScreen(),
    ),

    // Device provisioning routes
    GoRoute(
      path: '/add-device',
      name: 'add-device',
      builder: (context, state) => const ProvisioningScreen(),
    ),
  ],
);

/// Placeholder for device details screen.
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

/// Placeholder for forgot password screen.
class ForgotPasswordPlaceholder extends StatelessWidget {
  const ForgotPasswordPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: const Center(
        child: Text('Forgot Password Screen - Coming Soon'),
      ),
    );
  }
}
