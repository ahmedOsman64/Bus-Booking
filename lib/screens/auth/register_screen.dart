import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_input.dart';
import '../../core/services/supabase_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

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
                  Form(
                    key: _formKey,
                    child: Container(
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
                            hintText: 'Enter your full name',
                            controller: _nameController,
                            prefixIcon: Icons.person_outline_rounded,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Full name is required';
                              }
                              if (value.length < 3) {
                                return 'Name must be at least 3 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          AppInput(
                            label: 'Email Address',
                            hintText: 'Enter your email',
                            controller: _emailController,
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          AppInput(
                            label: 'Phone Number',
                            hintText: 'Enter your phone number',
                            controller: _phoneController,
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Phone number is required';
                              }
                              // Basic Somali phone validation: starts with +252 or 252 or 0 and has correct length
                              if (!RegExp(r'^(\+252|252|0)?[6-7][0-9]{8}$').hasMatch(value.replaceAll(' ', ''))) {
                                return 'Enter a valid Somali phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          AppInput(
                            label: 'Password',
                            hintText: 'Enter your password',
                            controller: _passwordController,
                            isPassword: _obscurePassword,
                            prefixIcon: Icons.lock_outline_rounded,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              return null;
                            },
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
                            isLoading: _isLoading,
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;

                              final name = _nameController.text.trim();
                              final email = _emailController.text.trim();
                              final phone = _phoneController.text.trim();
                              final password = _passwordController.text;

                              setState(() => _isLoading = true);

                              try {
                                if (!SupabaseService.isInitialized) {
                                  throw Exception('Supabase is not configured yet.');
                                }

                                final names = name.split(' ');
                                final firstName = names[0];
                                final lastName = names.length > 1 ? names.sublist(1).join(' ') : '';

                                final response = await SupabaseService.signUp(
                                  email: email,
                                  password: password,
                                  data: {
                                    'first_name': firstName,
                                    'last_name': lastName,
                                    'phone_number': phone,
                                    'role': 'passenger',
                                  },
                                );

                                if (response.user != null) {
                                  // Create profile entry
                                  await SupabaseService.client.from('profiles').insert({
                                    'id': response.user!.id,
                                    'first_name': firstName,
                                    'last_name': lastName,
                                    'email': email,
                                    'phone_number': phone,
                                    'role': 'passenger',
                                    'status': 'active',
                                  });

                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Account created successfully! Please login.'),
                                      backgroundColor: AppColors.success,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              } catch (e) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Registration failed: $e'),
                                    backgroundColor: AppColors.error,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              } finally {
                                if (mounted) setState(() => _isLoading = false);
                              }
                            },
                          ),
                        ],
                      ),
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
