import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/esp32_device.dart';
import '../../domain/entities/wifi_network.dart';
import '../../domain/repositories/provisioning_repository.dart';
import '../datasources/provisioning_data_source.dart';

/// Implementation of ProvisioningRepository.
class ProvisioningRepositoryImpl implements ProvisioningRepository {
  final ProvisioningDataSource dataSource;

  const ProvisioningRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<Esp32Device>>> scanForDevices() async {
    try {
      final devices = await dataSource.scanForDevices();
      return Right(devices);
    } on DeviceConnectionException catch (e) {
      return Left(DeviceConnectionFailure(message: e.message));
    } on BluetoothException catch (e) {
      return Left(BluetoothFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> connectToDevice(Esp32Device device) async {
    try {
      final result = await dataSource.connectToDevice(device);
      return Right(result);
    } on DeviceConnectionException catch (e) {
      return Left(DeviceConnectionFailure(message: e.message));
    } on BluetoothException catch (e) {
      return Left(BluetoothFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> disconnectFromDevice() async {
    try {
      await dataSource.disconnectFromDevice();
      return const Right(null);
    } on DeviceConnectionException catch (e) {
      return Left(DeviceConnectionFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WiFiNetwork>>> getAvailableNetworks() async {
    try {
      final networks = await dataSource.getAvailableNetworks();
      return Right(networks);
    } on DeviceConnectionException catch (e) {
      return Left(DeviceConnectionFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> provisionDevice({
    required String ssid,
    required String password,
    String? deviceName,
  }) async {
    try {
      final deviceId = await dataSource.provisionDevice(
        ssid: ssid,
        password: password,
        deviceName: deviceName,
      );
      return Right(deviceId);
    } on DeviceConnectionException catch (e) {
      return Left(DeviceConnectionFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> registerDeviceToCloud({
    required String deviceId,
    required String deviceName,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final cloudId = await dataSource.registerDeviceToCloud(
        deviceId: deviceId,
        deviceName: deviceName,
        metadata: metadata,
      );
      return Right(cloudId);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
