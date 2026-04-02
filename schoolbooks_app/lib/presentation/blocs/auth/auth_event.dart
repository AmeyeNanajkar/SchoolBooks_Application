import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String role;

  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.role = 'family',
  });

  @override
  List<Object?> get props => [name, email, password, phone, role];
}

class AuthOtpSendRequested extends AuthEvent {
  final String email;

  const AuthOtpSendRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthOtpVerifyRequested extends AuthEvent {
  final String email;
  final String otp;

  const AuthOtpVerifyRequested({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthUserUpdated extends AuthEvent {
  final Map<String, dynamic> userData;

  const AuthUserUpdated({required this.userData});

  @override
  List<Object?> get props => [userData];
}
