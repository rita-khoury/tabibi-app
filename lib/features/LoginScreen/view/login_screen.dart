import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../RegisterScreen/view/register_screen.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import '../controller/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController controller = Get.put(LoginController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Header Container
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.40,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primaryBlue, AppColors.lightBlue],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: SafeArea(
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10)),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset('assets/images/logo2.png', height: 150, width: 150, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.08), blurRadius: 24, offset: const Offset(0, 12))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: emailController,
                              onChanged: controller.setEmailOrPhone,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _buildInputDecoration(label: 'Email or Phone', hint: 'example@email.com', icon: Icons.person_outline),
                            ),
                            const SizedBox(height: 16),
                            Obx(() => TextField(
                              controller: passwordController,
                              obscureText: controller.isPasswordObscured.value,
                              onChanged: controller.setPassword,
                              decoration: _buildInputDecoration(label: 'Password', hint: '••••••••', icon: Icons.lock_outline).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(controller.isPasswordObscured.value ? Icons.visibility_off : Icons.visibility),
                                  onPressed: controller.togglePassword,
                                ),
                              ),
                            )),
                            const SizedBox(height: 20),

                            // الزر المحدث مع حالة التحميل
                            Obx(() => SizedBox(
                              height: 55,
                              child: ElevatedButton(
                                onPressed: controller.isLoading.value ? null : controller.login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlue,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                child: controller.isLoading.value
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text('Login', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                            )),

                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.gray.withValues(alpha: 0.5))),
                              child: const Center(child: Text('Continue with Google')),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () => Get.to(() => RegisterScreen()),
                            child: const Text("Sign Up", style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white, size: 28), onPressed: () => Get.back()),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String label, required String hint, required IconData icon}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primaryBlue),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}