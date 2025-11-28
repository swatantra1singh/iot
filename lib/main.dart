import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'features/iot/data/datasources/iot_local_data_source_impl.dart';
import 'features/iot/data/datasources/iot_remote_data_source_impl.dart';

/// Application entry point.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(AppProviders(
    localDataSource: IotLocalDataSourceImpl(sharedPreferences: sharedPreferences),
    remoteDataSource: IotRemoteDataSourceImpl(),
  ));
}
