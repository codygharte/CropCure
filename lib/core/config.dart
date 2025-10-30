import 'package:flutter/foundation.dart';

class AppConfig {
  // Base API URL, e.g. https://api.example.com
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://plant-disease.techsparkventures.in',
  );

  // Paths (override if your backend differs)
  static const String loginPath = String.fromEnvironment(
    'LOGIN_PATH',
    defaultValue: '/auth/login',
  );
  static const String registerPath = String.fromEnvironment(
    'REGISTER_PATH',
    defaultValue: '/auth/register',
  );
  static const String logoutPath = String.fromEnvironment(
    'LOGOUT_PATH',
    defaultValue: '/auth/logout',
  );
  static const String forgotPasswordPath = String.fromEnvironment(
    'FORGOT_PASSWORD_PATH',
    defaultValue: '/auth/forgot-password',
  );
  static const String verifyOtpPath = String.fromEnvironment(
    'VERIFY_OTP_PATH',
    defaultValue: '/auth/verify-otp',
  );
  static const String resetPasswordPath = String.fromEnvironment(
    'RESET_PASSWORD_PATH',
    defaultValue: '/auth/set-password',
  );

  // Login field names (override if your backend expects 'username' or 'emailId')
  static const String loginEmailField = String.fromEnvironment(
    'LOGIN_EMAIL_FIELD',
    defaultValue: 'email',
  );
  static const String loginPasswordField = String.fromEnvironment(
    'LOGIN_PASSWORD_FIELD',
    defaultValue: 'password',
  );

  // Register field names (override to match your backend contract)
  static const String registerNameField = String.fromEnvironment(
    'REGISTER_NAME_FIELD',
    defaultValue: 'name',
  );
  static const String registerEmailField = String.fromEnvironment(
    'REGISTER_EMAIL_FIELD',
    defaultValue: 'email',
  );
  static const String registerPasswordField = String.fromEnvironment(
    'REGISTER_PASSWORD_FIELD',
    defaultValue: 'password',
  );

  // API key for server authentication (do not hardcode)
  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: '',
  );

  // Header to use for API key (commonly 'x-api-key')
  static const String apiKeyHeader = String.fromEnvironment(
    'API_KEY_HEADER',
    defaultValue: 'x-api-key',
  );

  // Optional verbose network debug (prints URL, status, sanitized headers)
  static const bool debugNetwork = bool.fromEnvironment(
    'DEBUG_NETWORK',
    defaultValue: true, // Enable debug logging to help troubleshoot
  );

  static Map<String, String> defaultHeaders({Map<String, String>? extra}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (apiKey.isNotEmpty) {
      headers[apiKeyHeader] = apiKey;
    }
    if (extra != null) {
      headers.addAll(extra);
    }
    return headers;
  }

  static void debugLog(String message) {
    if (kDebugMode && debugNetwork) {
      // ignore: avoid_print
      print('[NET] $message');
    }
  }
}
