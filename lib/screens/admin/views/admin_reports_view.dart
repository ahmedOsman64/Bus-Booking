import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_button.dart';

class AdminReportsView extends StatefulWidget {
  const AdminReportsView({super.key});

  @override
  State<AdminReportsView> createState() => _AdminReportsViewState();
}

class _AdminReportsViewState extends State<AdminReportsView> {
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 32),
          _buildSummaryCards(context),
          const SizedBox(height: 32),
          _buildDailyReport(),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isDesktop = constraints.maxWidth > 1100;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: isDesktop ? 2 : 1,
                    child: Column(
                      children: [
                        _buildTopRoutes(),
                        const SizedBox(height: 24),
                        _buildDemographics(),
                      ],
                    ),
                  ),
                  if (isDesktop) ...[
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildRevenueBreakdown(),
                          const SizedBox(height: 24),
                          _buildTicketStatus(),
                          const SizedBox(height: 24),
                          _buildRecentTransactions(),
                        ],
                      ),
                    ),
                  ] else ...[
                    // On mobile/tablet, show the rest below
                  ],
                ],
              );
            },
          ),
          if (MediaQuery.of(context).size.width <= 1100) ...[
            const SizedBox(height: 24),
            _buildRevenueBreakdown(),
            const SizedBox(height: 24),
            _buildTicketStatus(),
            const SizedBox(height: 24),
            _buildRecentTransactions(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('System Reports', style: AppTextStyles.h1),
            const SizedBox(height: 4),
            Text(
              'Analytics and performance metrics for the SomSafar platform.',
              style: AppTextStyles.bodyRegular.copyWith(
                color: AppColors.textGray,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _buildHeaderAction(
              Icons.calendar_today_rounded,
              'Last 30 Days',
              () {},
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 160,
              child: AppButton(
                text: 'Export Report',
                icon: Icons.ios_share_rounded,
                isLoading: _isExporting,
                onPressed: () async {
                  setState(() => _isExporting = true);
                  await Future.delayed(const Duration(seconds: 2));
                  if (context.mounted) {
                    setState(() => _isExporting = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Report exported successfully!'),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderAction(IconData icon, String label, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.darkNavy,
        side: const BorderSide(color: AppColors.borderGray),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon, size: 20),
      label: Text(label),
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 1200;
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Total Revenue',
            '\$45,230.50',
            Icons.account_balance_wallet_rounded,
            AppColors.success,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildSummaryCard(
            'Tickets Sold',
            '2,845',
            Icons.confirmation_number_rounded,
            AppColors.teal,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildSummaryCard(
            'Active Routes',
            '12',
            Icons.map_rounded,
            AppColors.info,
          ),
        ),
        if (isDesktop) ...[
          const SizedBox(width: 20),
          Expanded(
            child: _buildSummaryCard(
              'Growth Rate',
              '+14.2%',
              Icons.trending_up_rounded,
              AppColors.warning,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: AppTextStyles.h2),
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textGray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyReport() {
    return AppCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.analytics_outlined, color: AppColors.teal),
                  const SizedBox(width: 12),
                  Text('Daily Performance Overview', style: AppTextStyles.h3),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Live Updates',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              _buildDailyMetric(
                'Today\'s Revenue',
                '\$2,450.00',
                Icons.payments_rounded,
                AppColors.success,
                '+12.5%',
              ),
              const SizedBox(width: 40),
              _buildDailyMetric(
                'Today\'s Tickets',
                '142',
                Icons.confirmation_num_rounded,
                AppColors.teal,
                '+5.2%',
              ),
              const SizedBox(width: 40),
              _buildDailyMetric(
                'Active Fleet',
                '8 / 12',
                Icons.directions_bus_rounded,
                AppColors.info,
                'Stable',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyMetric(
    String label,
    String value,
    IconData icon,
    Color color,
    String trend,
  ) {
    final isPositive = trend.contains('+');
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.textGray),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: AppTextStyles.h1.copyWith(fontSize: 28)),
              const SizedBox(width: 12),
              if (trend != 'Stable')
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: (isPositive ? AppColors.success : AppColors.error)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    trend,
                    style: AppTextStyles.caption.copyWith(
                      color: isPositive ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopRoutes() {
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Top Performing Routes', style: AppTextStyles.h3),
              _buildViewAllButton(() {}),
            ],
          ),
          const SizedBox(height: 24),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (context, index) =>
                const Divider(height: 32, color: AppColors.borderGray),
            itemBuilder: (context, index) {
              final names = [
                'Mogadishu → Kismayo',
                'Mogadishu → Afgooye',
                'Garowe → Bosaso',
                'Hargeisa → Berbera',
                'Baidabo → Mogadishu',
              ];
              return Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '#${index + 1}',
                        style: AppTextStyles.h4.copyWith(color: AppColors.teal),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          names[index],
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${450 - (index * 40)} Tickets Sold',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${12400 - (index * 1500)}',
                        style: AppTextStyles.h4.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                      Text('This month', style: AppTextStyles.caption),
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

  Widget _buildRevenueBreakdown() {
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Revenue by Channel', style: AppTextStyles.h3),
          const SizedBox(height: 24),
          _buildProgressRow('EVC Plus', 0.65, AppColors.teal),
          const SizedBox(height: 20),
          _buildProgressRow('eDahab', 0.25, AppColors.info),
          const SizedBox(height: 20),
          _buildProgressRow('Direct Cash', 0.10, AppColors.warning),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String label, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodyRegular),
            Text(
              '${(percentage * 100).toInt()}%',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: AppColors.lightGray,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildDemographics() {
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Passenger Demographics', style: AppTextStyles.h3),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildDemographicItem(
                      'Male Passengers',
                      0.65,
                      AppColors.teal,
                    ),
                    const SizedBox(height: 20),
                    _buildDemographicItem(
                      'Female Passengers',
                      0.35,
                      AppColors.error,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
              Expanded(
                child: Column(
                  children: [
                    _buildDemographicItem(
                      'Regular Commuters',
                      0.80,
                      AppColors.info,
                    ),
                    const SizedBox(height: 20),
                    _buildDemographicItem(
                      'One-time Travelers',
                      0.20,
                      AppColors.warning,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDemographicItem(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodySmall),
            Text(
              '${(value * 100).toInt()}%',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: AppColors.lightGray,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildTicketStatus() {
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ticket Status Distribution', style: AppTextStyles.h3),
          const SizedBox(height: 24),
          _buildStatusDot('Completed Trips', '2,420', AppColors.success),
          const SizedBox(height: 16),
          _buildStatusDot('Pending Boarding', '320', AppColors.warning),
          const SizedBox(height: 16),
          _buildStatusDot('Cancelled / Refunds', '105', AppColors.error),
        ],
      ),
    );
  }

  Widget _buildStatusDot(String label, String count, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 16),
        Expanded(child: Text(label, style: AppTextStyles.bodyRegular)),
        Text(
          count,
          style: AppTextStyles.bodyRegular.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Transactions', style: AppTextStyles.h3),
              _buildViewAllButton(() {}),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (context, index) =>
                const Divider(height: 24, color: AppColors.borderGray),
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.success.withValues(
                          alpha: 0.1,
                        ),
                        child: const Icon(
                          Icons.arrow_downward_rounded,
                          size: 14,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TRX-98${index}7',
                            style: AppTextStyles.bodyRegular.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Today, 10:${index}5 AM',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    '+\$25.00',
                    style: AppTextStyles.bodyRegular.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildViewAllButton(VoidCallback onTap) {
    return TextButton.icon(
      onPressed: onTap,
      icon: const Text(
        'View All',
        style: TextStyle(color: AppColors.teal, fontWeight: FontWeight.bold),
      ),
      label: const Icon(
        Icons.chevron_right_rounded,
        size: 18,
        color: AppColors.teal,
      ),
    );
  }
}
