import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../search/search_results_screen.dart';
import '../search/search_tab_screen.dart';

import '../tickets/my_tickets_screen.dart';
import '../profile/booking_history_screen.dart';
import '../profile/profile_screen.dart';
import 'notifications_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/route_provider.dart';
import '../../core/providers/booking_provider.dart';
import '../../core/providers/user_provider.dart';
import '../../core/models/booking_model.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentIndex = 0;

  String? _selectedOrigin;
  String? _selectedDestination;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHome();
      case 1:
        return const SearchTabScreen();
      case 2:
        return const MyTicketsScreen();
      case 3:
        return const NotificationsScreen();
      case 4:
        return const ProfileScreen();
      default:
        return _buildHome();
    }
  }

  Widget _buildHome() {
    final routes = ref.watch(routeProvider);
    final bookings = ref.watch(bookingProvider);
    final user = ref.watch(userProvider);
    
    final origins = routes.map((r) => r.origin).toSet().toList();
    final destinations = routes.map((r) => r.destination).toSet().toList();
    
    // Find latest confirmed booking
    final upcomingBooking = bookings.isNotEmpty 
        ? (bookings.where((b) => b.status == BookingStatus.confirmed).toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt)))
        : [];

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Stack(
            children: [
              Container(
                height: 300,
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
              Positioned(
                top: -50,
                right: -50,
                child: CircleAvatar(
                  radius: 120,
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(user.isNotEmpty ? user.first.firstName : 'Ahmed'),
                    const SizedBox(height: 32),
                    _buildSearchCard(origins, destinations),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Recent Searches Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 0, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Popular Routes', style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 100,
                  child: routes.isEmpty 
                    ? Center(child: Text('Loading routes...', style: AppTextStyles.caption))
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: routes.length > 5 ? 5 : routes.length,
                        itemBuilder: (context, index) {
                          return _buildRecentSearchItem(routes[index].origin, routes[index].destination);
                        },
                      ),
                ),
              ],
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Upcoming Trips', style: AppTextStyles.h3.copyWith(fontSize: 20)),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BookingHistoryScreen()),
                      ),
                      child: Text(
                        'See All',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                upcomingBooking.isEmpty 
                    ? _buildEmptyState()
                    : _buildUpcomingTripCard(upcomingBooking.first as Booking),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Icon(Icons.directions_bus_outlined, size: 48, color: AppColors.textGray.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text('No upcoming trips', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textGray)),
          const SizedBox(height: 8),
          Text('Your confirmed bookings will appear here.', style: AppTextStyles.caption, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildHeader(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $name!',
              style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 28),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.location_on_rounded, color: AppColors.lightMint.withValues(alpha: 0.8), size: 14),
                const SizedBox(width: 4),
                Text(
                  'Mogadishu, Somalia',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () => setState(() => _currentIndex = 4),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.lightMint.withValues(alpha: 0.5), width: 2),
            ),
            child: const CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.teal,
              child: Icon(Icons.person_rounded, color: Colors.white, size: 30),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchCard(List<String> origins, List<String> destinations) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkNavy.withValues(alpha: 0.1),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSearchField(
            icon: Icons.trip_origin_rounded,
            iconColor: AppColors.teal,
            label: 'From',
            value: _selectedOrigin ?? 'Select Origin',
            onTap: () => _showSelectionModal('Origin', origins, (val) {
              setState(() => _selectedOrigin = val);
            }),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(child: Divider(color: AppColors.borderGray)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderGray),
                ),
                child: const Icon(Icons.swap_vert_rounded, color: AppColors.teal, size: 20),
              ),
              const Expanded(child: Divider(color: AppColors.borderGray)),
            ],
          ),
          const SizedBox(height: 16),
          _buildSearchField(
            icon: Icons.location_on_rounded,
            iconColor: AppColors.warmCoral,
            label: 'To',
            value: _selectedDestination ?? 'Select Destination',
            onTap: () => _showSelectionModal('Destination', destinations, (val) {
              setState(() => _selectedDestination = val);
            }),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: AppColors.borderGray),
          ),
          _buildSearchField(
            icon: Icons.calendar_today_rounded,
            iconColor: Colors.blueAccent,
            label: 'Travel Date',
            value: "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 90)),
              );
              if (date != null) {
                setState(() => _selectedDate = date);
              }
            },
          ),
          const SizedBox(height: 32),
          AppButton(
            text: 'Find My Bus',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchResultsScreen(
                    origin: _selectedOrigin ?? 'Mogadishu',
                    destination: _selectedDestination ?? 'Afgooye',
                    date: _selectedDate,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearchItem(String origin, String dest) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SearchResultsScreen(
              origin: origin,
              destination: dest,
              date: DateTime.now(),
            ),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderGray),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(origin, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_rounded, size: 12, color: AppColors.textGray),
              ],
            ),
            const SizedBox(height: 4),
            Text(dest, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('Yesterday', style: AppTextStyles.caption.copyWith(color: AppColors.textGray)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textGray)),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: value.contains('Select') ? AppColors.textGray.withValues(alpha: 0.5) : AppColors.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingTripCard(Booking booking) {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 2),
      child: Container(
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                color: AppColors.lightMint.withValues(alpha: 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'CONFIRMED',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Ticket #${booking.id.split('-').last}',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textGray),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildStationInfo(booking.origin, booking.travelTime, true),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: List.generate(
                                  10,
                                  (index) => Expanded(
                                    child: Container(
                                      height: 1,
                                      margin: const EdgeInsets.symmetric(horizontal: 2),
                                      color: index % 2 == 0 ? AppColors.borderGray : Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                              const Icon(Icons.directions_bus_rounded, color: AppColors.darkNavy, size: 20),
                            ],
                          ),
                        ),
                        _buildStationInfo(booking.destination, 'Arrival', false),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTripMeta(Icons.calendar_today_rounded, booking.travelDate),
                        _buildTripMeta(Icons.airline_seat_recline_normal_rounded, 'Seat ${booking.seatNumbers.join(', ')}'),
                        Text(
                          '\$${booking.totalFare.toStringAsFixed(2)}',
                          style: AppTextStyles.h3.copyWith(color: AppColors.darkNavy),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStationInfo(String city, String time, bool isStart) {
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

  Widget _buildTripMeta(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textGray),
        const SizedBox(width: 8),
        Text(text, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGray)),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.darkNavy,
        unselectedItemColor: AppColors.textGray.withValues(alpha: 0.5),
        selectedLabelStyle: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
        unselectedLabelStyle: AppTextStyles.caption,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_number_rounded), label: 'Tickets'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_rounded), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }

  void _showSelectionModal(String title, List<String> items, Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select $title', style: AppTextStyles.h2),
              const SizedBox(height: 24),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        tileColor: AppColors.lightGray,
                        title: Text(items[index], style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                        trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                        onTap: () {
                          onSelect(items[index]);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
