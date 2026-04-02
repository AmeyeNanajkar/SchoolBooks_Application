import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/user_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage;

  AuthBloc({
    required ApiClient apiClient,
    required FlutterSecureStorage secureStorage,
  })  : _apiClient = apiClient,
        _secureStorage = secureStorage,
        super(const AuthState()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthOtpSendRequested>(_onOtpSendRequested);
    on<AuthOtpVerifyRequested>(_onOtpVerifyRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final token = await _secureStorage.read(key: StorageKeys.accessToken);
      if (token != null) {
        final response = await _apiClient.get(ApiConstants.usersMe);
        final user = UserModel.fromJson(response.data);
        emit(state.copyWith(status: AuthStatus.authenticated, user: user));
      } else {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      }
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final response = await _apiClient.post(
        ApiConstants.authLogin,
        data: {
          'email': event.email,
          'password': event.password,
        },
      );

      await _secureStorage.write(
        key: StorageKeys.accessToken,
        value: response.data['access_token'],
      );
      await _secureStorage.write(
        key: StorageKeys.refreshToken,
        value: response.data['refresh_token'],
      );

      final user = UserModel.fromJson(response.data['user']);
      await _secureStorage.write(key: StorageKeys.userRole, value: user.role.name);

      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } on AuthException catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: 'Login failed'));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final response = await _apiClient.post(
        ApiConstants.authRegister,
        data: {
          'name': event.name,
          'email': event.email,
          'password': event.password,
          'phone': event.phone,
          'role': event.role,
        },
      );

      await _secureStorage.write(
        key: StorageKeys.accessToken,
        value: response.data['access_token'],
      );
      await _secureStorage.write(
        key: StorageKeys.refreshToken,
        value: response.data['refresh_token'],
      );

      final user = UserModel.fromJson(response.data['user']);

      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } on AuthException catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: 'Registration failed'));
    }
  }

  Future<void> _onOtpSendRequested(
    AuthOtpSendRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, email: event.email));
    try {
      await _apiClient.post(
        ApiConstants.authOtpSend,
        data: {'email': event.email},
      );
      emit(state.copyWith(status: AuthStatus.otpSent));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: 'Failed to send OTP'));
    }
  }

  Future<void> _onOtpVerifyRequested(
    AuthOtpVerifyRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _apiClient.post(
        ApiConstants.authOtpVerify,
        data: {
          'email': event.email,
          'otp': event.otp,
        },
      );
      emit(state.copyWith(status: AuthStatus.otpVerified));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: 'Invalid OTP'));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _secureStorage.delete(key: StorageKeys.accessToken);
    await _secureStorage.delete(key: StorageKeys.refreshToken);
    await _secureStorage.delete(key: StorageKeys.userRole);
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
