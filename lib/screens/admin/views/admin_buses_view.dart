import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input.dart';
import '../../../core/models/bus_model.dart';
import '../../../core/providers/bus_provider.dart';

class AdminBusesView extends ConsumerWidget {
  const AdminBusesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buses = ref.watch(busProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, ref),
          const SizedBox(height: 32),
          buses.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(48.0),
                  child: Center(child: Text('No buses in fleet')),
                )
              : LayoutBuilder(builder: (context, constraints) {
                  int crossAxisCount = 2;
                  if (constraints.maxWidth > 1200) {
                    crossAxisCount = 4;
                  } else if (constraints.maxWidth > 800) {
                    crossAxisCount = 3;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: buses.length,
                    itemBuilder: (context, index) {
                      return _buildBusCard(context, ref, buses[index], index);
                    },
                  );
                }),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Buses Management', style: AppTextStyles.h1),
            const SizedBox(height: 4),
            Text('Monitor your fleet status, capacity, and maintenance schedules.',
                style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textGray)),
          ],
        ),
        Row(
          children: [
            _buildHeaderAction(Icons.filter_list_rounded, 'Filter Fleet', () => _showFilterDialog(context)),
            const SizedBox(width: 12),
            SizedBox(
              width: 160,
              child: AppButton(
                text: 'Add New Bus',
                icon: Icons.add_rounded,
                onPressed: () => _showAddBusDialog(context, ref),
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

  Widget _buildBusCard(BuildContext context, WidgetRef ref, Bus bus, int index) {
    Color statusColor = AppColors.success;

    if (bus.status == 'Available') {
      statusColor = AppColors.success;
    } else if (bus.status == 'On Trip') {
      statusColor = AppColors.info;
    } else {
      statusColor = AppColors.warning;
    }

    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.teal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.directions_bus_rounded, color: AppColors.teal, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withValues(alpha: 0.2)),
                ),
                child: Text(
                  bus.status,
                  style: AppTextStyles.caption.copyWith(color: statusColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(bus.number, style: AppTextStyles.h3),
          const SizedBox(height: 4),
          Text('Plate: ${bus.plateNumber}',
              style: AppTextStyles.caption.copyWith(color: AppColors.textGray)),
          const Spacer(),
          _buildInfoRow(Icons.airline_seat_recline_normal_rounded, '${bus.totalSeats} Seats'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.category_outlined, bus.type),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildCardAction(
                  icon: Icons.visibility_outlined,
                  label: 'View',
                  color: AppColors.info,
                  onPressed: () => _showBusDetailsDialog(context, ref, bus, isReadOnly: true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCardAction(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  color: AppColors.teal,
                  onPressed: () => _showBusDetailsDialog(context, ref, bus, isReadOnly: false),
                ),
              ),
              const SizedBox(width: 8),
              _buildDeleteAction(() => _showDeleteConfirmation(context, ref, bus.id)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textGray),
        const SizedBox(width: 8),
        Text(text, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGray)),
      ],
    );
  }

  Widget _buildCardAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: const BorderSide(color: AppColors.borderGray),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: Icon(icon, size: 14),
      label: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildDeleteAction(VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 18),
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filter Fleet', style: AppTextStyles.h2),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const AppInput(label: 'Status', hintText: 'Enter status', prefixIcon: Icons.info_outline_rounded),
              const SizedBox(height: 16),
              const AppInput(label: 'Capacity', hintText: 'Enter capacity', prefixIcon: Icons.airline_seat_recline_normal_rounded),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 120,
                    child: AppButton(
                      text: 'Reset',
                      type: AppButtonType.secondary,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 150,
                    child: AppButton(
                      text: 'Apply',
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
  }

  void _showAddBusDialog(BuildContext context, WidgetRef ref) {
    _showBusDetailsDialog(context, ref, null, isReadOnly: false, isNew: true);
  }

  void _showBusDetailsDialog(BuildContext context, WidgetRef ref, Bus? bus, {required bool isReadOnly, bool isNew = false}) {
    final numberController = TextEditingController(text: bus?.number ?? '');
    final plateController = TextEditingController(text: bus?.plateNumber ?? '');
    final seatsController = TextEditingController(text: bus?.totalSeats.toString() ?? '45');
    final typeController = TextEditingController(text: bus?.type ?? 'Luxury');

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.teal.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isNew ? Icons.add_rounded : (isReadOnly ? Icons.visibility_outlined : Icons.edit_outlined),
                        color: AppColors.teal,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(isNew ? 'Register New Bus' : (isReadOnly ? 'Bus Details' : 'Edit Bus Info'), style: AppTextStyles.h2),
                          Text('Manage vehicle technical specifications', style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                AppInput(
                  label: 'Bus Number / ID',
                  hintText: 'Enter bus number',
                  controller: numberController,
                  enabled: !isReadOnly,
                  prefixIcon: Icons.tag_rounded,
                ),
                const SizedBox(height: 20),
                AppInput(
                  label: 'License Plate',
                  hintText: 'Enter license plate',
                  controller: plateController,
                  enabled: !isReadOnly,
                  prefixIcon: Icons.badge_outlined,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: AppInput(
                        label: 'Total Seats',
                        hintText: 'Enter total seats',
                        controller: seatsController,
                        enabled: !isReadOnly,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.airline_seat_recline_normal_rounded,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: AppInput(
                        label: 'Bus Type',
                        hintText: 'Enter bus type',
                        controller: typeController,
                        enabled: !isReadOnly,
                        prefixIcon: Icons.category_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const AppInput(
                  label: 'Manufacturer / Model',
                  hintText: 'Enter manufacturer/model',
                  enabled: false,
                  prefixIcon: Icons.directions_bus_filled_outlined,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!isReadOnly) ...[
                      SizedBox(
                        width: 140,
                        child: AppButton(
                          text: 'Cancel',
                          type: AppButtonType.secondary,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 180,
                        child: AppButton(
                          text: isNew ? 'Register Bus' : 'Save Changes',
                          onPressed: () {
                             if (isNew) {
                                ref.read(busProvider.notifier).addBus(Bus(
                                  id: 'B${DateTime.now().millisecondsSinceEpoch}',
                                  number: numberController.text,
                                  plateNumber: plateController.text,
                                  totalSeats: int.tryParse(seatsController.text) ?? 45,
                                  type: typeController.text,
                                  status: 'Available',
                                ));
                             } else if (bus != null) {
                                ref.read(busProvider.notifier).updateBus(bus.copyWith(
                                  number: numberController.text,
                                  plateNumber: plateController.text,
                                  totalSeats: int.tryParse(seatsController.text) ?? 45,
                                  type: typeController.text,
                                ));
                             }

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isNew ? 'New bus registered successfully' : 'Bus information updated'),
                                backgroundColor: AppColors.success,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ),
                    ] else ...[
                      SizedBox(
                        width: 160,
                        child: AppButton(
                          text: 'Close',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.error),
            const SizedBox(width: 12),
            const Text('Delete Vehicle'),
          ],
        ),
        content: const Text('Are you sure you want to remove this bus from the fleet? This action is irreversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.textGray)),
          ),
          SizedBox(
            width: 100,
            child: AppButton(
              text: 'Delete',
              onPressed: () {
                ref.read(busProvider.notifier).removeBus(id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bus removed from fleet'),
                    backgroundColor: AppColors.error,
                    behavior: SnackBarBehavior.floating,
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
