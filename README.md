# IoT App

A production-grade Flutter IoT application built with Clean Architecture and Riverpod state management.

## Features

- 📱 Cross-platform support (iOS and Android)
- 🏗️ Clean Architecture with strict layer separation
- 🔄 State management with Riverpod (code generation)
- 📡 IoT device management (Bluetooth, WiFi, MQTT)
- 🎨 Modern Material Design 3 UI
- 🌓 Light and Dark theme support
- ✅ Comprehensive test coverage

## Architecture

This project follows Clean Architecture principles with the following structure:

```
lib/
├── core/                    # Core utilities and shared code
│   ├── constants/           # App constants
│   ├── errors/              # Error handling (Failures & Exceptions)
│   ├── theme/               # App theming
│   ├── router/              # Navigation routing
│   └── utils/               # Shared utilities
│
├── features/                # Feature modules
│   └── iot/                 # IoT feature
│       ├── data/            # Data layer
│       │   ├── datasources/ # Remote and local data sources
│       │   ├── models/      # Data models with JSON serialization
│       │   └── repositories/# Repository implementations
│       │
│       ├── domain/          # Domain layer
│       │   ├── entities/    # Business entities
│       │   ├── repositories/# Repository interfaces
│       │   └── usecases/    # Use cases
│       │
│       └── presentation/    # Presentation layer
│           ├── providers/   # Riverpod providers
│           ├── screens/     # UI screens
│           └── widgets/     # Reusable widgets
│
└── app.dart                 # App configuration
```

## Getting Started

### Prerequisites

- Flutter SDK (>= 3.10.0)
- Dart SDK (>= 3.0.0)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/your-repo/iot-app.git
cd iot-app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code (Riverpod, JSON serialization):
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

## State Management

This project uses [Riverpod](https://riverpod.dev/) with code generation for type-safe state management.

### Providers

```dart
// Using providers
final deviceState = ref.watch(iotDeviceNotifierProvider);
final deviceNotifier = ref.read(iotDeviceNotifierProvider.notifier);

// Load devices
await deviceNotifier.loadDevices();

// Connect to a device
await deviceNotifier.connectDevice(deviceId);
```

### Code Generation

Providers are generated using `riverpod_generator`. After making changes to providers, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Testing

Run all tests:
```bash
flutter test
```

Run tests with coverage:
```bash
flutter test --coverage
```

## Dependencies

### Main Dependencies

| Package | Description |
|---------|-------------|
| `hooks_riverpod` | State management |
| `riverpod_annotation` | Riverpod code generation annotations |
| `freezed_annotation` | Immutable data classes |
| `dartz` | Functional programming utilities |
| `dio` | HTTP client |
| `go_router` | Declarative routing |
| `mqtt_client` | MQTT protocol support |
| `flutter_blue_plus` | Bluetooth support |
| `connectivity_plus` | Network connectivity |

### Dev Dependencies

| Package | Description |
|---------|-------------|
| `build_runner` | Code generation |
| `riverpod_generator` | Riverpod provider generation |
| `freezed` | Immutable data class generation |
| `json_serializable` | JSON serialization generation |
| `mockito` | Mocking for tests |

## Project Structure

### Core Layer

- **Constants**: API endpoints, app configuration, storage keys
- **Errors**: Failure and Exception classes for error handling
- **Theme**: App colors, text styles, and theme configuration
- **Router**: GoRouter configuration for navigation
- **Utils**: Base use case classes and shared utilities

### Feature Layers

Each feature follows the Clean Architecture pattern:

1. **Data Layer**: Implements repositories, contains data sources and models
2. **Domain Layer**: Contains business logic (entities, repository interfaces, use cases)
3. **Presentation Layer**: UI components and state management

## IoT Capabilities

- **Device Discovery**: Scan for nearby Bluetooth/WiFi devices
- **Device Connection**: Connect to and manage IoT devices
- **Command Sending**: Send commands to connected devices
- **Sensor Data**: Receive and display real-time sensor data
- **Device Status**: Monitor device connection status

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
