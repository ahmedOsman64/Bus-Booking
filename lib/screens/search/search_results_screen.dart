import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../booking/travel_detail_screen.dart';

class SearchResultsScreen extends StatelessWidget {
  final String origin;
  final String destination;
  final DateTime date;

  const SearchResultsScreen({
    super.key,
    required this.origin,
    required this.destination,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: Column(
          children: [
            Text('$origin → $destination', style: AppTextStyles.h4.copyWith(color: Colors.white)),
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.8)),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 5, // Mock data
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildTravelCard(context, index),
          );
        },
      ),
    );
  }

  Widget _buildTravelCard(BuildContext context, int index) {
    final times = ['08:00 AM', '10:00 AM', '01:00 PM', '03:00 PM', '05:00 PM'];
    final prices = ['\$5.00', '\$6.00', '\$5.50', '\$7.00', '\$5.00'];
    final buses = ['Toyota Coaster', 'Isuzu Journey', 'Hyundai County', 'Nissan Civilian', 'Toyota Hiace'];

    return AppCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TravelDetailScreen(
              origin: origin,
              destination: destination,
              time: times[index % times.length],
              price: prices[index % prices.length],
              bus: buses[index % buses.length],
            ),
          ),
        );
      },
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          times[index % times.length],
                          style: AppTextStyles.h2.copyWith(color: AppColors.darkNavy),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.directions_bus_filled_rounded, size: 14, color: AppColors.textGray),
                            const SizedBox(width: 6),
                            Text(
                              buses[index % buses.length],
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGray),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          prices[index % prices.length],
                          style: AppTextStyles.h2.copyWith(color: AppColors.teal),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'per person',
                          style: AppTextStyles.caption.copyWith(color: AppColors.textGray),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildFeatureIcon(Icons.ac_unit_rounded, 'AC'),
                    const SizedBox(width: 12),
                    _buildFeatureIcon(Icons.wifi_rounded, 'WiFi'),
                    const SizedBox(width: 12),
                    _buildFeatureIcon(Icons.battery_charging_full_rounded, 'Power'),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.airline_seat_recline_normal_rounded, size: 16, color: AppColors.success),
                        const SizedBox(width: 4),
                        Text(
                          '12 left',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.darkNavy.withValues(alpha: 0.03),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '4.8',
                      style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 4),
                    Text('(120 reviews)', style: AppTextStyles.caption.copyWith(color: AppColors.textGray)),
                  ],
                ),
                Text(
                  'VIEW DETAILS',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.teal,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.teal),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10)),
        ],
      ),
    );
  }
}
