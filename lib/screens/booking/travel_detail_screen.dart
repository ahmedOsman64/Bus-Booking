import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import 'booking_screen.dart';

class TravelDetailScreen extends StatelessWidget {
  final String origin;
  final String destination;
  final String time;
  final String price;
  final String bus;
  final DateTime travelDate;

  const TravelDetailScreen({
    super.key,
    required this.origin,
    required this.destination,
    required this.time,
    required this.price,
    required this.bus,
    required this.travelDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRouteSection(),
                  const SizedBox(height: 32),
                  _buildBusInfoSection(),
                  const SizedBox(height: 32),
                  _buildFacilitiesSection(),
                  const SizedBox(height: 32),
                  _buildPolicySection(),
                  const SizedBox(height: 100), // Bottom padding for button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomBar(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      backgroundColor: AppColors.darkNavy,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Placeholder image for the bus
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black54, Colors.transparent],
                ),
              ),
              child: const Icon(Icons.directions_bus_rounded, color: Colors.white24, size: 120),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.lightMint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'PREMIUM CLASS',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.darkNavy,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    bus,
                    style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 28),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildLocationRow(origin, time, 'Departure'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Icon(Icons.more_vert_rounded, color: AppColors.borderGray),
                SizedBox(width: 16),
                Expanded(child: Divider(color: AppColors.borderGray)),
              ],
            ),
          ),
          _buildLocationRow(destination, '10:00 AM', 'Arrival'),
        ],
      ),
    );
  }

  Widget _buildLocationRow(String city, String time, String label) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.teal.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            label == 'Departure' ? Icons.trip_origin_rounded : Icons.location_on_rounded,
            color: AppColors.teal,
            size: 20,
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textGray)),
            const SizedBox(height: 4),
            Text(city, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
            Text(time, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGray)),
          ],
        ),
      ],
    );
  }

  Widget _buildBusInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Vehicle Information', style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoCard(Icons.airline_seat_recline_normal_rounded, '30 Seats', 'Total Capacity'),
            _buildInfoCard(Icons.speed_rounded, '80 km/h', 'Avg. Speed'),
            _buildInfoCard(Icons.star_rounded, '4.8', 'Rating'),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String value, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.teal, size: 24),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
          Text(label, style: AppTextStyles.caption.copyWith(fontSize: 8)),
        ],
      ),
    );
  }

  Widget _buildFacilitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Facilities', style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildFacilityChip(Icons.ac_unit_rounded, 'Air Conditioning'),
            _buildFacilityChip(Icons.wifi_rounded, 'Free Wi-Fi'),
            _buildFacilityChip(Icons.battery_charging_full_rounded, 'USB Charging'),
            _buildFacilityChip(Icons.tv_rounded, 'Entertainment'),
            _buildFacilityChip(Icons.local_cafe_rounded, 'Complimentary Drink'),
          ],
        ),
      ],
    );
  }

  Widget _buildFacilityChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.teal),
          const SizedBox(width: 8),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Widget _buildPolicySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Travel Policies', style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildPolicyItem('Check-in 30 mins before departure.'),
        _buildPolicyItem('Max luggage weight: 20kg per person.'),
        _buildPolicyItem('Refund available up to 24h before travel.'),
      ],
    );
  }

  Widget _buildPolicyItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline_rounded, color: AppColors.success, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: AppTextStyles.bodySmall)),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Price', style: AppTextStyles.caption),
              Text(price, style: AppTextStyles.h2.copyWith(color: AppColors.teal)),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: AppButton(
              text: 'Select Seat',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingScreen(
                      origin: origin,
                      destination: destination,
                      time: time,
                      price: price,
                      bus: bus,
                      travelDate: travelDate,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
