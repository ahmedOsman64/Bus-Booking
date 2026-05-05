import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_card.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

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
        title: Text('Booking History', style: AppTextStyles.h4),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: 3,
        itemBuilder: (context, index) {
          return _buildBookingCard(index);
        },
      ),
    );
  }

  Widget _buildBookingCard(int index) {
    final List<Map<String, String>> mockBookings = [
      {
        'route': 'Mogadishu → Baidoa',
        'date': '24 May 2026',
        'time': '08:00 AM',
        'bus': 'SomBus Express #442',
        'status': 'Completed',
        'price': '\$25.00',
        'seat': 'A12',
      },
      {
        'route': 'Kismayo → Mogadishu',
        'date': '15 May 2026',
        'time': '06:30 AM',
        'bus': 'Ocean Line #102',
        'status': 'Completed',
        'price': '\$30.00',
        'seat': 'B05',
      },
      {
        'route': 'Mogadishu → Garowe',
        'date': '02 May 2026',
        'time': '07:00 AM',
        'bus': 'Northern Star #88',
        'status': 'Completed',
        'price': '\$45.00',
        'seat': 'C02',
      },
    ];

    final booking = mockBookings[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: AppCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    booking['status']!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  booking['date']!,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGray),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.darkNavy.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.directions_bus_rounded, color: AppColors.darkNavy),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking['route']!, style: AppTextStyles.h4),
                      const SizedBox(height: 4),
                      Text(booking['bus']!, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1, color: AppColors.borderGray),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn('Departure', booking['time']!),
                _buildInfoColumn('Seat', booking['seat']!),
                _buildInfoColumn('Amount', booking['price']!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textGray)),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.bodyRegular.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
