import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../features/iot/data/models/iot_device_model.dart';
import '../../features/iot/data/models/sensor_data_model.dart';

part 'iot_api_service.g.dart';

/// Retrofit API service for IoT device operations.
///
/// This service defines all REST API endpoints for managing IoT devices.
/// Generated code handles the actual HTTP requests using Dio.
@RestApi()
abstract class IotApiService {
  /// Factory constructor that creates an [IotApiService] instance.
  factory IotApiService(Dio dio, {String baseUrl}) = _IotApiService;

  /// Fetches all devices from the server.
  @GET('/devices')
  Future<List<IotDeviceModel>> getDevices();

  /// Fetches a specific device by ID.
  @GET('/devices/{id}')
  Future<IotDeviceModel> getDeviceById(@Path('id') String deviceId);

  /// Creates a new device.
  @POST('/devices')
  Future<IotDeviceModel> createDevice(@Body() IotDeviceModel device);

  /// Updates an existing device.
  @PUT('/devices/{id}')
  Future<IotDeviceModel> updateDevice(
    @Path('id') String deviceId,
    @Body() IotDeviceModel device,
  );

  /// Deletes a device.
  @DELETE('/devices/{id}')
  Future<void> deleteDevice(@Path('id') String deviceId);

  /// Connects to a device.
  @POST('/devices/{id}/connect')
  Future<IotDeviceModel> connectToDevice(@Path('id') String deviceId);

  /// Disconnects from a device.
  @POST('/devices/{id}/disconnect')
  Future<IotDeviceModel> disconnectFromDevice(@Path('id') String deviceId);

  /// Sends a command to a device.
  @POST('/devices/{id}/command')
  Future<Map<String, dynamic>> sendCommand(
    @Path('id') String deviceId,
    @Body() Map<String, dynamic> command,
  );

  /// Gets sensor data for a device.
  @GET('/devices/{id}/sensor-data')
  Future<List<SensorDataModel>> getSensorData(
    @Path('id') String deviceId, {
    @Query('start_date') String? startDate,
    @Query('end_date') String? endDate,
    @Query('limit') int? limit,
  });

  /// Scans for nearby devices.
  @GET('/devices/scan')
  Future<List<IotDeviceModel>> scanForDevices();
}
