import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';


class HelpSupportController extends GetxController {

  // رقمك مخفي هون (ما بيظهر UI)
  final String _phoneNumber = "963999244738";

  void openWhatsApp() async {
    final url = Uri.parse(
      "https://wa.me/$_phoneNumber?text=Hello, I need help with the app"
    );

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  void reportProblem() {
    Get.snackbar(
      "Report",
      "Feature will be connected to backend soon",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openPrivacyPolicy() {
    Get.dialog(
      const AlertDialog(
        title: Text("Privacy Policy"),
        content: Text(
          "We respect your privacy. All medical data is securely stored and not shared without consent.",
        ),
      ),
    );
  }

  void openAboutApp() {
    Get.dialog(
      const AlertDialog(
        title: Text("About App"),
        content: Text(
          "Tabibi is a medical app that helps patients manage records and connect with doctors.",
        ),
      ),
    );
  }
}