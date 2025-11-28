// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:iot_app/features/auth/domain/entities/user.dart';
import 'package:iot_app/features/auth/domain/entities/auth_state.dart';
import 'package:iot_app/features/device_provisioning/domain/entities/esp32_device.dart';
import 'package:iot_app/features/device_provisioning/domain/entities/wifi_network.dart';
import 'package:iot_app/features/device_provisioning/domain/entities/provisioning_state.dart';

void main() {
  group('User Entity', () {
    test('should create User with required fields', () {
      const user = User(
        id: 'test-id',
        email: 'test@example.com',
      );

      expect(user.id, 'test-id');
      expect(user.email, 'test@example.com');
      expect(user.isEmailVerified, false);
    });

    test('should create User with all fields', () {
      final now = DateTime.now();
      final user = User(
        id: 'test-id',
        email: 'test@example.com',
        displayName: 'Test User',
        isEmailVerified: true,
        profileImageUrl: 'https://example.com/image.jpg',
        createdAt: now,
      );

      expect(user.id, 'test-id');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test User');
      expect(user.isEmailVerified, true);
      expect(user.profileImageUrl, 'https://example.com/image.jpg');
      expect(user.createdAt, now);
    });

    test('copyWith should create copy with updated fields', () {
      const user = User(
        id: 'test-id',
        email: 'test@example.com',
      );

      final updatedUser = user.copyWith(displayName: 'Updated Name');

      expect(updatedUser.id, 'test-id');
      expect(updatedUser.email, 'test@example.com');
      expect(updatedUser.displayName, 'Updated Name');
    });
  });

  group('AuthState', () {
    test('AuthInitial should be a valid state', () {
      const state = AuthInitial();
      expect(state, isA<AuthState>());
    });

    test('Authenticated should contain user', () {
      const user = User(id: '1', email: 'test@test.com');
      const state = Authenticated(user);
      expect(state.user, user);
    });

    test('AuthError should contain message', () {
      const state = AuthError('Error message');
      expect(state.message, 'Error message');
    });

    test('AuthNeedsVerification should contain email', () {
      const state = AuthNeedsVerification('test@test.com');
      expect(state.email, 'test@test.com');
    });
  });

  group('Esp32Device Entity', () {
    test('should create Esp32Device with required fields', () {
      const device = Esp32Device(
        id: 'esp32-001',
        name: 'ESP32 Sensor',
        address: 'AA:BB:CC:DD:EE:FF',
      );

      expect(device.id, 'esp32-001');
      expect(device.name, 'ESP32 Sensor');
      expect(device.address, 'AA:BB:CC:DD:EE:FF');
      expect(device.isConnectable, true);
    });

    test('should create Esp32Device with all fields', () {
      const device = Esp32Device(
        id: 'esp32-001',
        name: 'ESP32 Sensor',
        address: 'AA:BB:CC:DD:EE:FF',
        rssi: -50,
        isConnectable: false,
      );

      expect(device.rssi, -50);
      expect(device.isConnectable, false);
    });
  });

  group('WiFiNetwork Entity', () {
    test('should create WiFiNetwork with required fields', () {
      const network = WiFiNetwork(
        ssid: 'MyNetwork',
        signalStrength: 75,
      );

      expect(network.ssid, 'MyNetwork');
      expect(network.signalStrength, 75);
      expect(network.isSecured, true);
    });

    test('should create WiFiNetwork with all fields', () {
      const network = WiFiNetwork(
        ssid: 'MyNetwork',
        signalStrength: 85,
        isSecured: true,
        securityType: 'WPA2',
      );

      expect(network.ssid, 'MyNetwork');
      expect(network.signalStrength, 85);
      expect(network.isSecured, true);
      expect(network.securityType, 'WPA2');
    });
  });

  group('ProvisioningState', () {
    test('ProvisioningInitial should be a valid state', () {
      const state = ProvisioningInitial();
      expect(state, isA<ProvisioningState>());
    });

    test('ProvisioningScanning should be a valid state', () {
      const state = ProvisioningScanning();
      expect(state, isA<ProvisioningState>());
    });

    test('ProvisioningDeviceFound should contain devices list', () {
      const devices = [
        Esp32Device(id: '1', name: 'Device 1', address: 'AA:BB:CC:DD:EE:01'),
        Esp32Device(id: '2', name: 'Device 2', address: 'AA:BB:CC:DD:EE:02'),
      ];
      const state = ProvisioningDeviceFound(devices);
      expect(state.devices.length, 2);
    });

    test('ProvisioningSuccess should contain device and deviceId', () {
      const device = Esp32Device(
        id: 'esp32-001',
        name: 'ESP32 Sensor',
        address: 'AA:BB:CC:DD:EE:FF',
      );
      const state = ProvisioningSuccess(device: device, deviceId: 'cloud-123');
      expect(state.device, device);
      expect(state.deviceId, 'cloud-123');
    });

    test('ProvisioningError should contain message', () {
      const state = ProvisioningError(message: 'Connection failed');
      expect(state.message, 'Connection failed');
    });
  });
}
