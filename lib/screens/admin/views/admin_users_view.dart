import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input.dart';

class AdminUsersView extends StatelessWidget {
  const AdminUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 32),
          _buildSummaryCards(context),
          const SizedBox(height: 32),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildTableHeader(),
                const Divider(height: 1, color: AppColors.borderGray),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: 10,
                  separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.borderGray),
                  itemBuilder: (context, index) {
                    return _buildUserRow(context, index);
                  },
                ),
                _buildTableFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Users Management', style: AppTextStyles.h1),
            const SizedBox(height: 4),
            Text('Manage system roles, permissions, and user accounts.',
                style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textGray)),
          ],
        ),
        Row(
          children: [
            _buildHeaderAction(Icons.filter_list_rounded, 'Filter List', () => _showFilterDialog(context)),
            const SizedBox(width: 12),
            SizedBox(
              width: 180,
              child: AppButton(
                text: 'Create New User',
                icon: Icons.person_add_rounded,
                onPressed: () => _showAddUserDialog(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderAction(IconData icon, String label, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.darkNavy,
        side: const BorderSide(color: AppColors.borderGray),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon, size: 20),
      label: Text(label),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: AppColors.lightGray.withValues(alpha: 0.5),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('USER INFO', style: AppTextStyles.label.copyWith(fontSize: 11))),
          Expanded(flex: 2, child: Text('ROLE', style: AppTextStyles.label.copyWith(fontSize: 11))),
          Expanded(flex: 2, child: Text('STATUS', style: AppTextStyles.label.copyWith(fontSize: 11))),
          Expanded(flex: 2, child: Text('LAST ACTIVE', style: AppTextStyles.label.copyWith(fontSize: 11))),
          SizedBox(width: 120, child: Center(child: Text('ACTIONS', style: AppTextStyles.label.copyWith(fontSize: 11)))),
        ],
      ),
    );
  }

  Widget _buildUserRow(BuildContext context, int index) {
    final roles = ['Passenger', 'Driver', 'Admin'];
    final role = roles[index % 3];
    final Color roleColor = role == 'Admin' ? AppColors.error : (role == 'Driver' ? AppColors.info : AppColors.success);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // User Info
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.teal.withValues(alpha: 0.1),
                  child: Text(
                    'AH',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.teal, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ahmed Hassan', style: AppTextStyles.bodyRegular.copyWith(fontWeight: FontWeight.bold)),
                      Text('ahmed@somsafar.com', style: AppTextStyles.caption.copyWith(color: AppColors.textGray)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Role
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: roleColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                role,
                style: AppTextStyles.caption.copyWith(color: roleColor, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Status
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text('Active', style: AppTextStyles.bodySmall),
              ],
            ),
          ),

          // Last Active
          Expanded(
            flex: 2,
            child: Text('2 hours ago', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGray)),
          ),

          // Actions
          SizedBox(
            width: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionIcon(Icons.visibility_outlined, AppColors.info, () => _showUserDetailsDialog(context, index, isReadOnly: true)),
                const SizedBox(width: 8),
                _buildActionIcon(Icons.edit_outlined, AppColors.teal, () => _showUserDetailsDialog(context, index, isReadOnly: false)),
                const SizedBox(width: 8),
                _buildActionIcon(Icons.delete_outline_rounded, AppColors.error, () => _showDeleteConfirmation(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderGray),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  Widget _buildTableFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Showing 1-10 of 3,890 users', style: AppTextStyles.caption),
          Row(
            children: [
              _buildPageButton(Icons.chevron_left_rounded, false),
              const SizedBox(width: 8),
              _buildPageButton(Icons.chevron_right_rounded, true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton(IconData icon, bool enabled) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: Icon(icon, size: 18, color: enabled ? AppColors.darkNavy : AppColors.textGray),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete User Account'),
        content: const Text('Are you sure you want to permanently delete this user? All their booking history will be archived.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.textGray)),
          ),
          SizedBox(
            width: 120,
            child: AppButton(
              text: 'Delete',
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User account deleted'),
                    backgroundColor: AppColors.error,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    String selectedRole = 'Passenger';
    String selectedAdminType = 'Super Admin';

    const roles = ['Passenger', 'Driver', 'Admin'];
    const adminTypes = ['Super Admin', 'Route Manager', 'Bus Manager', 'Finance Admin', 'Support Admin'];

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Container(
                width: 640,
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.teal.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.person_add_outlined, color: AppColors.teal),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Create New User', style: AppTextStyles.h2),
                                  Text('Onboard a new passenger, driver, or administrator', style: AppTextStyles.caption),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded, color: AppColors.textGray),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Personal Info
                        _buildSectionHeader(Icons.person_outline_rounded, 'Personal Information'),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: AppInput(label: 'First Name', hintText: 'Ahmed', prefixIcon: Icons.badge_outlined, validator: (v) => v!.isEmpty ? 'Required' : null)),
                            const SizedBox(width: 20),
                            Expanded(child: AppInput(label: 'Last Name', hintText: 'Hassan', prefixIcon: Icons.badge_outlined, validator: (v) => v!.isEmpty ? 'Required' : null)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: AppInput(label: 'Email Address', hintText: 'ahmed@example.com', prefixIcon: Icons.email_outlined, validator: (v) => v!.isEmpty ? 'Required' : null)),
                            const SizedBox(width: 20),
                            Expanded(child: AppInput(label: 'Phone Number', hintText: '+252 61XXXXXXX', prefixIcon: Icons.phone_outlined, validator: (v) => v!.isEmpty ? 'Required' : null)),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Account Config
                        _buildSectionHeader(Icons.settings_outlined, 'Account Configuration'),
                        const SizedBox(height: 20),
                        Text('System Role', style: AppTextStyles.label),
                        const SizedBox(height: 12),
                        Row(
                          children: roles.map((role) {
                            final isSelected = selectedRole == role;
                            Color color = role == 'Admin' ? AppColors.error : (role == 'Driver' ? AppColors.info : AppColors.success);
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: role == roles.last ? 0 : 12),
                                child: InkWell(
                                  onTap: () => setDialogState(() => selectedRole = role),
                                  borderRadius: BorderRadius.circular(12),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected ? color.withValues(alpha: 0.1) : AppColors.lightGray,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: isSelected ? color : AppColors.borderGray, width: isSelected ? 1.5 : 1),
                                    ),
                                    child: Center(
                                      child: Text(role, style: AppTextStyles.bodySmall.copyWith(
                                        color: isSelected ? color : AppColors.textGray,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        if (selectedRole == 'Admin') ...[
                          const SizedBox(height: 20),
                          Text('Admin Permission Level', style: AppTextStyles.label),
                          const SizedBox(height: 8),
                          _buildPickerField(
                            value: selectedAdminType,
                            items: adminTypes,
                            onChanged: (val) => setDialogState(() => selectedAdminType = val!),
                            icon: Icons.shield_outlined,
                          ),
                        ],

                        const SizedBox(height: 32),
                        const AppInput(label: 'Temporary Password', hintText: 'Create a secure password', isPassword: true, prefixIcon: Icons.lock_outline_rounded),
                        const SizedBox(height: 40),

                        // Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 140,
                              child: AppButton(
                                text: 'Cancel',
                                type: AppButtonType.secondary,
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              width: 200,
                              child: AppButton(
                                text: 'Create Account',
                                icon: Icons.check_circle_outline_rounded,
                                isLoading: isSaving,
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    setDialogState(() => isSaving = true);
                                    await Future.delayed(const Duration(milliseconds: 1500));
                                    if (context.mounted) {
                                      setDialogState(() => isSaving = false);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('New user account created!'),
                                          backgroundColor: AppColors.success,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showUserDetailsDialog(BuildContext context, int index, {bool isReadOnly = false}) {
    String selectedRole = index == 0 ? 'Admin' : 'Passenger';
    String selectedAdminType = 'Super Admin';
    String selectedStatus = index == 0 ? 'Inactive' : 'Active';

    const roles = ['Passenger', 'Driver', 'Admin'];
    const adminTypes = ['Super Admin', 'Route Manager', 'Bus Manager', 'Finance Admin', 'Support Admin'];
    const statuses = ['Active', 'Inactive'];

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Container(
                width: 600,
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isReadOnly ? AppColors.info.withValues(alpha: 0.1) : AppColors.teal.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isReadOnly ? Icons.visibility_outlined : Icons.edit_outlined,
                                color: isReadOnly ? AppColors.info : AppColors.teal,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(isReadOnly ? 'User Profile' : 'Edit User Profile', style: AppTextStyles.h2),
                                  Text(
                                    isReadOnly ? 'Full access to user records and history' : 'Update account permissions and details',
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded, color: AppColors.textGray),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Personal Information Section
                        _buildSectionHeader(Icons.person_outline_rounded, 'Personal Information'),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: AppInput(
                                label: 'First Name',
                                controller: TextEditingController(text: 'Ahmed'),
                                enabled: !isReadOnly,
                                prefixIcon: Icons.badge_outlined,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: AppInput(
                                label: 'Last Name',
                                controller: TextEditingController(text: 'Hassan'),
                                enabled: !isReadOnly,
                                prefixIcon: Icons.badge_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        AppInput(
                          label: 'Email Address',
                          controller: TextEditingController(text: 'user${index + 1}@example.com'),
                          enabled: !isReadOnly,
                          prefixIcon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 24),

                        // Role & Account Section
                        _buildSectionHeader(Icons.shield_outlined, 'Account & Roles'),
                        const SizedBox(height: 20),
                        Text('System Role', style: AppTextStyles.label),
                        const SizedBox(height: 12),
                        Row(
                          children: roles.map((role) {
                            final isSelected = selectedRole == role;
                            Color color = role == 'Admin' ? AppColors.error : (role == 'Driver' ? AppColors.info : AppColors.success);
                            
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: role == roles.last ? 0 : 12),
                                child: InkWell(
                                  onTap: isReadOnly ? null : () => setDialogState(() => selectedRole = role),
                                  borderRadius: BorderRadius.circular(12),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected ? color.withValues(alpha: 0.1) : AppColors.lightGray,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected ? color : AppColors.borderGray,
                                        width: isSelected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        role,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: isSelected ? color : AppColors.textGray,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        
                        if (selectedRole == 'Admin') ...[
                          const SizedBox(height: 20),
                          Text('Admin Category', style: AppTextStyles.label),
                          const SizedBox(height: 8),
                          _buildPickerField(
                            value: selectedAdminType,
                            items: adminTypes,
                            onChanged: isReadOnly ? null : (val) => setDialogState(() => selectedAdminType = val!),
                            icon: Icons.admin_panel_settings_outlined,
                          ),
                        ],

                        const SizedBox(height: 24),
                        Text('Account Status', style: AppTextStyles.label),
                        const SizedBox(height: 12),
                        Row(
                          children: statuses.map((s) {
                            final isSelected = selectedStatus == s;
                            final color = s == 'Active' ? AppColors.success : AppColors.textGray;
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: s == statuses.last ? 0 : 12),
                                child: InkWell(
                                  onTap: isReadOnly ? null : () => setDialogState(() => selectedStatus = s),
                                  borderRadius: BorderRadius.circular(12),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected ? color.withValues(alpha: 0.1) : AppColors.lightGray,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected ? color : AppColors.borderGray,
                                        width: isSelected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        s,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: isSelected ? color : AppColors.textGray,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 40),

                        // Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (!isReadOnly) ...[
                              SizedBox(
                                width: 140,
                                child: AppButton(
                                  text: 'Discard',
                                  type: AppButtonType.secondary,
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: 180,
                                child: AppButton(
                                  text: 'Save Changes',
                                  icon: Icons.check_circle_outline_rounded,
                                  isLoading: isSaving,
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      setDialogState(() => isSaving = true);
                                      await Future.delayed(const Duration(milliseconds: 1500));
                                      if (context.mounted) {
                                        setDialogState(() => isSaving = false);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('User updated successfully!'),
                                            backgroundColor: AppColors.success,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ] else ...[
                              SizedBox(
                                width: 160,
                                child: AppButton(
                                  text: 'Close Profile',
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textGray),
        const SizedBox(width: 10),
        Text(title, style: AppTextStyles.h4.copyWith(color: AppColors.textGray)),
      ],
    );
  }

  Widget _buildPickerField({
    required String value,
    required List<String> items,
    required Function(String?)? onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          onChanged: onChanged,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(icon, size: 18, color: AppColors.textGray),
                  const SizedBox(width: 12),
                  Text(item, style: AppTextStyles.bodyRegular),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 1200;
    return Row(
      children: [
        Expanded(child: _buildSummaryCard('Total Users', '3,890', Icons.people_rounded, AppColors.info)),
        const SizedBox(width: 20),
        Expanded(child: _buildSummaryCard('Active Now', '1,240', Icons.person_pin_circle_rounded, AppColors.success)),
        const SizedBox(width: 20),
        Expanded(child: _buildSummaryCard('Drivers', '45', Icons.badge_rounded, AppColors.warning)),
        if (isDesktop) ...[
          const SizedBox(width: 20),
          Expanded(child: _buildSummaryCard('Admins', '8', Icons.admin_panel_settings_rounded, AppColors.error)),
        ]
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: AppTextStyles.h2),
                Text(title, style: AppTextStyles.caption.copyWith(color: AppColors.textGray, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Filter Users', style: AppTextStyles.h2),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppColors.textGray),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const AppInput(label: 'Role', hintText: 'All Roles', prefixIcon: Icons.badge_outlined),
                const SizedBox(height: 16),
                const AppInput(label: 'Status', hintText: 'All Statuses', prefixIcon: Icons.filter_list_rounded),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 120,
                      child: AppButton(
                        text: 'Reset',
                        type: AppButtonType.secondary,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 160,
                      child: AppButton(
                        text: 'Apply',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
