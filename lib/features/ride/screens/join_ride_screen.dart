import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_together/app/routes/app_routes.dart';
import 'package:ride_together/features/ride/controllers/ride_controller.dart';
import 'package:ride_together/features/ride/widgets/ride_action_button.dart';
import 'package:ride_together/features/ride/widgets/ride_code_input.dart';
import 'package:ride_together/features/ride/widgets/header.dart';
import 'package:ride_together/features/ride/widgets/ride_info_card.dart';

class JoinRideScreen extends StatefulWidget {
  const JoinRideScreen({super.key});

  @override
  State<JoinRideScreen> createState() => _JoinRideScreenState();
}

class _JoinRideScreenState extends State<JoinRideScreen> {
  final RideController rideController = Get.put(RideController());

  final codeController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final ride = await rideController.joinRide(codeController.text);

    if (!mounted) return;

    if (ride != null) {
      context.go('${AppRoutes.rideWaiting}/${ride.id}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(rideController.errorMessage.value),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F7),
      body: SafeArea(
        child: Column(
          children: [
            Header(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    const Text(
                      'Join a Ride',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172B3A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Enter the ride code shared by the ride leader\nto join the group',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Color(0xFF718096),
                      ),
                    ),
                    const SizedBox(height: 30),

                    const Text(
                      'Ride Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172B3A),
                      ),
                    ),
                    const SizedBox(height: 12),

                    RideCodeInput(controller: codeController),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Text(
                        'Enter the 6-character ride code.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF718096),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    RideInfoCard(
                      title: 'Have a ride code?',
                      description:
                          'Ask the ride leader for the unique code and enter it above to join the group ride.',
                    ),

                    const SizedBox(height: 30),

                    Obx(
                      () => RideActionButton(
                        isLoading: rideController.isLoading.value,
                        onPressed: submit,
                        text: 'Join Ride',
                        icon: Icons.group_add_outlined,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
