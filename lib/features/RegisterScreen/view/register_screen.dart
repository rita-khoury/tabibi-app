// import 'package:country_picker/country_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tabibi/core/constance/app_colors.dart';
// import '../controller/register_controller.dart';
//
// class RegisterScreen extends StatelessWidget {
//   const RegisterScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final RegisterController controller = Get.put(RegisterController());
//
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [AppColors.primaryBlue, AppColors.lightBlue],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Column(
//           children: [
//             SafeArea(
//               child: Align(
//                 alignment: Alignment.topLeft,
//                 child: IconButton(
//                   icon: const Icon(
//                     Icons.arrow_back_ios_new,
//                     color: AppColors.white,
//                   ),
//                   onPressed: () => Get.back(),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 20),
//                     Material(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(28),
//                       child: Padding(
//                         padding: const EdgeInsets.all(24),
//                         child: Column(
//                           children: [
//                             const Text(
//                               "Create Account",
//                               style: TextStyle(
//                                 color: AppColors.primaryBlue,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20,
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//
//                             _buildField(
//                               "First Name",
//                               "Ahmed",
//                               Icons.person,
//                               onChanged: (v) => controller.firstName.value = v,
//                             ),
//                             _buildField(
//                               "Father Name",
//                               "Ali",
//                               Icons.person,
//                               onChanged: (v) => controller.fatherName.value = v,
//                             ),
//                             _buildField(
//                               "Last Name",
//                               "Mohammed",
//                               Icons.person,
//                               onChanged: (v) => controller.lastName.value = v,
//                             ),
//                             _buildField(
//                               "Email or Phone",
//                               "example@email.com",
//                               Icons.email,
//                               onChanged: (v) =>
//                                   controller.emailOrPhone.value = v,
//                             ),
//                             _buildField(
//                               "Password",
//                               "••••••••",
//                               Icons.lock,
//                               isPass: true,
//                               onChanged: (v) => controller.setPassword(v),
//                             ),
//                             _buildField(
//                               "Address",
//                               "Your address",
//                               Icons.location_on,
//                               onChanged: (v) => controller.address.value = v,
//                             ),
//
//                             Obx(
//                               () => _buildField(
//                                 "Date of Birth",
//                                 controller.birthDate.value.isEmpty
//                                     ? "YYYY-MM-DD"
//                                     : controller.birthDate.value,
//                                 Icons.calendar_today,
//                                 readOnly: true,
//                                 onTap: () async {
//                                   DateTime? picked = await showDatePicker(
//                                     context: context,
//                                     initialDate: DateTime(2000),
//                                     firstDate: DateTime(1900),
//                                     lastDate: DateTime.now(),
//                                   );
//                                   if (picked != null) {
//                                     String formatted =
//                                         "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
//                                     controller.setBirthDate(formatted);
//                                   }
//                                 },
//                               ),
//                             ),
//
//                             const Align(
//                               alignment: Alignment.centerLeft,
//                               child: Text(
//                                 "Gender",
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             Obx(
//                               () => Row(
//                                 children: [
//                                   Expanded(
//                                     child: RadioListTile<String>(
//                                       title: const Text("Male"),
//                                       value: "Male",
//                                       groupValue: controller.gender.value,
//                                       onChanged: (v) =>
//                                           controller.setGender(v!),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: RadioListTile<String>(
//                                       title: const Text("Female"),
//                                       value: "Female",
//                                       groupValue: controller.gender.value,
//                                       onChanged: (v) =>
//                                           controller.setGender(v!),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//
//                             _buildCountryPicker(controller),
//                             const SizedBox(height: 20),
//
//                             Obx(
//                               () => SizedBox(
//                                 width: double.infinity,
//                                 height: 55,
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: AppColors.primaryBlue,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(16),
//                                     ),
//                                   ),
//                                   onPressed: controller.isLoading.value
//                                       ? null
//                                       : () => controller.register(),
//                                   child: controller.isLoading.value
//                                       ? const CircularProgressIndicator(
//                                           color: Colors.white,
//                                         )
//                                       : const Text(
//                                           "Create Account",
//                                           style: TextStyle(
//                                             fontSize: 18,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCountryPicker(RegisterController controller) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Material(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(16),
//         child: Obx(() {
//           final country = controller.selectedCountry.value;
//           return ListTile(
//             title: Text(
//               country == null
//                   ? "Select Country"
//                   : "${country.flagEmoji} ${country.name}",
//             ),
//             leading: const Icon(Icons.public, color: Colors.blue),
//             trailing: const Icon(Icons.arrow_drop_down),
//             onTap: () => showCountryPicker(
//               context: Get.context!,
//               onSelect: (c) => controller.setCountry(c),
//             ),
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget _buildField(
//     String label,
//     String hint,
//     IconData icon, {
//     bool isPass = false,
//     bool readOnly = false,
//     VoidCallback? onTap,
//     Function(String)? onChanged,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextFormField(
//         obscureText: isPass,
//         readOnly: readOnly,
//         onTap: onTap,
//         onChanged: onChanged,
//         decoration: InputDecoration(
//           labelText: label,
//           hintText: hint,
//           prefixIcon: Icon(icon, color: Colors.blue),
//           filled: true,
//           fillColor: Colors.grey.shade100,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import '../controller/register_controller.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterController controller = Get.put(RegisterController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
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
                    Icons.arrow_back_ios_new,
                    color: AppColors.white,
                  ),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            const Text(
                              "Create Account",
                              style: TextStyle(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // --- جزء اختيار الصورة الشخصية (Avatar Picker) ---
                            Center(
                              child: Stack(
                                children: [
                                  Obx(() {
                                    final file = controller.selectedAvatarFile.value;
                                    return CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.grey.shade200,
                                      backgroundImage: file != null ? FileImage(file) : null,
                                      child: file == null
                                          ? const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: AppColors.primaryBlue,
                                      )
                                          : null,
                                    );
                                  }),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () => _showImagePickerBottomSheet(context, controller),
                                      child: const CircleAvatar(
                                        radius: 18,
                                        backgroundColor: AppColors.primaryBlue,
                                        child: Icon(
                                          Icons.camera_alt,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // ----------------------------------------------

                            _buildField(
                              "First Name",
                              "Ahmed",
                              Icons.person,
                              onChanged: (v) => controller.firstName.value = v,
                            ),
                            _buildField(
                              "Father Name",
                              "Ali",
                              Icons.person,
                              onChanged: (v) => controller.fatherName.value = v,
                            ),
                            _buildField(
                              "Last Name",
                              "Mohammed",
                              Icons.person,
                              onChanged: (v) => controller.lastName.value = v,
                            ),
                            _buildField(
                              "Email or Phone",
                              "example@email.com",
                              Icons.email,
                              onChanged: (v) =>
                              controller.emailOrPhone.value = v,
                            ),
                            _buildField(
                              "Password",
                              "••••••••",
                              Icons.lock,
                              isPass: true,
                              onChanged: (v) => controller.setPassword(v),
                            ),
                            _buildField(
                              "Address",
                              "Your address",
                              Icons.location_on,
                              onChanged: (v) => controller.address.value = v,
                            ),

                            Obx(
                                  () => _buildField(
                                "Date of Birth",
                                controller.birthDate.value.isEmpty
                                    ? "YYYY-MM-DD"
                                    : controller.birthDate.value,
                                Icons.calendar_today,
                                readOnly: true,
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime(2000),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) {
                                    String formatted =
                                        "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                                    controller.setBirthDate(formatted);
                                  }
                                },
                              ),
                            ),

                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Gender",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Obx(
                                  () => Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: const Text(
                                        "Male",
                                        style: TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      value: "male",
                                      groupValue: controller.gender.value,
                                      activeColor: AppColors.primaryBlue,
                                      contentPadding: EdgeInsets.zero,
                                      onChanged: (v) =>
                                          controller.setGender(v!),
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: const Text(
                                        "Female",
                                        style: TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      value: "female",
                                      groupValue: controller.gender.value,
                                      activeColor: AppColors.primaryBlue,
                                      contentPadding: EdgeInsets.zero,
                                      onChanged: (v) =>
                                          controller.setGender(v!),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            _buildCountryPicker(controller),
                            const SizedBox(height: 20),

                            Obx(
                                  () => SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : () => controller.register(),
                                  child: controller.isLoading.value
                                      ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                      : const Text(
                                    "Create Account",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
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
          ],
        ),
      ),
    );
  }

  // دالة إظهار قائمة اختيار الصورة (كاميرا أو معرض) بتصميم متناسق مع الثيم
  void _showImagePickerBottomSheet(BuildContext context, RegisterController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primaryBlue),
                title: const Text(
                  "Gallery",
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickAvatar(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera, color: AppColors.primaryBlue),
                title: const Text(
                  "Camera",
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickAvatar(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountryPicker(RegisterController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        child: Obx(() {
          final country = controller.selectedCountry.value;
          return ListTile(
            title: Text(
              country == null
                  ? "Select Country"
                  : "${country.flagEmoji} ${country.name}",
            ),
            leading: const Icon(Icons.public, color: AppColors.primaryBlue),
            trailing: const Icon(Icons.arrow_drop_down, color: AppColors.primaryBlue),
            onTap: () => showCountryPicker(
              context: Get.context!,
              onSelect: (c) => controller.setCountry(c),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildField(
      String label,
      String hint,
      IconData icon, {
        bool isPass = false,
        bool readOnly = false,
        VoidCallback? onTap,
        Function(String)? onChanged,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        obscureText: isPass,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.primaryBlue),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}