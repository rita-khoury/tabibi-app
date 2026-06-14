import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tabibi/core/constance/app_colors.dart';
import '../controller/register_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterController controller = Get.put(RegisterController());

  final TextEditingController dateController = TextEditingController();

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  /// ✅ اختيار صورة من المعرض
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      controller.setImage(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryBlue,
              AppColors.lightBlue,
            ],
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
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    /// 🔥 PROFILE IMAGE
                    Obx(() {
                      return GestureDetector(
                        onTap: pickImage,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage:
                              controller.profileImage.value != null
                                  ? FileImage(
                                  controller.profileImage.value!)
                                  : null,
                              child:
                              controller.profileImage.value == null
                                  ? const Icon(Icons.person,
                                  size: 50, color: Colors.white)
                                  : null,
                            ),

                            /// camera icon
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),

                          _buildField(
                            "Email or Phone",
                            "example@email.com",
                            Icons.email,
                            onChanged: controller.setEmailOrPhone,
                          ),

                          const SizedBox(height: 12),

                          _buildField(
                            "Password",
                            "••••••••",
                            Icons.lock,
                            isPass: true,
                            onChanged: controller.setPassword,
                          ),

                          const SizedBox(height: 12),

                          _buildField(
                            "Full Name",
                            "Your name",
                            Icons.person,
                            onChanged: controller.setName,
                          ),

                          const SizedBox(height: 12),

                          _buildField(
                            "Date of Birth",
                            "YYYY-MM-DD",
                            Icons.calendar_today,
                            controller: dateController,
                            readOnly: true,
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime(2000),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );

                              if (picked != null) {
                                dateController.text =
                                "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";

                                controller.setBirthDate(dateController.text);
                              }
                            },
                          ),

                          const SizedBox(height: 12),

                          /// COUNTRY PICKER
                          Obx(() {
                            final country =
                                controller.selectedCountry.value;

                            return InkWell(
                              onTap: () {
                                showCountryPicker(
                                  context: context,
                                  showPhoneCode: false,
                                  countryListTheme: CountryListThemeData(
                                    backgroundColor: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    bottomSheetHeight: 600,
                                    inputDecoration: const InputDecoration(
                                      hintText: 'Search Country',
                                      prefixIcon: Icon(Icons.search),
                                    ),
                                  ),
                                  onSelect: (Country country) {
                                    controller.setCountry(country);
                                  },
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.public,
                                        color: Colors.blue),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        country == null
                                            ? "Select Country"
                                            : "${country.flagEmoji} ${country.name}",
                                        style: TextStyle(
                                          color: country == null
                                              ? Colors.grey
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            );
                          }),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                AppColors.primaryBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: controller.register,
                              child: const Text(
                                "Create Account",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
      String label,
      String hint,
      IconData icon, {
        bool isPass = false,
        TextEditingController? controller,
        bool readOnly = false,
        VoidCallback? onTap,
        Function(String)? onChanged,
      }) {
    return TextField(
      controller: controller,
      obscureText: isPass,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.blue),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}