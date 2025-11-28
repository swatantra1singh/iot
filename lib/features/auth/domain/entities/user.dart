import 'package:equatable/equatable.dart';

/// Entity representing an authenticated user.
class User extends Equatable {
  /// Unique identifier for the user.
  final String id;

  /// User's email address.
  final String email;

  /// User's display name.
  final String? displayName;

  /// Whether the user's email is verified.
  final bool isEmailVerified;

  /// User's profile image URL.
  final String? profileImageUrl;

  /// When the user was created.
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.isEmailVerified = false,
    this.profileImageUrl,
    this.createdAt,
  });

  /// Creates a copy of this user with the given fields replaced.
  User copyWith({
    String? id,
    String? email,
    String? displayName,
    bool? isEmailVerified,
    String? profileImageUrl,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        isEmailVerified,
        profileImageUrl,
        createdAt,
      ];
}
