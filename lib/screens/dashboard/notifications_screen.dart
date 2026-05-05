import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Unread', 'Updates', 'Account'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: _buildFilterChips(),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionHeader('Recent'),
                _buildNotificationItem(0, isUnread: true),
                _buildNotificationItem(1, isUnread: true),
                const SizedBox(height: 20),
                _buildSectionHeader('Earlier'),
                _buildNotificationItem(2),
                _buildNotificationItem(3),
                _buildNotificationItem(4),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.darkNavy,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Notifications',
          style: AppTextStyles.h3.copyWith(color: Colors.white),
        ),
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.darkNavy, AppColors.teal],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.done_all, color: Colors.white70),
          tooltip: 'Mark all as read',
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              selectedColor: AppColors.teal.withValues(alpha: 0.2),
              checkmarkColor: AppColors.teal,
              labelStyle: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.teal : AppColors.textGray,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? AppColors.teal : Colors.transparent,
                  width: 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: AppTextStyles.label.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildNotificationItem(int index, {bool isUnread = false}) {
    final titles = [
      'Booking Confirmed',
      'Travel Reminder',
      'Payment Received',
      'New Feedback Requested',
      'Travel Schedule Updated'
    ];
    final messages = [
      'Your booking for Mogadishu to Afgooye has been confirmed.',
      'Your travel starts in 1 hour. Please be at the station.',
      'We have received your payment for ticket #B12345.',
      'How was your trip yesterday? Please share your feedback.',
      'The departure time for your trip tomorrow has changed to 09:00 AM.'
    ];
    final times = ['2m ago', '1h ago', '3h ago', 'Yesterday', '2 days ago'];
    final icons = [
      Icons.check_circle,
      Icons.alarm,
      Icons.account_balance_wallet,
      Icons.star,
      Icons.sync_problem
    ];
    final colors = [
      AppColors.success,
      Colors.orange,
      AppColors.teal,
      Colors.amber,
      AppColors.error
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        padding: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: isUnread ? AppColors.teal : Colors.transparent,
                width: 4,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors[index % colors.length].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icons[index % icons.length],
                    color: colors[index % colors.length],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              titles[index % titles.length],
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: isUnread ? FontWeight.bold : FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            times[index % times.length],
                            style: AppTextStyles.caption.copyWith(
                              color: isUnread ? AppColors.teal : AppColors.textGray,
                              fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        messages[index % messages.length],
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textGray,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (isUnread)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 4),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.teal,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
