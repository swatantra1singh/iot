import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/confirm_sign_up.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/auth_data_source.dart';
import '../../data/datasources/auth_data_source_impl.dart';
import '../../../../core/utils/usecases.dart';

part 'auth_providers.g.dart';

/// Provider for auth data source.
@Riverpod(keepAlive: true)
AuthDataSource authDataSource(AuthDataSourceRef ref) {
  return AuthDataSourceImpl();
}

/// Provider for auth repository.
@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  final dataSource = ref.watch(authDataSourceProvider);
  return AuthRepositoryImpl(dataSource: dataSource);
}

/// Provider for SignIn use case.
@riverpod
SignIn signIn(SignInRef ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignIn(repository);
}

/// Provider for SignUp use case.
@riverpod
SignUp signUp(SignUpRef ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignUp(repository);
}

/// Provider for ConfirmSignUp use case.
@riverpod
ConfirmSignUp confirmSignUp(ConfirmSignUpRef ref) {
  final repository = ref.watch(authRepositoryProvider);
  return ConfirmSignUp(repository);
}

/// Provider for SignOut use case.
@riverpod
SignOut signOut(SignOutRef ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignOut(repository);
}

/// Provider for GetCurrentUser use case.
@riverpod
GetCurrentUser getCurrentUser(GetCurrentUserRef ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUser(repository);
}

/// Notifier for authentication state management.
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    // Check for current user on initialization
    _checkCurrentUser();
    return const AuthInitial();
  }

  Future<void> _checkCurrentUser() async {
    final getCurrentUserUseCase = ref.read(getCurrentUserProvider);
    final result = await getCurrentUserUseCase(NoParams());

    result.fold(
      (failure) {
        state = const Unauthenticated();
      },
      (user) {
        if (user != null) {
          state = Authenticated(user);
        } else {
          state = const Unauthenticated();
        }
      },
    );
  }

  /// Signs in a user.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();

    final signInUseCase = ref.read(signInProvider);
    final result = await signInUseCase(SignInParams(
      email: email,
      password: password,
    ));

    result.fold(
      (failure) {
        if (failure.message.contains('not verified')) {
          state = AuthNeedsVerification(email);
        } else {
          state = AuthError(failure.message);
        }
      },
      (user) {
        state = Authenticated(user);
      },
    );
  }

  /// Signs up a new user.
  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = const AuthLoading();

    final signUpUseCase = ref.read(signUpProvider);
    final result = await signUpUseCase(SignUpParams(
      email: email,
      password: password,
      displayName: displayName,
    ));

    result.fold(
      (failure) {
        state = AuthError(failure.message);
      },
      (user) {
        state = AuthNeedsVerification(email);
      },
    );
  }

  /// Confirms sign up with verification code.
  Future<void> confirmSignUp({
    required String email,
    required String confirmationCode,
  }) async {
    state = const AuthLoading();

    final confirmSignUpUseCase = ref.read(confirmSignUpProvider);
    final result = await confirmSignUpUseCase(ConfirmSignUpParams(
      email: email,
      confirmationCode: confirmationCode,
    ));

    result.fold(
      (failure) {
        state = AuthError(failure.message);
      },
      (success) {
        state = const Unauthenticated();
      },
    );
  }

  /// Resends the confirmation code.
  Future<bool> resendConfirmationCode({required String email}) async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.resendConfirmationCode(email: email);

    return result.fold(
      (failure) => false,
      (success) => success,
    );
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    state = const AuthLoading();

    final signOutUseCase = ref.read(signOutProvider);
    final result = await signOutUseCase(NoParams());

    result.fold(
      (failure) {
        state = AuthError(failure.message);
      },
      (_) {
        state = const Unauthenticated();
      },
    );
  }

  /// Clears any error state.
  void clearError() {
    if (state is AuthError) {
      state = const Unauthenticated();
    }
  }
}
