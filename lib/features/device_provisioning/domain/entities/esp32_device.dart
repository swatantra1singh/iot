import 'package:equatable/equatable.dart';

/// Represents an ESP32 device discovered during scanning.
class Esp32Device extends Equatable {
  /// Unique identifier for the device.
  final String id;

  /// Device name or identifier.
  final String name;

  /// Bluetooth/WiFi address of the device.
  final String address;

  /// Signal strength (RSSI).
  final int? rssi;

  /// Whether the device is connectable.
  final bool isConnectable;

  const Esp32Device({
    required this.id,
    required this.name,
    required this.address,
    this.rssi,
    this.isConnectable = true,
  });

  @override
  List<Object?> get props => [id, name, address, rssi, isConnectable];
}
