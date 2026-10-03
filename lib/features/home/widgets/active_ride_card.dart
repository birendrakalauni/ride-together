import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_together/app/routes/app_routes.dart';
import 'package:ride_together/features/ride/controllers/ride_controller.dart';

class ActiveRideCard extends StatelessWidget {
  const ActiveRideCard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final rideController = Get.put(RideController());

    if (user == null) {
      return _buildEmptyCard();
    }

    return StreamBuilder(
      stream: rideController.listenToActiveRideId(user.uid),
      builder: (context, snapshot) {
        final activeRideId = snapshot.data;

        if (activeRideId == null || activeRideId.isEmpty) {
          return _buildEmptyCard();
        }

        return _buildActiveRideCard(context, activeRideId);
      },
    );
  }
}

Widget _buildEmptyCard() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: const Color(0xFFE7F5F2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.map_outlined,
            color: Color(0xFF087F6E),
            size: 30,
          ),
        ),
        const SizedBox(width: 16),

        Expanded(
          child: Text(
            "You don't have an active ride.",
            style: TextStyle(fontSize: 13, color: Color(0xFF718096)),
          ),
        ),
      ],
    ),
  );
}

Widget _buildActiveRideCard(BuildContext context, String activeRideId) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color(0xFF087F6E),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.two_wheeler, color: Colors.white, size: 30),
        ),
        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Active Ride',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
              const SizedBox(height: 4),
              Text(
                'Ride $activeRideId',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            context.go('${AppRoutes.rideWaiting}/$activeRideId');
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF087F6E),
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            )
          ),
          child: const Text(
            "Resume",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}
