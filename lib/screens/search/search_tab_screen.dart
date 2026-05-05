import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import 'search_results_screen.dart';

class SearchTabScreen extends StatefulWidget {
  const SearchTabScreen({super.key});

  @override
  State<SearchTabScreen> createState() => _SearchTabScreenState();
}

class _SearchTabScreenState extends State<SearchTabScreen> {
  String? _selectedOrigin;
  String? _selectedDestination;
  DateTime _selectedDate = DateTime.now();
  String _selectedBusType = 'All';

  final List<String> _origins = ['Mogadishu', 'Afgooye', 'Jowhar', 'Beledweyne', 'Kismayo'];
  final List<String> _destinations = ['Mogadishu', 'Afgooye', 'Jowhar', 'Beledweyne', 'Baidoa'];

  final List<Map<String, String>> _buses = [
    {'name': 'Luxury Coaster', 'type': 'Premium', 'seats': '30', 'image': '🚌'},
    {'name': 'Standard Isuzu', 'type': 'Economy', 'seats': '45', 'image': '🚐'},
    {'name': 'Hyundai County', 'type': 'Business', 'seats': '28', 'image': '🚌'},
    {'name': 'Express Hiace', 'type': 'Mini', 'seats': '14', 'image': '🚐'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text('Find Travels'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Where are you going?', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text('Select your route and travel date', style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textGray)),
            const SizedBox(height: 32),
            
            // Search Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
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
                  _buildSearchField(
                    icon: Icons.location_on_rounded,
                    iconColor: AppColors.darkNavy,
                    label: 'From',
                    value: _selectedOrigin ?? 'Select Origin',
                    onTap: () => _showSelectionModal('Origin', _origins, (val) {
                      setState(() => _selectedOrigin = val);
                    }),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(color: AppColors.borderGray, height: 1),
                  ),
                  _buildSearchField(
                    icon: Icons.navigation_rounded,
                    iconColor: AppColors.warmCoral,
                    label: 'To',
                    value: _selectedDestination ?? 'Select Destination',
                    onTap: () => _showSelectionModal('Destination', _destinations, (val) {
                      setState(() => _selectedDestination = val);
                    }),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(color: AppColors.borderGray, height: 1),
                  ),
                  _buildSearchField(
                    icon: Icons.calendar_month_rounded,
                    iconColor: AppColors.teal,
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
                    text: 'Search Travels',
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
            ),
            
            const SizedBox(height: 40),
            
            // Choose Your Bus Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Choose Your Bus', style: AppTextStyles.h3),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All available bus types are shown.')),
                    );
                  },
                  child: Text('View All', style: AppTextStyles.bodySmall.copyWith(color: AppColors.darkNavy, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _buses.length,
                itemBuilder: (context, index) {
                  final bus = _buses[index];
                  final isSelected = _selectedBusType == bus['name'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _buildBusCard(bus, isSelected),
                  );
                },
              ),
            ),

            const SizedBox(height: 40),
            Text('Recommended For You', style: AppTextStyles.h3),
            const SizedBox(height: 16),
            // Mock recommended travels
            _buildRecommendedTravel('Mogadishu', 'Afgooye', '08:00 AM', '\$5.00'),
            const SizedBox(height: 12),
            _buildRecommendedTravel('Jowhar', 'Mogadishu', '10:00 AM', '\$6.00'),
            
            const SizedBox(height: 40),
            Text('Popular Routes', style: AppTextStyles.h3),
            const SizedBox(height: 16),
            _buildPopularRoute('Mogadishu', 'Afgooye', '\$5.00'),
            const SizedBox(height: 12),
            _buildPopularRoute('Mogadishu', 'Baidoa', '\$15.00'),
            const SizedBox(height: 12),
            _buildPopularRoute('Hargeisa', 'Berbera', '\$10.00'),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedTravel(String from, String to, String time, String price) {
    return AppCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SearchResultsScreen(
              origin: from,
              destination: to,
              date: DateTime.now(),
            ),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.teal.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.directions_bus_filled_rounded, color: AppColors.teal),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$from → $to', style: AppTextStyles.bodyRegular.copyWith(fontWeight: FontWeight.bold)),
                Text(time, style: AppTextStyles.caption.copyWith(color: AppColors.textGray)),
              ],
            ),
          ),
          Text(price, style: AppTextStyles.h4.copyWith(color: AppColors.teal)),
        ],
      ),
    );
  }

  Widget _buildBusCard(Map<String, String> bus, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBusType = bus['name']!;
        });
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkNavy : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.darkNavy : AppColors.borderGray,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(bus['image']!, style: const TextStyle(fontSize: 24)),
            const Spacer(),
            Text(
              bus['name']!,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "${bus['seats']} Seats",
              style: AppTextStyles.caption.copyWith(
                color: isSelected ? Colors.white.withValues(alpha: 0.7) : AppColors.textGray,
              ),
            ),
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

  Widget _buildPopularRoute(String from, String to, String price) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SearchResultsScreen(
              origin: from,
              destination: to,
              date: DateTime.now(),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.trending_up, color: AppColors.success, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text('$from → $to', style: AppTextStyles.bodyRegular.copyWith(fontWeight: FontWeight.w600)),
            ),
            Text(price, style: AppTextStyles.bodyRegular.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
          ],
        ),
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
