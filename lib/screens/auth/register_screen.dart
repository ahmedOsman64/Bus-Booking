import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.pageBackgroundGradient,
            ),
          ),

          // Decorative Elements
          Positioned(
            top: -80,
            left: -80,
            child: _buildDecorativeCircle(AppColors.teal.withValues(alpha: 0.05), 300),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: _buildDecorativeCircle(AppColors.lightMint.withValues(alpha: 0.08), 250),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.darkNavy),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Create Account',
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.darkNavy,
                      fontSize: 34,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join us and start your journey today',
                    style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textGray),
                  ),
                  const SizedBox(height: 40),

                  // Form Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.darkNavy.withValues(alpha: 0.05),
                          blurRadius: 40,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        AppInput(
                          label: 'Full Name',
                          hintText: 'John Doe',
                          controller: _nameController,
                          prefixIcon: Icons.person_outline_rounded,
                        ),
                        const SizedBox(height: 20),
                        AppInput(
                          label: 'Email Address',
                          hintText: 'john@example.com',
                          controller: _emailController,
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        AppInput(
                          label: 'Phone Number',
                          hintText: '+252 61 XXX XXXX',
                          controller: _phoneController,
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 20),
                        AppInput(
                          label: 'Password',
                          hintText: '••••••••',
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
                        const SizedBox(height: 32),
                        AppButton(
                          text: 'Create Account',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Footer
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textGray),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'Login',
                            style: AppTextStyles.bodyRegular.copyWith(
                              color: AppColors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
