import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_button.dart';

class TicketDetailScreen extends StatelessWidget {
  final String bookingId;
  final String origin;
  final String destination;
  final String date;
  final String time;
  final String seat;
  final String bus;
  final String price;

  const TicketDetailScreen({
    super.key,
    required this.bookingId,
    required this.origin,
    required this.destination,
    required this.date,
    required this.time,
    required this.seat,
    required this.bus,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkNavy,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Ticket Details', style: AppTextStyles.h3.copyWith(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            _buildTicketContent(),
            const SizedBox(height: 32),
            AppButton(
              text: 'Download Ticket',
              onPressed: () {},
              type: AppButtonType.outline,
              icon: Icons.download_outlined,
            ),
            const SizedBox(height: 16),
            AppButton(
              text: 'Cancel Ticket',
              onPressed: () => _showCancelConfirmation(context),
              type: AppButtonType.danger,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketContent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTicketInfo('Booking ID', bookingId),
                    _buildTicketInfo('Status', 'Confirmed', color: AppColors.success),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    _buildRouteNode(origin, time, true),
                    Expanded(
                      child: Column(
                        children: [
                          const Icon(Icons.directions_bus, color: AppColors.darkNavy, size: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: List.generate(15, (index) => Expanded(
                                child: Container(
                                  height: 1,
                                  color: index % 2 == 0 ? AppColors.borderGray : Colors.transparent,
                                ),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildRouteNode(destination, '10:00 AM', false),
                  ],
                ),
                const SizedBox(height: 32),
                const Divider(color: AppColors.borderGray),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTicketInfo('Date', date),
                    _buildTicketInfo('Seat Number', '#$seat'),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTicketInfo('Bus', bus),
                    _buildTicketInfo('Price', price),
                  ],
                ),
              ],
            ),
          ),
          _buildTicketCutter(),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Text(
                  'Boarding QR Code',
                  style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderGray),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.network(
                    'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=$bookingId',
                    width: 150,
                    height: 150,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.qr_code, size: 150),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Show this QR to the driver when boarding',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketInfo(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: color ?? AppColors.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildRouteNode(String city, String time, bool isOrigin) {
    return Column(
      crossAxisAlignment: isOrigin ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(city, style: AppTextStyles.h4),
        const SizedBox(height: 4),
        Text(time, style: AppTextStyles.bodySmall),
      ],
    );
  }

  Widget _buildTicketCutter() {
    return Row(
      children: [
        Container(
          height: 30,
          width: 15,
          decoration: const BoxDecoration(
            color: AppColors.darkNavy,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: List.generate(20, (index) => Expanded(
                child: Container(
                  height: 1,
                  color: index % 2 == 0 ? AppColors.borderGray : Colors.transparent,
                ),
              )),
            ),
          ),
        ),
        Container(
          height: 30,
          width: 15,
          decoration: const BoxDecoration(
            color: AppColors.darkNavy,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
          ),
        ),
      ],
    );
  }

  void _showCancelConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.warmCoral, size: 64),
            const SizedBox(height: 24),
            Text('Cancel Ticket?', style: AppTextStyles.h2),
            const SizedBox(height: 12),
            Text(
              'Are you sure you want to cancel this booking? This action cannot be undone.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyRegular,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Keep It',
                    onPressed: () => Navigator.pop(context),
                    type: AppButtonType.secondary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppButton(
                    text: 'Yes, Cancel',
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      // Handle cancellation logic
                    },
                    type: AppButtonType.danger,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
