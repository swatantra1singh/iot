import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/iot_device.dart';
import '../../domain/entities/sensor_data.dart';
import '../../domain/repositories/iot_device_repository.dart';
import '../datasources/iot_local_data_source.dart';
import '../datasources/iot_remote_data_source.dart';
import '../models/iot_device_model.dart';

/// Implementation of [IotDeviceRepository].
///
/// This implementation uses both remote and local data sources,
/// with the local source serving as a cache.
class IotDeviceRepositoryImpl implements IotDeviceRepository {
  final IotRemoteDataSource remoteDataSource;
  final IotLocalDataSource localDataSource;

  IotDeviceRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<IotDevice>>> getDevices() async {
    try {
      final remoteDevices = await remoteDataSource.getDevices();
      await localDataSource.cacheDevices(remoteDevices);
      return Right(remoteDevices.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      // Try to return cached data on server error
      try {
        final cachedDevices = await localDataSource.getCachedDevices();
        if (cachedDevices.isNotEmpty) {
          return Right(cachedDevices.map((model) => model.toEntity()).toList());
        }
      } on CacheException {
        // Ignore cache errors
      }
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      // Try to return cached data on network error
      try {
        final cachedDevices = await localDataSource.getCachedDevices();
        if (cachedDevices.isNotEmpty) {
          return Right(cachedDevices.map((model) => model.toEntity()).toList());
        }
      } on CacheException {
        // Ignore cache errors
      }
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, IotDevice>> getDeviceById(String deviceId) async {
    try {
      final device = await remoteDataSource.getDeviceById(deviceId);
      await localDataSource.cacheDevice(device);
      return Right(device.toEntity());
    } on ServerException catch (e) {
      // Try to return cached data on server error
      try {
        final cachedDevice = await localDataSource.getCachedDeviceById(deviceId);
        if (cachedDevice != null) {
          return Right(cachedDevice.toEntity());
        }
      } on CacheException {
        // Ignore cache errors
      }
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      // Try to return cached data on network error
      try {
        final cachedDevice = await localDataSource.getCachedDeviceById(deviceId);
        if (cachedDevice != null) {
          return Right(cachedDevice.toEntity());
        }
      } on CacheException {
        // Ignore cache errors
      }
      return Left(NetworkFailure(message: e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, IotDevice>> addDevice(IotDevice device) async {
    try {
      final model = IotDeviceModel.fromEntity(device);
      final addedDevice = await remoteDataSource.addDevice(model);
      await localDataSource.cacheDevice(addedDevice);
      return Right(addedDevice.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, IotDevice>> updateDevice(IotDevice device) async {
    try {
      final model = IotDeviceModel.fromEntity(device);
      final updatedDevice = await remoteDataSource.updateDevice(model);
      await localDataSource.cacheDevice(updatedDevice);
      return Right(updatedDevice.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, bool>> removeDevice(String deviceId) async {
    try {
      final result = await remoteDataSource.removeDevice(deviceId);
      await localDataSource.removeCachedDevice(deviceId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, IotDevice>> connectToDevice(String deviceId) async {
    try {
      final device = await remoteDataSource.connectToDevice(deviceId);
      await localDataSource.cacheDevice(device);
      return Right(device.toEntity());
    } on DeviceConnectionException catch (e) {
      return Left(DeviceConnectionFailure(message: e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, IotDevice>> disconnectFromDevice(String deviceId) async {
    try {
      final device = await remoteDataSource.disconnectFromDevice(deviceId);
      await localDataSource.cacheDevice(device);
      return Right(device.toEntity());
    } on DeviceConnectionException catch (e) {
      return Left(DeviceConnectionFailure(message: e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, bool>> sendCommand(
    String deviceId,
    String command,
    Map<String, dynamic>? parameters,
  ) async {
    try {
      final result = await remoteDataSource.sendCommand(
        deviceId,
        command,
        parameters,
      );
      return Right(result);
    } on DeviceConnectionException catch (e) {
      return Left(DeviceConnectionFailure(message: e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, List<SensorData>>> getSensorData(
    String deviceId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    try {
      final sensorData = await remoteDataSource.getSensorData(
        deviceId,
        startDate: startDate,
        endDate: endDate,
        limit: limit,
      );
      return Right(sensorData.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    }
  }

  @override
  Stream<Either<Failure, SensorData>> streamSensorData(String deviceId) {
    return remoteDataSource.streamSensorData(deviceId).map((model) {
      return Right<Failure, SensorData>(model.toEntity());
    }).handleError((Object error) {
      if (error is DeviceConnectionException) {
        return Left<Failure, SensorData>(
          DeviceConnectionFailure(message: error.message, code: error.code),
        );
      }
      if (error is ServerException) {
        return Left<Failure, SensorData>(
          ServerFailure(message: error.message, code: error.code),
        );
      }
      return Left<Failure, SensorData>(
        const ServerFailure(message: 'Unknown error occurred'),
      );
    });
  }

  @override
  Future<Either<Failure, List<IotDevice>>> scanForDevices() async {
    try {
      final devices = await remoteDataSource.scanForDevices();
      return Right(devices.map((model) => model.toEntity()).toList());
    } on BluetoothException catch (e) {
      return Left(BluetoothFailure(message: e.message, code: e.code));
    } on DeviceConnectionException catch (e) {
      return Left(DeviceConnectionFailure(message: e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    }
  }
}
