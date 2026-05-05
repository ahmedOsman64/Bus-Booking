import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class LanguageSelectorScreen extends StatefulWidget {
  const LanguageSelectorScreen({super.key});

  @override
  State<LanguageSelectorScreen> createState() => _LanguageSelectorScreenState();
}

class _LanguageSelectorScreenState extends State<LanguageSelectorScreen> {
  String _selectedLanguage = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text('Change Language'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select your preferred language', style: AppTextStyles.bodyLarge),
            const SizedBox(height: 24),
            _buildLanguageItem('English', 'en', '🇺🇸'),
            const SizedBox(height: 12),
            _buildLanguageItem('Soomaali', 'so', '🇸🇴'),
            const Spacer(),
            // In a real app, this would trigger a locale change via a provider
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageItem(String name, String code, String flag) {
    final isSelected = _selectedLanguage == code;
    return InkWell(
      onTap: () {
        setState(() => _selectedLanguage = code);
        // Implement actual language change logic here
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          Navigator.pop(context);
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.lightMint : AppColors.borderGray,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            Text(name, style: AppTextStyles.bodyLarge.copyWith(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.lightMint),
          ],
        ),
      ),
    );
  }
}
