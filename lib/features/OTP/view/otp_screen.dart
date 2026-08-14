// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pinput/pinput.dart';
// import 'package:tabibi/core/constance/app_colors.dart';
// import '../controller/otp_controller.dart';
//
// class OtpScreen extends StatelessWidget {
//   const OtpScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final OtpController controller = Get.put(OtpController());
//
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [AppColors.primaryBlue, AppColors.lightBlue],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               const SizedBox(height: 50),
//               const Text(
//                 "Verification",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Expanded(
//                 child: Container(
//                   padding: const EdgeInsets.all(24),
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(30),
//                     ),
//                   ),
//                   child: ListView(
//                     physics: const BouncingScrollPhysics(),
//                     children: [
//                       const Text(
//                         "Please enter the verification code sent to your device",
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 30),
//                       Pinput(
//                         length: 6,
//                         onChanged: (v) => controller.setOtp(v),
//                         defaultPinTheme: PinTheme(
//                           width: 50,
//                           height: 55,
//                           textStyle: const TextStyle(
//                             fontSize: 20,
//                             color: AppColors.primaryBlue,
//                           ),
//                           decoration: BoxDecoration(
//                             color: AppColors.lightGray,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 40),
//                       Obx(
//                         () => SizedBox(
//                           width: double.infinity,
//                           height: 55,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.primaryBlue,
//                             ),
//                             onPressed: controller.isLoading.value
//                                 ? null
//                                 : () => controller.verifyOtp(),
//                             child: controller.isLoading.value
//                                 ? const CircularProgressIndicator(
//                                     color: Colors.white,
//                                   )
//                                 : const Text(
//                                     "Verify Now",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 18,
//                                     ),
//                                   ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       TextButton(
//                         onPressed: () => Get.snackbar(
//                           "Notification",
//                           "Code resent successfully",
//                         ),
//                         child: const Text(
//                           "Didn't receive the code? Resend",
//                           style: TextStyle(color: AppColors.primaryBlue),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pinput/pinput.dart';
// import 'package:tabibi/core/constance/app_colors.dart';
// import '../controller/otp_controller.dart';
//
// class OtpScreen extends StatelessWidget {
//   const OtpScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final OtpController controller = Get.put(OtpController());
//
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [AppColors.primaryBlue, AppColors.lightBlue],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // زر السهم للرجوع للخلف في أعلى الصفحة
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: IconButton(
//                   icon: const Icon(
//                     Icons.arrow_back_ios_new,
//                     color: Colors.white,
//                     size: 22,
//                   ),
//                   onPressed: () => Get.back(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Center(
//                 child: Text(
//                   "Verification",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Expanded(
//                 child: Container(
//                   padding: const EdgeInsets.all(24),
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(30),
//                     ),
//                   ),
//                   child: ListView(
//                     physics: const BouncingScrollPhysics(),
//                     children: [
//                       const Text(
//                         "Please enter the verification code sent to your device",
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 30),
//                       Pinput(
//                         length: 6,
//                         onChanged: (v) => controller.setOtp(v),
//                         defaultPinTheme: PinTheme(
//                           width: 50,
//                           height: 55,
//                           textStyle: const TextStyle(
//                             fontSize: 20,
//                             color: AppColors.primaryBlue,
//                           ),
//                           decoration: BoxDecoration(
//                             color: AppColors.lightGray,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 40),
//                       Obx(
//                             () => SizedBox(
//                           width: double.infinity,
//                           height: 55,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.primaryBlue,
//                             ),
//                             onPressed: controller.isLoading.value
//                                 ? null
//                                 : () => controller.verifyOtp(),
//                             child: controller.isLoading.value
//                                 ? const CircularProgressIndicator(
//                               color: Colors.white,
//                             )
//                                 : const Text(
//                               "Verify Now",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       TextButton(
//                         onPressed: () => Get.snackbar(
//                           "Notification",
//                           "Code resent successfully",
//                         ),
//                         child: const Text(
//                           "Didn't receive the code? Resend",
//                           style: TextStyle(color: AppColors.primaryBlue),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import '../controller/otp_controller.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OtpController controller = Get.put(OtpController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryBlue, AppColors.lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // زر السهم للرجوع للخلف في أعلى الصفحة
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () => Get.back(),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Verification",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      const Text(
                        "Please enter the verification code sent to your device",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      Pinput(
                        length: 6,
                        onChanged: (v) => controller.setOtp(v),
                        defaultPinTheme: PinTheme(
                          width: 50,
                          height: 55,
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: AppColors.primaryBlue,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lightGray,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Obx(
                            () => SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                            ),
                            onPressed: controller.isLoading.value
                                ? null
                                : () => controller.verifyOtp(),
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                                : const Text(
                              "Verify Now",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(
                            () => TextButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () => controller.resendOtp(),
                          child: const Text(
                            "Didn't receive the code? Resend",
                            style: TextStyle(color: AppColors.primaryBlue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}