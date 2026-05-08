import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/models/user_model.dart';

class AdminProfileView extends ConsumerStatefulWidget {
  const AdminProfileView({super.key});

  @override
  ConsumerState<AdminProfileView> createState() => _AdminProfileViewState();
}

class _AdminProfileViewState extends ConsumerState<AdminProfileView> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  
  bool _isSaving = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _initializeData(User admin) {
    if (!_isInitialized) {
      _firstNameController.text = admin.firstName;
      _lastNameController.text = admin.lastName;
      _emailController.text = admin.email;
      _phoneController.text = admin.phoneNumber;
      _addressController.text = 'Mogadishu, Somalia'; // Default placeholder
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(userProvider);
    final admin = users.firstWhere((u) => u.role == UserRole.admin, orElse: () => users.first);
    
    _initializeData(admin);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPremiumHeader(admin),
          const SizedBox(height: 32),
          LayoutBuilder(builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 950;

            if (isDesktop) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: _buildSideActions(admin)),
                  const SizedBox(width: 32),
                  Expanded(flex: 2, child: _buildMainForm(admin)),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildSideActions(admin),
                  const SizedBox(height: 32),
                  _buildMainForm(admin),
                ],
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _buildPremiumHeader(User admin) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.darkNavy, Color(0xFF1E293B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkNavy.withValues(alpha: 0.2),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Opacity(
                  opacity: 0.1,
                  child: Icon(Icons.shield_rounded, size: 240, color: Colors.white),
                ),
              ),
              Positioned(
                left: 32,
                top: 32,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.teal.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.teal.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_user_rounded, color: AppColors.teal, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Secure Admin Node',
                        style: AppTextStyles.caption.copyWith(color: AppColors.teal, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -40,
          left: 40,
          right: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Stack(
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(color: Colors.white, width: 6),
                    ),
                    child: ClipOval(
                      child: Container(
                        color: AppColors.teal.withValues(alpha: 0.05),
                        child: admin.profileImage != null
                            ? Image.file(
                                File(admin.profileImage!),
                                fit: BoxFit.cover,
                                width: 140,
                                height: 140,
                              )
                            : Icon(Icons.person_rounded, size: 80, color: AppColors.darkNavy.withValues(alpha: 0.8)),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _showImageSourceDialog(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.teal,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(color: AppColors.teal.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 28),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('${admin.firstName} ${admin.lastName}', style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 32)),
                          const SizedBox(width: 12),
                          Icon(Icons.verified_rounded, color: AppColors.teal, size: 24),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildHeaderBadge(admin.adminCategory ?? 'Super Admin', AppColors.teal),
                          const SizedBox(width: 12),
                          _buildHeaderBadge('System Official', Colors.white.withValues(alpha: 0.2)),
                          const Spacer(),
                          SizedBox(
                            width: 140,
                            child: AppButton(
                              text: 'Edit Profile',
                              icon: Icons.edit_rounded,
                              onPressed: () => _showEditProfileDialog(context, admin),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 150,
                            child: AppButton(
                              text: 'Security',
                              type: AppButtonType.success,
                              icon: Icons.lock_outline_rounded,
                              onPressed: () => _showChangePasswordDialog(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  Widget _buildSideActions(User admin) {
    return Column(
      children: [
        AppCard(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contact Information', style: AppTextStyles.h3),
              const SizedBox(height: 28),
              _buildModernInfoRow(Icons.email_outlined, 'Primary Email', admin.email),
              const SizedBox(height: 24),
              _buildModernInfoRow(Icons.phone_outlined, 'Phone Number', admin.phoneNumber),
              const SizedBox(height: 24),
              _buildModernInfoRow(Icons.location_on_outlined, 'Base Location', 'Mogadishu, Somalia'),
              const SizedBox(height: 24),
              const Divider(color: AppColors.borderGray),
              const SizedBox(height: 24),
              AppButton(
                text: 'Copy Profile Link',
                type: AppButtonType.secondary,
                icon: Icons.link_rounded,
                onPressed: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        AppCard(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Account Statistics', style: AppTextStyles.h3),
              const SizedBox(height: 24),
              _buildStatItem('Total Sessions', '2,482', Icons.history_rounded, AppColors.teal),
              const SizedBox(height: 20),
              _buildStatItem('Last Security Audit', '2 days ago', Icons.gpp_good_outlined, AppColors.success),
              const SizedBox(height: 20),
              _buildStatItem('System Access', 'Unrestricted', Icons.vpn_key_outlined, AppColors.info),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textGray),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGray))),
        Text(value, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildModernInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.teal.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.teal, size: 22),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textGray, fontSize: 11)),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.bodyRegular.copyWith(fontWeight: FontWeight.w700, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainForm(User admin) {
    return Column(
      children: [
        AppCard(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), shape: BoxShape.circle),
                        child: const Icon(Icons.person_outline_rounded, color: AppColors.teal, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Text('Account Details', style: AppTextStyles.h2),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () {
                      _isInitialized = false;
                      setState(() => _initializeData(admin));
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Reset'),
                    style: TextButton.styleFrom(foregroundColor: AppColors.textGray),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(child: AppInput(label: 'First Name', hintText: 'Enter first name', controller: _firstNameController, prefixIcon: Icons.badge_outlined)),
                  const SizedBox(width: 24),
                  Expanded(child: AppInput(label: 'Last Name', hintText: 'Enter last name', controller: _lastNameController, prefixIcon: Icons.badge_outlined)),
                ],
              ),
              const SizedBox(height: 24),
              AppInput(
                  label: 'Email Address',
                  hintText: 'Enter email address',
                  controller: _emailController,
                  prefixIcon: Icons.email_outlined),
              const SizedBox(height: 24),
              AppInput(
                  label: 'Phone Number',
                  hintText: 'Enter phone number',
                  controller: _phoneController,
                  prefixIcon: Icons.phone_android_rounded),
              const SizedBox(height: 24),
              AppInput(
                  label: 'Mailing Address',
                  hintText: 'Enter your full address',
                  controller: _addressController,
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
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.shield_outlined, color: AppColors.error, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Text('Security & Authentication', style: AppTextStyles.h2),
                ],
              ),
              const SizedBox(height: 32),
              const AppInput(
                  label: 'Current Password',
                  hintText: 'Enter current password to verify',
                  isPassword: true,
                  prefixIcon: Icons.lock_outline_rounded),
              const SizedBox(height: 24),
              const AppInput(
                  label: 'New Password',
                  hintText: 'Leave blank to keep current',
                  isPassword: true,
                  prefixIcon: Icons.lock_reset_rounded),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 140,
                    child: AppButton(
                      text: 'Discard',
                      type: AppButtonType.secondary,
                      onPressed: () {
                         _isInitialized = false;
                         setState(() => _initializeData(admin));
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 200,
                    child: AppButton(
                      text: 'Save Changes',
                      isLoading: _isSaving,
                      onPressed: () async {
                        setState(() => _isSaving = true);
                        
                        final updatedAdmin = admin.copyWith(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          email: _emailController.text,
                          phoneNumber: _phoneController.text,
                        );

                        // Update provider
                        ref.read(userProvider.notifier).updateUser(updatedAdmin);

                        await Future.delayed(const Duration(milliseconds: 1500));
                        if (!mounted) return;
                        setState(() => _isSaving = false);
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile updated successfully!'),
                            backgroundColor: AppColors.success,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(20),
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

  void _showEditProfileDialog(BuildContext context, User admin) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: SizedBox(
          width: 500,
          child: AppCard(
            padding: const EdgeInsets.all(32),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), shape: BoxShape.circle),
                            child: const Icon(Icons.person_outline_rounded, color: AppColors.teal, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Text('Account Details', style: AppTextStyles.h2),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded, color: AppColors.textGray),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(child: AppInput(label: 'First Name', hintText: 'Enter first name', controller: _firstNameController, prefixIcon: Icons.badge_outlined)),
                      const SizedBox(width: 24),
                      Expanded(child: AppInput(label: 'Last Name', hintText: 'Enter last name', controller: _lastNameController, prefixIcon: Icons.badge_outlined)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  AppInput(
                      label: 'Email Address',
                      hintText: 'Enter email address',
                      controller: _emailController,
                      prefixIcon: Icons.email_outlined),
                  const SizedBox(height: 24),
                  AppInput(
                      label: 'Phone Number',
                      hintText: 'Enter phone number',
                      controller: _phoneController,
                      prefixIcon: Icons.phone_android_rounded),
                  const SizedBox(height: 24),
                  AppInput(
                      label: 'Mailing Address',
                      hintText: 'Enter mailing address',
                      controller: _addressController,
                      prefixIcon: Icons.location_on_outlined),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 120,
                        child: AppButton(
                          text: 'Cancel',
                          type: AppButtonType.secondary,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 160,
                        child: AppButton(
                          text: 'Save Changes',
                          onPressed: () async {
                            final updatedAdmin = admin.copyWith(
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              email: _emailController.text,
                              phoneNumber: _phoneController.text,
                            );

                            ref.read(userProvider.notifier).updateUser(updatedAdmin);
                            
                            Navigator.pop(context);
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile updated successfully!'),
                                backgroundColor: AppColors.success,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.all(20),
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
        ),
      ),
    ),
  );
}

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Dialog(
          backgroundColor: Colors.transparent,
          child: SizedBox(
            width: 450,
            child: AppCard(
              padding: const EdgeInsets.all(32),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), shape: BoxShape.circle),
                              child: const Icon(Icons.shield_outlined, color: AppColors.error, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Text('Security Update', style: AppTextStyles.h2),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded, color: AppColors.textGray),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    AppInput(
                      label: 'Current Password',
                      hintText: 'Enter current password',
                      isPassword: true,
                      controller: currentPasswordController,
                      prefixIcon: Icons.lock_outline_rounded,
                    ),
                    const SizedBox(height: 24),
                    AppInput(
                      label: 'New Password',
                      hintText: 'Enter new password',
                      isPassword: true,
                      controller: newPasswordController,
                      prefixIcon: Icons.lock_reset_rounded,
                    ),
                    const SizedBox(height: 24),
                    AppInput(
                      label: 'Confirm New Password',
                      hintText: 'Confirm new password',
                      isPassword: true,
                      controller: confirmPasswordController,
                      prefixIcon: Icons.check_circle_outline_rounded,
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 120,
                          child: AppButton(
                            text: 'Cancel',
                            type: AppButtonType.secondary,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 180,
                          child: AppButton(
                            text: 'Update Password',
                            isLoading: isSaving,
                            onPressed: () async {
                              if (newPasswordController.text.isEmpty || currentPasswordController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please fill all fields')),
                                );
                                return;
                              }
                              
                              if (newPasswordController.text != confirmPasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('New passwords do not match!'), backgroundColor: AppColors.error),
                                );
                                return;
                              }

                              setModalState(() => isSaving = true);
                              await Future.delayed(const Duration(seconds: 2));
                              
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Password updated successfully!'),
                                    backgroundColor: AppColors.success,
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.all(20),
                                  ),
                                );
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
        ),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.borderGray, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 24),
            Text('Update Profile Picture', style: AppTextStyles.h3),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  color: AppColors.teal,
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                _buildSourceOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  color: AppColors.darkNavy,
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 12),
          Text(label, style: AppTextStyles.bodyRegular.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    
    if (image != null) {
      final admin = ref.read(userProvider).firstWhere((u) => u.role == UserRole.admin);
      final updatedAdmin = admin.copyWith(profileImage: image.path);
      
      ref.read(userProvider.notifier).updateUser(updatedAdmin);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile picture updated successfully!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(20),
          ),
        );
      }
    }
  }
}
