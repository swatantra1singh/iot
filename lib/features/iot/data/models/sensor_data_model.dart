import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/sensor_data.dart';

part 'sensor_data_model.g.dart';

/// Data model for sensor data, with JSON serialization support.
@JsonSerializable()
class SensorDataModel {
  final String id;
  @JsonKey(name: 'device_id')
  final String deviceId;
  @JsonKey(name: 'sensor_type')
  final String sensorType;
  final double value;
  final String unit;
  final String timestamp;
  final double? quality;

  const SensorDataModel({
    required this.id,
    required this.deviceId,
    required this.sensorType,
    required this.value,
    required this.unit,
    required this.timestamp,
    this.quality,
  });

  /// Creates a [SensorDataModel] from JSON.
  factory SensorDataModel.fromJson(Map<String, dynamic> json) =>
      _$SensorDataModelFromJson(json);

  /// Converts this model to JSON.
  Map<String, dynamic> toJson() => _$SensorDataModelToJson(this);

  /// Converts this model to a domain entity.
  SensorData toEntity() {
    return SensorData(
      id: id,
      deviceId: deviceId,
      sensorType: sensorType,
      value: value,
      unit: unit,
      timestamp: DateTime.parse(timestamp),
      quality: quality,
    );
  }

  /// Creates a model from a domain entity.
  factory SensorDataModel.fromEntity(SensorData entity) {
    return SensorDataModel(
      id: entity.id,
      deviceId: entity.deviceId,
      sensorType: entity.sensorType,
      value: entity.value,
      unit: entity.unit,
      timestamp: entity.timestamp.toIso8601String(),
      quality: entity.quality,
    );
  }
}
