import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import 'reset_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get _otp => _otpControllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.darkNavy),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.pageBackgroundGradient,
            ),
          ),
          
          Positioned(
            top: -100,
            left: -100,
            child: _buildDecorativeCircle(AppColors.teal.withValues(alpha: 0.1), 300),
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
                        Icons.mark_email_read_rounded,
                        color: AppColors.lightMint,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    Text(
                      'Verify Email',
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.darkNavy,
                        fontSize: 32,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textGray),
                        children: [
                          const TextSpan(text: 'Please enter the 4-digit code sent to\n'),
                          TextSpan(
                            text: widget.email,
                            style: const TextStyle(
                              color: AppColors.darkNavy,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(4, (index) {
                              return SizedBox(
                                width: 60,
                                height: 70,
                                child: TextField(
                                  controller: _otpControllers[index],
                                  focusNode: _focusNodes[index],
                                  onChanged: (value) => _onOtpChanged(index, value),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  style: AppTextStyles.h2.copyWith(color: AppColors.darkNavy),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(color: AppColors.borderGray),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(color: AppColors.borderGray),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(color: AppColors.teal, width: 2),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 40),
                          AppButton(
                            text: 'Verify OTP',
                            isLoading: _isLoading,
                            onPressed: () async {
                              if (_otp.length < 4) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please enter the complete OTP')),
                                );
                                return;
                              }

                              setState(() => _isLoading = true);
                              
                              // Simulate verification
                              await Future.delayed(const Duration(seconds: 2));
                              
                              if (!mounted) return;
                              setState(() => _isLoading = false);

                              if (_otp == '1234') { // Default demo OTP
                                if (!context.mounted) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
                                );
                              } else {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Invalid OTP. Try 1234')),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 24),
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('OTP Resent!')),
                              );
                            },
                            child: Text(
                              "Didn't receive code? Resend",
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.teal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
