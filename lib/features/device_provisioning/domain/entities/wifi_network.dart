import 'package:equatable/equatable.dart';

/// Represents a WiFi network discovered during provisioning.
class WiFiNetwork extends Equatable {
  /// SSID of the network.
  final String ssid;

  /// Signal strength (0-100).
  final int signalStrength;

  /// Whether the network is secured.
  final bool isSecured;

  /// Security type (WPA, WPA2, WEP, etc.).
  final String? securityType;

  const WiFiNetwork({
    required this.ssid,
    required this.signalStrength,
    this.isSecured = true,
    this.securityType,
  });

  @override
  List<Object?> get props => [ssid, signalStrength, isSecured, securityType];
}
