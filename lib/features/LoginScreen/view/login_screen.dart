import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import '../../auth/repository/AuthController.dart';
import '../controller/login_controller.dart';
import '../../../features/RegisterScreen/view/register_screen.dart';
import 'package:tabibi/features/OTP/view/otp_screen.dart';
import 'package:tabibi/features/OTP/binding/otp_binding.dart';

class LoginScreen extends GetView<LoginController> {
  final AuthController authController = Get.put(
    AuthController(),
    permanent: true,
  );

  LoginScreen({super.key});
  Future<void> _showForgotPasswordDialog(BuildContext context) async {
    controller.forgotPasswordController.clear();
    final identifierController = controller.forgotPasswordController;

    await Get.dialog<void>(
      AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Forgot Password?'),
        content: TextField(
          controller: identifierController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email or Phone',
            hintText: 'Enter your email or phone number',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          Obx(
            () => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () async {
                      final identifier = identifierController.text.trim();
                      final isEmail = RegExp(
                        r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                      ).hasMatch(identifier);
                      final isPhone = RegExp(
                        r'^\+?[0-9]{7,15}$',
                      ).hasMatch(identifier);
                      if (!isEmail && !isPhone) {
                        Get.snackbar(
                          'Invalid identifier',
                          'Enter a valid email address or phone number.',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      final sent = await controller.handleForgotPassword(
                        identifier,
                      );
                      if (sent) {
                        if (Get.isDialogOpen == true) {
                          Get.back();
                        }
                        await Future<void>.delayed(Duration.zero);
                        Get.to(
                          () => const OtpScreen(),
                          binding: OtpBinding(),
                          arguments: {
                            'identifier': identifier,
                            'purpose': 'reset-password',
                          },
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Send Code',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryBlue, AppColors.lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),

                        _buildLogo(),

                        const SizedBox(height: 20),

                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(
                                    context,
                                  ).shadowColor.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextField(
                                  controller: controller.emailOrPhoneController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: _buildInputDecoration(
                                    'Email or Phone',
                                    Icons.person_outline,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                Obx(
                                  () => TextField(
                                    controller: controller.passwordController,
                                    obscureText:
                                        controller.isPasswordObscured.value,
                                    decoration:
                                        _buildInputDecoration(
                                          'Password',
                                          Icons.lock_outline,
                                        ).copyWith(
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              controller
                                                      .isPasswordObscured
                                                      .value
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                            ),
                                            onPressed:
                                                controller.togglePassword,
                                          ),
                                        ),
                                  ),
                                ),

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () =>
                                        _showForgotPasswordDialog(context),
                                    child: const Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                        color: AppColors.primaryBlue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Obx(
                                  () => ElevatedButton(
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : () => controller.login(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryBlue,
                                      minimumSize: const Size(
                                        double.infinity,
                                        55,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: controller.isLoading.value
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : const Text(
                                            'Login',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(color: Colors.white70),
                            ),
                            GestureDetector(
                              onTap: () => Get.to(() => RegisterScreen()),
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
              },
            ),
            SafeArea(
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Container(
        width: 130,
        height: 130,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ShaderMask(
          shaderCallback: (Rect rect) {
            return const RadialGradient(
              center: Alignment.center,
              radius: 0.5,
              colors: [Colors.black, Colors.transparent],
            ).createShader(rect);
          },
          blendMode: BlendMode.dstIn,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Image.asset('assets/images/logo2.png', fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primaryBlue),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
