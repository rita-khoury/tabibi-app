import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import '../controller/register_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterController controller = Get.put(RegisterController());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final countryCodeController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    countryCodeController.dispose();
    phoneController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Column(
          children: [
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.white,
                    size: 28,
                  ),
                  onPressed: () => Get.back(),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: AppColors.primaryBlue,
                          size: 45,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Create Account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 24),

                          _buildInputField(
                            emailController,
                            'email',
                            'example@email.com',
                            Icons.email_outlined,
                            onChanged: controller.setEmail,
                          ),

                          const SizedBox(height: 16),

                          _buildInputField(
                            passwordController,
                            'password',
                            '••••••••',
                            Icons.lock_outline,
                            isPass: true,
                            onChanged: controller.setPassword,
                          ),

                          const SizedBox(height: 16),

                          _buildInputField(
                            nameController,
                            'name',
                            'Your full name',
                            Icons.person_outline,
                            onChanged: controller.setName,
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: _buildInputField(
                                  countryCodeController,
                                  'code',
                                  '+961',
                                  Icons.public_rounded,
                                  onChanged: controller.setCountryCode,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 7,
                                child: _buildInputField(
                                  phoneController,
                                  'phone number',
                                  '70 123 456',
                                  Icons.phone_android_rounded,
                                  onChanged: controller.setPhone,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          _buildInputField(
                            ageController,
                            'age',
                            'e.g. 22',
                            Icons.add,
                            onChanged: controller.setAge,
                          ),

                          const SizedBox(height: 24),

                          GestureDetector(
                            onTap: controller.register,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: AppColors.primaryBlue,
                              ),
                              child: const Center(
                                child: Text(
                                  'Create',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
      TextEditingController controller,
      String label,
      String hint,
      IconData icon, {
        bool isPass = false,
        Function(String)? onChanged,
      }) {
    return TextField(
      controller: controller,
      obscureText: isPass,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primaryBlue),
        filled: true,
        fillColor: AppColors.lightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}