// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iot_device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IotDeviceModel _$IotDeviceModelFromJson(Map<String, dynamic> json) =>
    IotDeviceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      address: json['address'] as String?,
      lastValue: json['last_value'],
      lastUpdated: json['last_updated'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      isSelected: json['is_selected'] as bool? ?? false,
      batteryLevel: (json['battery_level'] as num?)?.toInt(),
      signalStrength: (json['signal_strength'] as num?)?.toInt(),
    );

Map<String, dynamic> _$IotDeviceModelToJson(IotDeviceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'status': instance.status,
      'address': instance.address,
      'last_value': instance.lastValue,
      'last_updated': instance.lastUpdated,
      'metadata': instance.metadata,
      'is_selected': instance.isSelected,
      'battery_level': instance.batteryLevel,
      'signal_strength': instance.signalStrength,
    };
