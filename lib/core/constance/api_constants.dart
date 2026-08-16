import 'package:flutter/foundation.dart';

class ApiConstants {
  const ApiConstants._();

  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:3000';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      // يعمل مع الجوال الحقيقي عند استخدام أمر adb reverse tcp:3000 tcp:3000
        return 'http://localhost:3000';
      case TargetPlatform.iOS:
        return 'http://127.0.0.1:3000';
      default:
        return 'http://localhost:3000';
    }
  }
}