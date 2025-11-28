import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:iot_app/core/errors/failures.dart';
import 'package:iot_app/features/iot/domain/entities/iot_device.dart';
import 'package:iot_app/features/iot/domain/repositories/iot_device_repository.dart';
import 'package:iot_app/features/iot/domain/usecases/get_devices.dart';

@GenerateMocks([IotDeviceRepository])
import 'get_devices_test.mocks.dart';

void main() {
  late GetDevices useCase;
  late MockIotDeviceRepository mockRepository;

  setUp(() {
    mockRepository = MockIotDeviceRepository();
    useCase = GetDevices(mockRepository);
  });

  final tDevices = [
    const IotDevice(
      id: '1',
      name: 'Test Device 1',
      type: DeviceType.sensor,
      status: DeviceStatus.online,
    ),
    const IotDevice(
      id: '2',
      name: 'Test Device 2',
      type: DeviceType.actuator,
      status: DeviceStatus.offline,
    ),
  ];

  test('should return list of devices from repository', () async {
    // arrange
    when(mockRepository.getDevices())
        .thenAnswer((_) async => Right(tDevices));

    // act
    final result = await useCase();

    // assert
    expect(result, Right(tDevices));
    verify(mockRepository.getDevices());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    // arrange
    const tFailure = ServerFailure(message: 'Server error');
    when(mockRepository.getDevices())
        .thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await useCase();

    // assert
    expect(result, const Left(tFailure));
    verify(mockRepository.getDevices());
    verifyNoMoreInteractions(mockRepository);
  });
}
