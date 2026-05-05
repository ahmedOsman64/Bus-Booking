import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_input.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Get in Touch', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text(
              'Have questions or feedback? We\'d love to hear from you.',
              style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textGray),
            ),
            const SizedBox(height: 32),
            _buildContactInfo(Icons.phone, 'Phone', '+252 61 1234567'),
            const SizedBox(height: 16),
            _buildContactInfo(Icons.email, 'Email', 'support@busbooking.so'),
            const SizedBox(height: 16),
            _buildContactInfo(Icons.location_on, 'Office', 'Mogadishu, Somalia'),
            const SizedBox(height: 40),
            Text('Send us a message', style: AppTextStyles.h3),
            const SizedBox(height: 24),
            const AppInput(
              label: 'Subject',
              hintText: 'What is your message about?',
              prefixIcon: Icons.subject,
            ),
            const SizedBox(height: 20),
            Text('Message', style: AppTextStyles.label),
            const SizedBox(height: 8),
            TextFormField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Type your message here...',
                hintStyle: AppTextStyles.bodySmall,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.borderGray),
                ),
              ),
            ),
            const SizedBox(height: 32),
            AppButton(
              text: 'Send Message',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message sent successfully!')),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.mediumGray.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.darkNavy, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              Text(value, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
