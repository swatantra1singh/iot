import 'dart:async';

import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/iot_api_service.dart';
import '../models/iot_device_model.dart';
import '../models/sensor_data_model.dart';
import 'iot_remote_data_source.dart';

/// Implementation of [IotRemoteDataSource] using Retrofit.
///
/// This implementation uses the [IotApiService] for REST API calls.
/// For streaming sensor data, it uses a WebSocket connection (placeholder).
class IotRetrofitDataSource implements IotRemoteDataSource {
  final IotApiService _apiService;

  /// Creates an [IotRetrofitDataSource] with the given [IotApiService].
  IotRetrofitDataSource({IotApiService? apiService})
      : _apiService = apiService ?? IotApiService(DioClient.instance);

  @override
  Future<List<IotDeviceModel>> getDevices() async {
    try {
      return await _apiService.getDevices();
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<IotDeviceModel> getDeviceById(String deviceId) async {
    try {
      return await _apiService.getDeviceById(deviceId);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<IotDeviceModel> addDevice(IotDeviceModel device) async {
    try {
      return await _apiService.createDevice(device);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<IotDeviceModel> updateDevice(IotDeviceModel device) async {
    try {
      return await _apiService.updateDevice(device.id, device);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<bool> removeDevice(String deviceId) async {
    try {
      await _apiService.deleteDevice(deviceId);
      return true;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<IotDeviceModel> connectToDevice(String deviceId) async {
    try {
      return await _apiService.connectToDevice(deviceId);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<IotDeviceModel> disconnectFromDevice(String deviceId) async {
    try {
      return await _apiService.disconnectFromDevice(deviceId);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<bool> sendCommand(
    String deviceId,
    String command,
    Map<String, dynamic>? parameters,
  ) async {
    try {
      final commandData = {
        'command': command,
        if (parameters != null) 'parameters': parameters,
      };
      final result = await _apiService.sendCommand(deviceId, commandData);
      return result['success'] == true;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<List<SensorDataModel>> getSensorData(
    String deviceId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    try {
      return await _apiService.getSensorData(
        deviceId,
        startDate: startDate?.toIso8601String(),
        endDate: endDate?.toIso8601String(),
        limit: limit,
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Stream<SensorDataModel> streamSensorData(String deviceId) {
    // Placeholder for WebSocket implementation
    // In a real implementation, this would connect to a WebSocket
    // and stream sensor data in real-time.
    return Stream.periodic(const Duration(seconds: 2), (i) {
      return SensorDataModel(
        id: 'stream-$deviceId-$i',
        deviceId: deviceId,
        sensorType: 'temperature',
        value: 20.0 + (i % 10),
        unit: '°C',
        timestamp: DateTime.now().toIso8601String(),
      );
    });
  }

  @override
  Future<List<IotDeviceModel>> scanForDevices() async {
    try {
      return await _apiService.scanForDevices();
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  /// Maps [DioException] to application-specific exceptions.
  AppException _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Connection timed out',
          code: error.response?.statusCode,
          originalException: error,
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'No internet connection',
          code: error.response?.statusCode,
          originalException: error,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401 || statusCode == 403) {
          return AuthException(
            message: 'Authentication failed',
            code: statusCode,
            originalException: error,
          );
        }
        return ServerException(
          message: error.response?.statusMessage ?? 'Server error occurred',
          code: statusCode,
          originalException: error,
        );
      case DioExceptionType.cancel:
        return ServerException(
          message: 'Request cancelled',
          originalException: error,
        );
      default:
        return ServerException(
          message: error.message ?? 'Unknown error occurred',
          originalException: error,
        );
    }
  }
}
