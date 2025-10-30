import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crop_cure/logic/auth/auth_event.dart';
import 'package:crop_cure/logic/auth/auth_state.dart';
import 'package:crop_cure/data/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      emit(AuthLoading());
      try {
        final isAuthenticated = await authRepository.isAuthenticated();
        if (isAuthenticated) {
          final token = await authRepository.getToken();
          final email = await authRepository.getUserEmail();
          emit(Authenticated(token: token!, userEmail: email!));
        } else {
          emit(Unauthenticated());
        }
      } catch (e) {
        emit(Unauthenticated());
      }
    });

    on<LoginRequested>((event, emit) async {
      print('AuthBloc: LoginRequested event received');
      print('Email: ${event.email}');
      emit(AuthLoading());
      try {
        print('AuthBloc: Calling authRepository.login');
        final response =
            await authRepository.login(event.email, event.password);
        final token = (response['token'] ?? '').toString();
        if (token.isNotEmpty) {
          print('AuthBloc: Login successful, emitting Authenticated state');
          emit(Authenticated(
            token: token,
            userEmail: response['user']['email'],
          ));
        } else {
          print('AuthBloc: Login succeeded but no token returned; emitting failure');
          emit(AuthFailure(
              error:
                  'Login succeeded but no token was returned. Please try again.'));
        }
      } catch (e) {
        print('AuthBloc: Login failed with error: $e');
        emit(AuthFailure(error: e.toString()));
      }
    });

    on<RegisterRequested>((event, emit) async {
      print('AuthBloc: RegisterRequested event received');
      print('Name: ${event.name}, Email: ${event.email}');
      emit(AuthLoading());
      try {
        print('AuthBloc: Calling authRepository.register');
        final response = await authRepository.register(
          name: event.name,
          email: event.email,
          password: event.password,
        );
        final token = (response['token'] ?? '').toString();
        if (token.isNotEmpty) {
          print('AuthBloc: Register successful, emitting Authenticated state');
          emit(Authenticated(
            token: token,
            userEmail: response['user']['email'],
          ));
        } else {
          print('AuthBloc: Register succeeded but no token returned; emitting failure');
          emit(AuthFailure(
              error:
                  'Registration successful. Please sign in to continue.'));
        }
      } catch (e) {
        print('AuthBloc: Register failed with error: $e');
        emit(AuthFailure(error: e.toString()));
      }
    });

    on<LoggedOut>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.logout();
        emit(Unauthenticated());
      } catch (e) {
        emit(Unauthenticated());
      }
    });

    on<ForgotPasswordRequested>((event, emit) async {
      print('AuthBloc: ForgotPasswordRequested event received');
      print('Email: ${event.email}');
      emit(ForgotPasswordLoading());
      try {
        print('AuthBloc: Calling authRepository.forgotPassword');
        final response = await authRepository.forgotPassword(event.email);
        print(
            'AuthBloc: Forgot password successful, emitting ForgotPasswordSuccess state');
        emit(ForgotPasswordSuccess(message: response['message']));
      } catch (e) {
        print('AuthBloc: Forgot password failed with error: $e');
        emit(ForgotPasswordFailure(error: e.toString()));
      }
    });

    on<VerifyOtpRequested>((event, emit) async {
      print('AuthBloc: VerifyOtpRequested event received');
      print('Email: ${event.email}, OTP: ${event.otp}');
      emit(VerifyOtpLoading());
      try {
        print('AuthBloc: Calling authRepository.verifyOtp');
        final response = await authRepository.verifyOtp(event.email, event.otp);
        print(
            'AuthBloc: OTP verification successful, emitting VerifyOtpSuccess state');
        emit(VerifyOtpSuccess(message: response['message']));
      } catch (e) {
        print('AuthBloc: OTP verification failed with error: $e');
        emit(VerifyOtpFailure(error: e.toString()));
      }
    });

    on<ResetPasswordRequested>((event, emit) async {
      print('AuthBloc: ResetPasswordRequested event received');
      print('Email: ${event.email}, OTP: ${event.otp}');
      emit(ResetPasswordLoading());
      try {
        print('AuthBloc: Calling authRepository.resetPassword');
        final response = await authRepository.resetPassword(
          email: event.email,
          otp: event.otp,
          newPassword: event.newPassword,
        );
        print(
            'AuthBloc: Password reset successful, emitting ResetPasswordSuccess state');
        emit(ResetPasswordSuccess(message: response['message']));
      } catch (e) {
        print('AuthBloc: Password reset failed with error: $e');
        emit(ResetPasswordFailure(error: e.toString()));
      }
    });
  }
}
