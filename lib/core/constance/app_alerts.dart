import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_messages.dart';

class AppAlerts {
  // تنبيه النجاح (متناسق مع أزرق التطبيق الأساسي)
  static void showSuccess({required String title, required String message}) =>
      _show(title, message, const Color(0xFF007BFF), Icons.check_circle_outline);

  // تنبيه الخطأ (أحمر ناعم ومتناسق)
  static void showError({required String title, required String message}) =>
      _show(title, message, const Color(0xFFE53935), Icons.error_outline);

  // تنبيه التحذير أو الملاحظات (أزرق داكن أو برتقالي هادئ يتماشى مع الثيم)
  static void showNotice({required String title, required String message}) =>
      _show(title, message, const Color(0xFF17A2B8), Icons.info_outline);

  static void _show(String title, String message, Color color, IconData icon) {
    Get.snackbar(
      title,
      message,
      backgroundColor: color,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: Icon(icon, color: Colors.white),
      duration: const Duration(seconds: 2), // ثانيتان بالضبط
      animationDuration: const Duration(milliseconds: 300), // حركة سريعة وخفيفة
    );
  }
}