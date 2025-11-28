import 'package:flutter_test/flutter_test.dart';
import 'package:iot_app/features/iot/domain/entities/iot_device.dart';

void main() {
  group('IotDevice', () {
    const tDevice = IotDevice(
      id: '1',
      name: 'Test Device',
      type: DeviceType.sensor,
      status: DeviceStatus.online,
      address: '192.168.1.1',
      batteryLevel: 85,
      signalStrength: 90,
    );

    test('should be equal when all properties are the same', () {
      const tDevice2 = IotDevice(
        id: '1',
        name: 'Test Device',
        type: DeviceType.sensor,
        status: DeviceStatus.online,
        address: '192.168.1.1',
        batteryLevel: 85,
        signalStrength: 90,
      );

      expect(tDevice, equals(tDevice2));
    });

    test('copyWith should return a new instance with updated values', () {
      final updatedDevice = tDevice.copyWith(
        name: 'Updated Device',
        status: DeviceStatus.offline,
      );

      expect(updatedDevice.id, equals('1'));
      expect(updatedDevice.name, equals('Updated Device'));
      expect(updatedDevice.status, equals(DeviceStatus.offline));
      expect(updatedDevice.address, equals('192.168.1.1'));
    });

    test('should contain all props for equality comparison', () {
      expect(tDevice.props.length, equals(11));
    });
  });

  group('DeviceStatus', () {
    test('should have all expected values', () {
      expect(DeviceStatus.values.length, equals(4));
      expect(DeviceStatus.values, contains(DeviceStatus.online));
      expect(DeviceStatus.values, contains(DeviceStatus.offline));
      expect(DeviceStatus.values, contains(DeviceStatus.connecting));
      expect(DeviceStatus.values, contains(DeviceStatus.error));
    });
  });

  group('DeviceType', () {
    test('should have all expected values', () {
      expect(DeviceType.values.length, equals(5));
      expect(DeviceType.values, contains(DeviceType.sensor));
      expect(DeviceType.values, contains(DeviceType.actuator));
      expect(DeviceType.values, contains(DeviceType.gateway));
      expect(DeviceType.values, contains(DeviceType.controller));
      expect(DeviceType.values, contains(DeviceType.unknown));
    });
  });
}
