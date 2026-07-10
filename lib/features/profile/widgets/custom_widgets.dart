import 'package:flutter/material.dart';
import 'package:tabibi/core/constance/app_colors.dart';

class CustomCard extends StatelessWidget {
  final List<Widget> children;

  const CustomCard({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class CustomInputField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final IconData prefixIcon;
  final bool readOnly;
  final bool obscureText;
  final Widget? suffixIcon;

  const CustomInputField({
    Key? key,
    required this.label,
    required this.controller,
    required this.prefixIcon,
    this.hintText,
    this.readOnly = false,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          obscureText: obscureText,
          style: TextStyle(color: readOnly ? AppColors.gray : Colors.black87),
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: readOnly
                ? AppColors.lightGray.withOpacity(0.5)
                : AppColors.lightGray,
            prefixIcon: Icon(
              prefixIcon,
              color: AppColors.primaryBlue,
              size: 20,
            ),
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primaryBlue),
            ),
          ),
        ),
      ],
    );
  }
}
