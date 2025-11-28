import 'package:json_annotation/json_annotation.dart';

part 'command_response_model.g.dart';

/// Response model for device command operations.
@JsonSerializable()
class CommandResponseModel {
  /// Whether the command was executed successfully.
  final bool success;

  /// Optional message from the device or server.
  final String? message;

  /// Optional data returned by the command.
  final Map<String, dynamic>? data;

  /// Timestamp when the command was executed.
  final String? executedAt;

  const CommandResponseModel({
    required this.success,
    this.message,
    this.data,
    this.executedAt,
  });

  /// Creates a [CommandResponseModel] from JSON.
  factory CommandResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CommandResponseModelFromJson(json);

  /// Converts this model to JSON.
  Map<String, dynamic> toJson() => _$CommandResponseModelToJson(this);
}
