import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/services/pdf_service.dart';
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
          _buildMainDashboardSection(context),
          const SizedBox(height: 32),
          _buildTopRoutesAndRecentActivity(context),
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
              'Comprehensive analytics and platform performance metrics.',
              style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textGray),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderGray),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_rounded, size: 18, color: AppColors.textGray),
                  const SizedBox(width: 12),
                  Text('May 1, 2026 - May 31, 2026', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(width: 12),
                  const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.textGray),
                ],
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 180,
              child: AppButton(
                text: 'Export Report',
                icon: Icons.file_download_outlined,
                isLoading: _isExporting,
                onPressed: () async {
                  setState(() => _isExporting = true);
                  
                  // Collect data for PDF
                  final summaryData = [
                    {'label': 'Total Revenue', 'value': r'$45,230.50'},
                    {'label': 'Tickets Sold', 'value': '2,845'},
                    {'label': 'Active Routes', 'value': '12'},
                    {'label': 'Growth Rate', 'value': '14.2%'},
                  ];

                  final topRoutes = [
                    {'name': 'Mogadishu → Kismayo', 'revenue': r'$12,400', 'tickets': '450'},
                    {'name': 'Mogadishu → Afgooye', 'revenue': r'$9,900', 'tickets': '370'},
                    {'name': 'Garowe → Bosaso', 'revenue': r'$7,400', 'tickets': '290'},
                    {'name': 'Hargeisa → Berbera', 'revenue': r'$4,900', 'tickets': '210'},
                  ];

                  await PdfService.generateReport(
                    title: 'System Performance Report - May 2026',
                    summaryData: summaryData,
                    topRoutes: topRoutes,
                  );

                  if (context.mounted) {
                    setState(() => _isExporting = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Report generated and ready to save!'),
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

  Widget _buildSummaryCards(BuildContext context) {
    return Row(
      children: [
        _buildSummaryCard('Total Revenue', r'$45,230.50', Icons.account_balance_wallet_outlined, const Color(0xFF3383FF), '+12.5%'),
        const SizedBox(width: 20),
        _buildSummaryCard('Tickets Sold', '2,845', Icons.confirmation_number_outlined, const Color(0xFF10B981), '+5.2%'),
        const SizedBox(width: 20),
        _buildSummaryCard('Active Routes', '12', Icons.map_outlined, const Color(0xFFF59E0B), 'Stable'),
        const SizedBox(width: 20),
        _buildSummaryCard('Customer Growth', '+14.2%', Icons.trending_up_rounded, const Color(0xFF6366F1), '+2.1%'),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color, String trend) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 8)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                  child: Icon(icon, color: color, size: 22),
                ),
                if (trend != 'Stable')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text(trend, style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 10)),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Text(value, style: AppTextStyles.h1.copyWith(fontSize: 28, letterSpacing: -0.5)),
            const SizedBox(height: 4),
            Text(title, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGray, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildMainDashboardSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Revenue Chart (Simulated)
        Expanded(
          flex: 2,
          child: AppCard(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Revenue Overview', style: AppTextStyles.h3),
                        Text('Monthly earnings through various channels', style: AppTextStyles.caption),
                      ],
                    ),
                    Row(
                      children: [
                        _buildChartLegend('EVC Plus', AppColors.teal),
                        const SizedBox(width: 16),
                        _buildChartLegend('eDahab', AppColors.info),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                // Simulated Bar Chart
                SizedBox(
                  height: 240,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(12, (index) {
                      final h1 = 50.0 + (index * 15) % 120;
                      final h2 = 30.0 + (index * 10) % 80;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(width: 12, height: h1, decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.8), borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))),
                              const SizedBox(width: 4),
                              Container(width: 12, height: h2, decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.8), borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][index], style: AppTextStyles.caption.copyWith(fontSize: 10)),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),
        // Daily Performance Card
        Expanded(
          flex: 1,
          child: AppCard(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Today\'s Metrics', style: AppTextStyles.h3),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildModernDailyMetric('Daily Revenue', r'$2,450.00', Icons.payments_outlined, AppColors.success, 0.7),
                const SizedBox(height: 24),
                _buildModernDailyMetric('Trips Completed', '42 / 60', Icons.local_shipping_outlined, AppColors.teal, 0.65),
                const SizedBox(height: 24),
                _buildModernDailyMetric('Occupancy Rate', '84%', Icons.people_outline_rounded, AppColors.info, 0.84),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartLegend(String label, Color color) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildModernDailyMetric(String label, String value, IconData icon, Color color, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: AppColors.textGray),
                const SizedBox(width: 10),
                Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGray)),
              ],
            ),
            Text(value, style: AppTextStyles.bodyRegular.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.lightGray,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildTopRoutesAndRecentActivity(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: AppCard(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Top Performing Routes', style: AppTextStyles.h3),
                    TextButton(onPressed: () {}, child: Text('Full Report', style: TextStyle(color: AppColors.teal, fontWeight: FontWeight.bold))),
                  ],
                ),
                const SizedBox(height: 24),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  separatorBuilder: (context, index) => const Divider(height: 40, color: AppColors.borderGray),
                  itemBuilder: (context, index) {
                    final names = ['Mogadishu → Kismayo', 'Mogadishu → Afgooye', 'Garowe → Bosaso', 'Hargeisa → Berbera'];
                    final progress = [0.92, 0.78, 0.65, 0.45];
                    return Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
                          child: Center(child: Text('${index + 1}', style: AppTextStyles.h4.copyWith(color: AppColors.darkNavy))),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(names[index], style: AppTextStyles.bodyRegular.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(value: progress[index], backgroundColor: AppColors.lightGray, valueColor: AlwaysStoppedAnimation<Color>(AppColors.teal), minHeight: 4),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 40),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('\$${12400 - (index * 2500)}.00', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: AppColors.success)),
                            Text('${450 - (index * 80)} tickets', style: AppTextStyles.caption),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildModernRevenueByChannel(),
              const SizedBox(height: 24),
              _buildRecentActivity(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModernRevenueByChannel() {
    return AppCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Revenue Channels', style: AppTextStyles.h3),
          const SizedBox(height: 24),
          _buildChannelItem('EVC Plus', 0.65, AppColors.teal, r'$29,400'),
          const SizedBox(height: 20),
          _buildChannelItem('eDahab', 0.25, AppColors.info, r'$11,307'),
          const SizedBox(height: 20),
          _buildChannelItem('Cash', 0.10, AppColors.warning, r'$4,523'),
        ],
      ),
    );
  }

  Widget _buildChannelItem(String label, double value, Color color, String amount) {
    return Row(
      children: [
        Container(width: 4, height: 32, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                  Text(amount, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 4),
              Text('${(value * 100).toInt()}% of total volume', style: AppTextStyles.caption),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return AppCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Activity', style: AppTextStyles.h3),
          const SizedBox(height: 24),
          _buildActivityItem('Report Exported', 'Super Admin', '2 mins ago', Icons.file_download_outlined, AppColors.info),
          const SizedBox(height: 20),
          _buildActivityItem('New Route Added', 'Mog → Kis', '45 mins ago', Icons.add_road_rounded, AppColors.success),
          const SizedBox(height: 20),
          _buildActivityItem('System Backup', 'Automatic', '3 hours ago', Icons.backup_outlined, AppColors.warning),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle, String time, IconData icon, Color color) {
    return Row(
      children: [
        CircleAvatar(radius: 18, backgroundColor: color.withValues(alpha: 0.1), child: Icon(icon, size: 16, color: color)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
              Text('$subtitle • $time', style: AppTextStyles.caption),
            ],
          ),
        ),
      ],
    );
  }
}
