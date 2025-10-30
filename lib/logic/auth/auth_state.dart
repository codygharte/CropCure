import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String token;
  final String userEmail;

  const Authenticated({required this.token, required this.userEmail});

  @override
  List<Object> get props => [token, userEmail];
}

class Unauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class ForgotPasswordLoading extends AuthState {}

class ForgotPasswordSuccess extends AuthState {
  final String message;

  const ForgotPasswordSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class ForgotPasswordFailure extends AuthState {
  final String error;

  const ForgotPasswordFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class VerifyOtpLoading extends AuthState {}

class VerifyOtpSuccess extends AuthState {
  final String message;

  const VerifyOtpSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class VerifyOtpFailure extends AuthState {
  final String error;

  const VerifyOtpFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class ResetPasswordLoading extends AuthState {}

class ResetPasswordSuccess extends AuthState {
  final String message;

  const ResetPasswordSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class ResetPasswordFailure extends AuthState {
  final String error;

  const ResetPasswordFailure({required this.error});

  @override
  List<Object> get props => [error];
}
