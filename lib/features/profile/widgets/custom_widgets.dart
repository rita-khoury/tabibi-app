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
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
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
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          obscureText: obscureText,
          style: TextStyle(
            color: readOnly
                ? Theme.of(context).colorScheme.onSurfaceVariant
                : Theme.of(context).colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: readOnly
                ? Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
                : Theme.of(context).colorScheme.surfaceContainerHighest,
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
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
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
