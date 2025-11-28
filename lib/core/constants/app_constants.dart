/// API Constants for the IoT application.
class ApiConstants {
  ApiConstants._();

  /// Base URL for the IoT API
  static const String baseUrl = 'https://api.iot-example.com/v1';

  /// Connection timeout in milliseconds
  static const int connectionTimeout = 30000;

  /// Receive timeout in milliseconds
  static const int receiveTimeout = 30000;

  /// MQTT broker URL
  static const String mqttBrokerUrl = 'mqtt://broker.iot-example.com';

  /// MQTT broker port
  static const int mqttBrokerPort = 1883;

  /// WebSocket URL for real-time updates
  static const String wsUrl = 'wss://ws.iot-example.com';
}

/// App Constants
class AppConstants {
  AppConstants._();

  /// Application name
  static const String appName = 'IoT App';

  /// Application version
  static const String appVersion = '1.0.0';

  /// Maximum retry attempts for network requests
  static const int maxRetryAttempts = 3;

  /// Delay between retry attempts in milliseconds
  static const int retryDelay = 1000;
}

/// Storage Keys for SharedPreferences
class StorageKeys {
  StorageKeys._();

  /// Key for storing auth token
  static const String authToken = 'auth_token';

  /// Key for storing user preferences
  static const String userPreferences = 'user_preferences';

  /// Key for storing device list cache
  static const String deviceListCache = 'device_list_cache';

  /// Key for storing last sync timestamp
  static const String lastSyncTimestamp = 'last_sync_timestamp';
}
