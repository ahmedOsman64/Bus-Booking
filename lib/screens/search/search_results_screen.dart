import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../booking/travel_detail_screen.dart';
import '../../core/providers/route_provider.dart';
import '../../core/models/route_model.dart';

class SearchResultsScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(routeProvider);
    final filteredRoutes = routes.where((r) => 
      r.origin.toLowerCase() == origin.toLowerCase() && 
      r.destination.toLowerCase() == destination.toLowerCase()
    ).toList();

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
      body: filteredRoutes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off_rounded, size: 64, color: AppColors.textGray),
                  const SizedBox(height: 16),
                  Text('No travels found for this route', style: AppTextStyles.bodyLarge),
                  const SizedBox(height: 8),
                  Text('Try another route or date', style: AppTextStyles.caption),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredRoutes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildTravelCard(context, filteredRoutes[index]),
                );
              },
            ),
    );
  }

  Widget _buildTravelCard(BuildContext context, BusRoute route) {
    return AppCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TravelDetailScreen(
              origin: route.origin,
              destination: route.destination,
              time: route.departureTime,
              price: '\$${route.price.toStringAsFixed(2)}',
              bus: route.busId,
              travelDate: date,
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
                          route.departureTime,
                          style: AppTextStyles.h2.copyWith(color: AppColors.darkNavy),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.directions_bus_filled_rounded, size: 14, color: AppColors.textGray),
                            const SizedBox(width: 6),
                            Text(
                              route.busId,
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
                          '\$${route.price.toStringAsFixed(2)}',
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
                          'Available',
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
                    Text('(New)', style: AppTextStyles.caption.copyWith(color: AppColors.textGray)),
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
