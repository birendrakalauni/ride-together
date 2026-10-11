import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_together/app/routes/app_routes.dart';
import 'package:ride_together/features/ride/controllers/ride_controller.dart';

enum BottomNavItem { home, map, help }

class ButtonNavigationBar extends StatelessWidget {
  final BottomNavItem activeItem;
  const ButtonNavigationBar({super.key, required this.activeItem});

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
              isActive: activeItem == BottomNavItem.home,
              onTap: () {
                context.go(AppRoutes.home);
              },
            ),

            // _BottomNavItem(
            //   icon: Icons.map_outlined,
            //   activeIcon: Icons.map,
            //   label: 'Map',
            //   onTap: () async {
            //     final user = FirebaseAuth.instance.currentUser;
            //     final rideController = Get.put(RideController());
            //     final activeRideId = await rideController
            //         .listenToActiveRideId(user.uid)
            //         .first;
            //     if (!context.mounted) return;
            //     context.go('${AppRoutes.liveRide}/$activeRideId');
            //   },
            // ),
            _BottomNavItem(
              icon: Icons.map_outlined,
              activeIcon: Icons.map,
              label: 'Map',
              isActive: activeItem == BottomNavItem.map,
              onTap: () async {
                final user = FirebaseAuth.instance.currentUser;

                if (user == null) {
                  context.go(AppRoutes.login);
                  return;
                }

                final rideController = Get.put(RideController());

                final rideId = await rideController
                    .listenToActiveRideId(user.uid)
                    .first;

                if (!context.mounted) return;

                if (rideId == null || rideId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("You don't have an active ride."),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }

                context.go('${AppRoutes.liveRide}/$rideId');
              },
            ),

            _BottomNavItem(
              icon: Icons.help,
              activeIcon: Icons.help,
              label: 'Help',
              isActive: activeItem == BottomNavItem.help,
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
