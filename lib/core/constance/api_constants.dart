import 'package:flutter/foundation.dart';

class ApiConstants {
  const ApiConstants._();

  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:3000';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      // تم التغيير إلى 127.0.0.1 ليعمل مع adb reverse على الجوال الحقيقي
      // (إذا عدت لاستخدام المحاكي مستقبلاً قم بتغييرها إلى 10.0.2.2)
        return 'http://127.0.0.1:3000';
      case TargetPlatform.iOS:
        return 'http://127.0.0.1:3000';
      default:
        return 'http://localhost:3000';
    }
  }

  static String getFullImageUrl(String? path) {
    if (path == null || path.trim().isEmpty) return '';
    final trimmedPath = path.trim();
    if (trimmedPath.startsWith('http://') || trimmedPath.startsWith('https://')) {
      return trimmedPath;
    }
    final cleanBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    // تم تصحيح الدمج هنا لإضافة اسم المسار كاملاً
    final cleanPath = trimmedPath.startsWith('/')
        ? trimmedPath
        : '/$trimmedPath';
    return cleanBase + cleanPath;
  }
}