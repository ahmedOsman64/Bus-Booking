import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_card.dart';

import 'feedback_form_screen.dart';
import 'help_screen.dart';
import 'contact_screen.dart';
import 'language_selector_screen.dart';
import '../auth/login_screen.dart';
import 'personal_info_screen.dart';
import 'booking_history_screen.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: CustomScrollView(
        slivers: [
          // Premium Header
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Container(
                  height: 220,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.darkNavy, AppColors.teal],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    icon: const Icon(Icons.settings_outlined, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 20,
                  child: Text(
                    'Profile',
                    style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 24),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 110),
                      _buildAvatar(),
                      const SizedBox(height: 16),
                      Text(
                        'Ahmed Ali',
                        style: AppTextStyles.h2.copyWith(fontSize: 24),
                      ),
                      Text(
                        'ahmed@example.com',
                        style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textGray),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Menu Content
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionTitle('Account Settings'),
                const SizedBox(height: 16),
                _buildProfileItem(
                  icon: Icons.person_outline_rounded,
                  title: 'Personal Info',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PersonalInfoScreen()),
                  ),
                ),
                const SizedBox(height: 12),
                _buildProfileItem(
                  icon: Icons.history_rounded,
                  title: 'Booking History',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BookingHistoryScreen()),
                  ),
                ),
                const SizedBox(height: 12),
                _buildProfileItem(
                  icon: Icons.language_rounded,
                  title: 'Language (English)',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LanguageSelectorScreen()),
                  ),
                ),
                
                const SizedBox(height: 32),
                _buildSectionTitle('Support & Feedback'),
                const SizedBox(height: 16),
                _buildProfileItem(
                  icon: Icons.star_outline_rounded,
                  title: 'Give Feedback',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FeedbackFormScreen(travelTitle: 'Mogadishu → Afgooye')),
                  ),
                ),
                const SizedBox(height: 12),
                _buildProfileItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & Support',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HelpScreen()),
                  ),
                ),
                const SizedBox(height: 12),
                _buildProfileItem(
                  icon: Icons.contact_support_outlined,
                  title: 'Contact Us',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ContactScreen()),
                  ),
                ),

                const SizedBox(height: 48),
                _buildLogoutButton(context),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          const CircleAvatar(
            radius: 55,
            backgroundColor: AppColors.darkNavy,
            child: Icon(Icons.person_rounded, size: 55, color: Colors.white),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.lightMint,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt_rounded, size: 18, color: AppColors.darkNavy),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: AppTextStyles.caption.copyWith(
        color: AppColors.textGray,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.darkNavy.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.darkNavy, size: 22),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textGray, size: 20),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      ),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.warmCoral.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.warmCoral.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: AppColors.warmCoral, size: 22),
            const SizedBox(width: 12),
            Text(
              'Logout Account',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.warmCoral,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
