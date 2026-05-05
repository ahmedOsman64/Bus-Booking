import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_input.dart';
import '../../widgets/app_card.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;




class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _nameController = TextEditingController(text: 'Ahmed Ali');
  final _emailController = TextEditingController(text: 'ahmed@example.com');
  final _phoneController = TextEditingController(text: '+252 612 345678');
  bool _isSaving = false;
  XFile? _pickedFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _pickedFile = image;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }



  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.darkNavy),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Personal Information', style: AppTextStyles.h4),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildAvatarSection(),
            const SizedBox(height: 32),
            AppCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  AppInput(
                    label: 'Full Name',
                    hintText: 'Enter your name',
                    controller: _nameController,
                    prefixIcon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 20),
                  AppInput(
                    label: 'Email Address',
                    hintText: 'Enter your email',
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  AppInput(
                    label: 'Phone Number',
                    hintText: 'Enter your phone',
                    controller: _phoneController,
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            AppButton(
              text: 'Save Changes',
              isLoading: _isSaving,
              onPressed: () async {
                setState(() => _isSaving = true);
                
                // Simulate save
                await Future.delayed(const Duration(seconds: 2));
                
                if (!context.mounted) return;
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
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Center(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.teal.withValues(alpha: 0.2), width: 2),
            ),
            child: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.darkNavy,
                backgroundImage: _pickedFile != null 
                  ? (kIsWeb ? NetworkImage(_pickedFile!.path) : FileImage(io.File(_pickedFile!.path))) as ImageProvider
                  : null,
                child: _pickedFile == null
                    ? const Icon(Icons.person_rounded, size: 60, color: Colors.white)
                    : null,
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.teal,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(Icons.camera_alt_rounded, size: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
