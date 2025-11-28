import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/iot/data/datasources/iot_local_data_source.dart';
import 'features/iot/data/datasources/iot_remote_data_source.dart';
import 'features/iot/presentation/providers/iot_device_providers.dart';
import 'features/settings/presentation/providers/theme_provider.dart';

/// Main IoT Application widget.
class IotApp extends ConsumerWidget {
  const IotApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);

    return MaterialApp.router(
      title: 'IoT App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}

/// Entry point wrapper that sets up providers.
class AppProviders extends StatelessWidget {
  final IotLocalDataSource localDataSource;
  final IotRemoteDataSource remoteDataSource;

  const AppProviders({
    super.key,
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        iotLocalDataSourceProvider.overrideWithValue(localDataSource),
        iotRemoteDataSourceProvider.overrideWithValue(remoteDataSource),
      ],
      child: const IotApp(),
    );
  }
}
