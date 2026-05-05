import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class AppInput extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;

  const AppInput({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          enabled: enabled,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          style: AppTextStyles.bodyRegular,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.bodySmall,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.textGray, size: 20)
                : null,
            suffixIcon: suffixIcon,
            filled: !enabled,
            fillColor: !enabled ? AppColors.lightGray.withValues(alpha: 0.5) : null,
          ),
        ),
      ],
    );
  }
}
