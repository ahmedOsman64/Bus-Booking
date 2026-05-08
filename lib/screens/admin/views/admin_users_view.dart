import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input.dart';

import '../../../core/models/user_model.dart' as model;
import '../../../core/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminUsersView extends ConsumerWidget {
  const AdminUsersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userProvider);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, ref),
          const SizedBox(height: 32),
          _buildSummaryCards(context, users),
          const SizedBox(height: 32),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildTableHeader(),
                const Divider(height: 1, color: AppColors.borderGray),
                users.isEmpty 
                  ? const Padding(
                      padding: EdgeInsets.all(48.0),
                      child: Center(child: Text('No users found')),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: users.length,
                      separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.borderGray),
                      itemBuilder: (context, index) {
                        return _buildUserRow(context, ref, users[index], index);
                      },
                    ),
                _buildTableFooter(users.length),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
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
                onPressed: () => _showAddUserDialog(context, ref),
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
          SizedBox(width: 160, child: Center(child: Text('ACTIONS', style: AppTextStyles.label.copyWith(fontSize: 11)))),
        ],
      ),
    );
  }

  Widget _buildUserRow(BuildContext context, WidgetRef ref, model.User user, int index) {
    final String role = user.role == model.UserRole.admin ? 'Admin' : (user.role == model.UserRole.driver ? 'Driver' : 'Passenger');
    final Color roleColor = user.role == model.UserRole.admin ? AppColors.error : (user.role == model.UserRole.driver ? AppColors.info : AppColors.success);
    
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
                    user.firstName.substring(0, 1) + user.lastName.substring(0, 1),
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.teal, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.fullName, style: AppTextStyles.bodyRegular.copyWith(fontWeight: FontWeight.bold)),
                      Text(user.email, style: AppTextStyles.caption.copyWith(color: AppColors.textGray)),
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
                  decoration: BoxDecoration(
                    color: user.status == model.UserStatus.active ? AppColors.success : AppColors.textGray,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(user.status == model.UserStatus.active ? 'Active' : 'Inactive', style: AppTextStyles.bodySmall),
              ],
            ),
          ),

          // Last Active
          Expanded(
            flex: 2,
            child: Text(user.lastActive, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGray)),
          ),

          // Actions
          SizedBox(
            width: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionIcon(
                  Icons.visibility_rounded,
                  const Color(0xFF3383FF),
                  const Color(0xFFEBF3FF),
                  () => _showUserDetailsDialog(context, ref, user, isReadOnly: true),
                ),
                const SizedBox(width: 12),
                _buildActionIcon(
                  Icons.edit_rounded,
                  const Color(0xFF475569),
                  const Color(0xFFF1F5F9),
                  () => _showUserDetailsDialog(context, ref, user, isReadOnly: false),
                ),
                const SizedBox(width: 12),
                _buildActionIcon(
                  Icons.delete_rounded,
                  const Color(0xFFEF4444),
                  const Color(0xFFFEE2E2),
                  () => _showDeleteConfirmation(context, ref, user.id),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, Color color, Color bgColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }

  Widget _buildTableFooter(int total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Showing $total users', style: AppTextStyles.caption),
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

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, String id) {
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
                ref.read(userProvider.notifier).deleteUser(id);
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

  void _showAddUserDialog(BuildContext context, WidgetRef ref) {
    String selectedRole = 'Passenger';
    String selectedAdminType = 'Super Admin';

    const roles = ['Passenger', 'Driver', 'Admin'];
    const adminTypes = ['Super Admin', 'Route Manager', 'Bus Manager', 'Finance Admin', 'Support Admin'];

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    
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
                            Expanded(child: AppInput(label: 'First Name', hintText: 'Ahmed', controller: firstNameController, prefixIcon: Icons.badge_outlined, validator: (v) => v!.isEmpty ? 'Required' : null)),
                            const SizedBox(width: 20),
                            Expanded(child: AppInput(label: 'Last Name', hintText: 'Hassan', controller: lastNameController, prefixIcon: Icons.badge_outlined, validator: (v) => v!.isEmpty ? 'Required' : null)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: AppInput(label: 'Email Address', hintText: 'ahmed@example.com', controller: emailController, prefixIcon: Icons.email_outlined, validator: (v) => v!.isEmpty ? 'Required' : null)),
                            const SizedBox(width: 20),
                            Expanded(child: AppInput(label: 'Phone Number', hintText: '+252 61XXXXXXX', controller: phoneController, prefixIcon: Icons.phone_outlined, validator: (v) => v!.isEmpty ? 'Required' : null)),
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
                                    
                                    final newUser = model.User(
                                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text,
                                      email: emailController.text,
                                      phoneNumber: phoneController.text,
                                      role: selectedRole == 'Admin' ? model.UserRole.admin : (selectedRole == 'Driver' ? model.UserRole.driver : model.UserRole.passenger),
                                      status: model.UserStatus.active,
                                      lastActive: 'Just now',
                                      adminCategory: selectedRole == 'Admin' ? selectedAdminType : null,
                                    );

                                    await Future.delayed(const Duration(milliseconds: 1000));
                                    ref.read(userProvider.notifier).addUser(newUser);

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

  void _showUserDetailsDialog(BuildContext context, WidgetRef ref, model.User user, {bool isReadOnly = false}) {
    String selectedRole = user.role == model.UserRole.admin ? 'Admin' : (user.role == model.UserRole.driver ? 'Driver' : 'Passenger');
    String selectedAdminType = user.adminCategory ?? 'Super Admin';
    String selectedStatus = user.status == model.UserStatus.active ? 'Active' : 'Inactive';

    const roles = ['Passenger', 'Driver', 'Admin'];
    const adminTypes = ['Super Admin', 'Route Manager', 'Bus Manager', 'Finance Admin', 'Support Admin'];
    const statuses = ['Active', 'Inactive'];

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final firstNameController = TextEditingController(text: user.firstName);
    final lastNameController = TextEditingController(text: user.lastName);
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phoneNumber);
    
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.white,
              elevation: 40,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
              child: Container(
                width: 680,
                padding: const EdgeInsets.all(40),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBF3FF),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.visibility_rounded,
                                color: Color(0xFF3383FF),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(isReadOnly ? 'User Profile' : 'Edit User Profile', style: AppTextStyles.h2.copyWith(fontSize: 26)),
                                  Text(
                                    isReadOnly ? 'Full access to user records and history' : 'Update account permissions and details',
                                    style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textGray.withValues(alpha: 0.7)),
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
                        const SizedBox(height: 48),

                        // Section 1: Personal Information
                        Row(
                          children: [
                            const Icon(Icons.person_outline_rounded, size: 22, color: Color(0xFF6B7A99)),
                            const SizedBox(width: 12),
                            Text('Personal Information', style: AppTextStyles.h3.copyWith(color: const Color(0xFF6B7A99), fontSize: 20)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: AppInput(
                                label: 'First Name',
                                controller: firstNameController,
                                enabled: !isReadOnly,
                                prefixIcon: Icons.badge_outlined,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: AppInput(
                                label: 'Last Name',
                                controller: lastNameController,
                                enabled: !isReadOnly,
                                prefixIcon: Icons.badge_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: AppInput(
                                label: 'Email Address',
                                controller: emailController,
                                enabled: !isReadOnly,
                                prefixIcon: Icons.email_outlined,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: AppInput(
                                label: 'Phone Number',
                                controller: phoneController,
                                enabled: !isReadOnly,
                                prefixIcon: Icons.phone_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // Section 2: Account & Roles
                        Row(
                          children: [
                            const Icon(Icons.shield_outlined, size: 22, color: Color(0xFF6B7A99)),
                            const SizedBox(width: 12),
                            Text('Account & Roles', style: AppTextStyles.h3.copyWith(color: const Color(0xFF6B7A99), fontSize: 20)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text('System Role', style: AppTextStyles.label.copyWith(color: const Color(0xFF6B7A99))),
                        const SizedBox(height: 12),
                        Row(
                          children: roles.map((role) {
                            final isSelected = selectedRole == role;
                            final Color roleColor = role == 'Admin' ? AppColors.error : AppColors.info;
                            
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: role == roles.last ? 0 : 16),
                                child: InkWell(
                                  onTap: isReadOnly ? null : () => setDialogState(() => selectedRole = role),
                                  borderRadius: BorderRadius.circular(16),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    decoration: BoxDecoration(
                                      color: isSelected ? roleColor.withValues(alpha: 0.08) : const Color(0xFFF8FAFF),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected ? roleColor : const Color(0xFFE4E8F0),
                                        width: isSelected ? 2 : 1.5,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        role,
                                        style: AppTextStyles.bodyRegular.copyWith(
                                          color: isSelected ? roleColor : const Color(0xFF6B7A99),
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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
                          const SizedBox(height: 32),
                          Text('Admin Category', style: AppTextStyles.label.copyWith(color: const Color(0xFF6B7A99))),
                          const SizedBox(height: 12),
                          _buildPickerField(
                            value: selectedAdminType,
                            items: adminTypes,
                            onChanged: isReadOnly ? null : (val) => setDialogState(() => selectedAdminType = val!),
                            icon: Icons.admin_panel_settings_outlined,
                          ),
                        ],

                        const SizedBox(height: 24),
                        Text('Account Status', style: AppTextStyles.label.copyWith(color: const Color(0xFF6B7A99))),
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

                        const SizedBox(height: 56),

                        // Actions Section
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
                                width: 200,
                                child: AppButton(
                                  text: 'Save Changes',
                                  icon: Icons.check_circle_outline_rounded,
                                  isLoading: isSaving,
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      setDialogState(() => isSaving = true);
                                      
                                      final updatedUser = user.copyWith(
                                        firstName: firstNameController.text,
                                        lastName: lastNameController.text,
                                        email: emailController.text,
                                        phoneNumber: phoneController.text,
                                        role: selectedRole == 'Admin' ? model.UserRole.admin : (selectedRole == 'Driver' ? model.UserRole.driver : model.UserRole.passenger),
                                        status: selectedStatus == 'Active' ? model.UserStatus.active : model.UserStatus.inactive,
                                        adminCategory: selectedRole == 'Admin' ? selectedAdminType : null,
                                      );

                                      await Future.delayed(const Duration(milliseconds: 1000));
                                      ref.read(userProvider.notifier).updateUser(updatedUser);

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
                                width: 220,
                                child: AppButton(
                                  text: 'Done',
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

  Widget _buildSummaryCards(BuildContext context, List<model.User> users) {
    final bool isDesktop = MediaQuery.of(context).size.width > 1200;
    final int activeCount = users.where((u) => u.status == model.UserStatus.active).length;
    final int driverCount = users.where((u) => u.role == model.UserRole.driver).length;
    final int adminCount = users.where((u) => u.role == model.UserRole.admin).length;

    return Row(
      children: [
        Expanded(child: _buildSummaryCard('Total Users', users.length.toString(), Icons.people_rounded, AppColors.info)),
        const SizedBox(width: 20),
        Expanded(child: _buildSummaryCard('Active Now', activeCount.toString(), Icons.person_pin_circle_rounded, AppColors.success)),
        const SizedBox(width: 20),
        Expanded(child: _buildSummaryCard('Drivers', driverCount.toString(), Icons.badge_rounded, AppColors.warning)),
        if (isDesktop) ...[
          const SizedBox(width: 20),
          Expanded(child: _buildSummaryCard('Admins', adminCount.toString(), Icons.admin_panel_settings_rounded, AppColors.error)),
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
