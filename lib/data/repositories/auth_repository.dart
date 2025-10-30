import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepository {
  final AuthRemoteDataSource _dataSource;
  final FlutterSecureStorage _storage;

  AuthRepository({
    required AuthRemoteDataSource dataSource,
    required FlutterSecureStorage storage,
  })  : _dataSource = dataSource,
        _storage = storage;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dataSource.login(email, password);
    final token = response['token'] as String?;
    final userEmail = (response['user'] is Map && response['user']['email'] is String)
        ? response['user']['email'] as String
        : email;
    await _storage.write(key: 'auth_token', value: token);
    await _storage.write(key: 'user_email', value: userEmail);
    return {
      ...response,
      'token': token ?? '',
      'user': {
        ...(response['user'] as Map<String, dynamic>? ?? {}),
        'email': userEmail,
      },
    };
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _dataSource.register(
        name: name, email: email, password: password);

    String? token = response['token'] as String?;
    if (token == null || token.isEmpty) {
      // Some backends don't return a token on register; try to login immediately.
      try {
        final loginResponse = await _dataSource.login(email, password);
        token = loginResponse['token'] as String?;
        if (token != null && token.isNotEmpty) {
          // Merge user info preferring register response user
          final mergedUser = {
            ...(loginResponse['user'] as Map<String, dynamic>? ?? {}),
            ...(response['user'] as Map<String, dynamic>? ?? {}),
          };
          await _storage.write(key: 'auth_token', value: token);
          await _storage.write(
              key: 'user_email',
              value: (mergedUser['email'] as String?) ?? email);
          return {
            ...loginResponse,
            'token': token ?? '',
            'user': {
              ...mergedUser,
              'email': (mergedUser['email'] as String?) ?? email,
            },
          };
        }
      } catch (_) {
        // fall through to surface the absence of token
      }
    }

    final userEmail = (response['user'] is Map && response['user']['email'] is String)
        ? response['user']['email'] as String
        : email;
    await _storage.write(key: 'auth_token', value: token);
    await _storage.write(key: 'user_email', value: userEmail);
    return {
      ...response,
      'token': token ?? '',
      'user': {
        ...(response['user'] as Map<String, dynamic>? ?? {}),
        'email': userEmail,
      },
    };
  }

  Future<void> logout() async {
    final token = await _storage.read(key: 'auth_token');
    if (token != null) {
      await _dataSource.logout(token);
    }
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_email');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: 'user_email');
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await _dataSource.forgotPassword(email);
    return response;
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    final response = await _dataSource.verifyOtp(email, otp);
    // Store the reset token temporarily for password reset
    if (response['token'] != null) {
      await _storage.write(key: 'reset_token', value: response['token']);
    }
    return response;
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final response = await _dataSource.resetPassword(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );
    // Clear the reset token after successful password reset
    await _storage.delete(key: 'reset_token');
    return response;
  }

  Future<String?> getResetToken() async {
    return await _storage.read(key: 'reset_token');
  }
}
