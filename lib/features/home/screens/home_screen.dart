import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_together/app/routes/app_routes.dart';
import 'package:ride_together/features/home/widgets/active_ride_card.dart';
import 'package:ride_together/features/home/widgets/greeting_section.dart';
import 'package:ride_together/features/home/widgets/home_header.dart';
import 'package:ride_together/features/home/widgets/nearby_rides.dart';
import 'package:ride_together/features/home/widgets/popular_rides.dart';
import 'package:ride_together/features/home/widgets/quick_actions.dart';
import 'package:ride_together/features/home/widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final displayName = user?.displayName?.isNotEmpty == true
        ? user!.displayName!
        : (user?.email ?? 'Rider');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F7),

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  HomeHeader(
                    onProfileTap: () {
                      context.go(AppRoutes.profile);
                    },
                  ),
                  const SizedBox(height: 28),

                  GreetingSection(displayName: displayName),

                  const SizedBox(height: 24),

                  const QuickActions(),

                  const SizedBox(height: 28),

                  const SectionHeader(title: 'My Active Ride'),

                  const SizedBox(height: 12),

                  const ActiveRideCard(),

                  const SizedBox(height: 28),

                  SectionHeader(
                    title: 'Popular Rides',
                    showSeeAll: true,
                    onSeeAll: () {},
                  ),

                  const SizedBox(height: 12),

                  const PopularRides(),

                  const SizedBox(height: 28),

                  SectionHeader(
                    title: 'Nearby Rides',
                    showSeeAll: true,
                    onSeeAll: () {},
                  ),
                  const SizedBox(height: 12,),

                  const NearbyRides(),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _HomeBottomNavigationBar(),
    );
  }
}

class _HomeBottomNavigationBar extends StatelessWidget {
  const _HomeBottomNavigationBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BottomNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: 'Home',
              isActive: true,
              onTap: () {
                context.go(AppRoutes.home);
              },
            ),

            _BottomNavItem(
              icon: Icons.map_outlined,
              activeIcon: Icons.map,
              label: 'Map',
              onTap: () {},
            ),

            _BottomNavItem(
              icon: Icons.help,
              activeIcon: Icons.help,
              label: 'Help',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isActive ? const Color(0xFF087F6E) : Colors.black;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isActive ? activeIcon : icon, size: 28, color: iconColor),

            const SizedBox(height: 5),

            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
