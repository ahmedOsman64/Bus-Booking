import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class AppSelect<T> extends StatelessWidget {
  final String label;
  final String? hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final IconData? prefixIcon;
  final String? Function(T?)? validator;
  final bool enabled;

  const AppSelect({
    super.key,
    required this.label,
    this.hintText,
    this.value,
    required this.items,
    this.onChanged,
    this.prefixIcon,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label.copyWith(
          color: enabled ? AppColors.darkNavy : AppColors.textGray,
        )),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: enabled ? onChanged : null,
          validator: validator,
          style: AppTextStyles.bodyRegular.copyWith(
            color: enabled ? AppColors.darkNavy : AppColors.textGray,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded, 
            color: enabled ? AppColors.textGray : AppColors.textGray.withValues(alpha: 0.5)
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.bodySmall,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: enabled ? AppColors.textGray : AppColors.textGray.withValues(alpha: 0.5), size: 20)
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: !enabled,
            fillColor: enabled ? null : AppColors.lightGray,
          ),
        ),
      ],
    );
  }
}
