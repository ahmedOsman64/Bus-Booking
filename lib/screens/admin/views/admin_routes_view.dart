import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_input.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_select.dart';

class AdminRoutesView extends StatelessWidget {
  const AdminRoutesView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 32),
          AppCard(
            padding: EdgeInsets.zero,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              itemCount: 8,
              separatorBuilder: (context, index) =>
                  const Divider(height: 32, color: AppColors.borderGray),
              itemBuilder: (context, index) {
                return _buildRouteItem(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddRouteDialog(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool isSaving = false;

    final TextEditingController originController = TextEditingController();
    final TextEditingController destinationController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController distanceController = TextEditingController();
    final TextEditingController boardingController = TextEditingController();

    String scheduleType = 'daily';
    TimeOfDay? departureTime;
    TimeOfDay? arrivalTime;
    DateTime? specificDate;
    String? selectedBus;
    String selectedStatus = 'Active';
    final buses = List.generate(12, (index) => 'Bus #${100 + index}');
    final statuses = ['Active', 'Inactive'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            String formatTime(TimeOfDay? t) => t != null ? t.format(context) : 'Select Time';
            String formatDate(DateTime? d) => d != null ? '${d.day}/${d.month}/${d.year}' : 'Select Date';

            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Container(
                width: 560,
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: formKey,
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
                                Text('Create New Route', style: AppTextStyles.h2),
                                Text('Set up a new travel path and schedule', style: AppTextStyles.caption),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded, color: AppColors.textGray),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: AppInput(
                                label: 'Origin Point',
                                hintText: 'e.g., Mogadishu',
                                prefixIcon: Icons.trip_origin_rounded,
                                controller: originController,
                                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: AppInput(
                                label: 'Destination',
                                hintText: 'e.g., Kismayo',
                                prefixIcon: Icons.location_on_rounded,
                                controller: destinationController,
                                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text('Schedule Configuration', style: AppTextStyles.label),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.lightGray,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            children: [
                              _buildScheduleTab('Daily Route', Icons.repeat_rounded, scheduleType == 'daily', () => setDialogState(() => scheduleType = 'daily')),
                              _buildScheduleTab('Specific Date', Icons.calendar_today_rounded, scheduleType == 'specific', () => setDialogState(() => scheduleType = 'specific')),
                            ],
                          ),
                        ),
                        if (scheduleType == 'specific') ...[
                          const SizedBox(height: 16),
                          _buildPickerField('Travel Date', Icons.calendar_month_rounded, formatDate(specificDate), () async {
                            final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                            if (picked != null) setDialogState(() => specificDate = picked);
                          }),
                        ],
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildPickerField('Departure', Icons.access_time_rounded, formatTime(departureTime), () async {
                              final picked = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 8, minute: 0));
                              if (picked != null) setDialogState(() => departureTime = picked);
                            })),
                            const SizedBox(width: 16),
                            Expanded(child: _buildPickerField('Arrival', Icons.access_time_rounded, formatTime(arrivalTime), () async {
                              final picked = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 14, minute: 0));
                              if (picked != null) setDialogState(() => arrivalTime = picked);
                            })),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: AppInput(label: r'Price ($)', hintText: '15.00', keyboardType: TextInputType.number, prefixIcon: Icons.attach_money_rounded, controller: priceController)),
                            const SizedBox(width: 16),
                            Expanded(child: AppInput(label: 'Distance (km)', hintText: '500', keyboardType: TextInputType.number, prefixIcon: Icons.route_rounded, controller: distanceController)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        AppInput(label: 'Boarding Points', hintText: 'e.g., KM4, Benadir', prefixIcon: Icons.location_city_rounded, controller: boardingController),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: AppSelect<String>(label: 'Assign Bus', value: selectedBus, prefixIcon: Icons.directions_bus_rounded, items: buses.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(), onChanged: (v) => setDialogState(() => selectedBus = v))),
                            const SizedBox(width: 16),
                            Expanded(child: AppSelect<String>(label: 'Initial Status', value: selectedStatus, prefixIcon: Icons.toggle_on_rounded, items: statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (v) => setDialogState(() => selectedStatus = v!))),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(width: 120, child: AppButton(text: 'Cancel', type: AppButtonType.secondary, onPressed: () => Navigator.pop(context))),
                            const SizedBox(width: 16),
                            SizedBox(width: 180, child: AppButton(text: 'Save Route', icon: Icons.check_circle_rounded, isLoading: isSaving, onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                setDialogState(() => isSaving = true);
                                await Future.delayed(const Duration(milliseconds: 1500));
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Route created successfully!'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating));
                                }
                              }
                            })),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildScheduleTab(String text, IconData icon, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.teal : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isSelected ? Colors.white : AppColors.textGray),
              const SizedBox(width: 8),
              Text(text, style: AppTextStyles.bodyRegular.copyWith(color: isSelected ? Colors.white : AppColors.textGray, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPickerField(String label, IconData icon, String value, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderGray)),
            child: Row(
              children: [
                Icon(icon, color: AppColors.teal, size: 20),
                const SizedBox(width: 12),
                Text(value, style: AppTextStyles.bodyRegular),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showRouteDetailsDialog(BuildContext context, int index, {bool isReadOnly = false}) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool isSaving = false;

    final TextEditingController originController = TextEditingController(text: 'Mogadishu');
    final TextEditingController destinationController = TextEditingController(text: index % 2 == 0 ? 'Afgooye' : 'Kismayo');
    final TextEditingController priceController = TextEditingController(text: index % 2 == 0 ? '5.00' : '25.00');
    final TextEditingController distanceController = TextEditingController(text: '500');
    final TextEditingController boardingController = TextEditingController(text: 'KM4, Benadir, Ex-Control, Afgooye Road');

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Container(
              width: 560,
              padding: const EdgeInsets.all(32),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: isReadOnly ? AppColors.info.withValues(alpha: 0.1) : AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                            child: Icon(isReadOnly ? Icons.visibility_outlined : Icons.edit_outlined, color: isReadOnly ? AppColors.info : AppColors.teal),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(isReadOnly ? 'Route Details' : 'Edit Route', style: AppTextStyles.h2),
                                Text(isReadOnly ? 'View comprehensive route information' : 'Update route parameters and pricing', style: AppTextStyles.caption),
                              ],
                            ),
                          ),
                          IconButton(icon: const Icon(Icons.close_rounded, color: AppColors.textGray), onPressed: () => Navigator.pop(context)),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(child: AppInput(label: 'Origin Point', prefixIcon: Icons.trip_origin_rounded, controller: originController, enabled: !isReadOnly)),
                          const SizedBox(width: 20),
                          Expanded(child: AppInput(label: 'Destination', prefixIcon: Icons.location_on_rounded, controller: destinationController, enabled: !isReadOnly)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(child: AppInput(label: r'Ticket Price ($)', prefixIcon: Icons.payments_outlined, controller: priceController, enabled: !isReadOnly)),
                          const SizedBox(width: 20),
                          Expanded(child: AppInput(label: 'Distance (km)', prefixIcon: Icons.route_outlined, controller: distanceController, enabled: !isReadOnly)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      AppInput(label: 'Boarding Points', prefixIcon: Icons.map_outlined, controller: boardingController, enabled: !isReadOnly),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (!isReadOnly) ...[
                            SizedBox(width: 140, child: AppButton(text: 'Discard', type: AppButtonType.secondary, onPressed: () => Navigator.pop(context))),
                            const SizedBox(width: 16),
                            SizedBox(width: 180, child: AppButton(text: 'Update Route', icon: Icons.check_circle_outline_rounded, isLoading: isSaving, onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                setDialogState(() => isSaving = true);
                                await Future.delayed(const Duration(milliseconds: 1500));
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Route updated successfully!'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating));
                                }
                              }
                            })),
                          ] else ...[
                            SizedBox(width: 160, child: AppButton(text: 'Close View', onPressed: () => Navigator.pop(context))),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Routes Management', style: AppTextStyles.h1),
            const SizedBox(height: 4),
            Text('Configure travel paths, schedules, and pricing.',
                style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textGray)),
          ],
        ),
        SizedBox(
          width: 160,
          child: AppButton(
            text: 'Add Route',
            icon: Icons.add_rounded,
            onPressed: () => _showAddRouteDialog(context),
          ),
        ),
      ],
    );
  }

  Widget _buildRouteItem(BuildContext context, int index) {
    final bool isEven = index % 2 == 0;
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.teal.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.route_rounded, color: AppColors.teal, size: 28),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEven ? 'Mogadishu → Afgooye' : 'Mogadishu → Kismayo',
                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                isEven ? 'Daily • 50km • 1 hour' : 'Wed, Sat • 500km • 8 hours',
                style: AppTextStyles.caption.copyWith(color: AppColors.textGray),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              isEven ? r'$5.00' : r'$25.00',
              style: AppTextStyles.h3.copyWith(color: AppColors.teal),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildRouteAction(Icons.visibility_outlined, AppColors.info, () => _showRouteDetailsDialog(context, index, isReadOnly: true)),
                const SizedBox(width: 12),
                _buildRouteAction(Icons.edit_outlined, AppColors.teal, () => _showRouteDetailsDialog(context, index, isReadOnly: false)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRouteAction(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderGray),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
