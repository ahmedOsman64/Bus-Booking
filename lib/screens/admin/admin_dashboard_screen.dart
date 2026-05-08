import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/services/auth_service.dart';
import '../auth/login_screen.dart';

// Import views
import 'views/admin_dashboard_view.dart';
import 'views/admin_bookings_view.dart';
import 'views/admin_routes_view.dart';
import 'views/admin_buses_view.dart';
import 'views/admin_users_view.dart';
import 'views/admin_reports_view.dart';
import 'views/admin_settings_view.dart';
import 'views/admin_profile_view.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _views = [
    AdminDashboardView(onNavigate: (index) {
      setState(() => _selectedIndex = index);
    }),
    const AdminBookingsView(),
    const AdminRoutesView(),
    const AdminBusesView(),
    const AdminUsersView(),
    const AdminReportsView(),
    const AdminSettingsView(),
    const AdminProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    // Determine if it's wide screen for responsive layout
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.darkNavy),
              title: Text('BUS BOOKING Admin', style: AppTextStyles.h4),
              actions: [
                _buildHeaderIcon(
                  icon: Icons.notifications_none_rounded,
                  color: Colors.white,
                  iconColor: AppColors.darkNavy,
                  onTap: () {},
                ),
                const SizedBox(width: 12),
                _buildHeaderIcon(
                  icon: Icons.person_rounded,
                  color: AppColors.darkNavy,
                  iconColor: Colors.white,
                  onTap: () => setState(() => _selectedIndex = 7),
                ),
                const SizedBox(width: 16),
              ],
            ),
      drawer: isDesktop ? null : Drawer(child: _buildSideNav(context)),
      body: SafeArea(
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSideNav(context),
                  Expanded(child: _views[_selectedIndex]),
                ],
              )
            : _views[_selectedIndex],
      ),
    );
  }

  Widget _buildSideNav(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          if (MediaQuery.of(context).size.width > 800) ...[
            const SizedBox(height: 32),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/logo.png',
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12),
            Text('BUS BOOKING Admin', style: AppTextStyles.h3),
            const SizedBox(height: 32),
          ] else ...[
            DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.lightGray),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('BUS BOOKING Admin', style: AppTextStyles.h3),
                  ],
                ),
              ),
            ),
          ],
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildNavItem(Icons.dashboard_rounded, 'Dashboard', 0),
                  _buildNavItem(Icons.book_online_rounded, 'Bookings', 1),
                  _buildNavItem(Icons.route_rounded, 'Routes', 2),
                  _buildNavItem(
                    Icons.directions_bus_filled_rounded,
                    'Buses',
                    3,
                  ),
                  _buildNavItem(Icons.people_alt_rounded, 'Users', 4),
                  _buildNavItem(Icons.analytics_rounded, 'Reports', 5),
                  _buildNavItem(Icons.settings_rounded, 'Settings', 6),
                  _buildNavItem(Icons.person_outline_rounded, 'Profile', 7),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.error),
            title: Text(
              'Logout',
              style: AppTextStyles.bodyRegular.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              await AuthService.clearSession();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index) {
    final bool isSelected = _selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.teal.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? AppColors.teal : AppColors.textGray,
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyRegular.copyWith(
            color: isSelected ? AppColors.teal : AppColors.textGray,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
          // Close drawer on mobile
          if (MediaQuery.of(context).size.width <= 800) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget _buildHeaderIcon({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}
