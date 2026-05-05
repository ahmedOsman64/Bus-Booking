import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_button.dart';

class FeedbackFormScreen extends StatefulWidget {
  final String travelTitle;

  const FeedbackFormScreen({super.key, required this.travelTitle});

  @override
  State<FeedbackFormScreen> createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  int _rating = 0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text('Give Feedback'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Icon(Icons.rate_review_outlined, size: 64, color: AppColors.darkNavy),
                  const SizedBox(height: 16),
                  Text('How was your trip?', style: AppTextStyles.h2),
                  const SizedBox(height: 8),
                  Text(
                    widget.travelTitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textGray),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            Text('Rate your experience', style: AppTextStyles.label),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: index < _rating ? Colors.amber : AppColors.textGray,
                    size: 40,
                  ),
                  onPressed: () => setState(() => _rating = index + 1),
                );
              }),
            ),
            const SizedBox(height: 40),
            Text('Write your comments', style: AppTextStyles.label),
            const SizedBox(height: 8),
            TextFormField(
              controller: _commentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Tell us what you liked or how we can improve...',
                hintStyle: AppTextStyles.bodySmall,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.borderGray),
                ),
              ),
            ),
            const SizedBox(height: 48),
            AppButton(
              text: 'Submit Feedback',
              onPressed: _rating == 0 ? () {} : () => _showSuccess(),
              type: _rating == 0 ? AppButtonType.secondary : AppButtonType.primary,
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 80),
            const SizedBox(height: 24),
            Text('Thank You!', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text(
              'Your feedback helps us improve our service for everyone.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyRegular,
            ),
            const SizedBox(height: 32),
            AppButton(
              text: 'Done',
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
