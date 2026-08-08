// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class HelpSupportController extends GetxController {
//   final String _phoneNumber = "963999244738";
//
//   void openWhatsApp() async {
//     final url = Uri.parse(
//       "https://wa.me/$_phoneNumber?text=Hello, I need help with the app",
//     );
//
//     await launchUrl(url, mode: LaunchMode.externalApplication);
//   }
//
//   void reportProblem() {
//     Get.snackbar(
//       "Report",
//       "Feature will be connected to backend soon",
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
//
//   void openPrivacyPolicy() {
//     Get.dialog(
//       const AlertDialog(
//         title: Text("Privacy Policy"),
//         content: Text(
//           "We respect your privacy. All medical data is securely stored and not shared without consent.",
//         ),
//       ),
//     );
//   }
//
//   void openAboutApp() {
//     Get.dialog(
//       const AlertDialog(
//         title: Text("About App"),
//         content: Text(
//           "Tabibi is a medical app that helps patients manage records and connect with doctors.",
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// استيراد ملفات الرسائل والتنبيهات المركزية
import '../../../core/constance/app_messages.dart';
import '../../../core/constance/app_alerts.dart';

class HelpSupportController extends GetxController {
  final String _phoneNumber = "963999244738";

  void openWhatsApp() async {
    final url = Uri.parse(
      "https://wa.me/$_phoneNumber?text=Hello, I need help with the app",
    );

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  void reportProblem() {
    AppAlerts.showNotice(
      title: AppMessages.reportTitle,
      message: AppMessages.reportFeatureComingSoon,
    );
  }

  void openPrivacyPolicy() {
    Get.dialog(
      const AlertDialog(
        title: Text(AppMessages.privacyPolicyTitle),
        content: Text(
          AppMessages.privacyPolicyContent,
        ),
      ),
    );
  }

  void openAboutApp() {
    Get.dialog(
      const AlertDialog(
        title: Text(AppMessages.aboutAppTitle),
        content: Text(
          AppMessages.aboutAppContent,
        ),
      ),
    );
  }
}