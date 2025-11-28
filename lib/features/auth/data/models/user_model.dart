import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

/// Data model for User entity.
@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  @JsonKey(name: 'display_name')
  final String? displayName;
  @JsonKey(name: 'is_email_verified')
  final bool isEmailVerified;
  @JsonKey(name: 'profile_image_url')
  final String? profileImageUrl;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.isEmailVerified = false,
    this.profileImageUrl,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Converts this model to a domain entity.
  User toEntity() {
    return User(
      id: id,
      email: email,
      displayName: displayName,
      isEmailVerified: isEmailVerified,
      profileImageUrl: profileImageUrl,
      createdAt: createdAt,
    );
  }

  /// Creates a model from a domain entity.
  factory UserModel.fromEntity(User entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      displayName: entity.displayName,
      isEmailVerified: entity.isEmailVerified,
      profileImageUrl: entity.profileImageUrl,
      createdAt: entity.createdAt,
    );
  }
}
