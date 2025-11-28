import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/iot_device_model.dart';
import 'iot_local_data_source.dart';

/// Implementation of [IotLocalDataSource] using SharedPreferences.
class IotLocalDataSourceImpl implements IotLocalDataSource {
  final SharedPreferences sharedPreferences;

  IotLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<IotDeviceModel>> getCachedDevices() async {
    try {
      final jsonString = sharedPreferences.getString(StorageKeys.deviceListCache);
      if (jsonString == null) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => IotDeviceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on Exception catch (e) {
      throw CacheException(
        message: 'Failed to get cached devices',
        originalException: e,
      );
    }
  }

  @override
  Future<void> cacheDevices(List<IotDeviceModel> devices) async {
    try {
      final jsonList = devices.map((device) => device.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await sharedPreferences.setString(StorageKeys.deviceListCache, jsonString);
    } on Exception catch (e) {
      throw CacheException(
        message: 'Failed to cache devices',
        originalException: e,
      );
    }
  }

  @override
  Future<IotDeviceModel?> getCachedDeviceById(String deviceId) async {
    try {
      final devices = await getCachedDevices();
      return devices.firstWhere(
        (device) => device.id == deviceId,
      );
    } on StateError {
      return null;
    } on CacheException {
      rethrow;
    }
  }

  @override
  Future<void> cacheDevice(IotDeviceModel device) async {
    try {
      final devices = await getCachedDevices();
      final index = devices.indexWhere((d) => d.id == device.id);

      if (index >= 0) {
        devices[index] = device;
      } else {
        devices.add(device);
      }

      await cacheDevices(devices);
    } on CacheException {
      rethrow;
    }
  }

  @override
  Future<void> removeCachedDevice(String deviceId) async {
    try {
      final devices = await getCachedDevices();
      devices.removeWhere((device) => device.id == deviceId);
      await cacheDevices(devices);
    } on CacheException {
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(StorageKeys.deviceListCache);
    } on Exception catch (e) {
      throw CacheException(
        message: 'Failed to clear cache',
        originalException: e,
      );
    }
  }
}
