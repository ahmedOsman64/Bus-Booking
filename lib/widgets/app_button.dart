import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

enum AppButtonType { primary, secondary, danger, success, outline }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final AppButtonType type;
  final bool isLoading;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: _getDecoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: _getTextColor(), size: 20),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: AppTextStyles.buttonText.copyWith(
                          color: _getTextColor(),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _getDecoration() {
    switch (type) {
      case AppButtonType.primary:
        return BoxDecoration(
          gradient: AppColors.primaryButtonGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkNavy.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        );
      case AppButtonType.secondary:
        return BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderGray),
        );
      case AppButtonType.danger:
        return BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(12),
        );
      case AppButtonType.success:
        return BoxDecoration(
          color: AppColors.success,
          borderRadius: BorderRadius.circular(12),
        );
      case AppButtonType.outline:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.darkNavy, width: 1.5),
        );
    }
  }

  Color _getTextColor() {
    switch (type) {
      case AppButtonType.secondary:
      case AppButtonType.outline:
        return AppColors.darkNavy;
      default:
        return Colors.white;
    }
  }
}
