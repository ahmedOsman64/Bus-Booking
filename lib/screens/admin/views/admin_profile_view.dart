import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input.dart';

class AdminProfileView extends StatefulWidget {
  const AdminProfileView({super.key});

  @override
  State<AdminProfileView> createState() => _AdminProfileViewState();
}

class _AdminProfileViewState extends State<AdminProfileView> {
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPremiumHeader(),
          const SizedBox(height: 32),
          LayoutBuilder(builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 950;

            if (isDesktop) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: _buildSideActions()),
                  const SizedBox(width: 32),
                  Expanded(flex: 2, child: _buildMainForm()),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildSideActions(),
                  const SizedBox(height: 32),
                  _buildMainForm(),
                ],
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _buildPremiumHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.darkNavy, AppColors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Opacity(
            opacity: 0.1,
            child: Icon(Icons.pattern_rounded, size: 300, color: Colors.white),
          ),
        ),
        Positioned(
          bottom: -40,
          left: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Stack(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(color: Colors.white, width: 5),
                    ),
                    child: ClipOval(
                      child: Container(
                        color: AppColors.teal.withValues(alpha: 0.1),
                        child: const Icon(Icons.person_rounded, size: 70, color: AppColors.teal),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.darkNavy,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Admin User', style: AppTextStyles.h1.copyWith(color: Colors.white)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Super Admin',
                            style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.verified_rounded, color: AppColors.teal, size: 18),
                        const SizedBox(width: 4),
                        Text('Verified Official', style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.8))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSideActions() {
    return Column(
      children: [
        AppCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contact Information', style: AppTextStyles.h3),
              const SizedBox(height: 24),
              _buildModernInfoRow(Icons.email_outlined, 'Email', 'admin@sombus.com'),
              const SizedBox(height: 20),
              _buildModernInfoRow(Icons.phone_outlined, 'Phone', '+252 61X XXXXXX'),
              const SizedBox(height: 20),
              _buildModernInfoRow(Icons.location_on_outlined, 'Location', 'Mogadishu, Somalia'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        AppCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Account Statistics', style: AppTextStyles.h3),
              const SizedBox(height: 20),
              _buildStatRow('Total Logins', '124'),
              const Divider(height: 24),
              _buildStatRow('Last Active', '2 hours ago'),
              const Divider(height: 24),
              _buildStatRow('Security Level', 'High'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModernInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.teal, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption),
            Text(value, style: AppTextStyles.bodyRegular.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyRegular),
        Text(value, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: AppColors.teal)),
      ],
    );
  }

  Widget _buildMainForm() {
    return Column(
      children: [
        AppCard(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.person_outline_rounded, color: AppColors.teal),
                  const SizedBox(width: 12),
                  Text('Account Details', style: AppTextStyles.h2),
                ],
              ),
              const SizedBox(height: 32),
              const Row(
                children: [
                  Expanded(child: AppInput(label: 'First Name', hintText: 'Admin', prefixIcon: Icons.badge_outlined)),
                  SizedBox(width: 24),
                  Expanded(child: AppInput(label: 'Last Name', hintText: 'User', prefixIcon: Icons.badge_outlined)),
                ],
              ),
              const SizedBox(height: 24),
              const AppInput(
                  label: 'Email Address',
                  hintText: 'admin@sombus.com',
                  prefixIcon: Icons.email_outlined),
              const SizedBox(height: 24),
              const AppInput(
                  label: 'Mailing Address',
                  hintText: 'Enter your full address',
                  prefixIcon: Icons.location_on_outlined),
            ],
          ),
        ),
        const SizedBox(height: 24),
        AppCard(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.shield_outlined, color: AppColors.teal),
                  const SizedBox(width: 12),
                  Text('Security Settings', style: AppTextStyles.h2),
                ],
              ),
              const SizedBox(height: 24),
              const AppInput(
                  label: 'New Password',
                  hintText: 'Leave blank to keep current',
                  isPassword: true,
                  prefixIcon: Icons.lock_outline_rounded),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 140,
                    child: AppButton(
                      text: 'Discard',
                      type: AppButtonType.secondary,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 180,
                    child: AppButton(
                      text: 'Save Changes',
                      isLoading: _isSaving,
                      onPressed: () async {
                        setState(() => _isSaving = true);
                        await Future.delayed(const Duration(milliseconds: 1500));
                        if (!mounted) return;
                        setState(() => _isSaving = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile updated successfully!'),
                            backgroundColor: AppColors.success,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
