import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/iot_device.dart';

part 'iot_device_model.g.dart';

/// Data model for IoT device, with JSON serialization support.
@JsonSerializable()
class IotDeviceModel {
  final String id;
  final String name;
  final String type;
  final String status;
  final String? address;
  @JsonKey(name: 'last_value')
  final dynamic lastValue;
  @JsonKey(name: 'last_updated')
  final String? lastUpdated;
  final Map<String, dynamic>? metadata;
  @JsonKey(name: 'is_selected')
  final bool isSelected;
  @JsonKey(name: 'battery_level')
  final int? batteryLevel;
  @JsonKey(name: 'signal_strength')
  final int? signalStrength;

  const IotDeviceModel({
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

  /// Creates an [IotDeviceModel] from JSON.
  factory IotDeviceModel.fromJson(Map<String, dynamic> json) =>
      _$IotDeviceModelFromJson(json);

  /// Converts this model to JSON.
  Map<String, dynamic> toJson() => _$IotDeviceModelToJson(this);

  /// Converts this model to a domain entity.
  IotDevice toEntity() {
    return IotDevice(
      id: id,
      name: name,
      type: _parseDeviceType(type),
      status: _parseDeviceStatus(status),
      address: address,
      lastValue: lastValue,
      lastUpdated: lastUpdated != null ? DateTime.tryParse(lastUpdated!) : null,
      metadata: metadata,
      isSelected: isSelected,
      batteryLevel: batteryLevel,
      signalStrength: signalStrength,
    );
  }

  /// Creates a model from a domain entity.
  factory IotDeviceModel.fromEntity(IotDevice entity) {
    return IotDeviceModel(
      id: entity.id,
      name: entity.name,
      type: entity.type.name,
      status: entity.status.name,
      address: entity.address,
      lastValue: entity.lastValue,
      lastUpdated: entity.lastUpdated?.toIso8601String(),
      metadata: entity.metadata,
      isSelected: entity.isSelected,
      batteryLevel: entity.batteryLevel,
      signalStrength: entity.signalStrength,
    );
  }

  DeviceType _parseDeviceType(String type) {
    return DeviceType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => DeviceType.unknown,
    );
  }

  DeviceStatus _parseDeviceStatus(String status) {
    return DeviceStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => DeviceStatus.offline,
    );
  }
}
