// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SensorDataModel _$SensorDataModelFromJson(Map<String, dynamic> json) =>
    SensorDataModel(
      id: json['id'] as String,
      deviceId: json['device_id'] as String,
      sensorType: json['sensor_type'] as String,
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      timestamp: json['timestamp'] as String,
      quality: (json['quality'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SensorDataModelToJson(SensorDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'device_id': instance.deviceId,
      'sensor_type': instance.sensorType,
      'value': instance.value,
      'unit': instance.unit,
      'timestamp': instance.timestamp,
      'quality': instance.quality,
    };
