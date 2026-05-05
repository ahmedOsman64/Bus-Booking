import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_input.dart';

class PassengerInfoScreen extends StatefulWidget {
  final List<int> seatNumbers;
  final String origin;
  final String destination;
  final String time;
  final String price;
  final String bus;

  const PassengerInfoScreen({
    super.key,
    required this.seatNumbers,
    required this.origin,
    required this.destination,
    required this.time,
    required this.price,
    required this.bus,
  });

  @override
  State<PassengerInfoScreen> createState() => _PassengerInfoScreenState();
}

class _PassengerInfoScreenState extends State<PassengerInfoScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _idController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text('Passenger Info'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTripSummary(),
            const SizedBox(height: 32),
            Text('Primary Passenger', style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildPassengerForm(),
            const SizedBox(height: 32),
            Text('Emergency Contact', style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildEmergencyForm(),
            const SizedBox(height: 40),
            AppButton(
              text: 'Review & Pay',
              onPressed: () => _showConfirmationDialog(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTripSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkNavy,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Trip Details', style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.lightMint.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.seatNumbers.length > 1 
                      ? '${widget.seatNumbers.length} SEATS SELECTED' 
                      : 'SEAT #${widget.seatNumbers.first}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.lightMint, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.origin, style: AppTextStyles.h4.copyWith(color: Colors.white)),
                  Text(widget.time, style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                ],
              ),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white38),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(widget.destination, style: AppTextStyles.h4.copyWith(color: Colors.white)),
                  Text('10:00 AM', style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white12),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.event_seat_rounded, color: AppColors.lightMint, size: 16),
              const SizedBox(width: 8),
              Text(
                'Seats: ${widget.seatNumbers.join(', ')}',
                style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          AppInput(
            label: 'Main Passenger / Contact Name',
            hintText: 'Enter full name',
            controller: _nameController,
            prefixIcon: Icons.person_outline_rounded,
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
            label: 'ID / Passport Number',
            hintText: 'Enter ID number',
            controller: _idController,
            prefixIcon: Icons.badge_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          AppInput(
            label: 'Contact Name',
            hintText: 'Name of emergency contact',
            controller: _emergencyNameController,
            prefixIcon: Icons.person_add_alt_1_outlined,
          ),
          const SizedBox(height: 20),
          AppInput(
            label: 'Contact Phone',
            hintText: 'Phone of emergency contact',
            controller: _emergencyPhoneController,
            prefixIcon: Icons.contact_phone_outlined,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(color: AppColors.borderGray, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 32),
            Text('Booking Confirmation', style: AppTextStyles.h2),
            const SizedBox(height: 12),
            Text('Please confirm the details below before proceeding to payment.', textAlign: TextAlign.center, style: AppTextStyles.bodyRegular),
            const SizedBox(height: 32),
            _buildReviewItem('Main Contact', _nameController.text),
            _buildReviewItem('Seats Selected', '${widget.seatNumbers.length} (${widget.seatNumbers.join(', ')})'),
            _buildReviewItem('Route', '${widget.origin} → ${widget.destination}'),
            const Divider(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Amount', style: AppTextStyles.bodyLarge),
                Text(widget.price, style: AppTextStyles.h2.copyWith(color: AppColors.teal)),
              ],
            ),
            const SizedBox(height: 32),
            AppButton(
              text: 'Confirm & Pay',
              onPressed: () {
                Navigator.pop(context);
                _showFinalSuccessDialog();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGray)),
          Text(value, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showFinalSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 80),
            const SizedBox(height: 24),
            Text('Payment Successful!', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text('Your trip is confirmed. We\'ve sent the ticket to your phone.', textAlign: TextAlign.center, style: AppTextStyles.bodyRegular),
            const SizedBox(height: 32),
            AppButton(
              text: 'View My Ticket',
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}
