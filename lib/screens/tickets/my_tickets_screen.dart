import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import 'ticket_detail_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/booking_provider.dart';
import '../../core/models/booking_model.dart';

class MyTicketsScreen extends ConsumerWidget {
  const MyTicketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        body: Column(
          children: [
            // Premium Header with TabBar
            Stack(
              children: [
                Container(
                  height: 180,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.darkNavy, AppColors.teal],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'My Tickets',
                              style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 24),
                            ),
                            const Icon(Icons.history_rounded, color: Colors.white70),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TabBar(
                        indicatorColor: AppColors.lightMint,
                        indicatorWeight: 3,
                        indicatorSize: TabBarIndicatorSize.label,
                        dividerColor: Colors.transparent,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
                        labelStyle: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                        unselectedLabelStyle: AppTextStyles.bodyLarge,
                        tabs: const [
                          Tab(text: 'Active'),
                          Tab(text: 'Past Trips'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Content
            Expanded(
              child: TabBarView(
                children: [
                  _buildTicketsList(context, ref, true),
                  _buildTicketsList(context, ref, false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketsList(BuildContext context, WidgetRef ref, bool isActive) {
    final bookings = ref.watch(bookingProvider);
    
    // Simple filter: confirmed = active, others = past (or based on date)
    final filteredBookings = isActive 
        ? bookings.where((b) => b.status == BookingStatus.confirmed).toList()
        : bookings.where((b) => b.status == BookingStatus.cancelled).toList();
    
    if (filteredBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.confirmation_number_outlined, size: 80, color: AppColors.textGray.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              isActive ? 'No active tickets' : 'No past trips',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textGray),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      itemCount: filteredBookings.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: _buildTicketCard(context, filteredBookings[index]),
        );
      },
    );
  }

  Widget _buildTicketCard(BuildContext context, Booking booking) {
    final bool isActive = booking.status == BookingStatus.confirmed;
    return AppCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TicketDetailScreen(
              bookingId: booking.id,
              origin: booking.origin,
              destination: booking.destination,
              date: booking.travelDate,
              time: booking.travelTime,
              seat: booking.seatNumbers.join(', '),
              bus: booking.busName,
              price: '\$${booking.totalFare.toStringAsFixed(2)}',
            ),
          ),
        );
      },
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.teal.withValues(alpha: 0.03) : AppColors.mediumGray.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.confirmation_number_rounded, color: AppColors.teal.withValues(alpha: 0.5), size: 16),
                        const SizedBox(width: 8),
                        Text(
                          booking.id.split('-').last,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textGray,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    _buildStatusBadge(isActive),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildLocationInfo(booking.origin, booking.travelTime, true),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Row(
                                children: List.generate(
                                  12,
                                  (index) => Expanded(
                                    child: Container(
                                      height: 1.5,
                                      margin: const EdgeInsets.symmetric(horizontal: 2),
                                      color: index % 2 == 0 ? AppColors.borderGray : Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.directions_bus_rounded, color: AppColors.teal, size: 18),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        _buildLocationInfo(booking.destination, 'Arrival', false),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.lightGray,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTicketInfo('Date', booking.travelDate),
                          _buildTicketInfo('Seats', booking.seatNumbers.join(', ')),
                          _buildTicketInfo('Price', '\$${booking.totalFare.toStringAsFixed(2)}', isAccent: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Ticket Cutouts (Visual only)
          Positioned(
            left: -8,
            top: 48,
            child: Container(
              height: 16,
              width: 16,
              decoration: const BoxDecoration(color: AppColors.lightGray, shape: BoxShape.circle),
            ),
          ),
          Positioned(
            right: -8,
            top: 48,
            child: Container(
              height: 16,
              width: 16,
              decoration: const BoxDecoration(color: AppColors.lightGray, shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.success : AppColors.textGray.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? 'ACTIVE' : 'PAST',
        style: AppTextStyles.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLocationInfo(String city, String time, bool isStart) {
    return Column(
      crossAxisAlignment: isStart ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          time,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGray),
        ),
        const SizedBox(height: 4),
        Text(
          city,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTicketInfo(String label, String value, {bool isAccent = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textGray)),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyRegular.copyWith(
            fontWeight: FontWeight.bold,
            color: isAccent ? AppColors.success : AppColors.textDark,
          ),
        ),
      ],
    );
  }
}
