import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crop_cure/core/config.dart';

class AuthRemoteDataSource {
  // Base URL comes from AppConfig (via --dart-define)
  final String _baseUrl = AppConfig.baseUrl;

  Uri _buildUri(String path) {
    final trimmedBase = _baseUrl.endsWith('/')
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    final trimmedPath = path.startsWith('/') ? path.substring(1) : path;
    return Uri.parse('$trimmedBase/$trimmedPath');
  }

  Map<String, String> _headers([Map<String, String>? extra]) =>
      AppConfig.defaultHeaders(extra: {
        'Accept': 'application/json',
        if (extra != null) ...extra,
      });

  Future<Map<String, dynamic>> login(String email, String password) async {
    final uri = _buildUri(AppConfig.loginPath);
    // Build payload using configurable fields and include common fallbacks
    final body = <String, dynamic>{
      AppConfig.loginEmailField: email,
      AppConfig.loginPasswordField: password,
    };
    // Identifier fallbacks
    if (AppConfig.loginEmailField != 'username') body['username'] = email;
    if (AppConfig.loginEmailField != 'email') body['email'] = email;
    // Password fallback
    if (AppConfig.loginPasswordField != 'password') body['password'] = password;
    try {
      AppConfig.debugLog('POST $uri');
      AppConfig.debugLog('Headers: ' +
          _headers()
              .map((k, v) =>
                  MapEntry(k, k.toLowerCase() == 'authorization' ? '***' : v))
              .toString());
      AppConfig.debugLog('Body keys: ${body.keys.toList()}');

      final response = await http.post(
        uri,
        headers: _headers(),
        body: jsonEncode(body),
      );
      AppConfig.debugLog(
          'Response: ${response.statusCode} ${response.headers['content-type']}');
      if (AppConfig.debugNetwork) {
        final preview = response.body.length > 500
            ? response.body.substring(0, 500) + '…'
            : response.body;
        // ignore: avoid_print
        print('[NET] Body preview: $preview');
      }

      final isJson =
          response.headers['content-type']?.contains('application/json') ??
              false;
      if (response.statusCode == 200 && isJson) {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'token': _extractToken(responseBody),
          'user': _extractUser(responseBody) ?? {'email': email},
        };
      } else {
        if (!isJson) {
          throw Exception(
              'Unexpected non-JSON response from server (status ${response.statusCode}).');
        }
        final errorBody = _safeDecode(response.body);
        throw Exception(errorBody['message'] ??
            'Login failed (status ${response.statusCode}).');
      }
    } catch (e) {
      // For development, return mock data if API is not available
      if (email == 'test@test.com' && password == 'password') {
        return {
          'token': 'mock_token_12345',
          'user': {'email': email, 'name': 'Test User'},
        };
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final uri = _buildUri(AppConfig.registerPath);
    try {
      AppConfig.debugLog('POST $uri');
      // Build payload using configurable field names and add a compatibility
      // 'username' mirror if backend expects it.
      final payload = <String, dynamic>{
        AppConfig.registerNameField: name,
        AppConfig.registerEmailField: email,
        AppConfig.registerPasswordField: password,
      };
      // Identifier fallbacks
      if (AppConfig.registerEmailField != 'username') {
        payload['username'] = email;
      }
      if (AppConfig.registerEmailField != 'email') {
        payload['email'] = email;
      }
      // Password fallback
      if (AppConfig.registerPasswordField != 'password') {
        payload['password'] = password;
      }

      final response = await http.post(
        uri,
        headers: _headers(),
        body: jsonEncode(payload),
      );

      final isJson =
          response.headers['content-type']?.contains('application/json') ??
              false;
      if ((response.statusCode == 201 || response.statusCode == 200) &&
          isJson) {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'token': _extractToken(responseBody),
          'user': _extractUser(responseBody) ?? {'email': email, 'name': name},
        };
      } else {
        if (!isJson) {
          throw Exception(
              'Unexpected non-JSON response from server (status ${response.statusCode}).');
        }
        final errorBody = _safeDecode(response.body);
        throw Exception(errorBody['message'] ??
            'Registration failed (status ${response.statusCode}).');
      }
    } catch (e) {
      // Only allow mock registration for explicit test accounts; otherwise surface the error
      if (email == 'test@test.com' || email == 'demo@example.com') {
        return {
          'token': 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
          'user': {'email': email, 'name': name},
        };
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<void> logout(String token) async {
    final uri = _buildUri(AppConfig.logoutPath);
    try {
      AppConfig.debugLog('POST $uri');
      await http.post(
        uri,
        headers: _headers({'Authorization': 'Bearer $token'}),
      );
    } catch (e) {
      // Logout should not fail even if API call fails
      // The token will be removed from local storage regardless
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final uri = _buildUri(AppConfig.forgotPasswordPath);
    // Use the configured login identifier field name and include
    // compatibility mirrors for common alternatives.
    final body = <String, String>{
      AppConfig.loginEmailField: email,
    };
    if (AppConfig.loginEmailField != 'username') body['username'] = email;
    if (AppConfig.loginEmailField != 'email') body['email'] = email;

    try {
      AppConfig.debugLog('POST $uri');
      AppConfig.debugLog('Headers: ' +
          _headers()
              .map((k, v) =>
                  MapEntry(k, k.toLowerCase() == 'authorization' ? '***' : v))
              .toString());
      AppConfig.debugLog('Body: $body');

      final response = await http.post(
        uri,
        headers: _headers(),
        body: jsonEncode(body),
      );

      AppConfig.debugLog(
          'Response: ${response.statusCode} ${response.headers['content-type']}');
      if (AppConfig.debugNetwork) {
        final preview = response.body.length > 500
            ? response.body.substring(0, 500) + '…'
            : response.body;
        // ignore: avoid_print
        print('[NET] Body preview: $preview');
      }

      final isJson =
          response.headers['content-type']?.contains('application/json') ??
              false;

      if (response.statusCode == 200 && isJson) {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'message': responseBody['message'] ?? 'OTP sent successfully',
          'success': true,
        };
      } else {
        if (!isJson) {
          throw Exception(
              'Unexpected non-JSON response from server (status ${response.statusCode}).');
        }
        final errorBody = _safeDecode(response.body);
        // Enhanced error message with more details
        final errorMessage = errorBody['message'] ??
            errorBody['error'] ??
            'Failed to send OTP (status ${response.statusCode})';
        AppConfig.debugLog('Error response body: ${response.body}');
        throw Exception(errorMessage);
      }
    } catch (e) {
      // For development, return mock success if API is not available
      if (email == 'test@test.com' || email == 'demo@example.com') {
        return {
          'message': 'OTP sent successfully to $email',
          'success': true,
        };
      }
      AppConfig.debugLog('Forgot password error: ${e.toString()}');
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    final uri = _buildUri(AppConfig.verifyOtpPath);
    // Use the configured login identifier field name and include
    // compatibility mirrors for common alternatives.
    final body = <String, String>{
      AppConfig.loginEmailField: email,
      'otp': otp,
    };
    if (AppConfig.loginEmailField != 'username') body['username'] = email;
    if (AppConfig.loginEmailField != 'email') body['email'] = email;

    try {
      AppConfig.debugLog('POST $uri');
      AppConfig.debugLog('Headers: ' +
          _headers()
              .map((k, v) =>
                  MapEntry(k, k.toLowerCase() == 'authorization' ? '***' : v))
              .toString());
      AppConfig.debugLog('Body: $body');

      final response = await http.post(
        uri,
        headers: _headers(),
        body: jsonEncode(body),
      );

      AppConfig.debugLog(
          'Response: ${response.statusCode} ${response.headers['content-type']}');
      if (AppConfig.debugNetwork) {
        final preview = response.body.length > 500
            ? response.body.substring(0, 500) + '…'
            : response.body;
        // ignore: avoid_print
        print('[NET] Body preview: $preview');
      }

      final isJson =
          response.headers['content-type']?.contains('application/json') ??
              false;

      if (response.statusCode == 200 && isJson) {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'message': responseBody['message'] ?? 'OTP verified successfully',
          'success': true,
          'token': _extractToken(responseBody),
        };
      } else {
        if (!isJson) {
          throw Exception(
              'Unexpected non-JSON response from server (status ${response.statusCode}).');
        }
        final errorBody = _safeDecode(response.body);
        throw Exception(errorBody['message'] ??
            'OTP verification failed (status ${response.statusCode}).');
      }
    } catch (e) {
      // For development, return mock success if API is not available
      if ((email == 'test@test.com' || email == 'demo@example.com') &&
          otp == '123456') {
        return {
          'message': 'OTP verified successfully',
          'success': true,
          'token': 'mock_reset_token_${DateTime.now().millisecondsSinceEpoch}',
        };
      }
      AppConfig.debugLog('Verify OTP error: ${e.toString()}');
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final uri = _buildUri(AppConfig.resetPasswordPath);
    // Use the configured login identifier field name and include
    // compatibility mirrors for common alternatives
    final body = <String, String>{
      AppConfig.loginEmailField: email,
      'otp': otp,
      // Primary key used by many backends
      'password': newPassword,
      // Fallback keys commonly used by other backends
      'new_password': newPassword,
      'newPassword': newPassword,
    };
    if (AppConfig.loginEmailField != 'username') body['username'] = email;
    if (AppConfig.loginEmailField != 'email') body['email'] = email;

    try {
      AppConfig.debugLog('POST $uri');
      AppConfig.debugLog('Headers: ' +
          _headers()
              .map((k, v) =>
                  MapEntry(k, k.toLowerCase() == 'authorization' ? '***' : v))
              .toString());
      AppConfig.debugLog('Body keys: ${body.keys.toList()}');

      final response = await http.post(
        uri,
        headers: _headers(),
        body: jsonEncode(body),
      );

      AppConfig.debugLog(
          'Response: ${response.statusCode} ${response.headers['content-type']}');
      if (AppConfig.debugNetwork) {
        final preview = response.body.length > 500
            ? response.body.substring(0, 500) + '…'
            : response.body;
        // ignore: avoid_print
        print('[NET] Body preview: $preview');
      }

      final isJson =
          response.headers['content-type']?.contains('application/json') ??
              false;

      if (response.statusCode == 200 && isJson) {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'message': responseBody['message'] ?? 'Password reset successfully',
          'success': true,
        };
      } else {
        if (!isJson) {
          throw Exception(
              'Unexpected non-JSON response from server (status ${response.statusCode}).');
        }
        final errorBody = _safeDecode(response.body);
        throw Exception(errorBody['message'] ??
            'Password reset failed (status ${response.statusCode}).');
      }
    } catch (e) {
      // For development, return mock success if API is not available
      if ((email == 'test@test.com' || email == 'demo@example.com') &&
          otp == '123456') {
        return {
          'message': 'Password reset successfully',
          'success': true,
        };
      }
      AppConfig.debugLog('Reset password error: ${e.toString()}');
      throw Exception('Network error: ${e.toString()}');
    }
  }

  String? _extractToken(Map<String, dynamic> body) {
    final token = body['token'] ?? body['access_token'];
    if (token is String) return token;
    final data = body['data'];
    if (data is Map<String, dynamic>) {
      final t = data['token'] ?? data['access_token'];
      if (t is String) return t;
    }
    return null;
  }

  Map<String, dynamic>? _extractUser(Map<String, dynamic> body) {
    if (body['user'] is Map<String, dynamic>)
      return body['user'] as Map<String, dynamic>;
    if (body['data'] is Map<String, dynamic>) {
      final data = body['data'] as Map<String, dynamic>;
      if (data['user'] is Map<String, dynamic>)
        return data['user'] as Map<String, dynamic>;
    }
    return null;
  }

  Map<String, dynamic> _safeDecode(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return {};
  }
}
