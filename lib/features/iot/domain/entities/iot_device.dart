import 'package:equatable/equatable.dart';

/// Represents the connection status of an IoT device.
enum DeviceStatus {
  online,
  offline,
  connecting,
  error,
}

/// Represents the type of IoT device.
enum DeviceType {
  sensor,
  actuator,
  gateway,
  controller,
  unknown,
}

/// Entity representing an IoT device.
///
/// This is the core domain model for IoT devices in the application.
class IotDevice extends Equatable {
  /// Unique identifier for the device.
  final String id;

  /// Display name of the device.
  final String name;

  /// Type of the device.
  final DeviceType type;

  /// Current connection status.
  final DeviceStatus status;

  /// IP address or Bluetooth address of the device.
  final String? address;

  /// Last known value or reading from the device.
  final dynamic lastValue;

  /// Timestamp of the last update.
  final DateTime? lastUpdated;

  /// Additional metadata for the device.
  final Map<String, dynamic>? metadata;

  /// Whether the device is currently selected.
  final bool isSelected;

  /// Battery level (0-100) if applicable.
  final int? batteryLevel;

  /// Signal strength (0-100) if applicable.
  final int? signalStrength;

  const IotDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    this.address,
    this.lastValue,
    this.lastUpdated,
    this.metadata,
    this.isSelected = false,
    this.batteryLevel,
    this.signalStrength,
  });

  /// Creates a copy of this device with the given fields replaced.
  IotDevice copyWith({
    String? id,
    String? name,
    DeviceType? type,
    DeviceStatus? status,
    String? address,
    dynamic lastValue,
    DateTime? lastUpdated,
    Map<String, dynamic>? metadata,
    bool? isSelected,
    int? batteryLevel,
    int? signalStrength,
  }) {
    return IotDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      address: address ?? this.address,
      lastValue: lastValue ?? this.lastValue,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      metadata: metadata ?? this.metadata,
      isSelected: isSelected ?? this.isSelected,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      signalStrength: signalStrength ?? this.signalStrength,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        status,
        address,
        lastValue,
        lastUpdated,
        metadata,
        isSelected,
        batteryLevel,
        signalStrength,
      ];
}
