import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text('Help Center'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Frequently Asked Questions', style: AppTextStyles.h2),
          const SizedBox(height: 24),
          _buildFaqItem(
            'How do I book a ticket?',
            'Search for your travel by selecting origin, destination, and date. Pick a travel, select your seat, and confirm your booking.',
          ),
          _buildFaqItem(
            'Can I cancel my ticket?',
            'Yes, you can cancel your ticket from the Ticket Detail screen before the bus departs.',
          ),
          _buildFaqItem(
            'How do I board the bus?',
            'Present your QR code located in the Ticket Detail screen to the driver before boarding.',
          ),
          _buildFaqItem(
            'What happens if the bus is canceled?',
            'You will receive a notification, and our team will contact you to reschedule or process a refund.',
          ),
          const SizedBox(height: 32),
          Text('Still need help?', style: AppTextStyles.h3),
          const SizedBox(height: 16),
          _buildSupportCard(
            context,
            'Contact Support',
            'Our team is available 24/7 to assist you.',
            Icons.headset_mic_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(answer, style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textGray)),
        ),
      ],
    );
  }

  Widget _buildSupportCard(BuildContext context, String title, String subtitle, IconData icon) {
    return InkWell(
      onTap: () {
        // Navigate to Contact Screen
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.darkNavy,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.lightMint, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.7))),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}
