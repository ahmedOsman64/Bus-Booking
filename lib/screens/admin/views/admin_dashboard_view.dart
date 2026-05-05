import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/app_card.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isDesktop) ...[
                  _buildHeader(context),
                  const SizedBox(height: 32),
                ],
                _buildQuickStats(context, isDesktop),
                const SizedBox(height: 32),
                _buildQuickActions(),
                const SizedBox(height: 32),
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildRecentBookings(),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 1,
                        child: _buildRevenueSummary(),
                      ),
                    ],
                  )
                else ...[
                  _buildRecentBookings(),
                  const SizedBox(height: 32),
                  _buildRevenueSummary(),
                ],
                const SizedBox(height: 32), // Bottom padding
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello, Admin 👋', style: AppTextStyles.h1),
            Text('Here is what\'s happening today.', style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textGray)),
          ],
        ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: AppColors.darkNavy),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 16),
            const CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.teal,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context, bool isDesktop) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isDesktop ? 4 : (MediaQuery.of(context).size.width > 500 ? 2 : 1),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isDesktop ? 1.4 : 1.6,
      children: [
        _buildGradientStatCard('Total Revenue', '\$4,240', '+12%', Icons.payments_rounded, const [Color(0xFF11998e), Color(0xFF38ef7d)]),
        _buildGradientStatCard('Total Bookings', '1,256', '+5%', Icons.confirmation_number_rounded, const [Color(0xFF2F80ED), Color(0xFF56CCF2)]),
        _buildGradientStatCard('Active Buses', '24', 'Online', Icons.directions_bus_rounded, const [Color(0xFFF2994A), Color(0xFFF2C94C)]),
        _buildGradientStatCard('Total Users', '3,890', '+18%', Icons.people_rounded, const [Color(0xFF8E2DE2), Color(0xFF4A00E0)]),
      ],
    );
  }

  Widget _buildGradientStatCard(String title, String value, String trend, IconData icon, List<Color> gradientColors) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(trend, style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppTextStyles.h2.copyWith(color: Colors.white, fontSize: 28)),
              Text(title, style: AppTextStyles.bodyRegular.copyWith(color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: AppTextStyles.h3),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildActionChip('Add Route', Icons.add_road_rounded, AppColors.teal),
              _buildActionChip('Assign Bus', Icons.directions_bus_rounded, AppColors.warning),
              _buildActionChip('Manage Drivers', Icons.badge_rounded, AppColors.info),
              _buildActionChip('Promotions', Icons.local_offer_rounded, AppColors.success),
              _buildActionChip('Reports', Icons.analytics_rounded, AppColors.completed),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionChip(String label, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Text(label, style: AppTextStyles.bodyRegular.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentBookings() {
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Bookings', style: AppTextStyles.h3),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.teal,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            separatorBuilder: (context, index) => const Divider(height: 24, color: AppColors.borderGray),
            itemBuilder: (context, index) {
              final status = index % 3 == 0 ? 'Pending' : (index % 4 == 0 ? 'Cancelled' : 'Completed');
              final statusColor = status == 'Completed' ? AppColors.success : (status == 'Pending' ? AppColors.warning : AppColors.error);

              return Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.mediumGray,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.person_outline_rounded, color: AppColors.teal),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Passenger ${index + 1}', style: AppTextStyles.bodyRegular.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Mogadishu → Afgooye • 10:30 AM', style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('\$15.00', style: AppTextStyles.bodyRegular.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          status,
                          style: AppTextStyles.caption.copyWith(color: statusColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueSummary() {
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Revenue Overview', style: AppTextStyles.h3),
          const SizedBox(height: 24),
          Center(
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderGray),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart_rounded, size: 48, color: AppColors.textGray.withValues(alpha: 0.5)),
                    const SizedBox(height: 8),
                    Text('Chart Data Unavailable', style: TextStyle(color: AppColors.textGray.withValues(alpha: 0.8))),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniStat('Today', '\$450'),
              _buildMiniStat('This Week', '\$3,240'),
              _buildMiniStat('This Month', '\$12,500'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: AppColors.teal)),
      ],
    );
  }
}
