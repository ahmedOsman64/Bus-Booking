import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/providers/booking_provider.dart';

class AdminBookingsView extends ConsumerWidget {
  const AdminBookingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(bookingProvider);
    final confirmedCount = bookings.where((b) => b.status == BookingStatus.confirmed).length;
    final pendingCount = bookings.where((b) => b.status == BookingStatus.pending).length;
    final cancelledCount = bookings.where((b) => b.status == BookingStatus.cancelled).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 32),
          _buildSummaryCards(context, bookings.length, confirmedCount, pendingCount, cancelledCount),
          const SizedBox(height: 32),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Booking Records', style: AppTextStyles.h3),
                      SizedBox(
                        width: 300,
                        child: AppInput(
                          label: 'Search Bookings',
                          hintText: 'Search by passenger or ID...',
                          prefixIcon: Icons.search_rounded,
                          onChanged: (v) {},
                        ),
                      ),
                    ],
                  ),
                ),
                _buildTableHeader(),
                const Divider(height: 1, color: AppColors.borderGray),
                bookings.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(48.0),
                        child: Center(child: Text('No bookings found')),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        itemCount: bookings.length,
                        separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.borderGray),
                        itemBuilder: (context, index) {
                          return _buildBookingRow(context, ref, bookings[index]);
                        },
                      ),
                _buildTableFooter(bookings.length),
              ],
            ),
          ),
          const SizedBox(height: 32),
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
            Text('Bookings Management', style: AppTextStyles.h1),
            const SizedBox(height: 4),
            Text('Monitor and manage passenger trip reservations.',
                style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textGray)),
          ],
        ),
        Row(
          children: [
            _buildHeaderAction(Icons.filter_list_rounded, 'Filter Results', () => _showFilterDialog(context)),
            const SizedBox(width: 12),
            SizedBox(
              width: 140,
              child: AppButton(
                text: 'Export',
                icon: Icons.download_rounded,
                onPressed: () {},
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

  Widget _buildSummaryCards(BuildContext context, int total, int confirmed, int pending, int cancelled) {
    final bool isDesktop = MediaQuery.of(context).size.width > 1200;
    return Row(
      children: [
        Expanded(child: _buildSummaryCard('Total Bookings', total.toString(), Icons.book_online_rounded, AppColors.info)),
        const SizedBox(width: 20),
        Expanded(child: _buildSummaryCard('Confirmed', confirmed.toString(), Icons.check_circle_rounded, AppColors.success)),
        const SizedBox(width: 20),
        Expanded(child: _buildSummaryCard('Pending', pending.toString(), Icons.pending_actions_rounded, AppColors.warning)),
        if (isDesktop) ...[
          const SizedBox(width: 20),
          Expanded(child: _buildSummaryCard('Cancelled', cancelled.toString(), Icons.cancel_rounded, AppColors.error)),
        ]
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
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
                Text(title, style: AppTextStyles.caption.copyWith(color: AppColors.textGray, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: AppColors.lightGray.withValues(alpha: 0.5),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('PASSENGER INFO', style: AppTextStyles.label.copyWith(fontSize: 11))),
          Expanded(flex: 2, child: Text('TRIP DETAILS', style: AppTextStyles.label.copyWith(fontSize: 11))),
          Expanded(flex: 1, child: Text('SEATS', style: AppTextStyles.label.copyWith(fontSize: 11))),
          Expanded(flex: 1, child: Text('FARE', style: AppTextStyles.label.copyWith(fontSize: 11))),
          Expanded(flex: 1, child: Text('STATUS', style: AppTextStyles.label.copyWith(fontSize: 11))),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildBookingRow(BuildContext context, WidgetRef ref, Booking booking) {
    final status = booking.status == BookingStatus.confirmed ? 'Confirmed' : (booking.status == BookingStatus.pending ? 'Pending' : 'Cancelled');
    final statusColor = booking.status == BookingStatus.confirmed ? AppColors.success : (booking.status == BookingStatus.pending ? AppColors.warning : AppColors.error);

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.teal.withValues(alpha: 0.1),
                    child: const Icon(Icons.person_rounded, color: AppColors.teal, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(booking.passengerName, style: AppTextStyles.bodyRegular.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                        Text('#${booking.id}', style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${booking.origin} → ${booking.destination}', style: AppTextStyles.bodyRegular.copyWith(fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                  Text(booking.travelDate, style: AppTextStyles.caption),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text('${booking.seatNumbers.length} Seats', style: AppTextStyles.bodyRegular),
            ),
            Expanded(
              flex: 1,
              child: Text('\$${booking.totalFare.toStringAsFixed(2)}', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: AppColors.darkNavy)),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
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
              ),
            ),
            PopupMenuButton<BookingStatus>(
              icon: const Icon(Icons.more_vert_rounded, color: AppColors.textGray, size: 20),
              onSelected: (newStatus) {
                ref.read(bookingProvider.notifier).updateBookingStatus(booking.id, newStatus);
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: BookingStatus.confirmed, child: Text('Confirm')),
                const PopupMenuItem(value: BookingStatus.pending, child: Text('Mark Pending')),
                const PopupMenuItem(value: BookingStatus.cancelled, child: Text('Cancel')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableFooter(int total) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Showing $total bookings', style: AppTextStyles.caption),
          Row(
            children: [
              _buildPageButton(Icons.chevron_left_rounded, false),
              const SizedBox(width: 8),
              _buildPageNumber(1, true),
              const SizedBox(width: 8),
              _buildPageButton(Icons.chevron_right_rounded, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton(IconData icon, bool enabled) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borderGray),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 20, color: enabled ? AppColors.darkNavy : AppColors.textGray.withValues(alpha: 0.5)),
    );
  }

  Widget _buildPageNumber(int number, bool isSelected) {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.teal : Colors.white,
        border: Border.all(color: isSelected ? AppColors.teal : AppColors.borderGray),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          number.toString(),
          style: AppTextStyles.caption.copyWith(color: isSelected ? Colors.white : AppColors.darkNavy, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    String selectedStatus = 'All';
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                width: 480,
                padding: const EdgeInsets.all(32),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Filter Bookings', style: AppTextStyles.h2),
                              const SizedBox(height: 4),
                              Text('Narrow down results by criteria below.', style: AppTextStyles.caption.copyWith(color: AppColors.textGray)),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, color: AppColors.textGray),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(color: AppColors.borderGray),
                      const SizedBox(height: 20),
                      // Route filters
                      Text('Route', style: AppTextStyles.h4.copyWith(color: AppColors.textGray)),
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          Expanded(child: AppInput(label: 'From City', hintText: 'e.g., Mogadishu', prefixIcon: Icons.trip_origin_rounded)),
                          SizedBox(width: 16),
                          Expanded(child: AppInput(label: 'To City', hintText: 'e.g., Kismayo', prefixIcon: Icons.location_on_rounded)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Date & Time filters
                      Text('Date & Time', style: AppTextStyles.h4.copyWith(color: AppColors.textGray)),
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          Expanded(child: AppInput(label: 'From Date', hintText: 'e.g., 2025-01-01', prefixIcon: Icons.calendar_today_rounded)),
                          SizedBox(width: 16),
                          Expanded(child: AppInput(label: 'To Date', hintText: 'e.g., 2025-12-31', prefixIcon: Icons.calendar_month_rounded)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Status toggle buttons
                      Text('Booking Details', style: AppTextStyles.h4.copyWith(color: AppColors.textGray)),
                      const SizedBox(height: 12),
                      Text('Status', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: ['All', 'Confirmed', 'Pending', 'Cancelled'].map((status) {
                          final isSelected = selectedStatus == status;
                          Color statusColor;
                          switch (status) {
                            case 'Confirmed': statusColor = AppColors.success; break;
                            case 'Pending':   statusColor = AppColors.warning; break;
                            case 'Cancelled': statusColor = AppColors.error;   break;
                            default:          statusColor = AppColors.teal;    break;
                          }
                          return GestureDetector(
                            onTap: () => setDialogState(() => selectedStatus = status),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? statusColor.withValues(alpha: 0.12) : AppColors.lightGray,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: isSelected ? statusColor : AppColors.borderGray,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Text(
                                status,
                                style: AppTextStyles.bodyRegular.copyWith(
                                  color: isSelected ? statusColor : AppColors.textGray,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      const AppInput(label: 'Payment Method', hintText: 'EVC / eDahab / Cash', prefixIcon: Icons.payment_rounded),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Expanded(child: AppInput(label: 'Min Price (\$)', hintText: 'e.g., 5.00', keyboardType: TextInputType.number, prefixIcon: Icons.attach_money_rounded)),
                          SizedBox(width: 16),
                          Expanded(child: AppInput(label: 'Max Price (\$)', hintText: 'e.g., 50.00', keyboardType: TextInputType.number, prefixIcon: Icons.money_off_rounded)),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 110,
                            child: AppButton(
                              text: 'Reset All',
                              type: AppButtonType.secondary,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 150,
                            child: AppButton(
                              text: 'Apply Filters',
                              icon: Icons.check_rounded,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
