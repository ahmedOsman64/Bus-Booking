import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_input.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.pageBackgroundGradient,
            ),
          ),
          
          Positioned(
            bottom: -100,
            right: -100,
            child: _buildDecorativeCircle(AppColors.darkNavy.withValues(alpha: 0.05), 300),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.darkNavy,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.darkNavy.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.security_rounded,
                        color: AppColors.lightMint,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    Text(
                      'Reset Password',
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.darkNavy,
                        fontSize: 32,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your new password must be different from previously used passwords.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 48),
                    
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          AppInput(
                            label: 'New Password',
                            hintText: 'Enter new password',
                            controller: _passwordController,
                            isPassword: _obscurePassword,
                            prefixIcon: Icons.lock_outline_rounded,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                color: AppColors.textGray,
                                size: 20,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          const SizedBox(height: 24),
                          AppInput(
                            label: 'Confirm Password',
                            hintText: 'Re-enter new password',
                            controller: _confirmPasswordController,
                            isPassword: _obscurePassword,
                            prefixIcon: Icons.lock_clock_outlined,
                          ),
                          const SizedBox(height: 40),
                          AppButton(
                            text: 'Reset Password',
                            isLoading: _isLoading,
                            onPressed: () async {
                              if (_passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please fill all fields')),
                                );
                                return;
                              }
                              if (_passwordController.text != _confirmPasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Passwords do not match')),
                                );
                                return;
                              }

                              setState(() => _isLoading = true);
                              
                              // Simulate reset
                              await Future.delayed(const Duration(seconds: 2));
                              
                              if (!context.mounted) return;
                              setState(() => _isLoading = false);
                              _showSuccessDialog(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 60),
            ),
            const SizedBox(height: 24),
            Text('Password Reset!', style: AppTextStyles.h2),
            const SizedBox(height: 12),
            Text(
              'Your password has been successfully reset. You can now login with your new password.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textGray),
            ),
            const SizedBox(height: 32),
            AppButton(
              text: 'Back to Login',
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDecorativeCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
