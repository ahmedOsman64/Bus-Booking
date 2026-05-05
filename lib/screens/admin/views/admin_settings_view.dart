import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input.dart';

class AdminSettingsView extends StatefulWidget {
  const AdminSettingsView({super.key});

  @override
  State<AdminSettingsView> createState() => _AdminSettingsViewState();
}

class _AdminSettingsViewState extends State<AdminSettingsView> {
  int _selectedIndex = 0;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _maintenanceMode = false;
  bool _isSaving = false;

  final List<Map<String, dynamic>> _categories = [
    {'title': 'General', 'icon': Icons.settings_outlined, 'activeIcon': Icons.settings_rounded},
    {'title': 'Security', 'icon': Icons.security_outlined, 'activeIcon': Icons.security_rounded},
    {'title': 'Notifications', 'icon': Icons.notifications_none_rounded, 'activeIcon': Icons.notifications_active_rounded},
    {'title': 'System Status', 'icon': Icons.dns_outlined, 'activeIcon': Icons.dns_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.teal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.tune_rounded, color: AppColors.teal),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Settings & Configuration', style: AppTextStyles.h2),
                  Text('Manage system preferences and security configurations.', 
                    style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textGray)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bool isDesktop = constraints.maxWidth > 850;
                
                if (isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sidebar
                      Container(
                        width: 240,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: List.generate(_categories.length, (index) {
                            final category = _categories[index];
                            final isSelected = _selectedIndex == index;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: InkWell(
                                onTap: () => setState(() => _selectedIndex = index),
                                borderRadius: BorderRadius.circular(12),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.teal : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isSelected ? category['activeIcon'] : category['icon'],
                                        color: isSelected ? Colors.white : AppColors.textGray,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        category['title'],
                                        style: AppTextStyles.bodyLarge.copyWith(
                                          color: isSelected ? Colors.white : AppColors.textGray,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(width: 32),
                      // Content Area
                      Expanded(
                        child: SingleChildScrollView(
                          child: _buildSelectedCategoryContent(),
                        ),
                      ),
                    ],
                  );
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildGeneralSettings(),
                        const SizedBox(height: 24),
                        _buildSecuritySettings(),
                        const SizedBox(height: 24),
                        _buildNotificationSettings(),
                        const SizedBox(height: 24),
                        _buildSystemStatus(),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedCategoryContent() {
    switch (_selectedIndex) {
      case 0: return _buildGeneralSettings();
      case 1: return _buildSecuritySettings();
      case 2: return _buildNotificationSettings();
      case 3: return _buildSystemStatus();
      default: return _buildGeneralSettings();
    }
  }

  Widget _buildGeneralSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('General Configuration', style: AppTextStyles.h3),
        const SizedBox(height: 8),
        Text('Configure your platform identity and regional preferences.', 
          style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textGray)),
        const SizedBox(height: 24),
        AppCard(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Expanded(child: AppInput(label: 'Platform Name', hintText: 'SomBus Admin', prefixIcon: Icons.business_rounded)),
                  SizedBox(width: 16),
                  Expanded(child: AppInput(label: 'Support Email', hintText: 'support@sombus.com', prefixIcon: Icons.contact_support_rounded)),
                ],
              ),
              const SizedBox(height: 24),
              const Row(
                children: [
                  Expanded(child: AppInput(label: 'Base Currency', hintText: 'USD (\$)', prefixIcon: Icons.payments_rounded)),
                  SizedBox(width: 16),
                  Expanded(child: AppInput(label: 'System Timezone', hintText: 'Africa/Mogadishu', prefixIcon: Icons.public_rounded)),
                ],
              ),
              const SizedBox(height: 32),
              const Divider(color: AppColors.borderGray),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 160,
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
                            content: Text('Settings saved successfully!'),
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

  Widget _buildNotificationSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notifications', style: AppTextStyles.h3),
        const SizedBox(height: 8),
        Text('Choose how you want to be notified about system events.', 
          style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textGray)),
        const SizedBox(height: 24),
        AppCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildSwitchRow(
                'Email Notifications',
                'Receive daily summaries and critical alerts via email',
                _emailNotifications,
                (val) => setState(() => _emailNotifications = val),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: AppColors.borderGray),
              ),
              _buildSwitchRow(
                'SMS Alerts',
                'Receive SMS for urgent system issues or passenger disputes',
                _smsNotifications,
                (val) => setState(() => _smsNotifications = val),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSystemStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('System Control', style: AppTextStyles.h3),
        const SizedBox(height: 8),
        Text('Manage global system availability and diagnostic modes.', 
          style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textGray)),
        const SizedBox(height: 24),
        AppCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildSwitchRow(
                'Maintenance Mode',
                'Disables booking for passengers while maintaining admin access.',
                _maintenanceMode,
                (val) => setState(() => _maintenanceMode = val),
                isDanger: true,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: AppColors.borderGray),
              ),
              _buildStatusIndicator('System Health', 'Optimal', AppColors.success),
              const SizedBox(height: 16),
              _buildStatusIndicator('Database Connection', 'Connected', AppColors.teal),
              const SizedBox(height: 16),
              _buildStatusIndicator('API Gateway', 'Operational', AppColors.info),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(String label, String status, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyRegular),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(status, style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildSecuritySettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Security & Access', style: AppTextStyles.h3),
        const SizedBox(height: 8),
        Text('Secure your account and manage sensitive system access.', 
          style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textGray)),
        const SizedBox(height: 24),
        AppCard(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              _buildActionRow(
                'Change Admin Password',
                'Update your administrative login credentials regularly.',
                Icons.lock_outline_rounded,
                AppColors.teal,
                'Update Password',
                () {},
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Divider(color: AppColors.borderGray),
              ),
              _buildActionRow(
                'Two-Factor Authentication',
                'Add an extra layer of security to your admin account.',
                Icons.verified_user_outlined,
                AppColors.info,
                'Enable 2FA',
                () {},
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Divider(color: AppColors.borderGray),
              ),
              _buildActionRow(
                'Clear System Cache',
                'Forces the system to reload all configuration data.',
                Icons.cleaning_services_outlined,
                AppColors.error,
                'Purge Cache',
                () {},
                isDanger: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow(String title, String subtitle, IconData icon, Color color, String actionText, VoidCallback onPressed, {bool isDanger = false}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: AppTextStyles.caption),
            ],
          ),
        ),
        const SizedBox(width: 24),
        OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: isDanger ? AppColors.error : AppColors.teal,
            side: BorderSide(color: isDanger ? AppColors.error.withValues(alpha: 0.3) : AppColors.teal.withValues(alpha: 0.3)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text(actionText),
        ),
      ],
    );
  }

  Widget _buildSwitchRow(String title, String subtitle, bool value, ValueChanged<bool> onChanged, {bool isDanger = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: isDanger ? AppColors.error : AppColors.darkNavy)),
              const SizedBox(height: 4),
              Text(subtitle, style: AppTextStyles.caption),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: isDanger ? AppColors.error.withValues(alpha: 0.5) : AppColors.teal.withValues(alpha: 0.5),
          activeThumbColor: isDanger ? AppColors.error : AppColors.teal,
        ),
      ],
    );
  }
}
