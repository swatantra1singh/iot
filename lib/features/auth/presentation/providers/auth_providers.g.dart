// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authDataSourceHash() => r'auth_data_source_hash';

/// Provider for auth data source.
///
/// Copied from [authDataSource].
@ProviderFor(authDataSource)
final authDataSourceProvider = Provider<AuthDataSource>.internal(
  authDataSource,
  name: r'authDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthDataSourceRef = ProviderRef<AuthDataSource>;

String _$authRepositoryHash() => r'auth_repository_hash';

/// Provider for auth repository.
///
/// Copied from [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = Provider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthRepositoryRef = ProviderRef<AuthRepository>;

String _$signInHash() => r'sign_in_hash';

/// Provider for SignIn use case.
///
/// Copied from [signIn].
@ProviderFor(signIn)
final signInProvider = AutoDisposeProvider<SignIn>.internal(
  signIn,
  name: r'signInProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$signInHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SignInRef = AutoDisposeProviderRef<SignIn>;

String _$signUpHash() => r'sign_up_hash';

/// Provider for SignUp use case.
///
/// Copied from [signUp].
@ProviderFor(signUp)
final signUpProvider = AutoDisposeProvider<SignUp>.internal(
  signUp,
  name: r'signUpProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$signUpHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SignUpRef = AutoDisposeProviderRef<SignUp>;

String _$confirmSignUpHash() => r'confirm_sign_up_hash';

/// Provider for ConfirmSignUp use case.
///
/// Copied from [confirmSignUp].
@ProviderFor(confirmSignUp)
final confirmSignUpProvider = AutoDisposeProvider<ConfirmSignUp>.internal(
  confirmSignUp,
  name: r'confirmSignUpProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$confirmSignUpHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ConfirmSignUpRef = AutoDisposeProviderRef<ConfirmSignUp>;

String _$signOutHash() => r'sign_out_hash';

/// Provider for SignOut use case.
///
/// Copied from [signOut].
@ProviderFor(signOut)
final signOutProvider = AutoDisposeProvider<SignOut>.internal(
  signOut,
  name: r'signOutProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$signOutHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SignOutRef = AutoDisposeProviderRef<SignOut>;

String _$getCurrentUserHash() => r'get_current_user_hash';

/// Provider for GetCurrentUser use case.
///
/// Copied from [getCurrentUser].
@ProviderFor(getCurrentUser)
final getCurrentUserProvider = AutoDisposeProvider<GetCurrentUser>.internal(
  getCurrentUser,
  name: r'getCurrentUserProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getCurrentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetCurrentUserRef = AutoDisposeProviderRef<GetCurrentUser>;

String _$authNotifierHash() => r'auth_notifier_hash';

/// Notifier for authentication state management.
///
/// Copied from [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthState>.internal(
  AuthNotifier.new,
  name: r'authNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthNotifier = Notifier<AuthState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
