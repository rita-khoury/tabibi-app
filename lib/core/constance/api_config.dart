import 'package:flutter/foundation.dart';

class ApiConfig {
  const ApiConfig._();

  static const _override = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    final configured = _override.trim().replaceFirst(RegExp(r'/+$'), '');
    if (configured.isNotEmpty) return configured;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }
}
