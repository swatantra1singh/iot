import 'package:equatable/equatable.dart';

/// Entity representing sensor data from an IoT device.
class SensorData extends Equatable {
  /// Unique identifier for this sensor reading.
  final String id;

  /// Device ID that produced this reading.
  final String deviceId;

  /// Type of sensor (temperature, humidity, pressure, etc.).
  final String sensorType;

  /// The sensor value.
  final double value;

  /// Unit of measurement (°C, %, hPa, etc.).
  final String unit;

  /// Timestamp when the reading was taken.
  final DateTime timestamp;

  /// Quality indicator (0.0 - 1.0).
  final double? quality;

  const SensorData({
    required this.id,
    required this.deviceId,
    required this.sensorType,
    required this.value,
    required this.unit,
    required this.timestamp,
    this.quality,
  });

  /// Creates a copy of this sensor data with the given fields replaced.
  SensorData copyWith({
    String? id,
    String? deviceId,
    String? sensorType,
    double? value,
    String? unit,
    DateTime? timestamp,
    double? quality,
  }) {
    return SensorData(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      sensorType: sensorType ?? this.sensorType,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      timestamp: timestamp ?? this.timestamp,
      quality: quality ?? this.quality,
    );
  }

  @override
  List<Object?> get props => [
        id,
        deviceId,
        sensorType,
        value,
        unit,
        timestamp,
        quality,
      ];
}
