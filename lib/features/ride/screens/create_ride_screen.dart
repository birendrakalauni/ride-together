import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_together/app/routes/app_routes.dart';
import 'package:ride_together/features/ride/controllers/ride_controller.dart';
import 'package:ride_together/features/ride/widgets/create_ride_button.dart';
import 'package:ride_together/features/ride/widgets/ride_info_card.dart';
import 'package:ride_together/features/ride/widgets/ride_input_card.dart';

class CreateRideScreen extends StatefulWidget {
  const CreateRideScreen({super.key});

  @override
  State<CreateRideScreen> createState() => _CreateRideScreenState();
}

class _CreateRideScreenState extends State<CreateRideScreen> {
  final RideController rideController = Get.put(RideController());
  final nameController = TextEditingController();
  final destinationController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final ride = await rideController.createRide(
      name: nameController.text,
      destination: destinationController.text,
    );
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
            _buildHeader(context),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      const Text(
                        'Create a Ride',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF172B3A),
                        ),
                      ),
                      const SizedBox(height: 6),

                      const Text(
                        'Plan your journey and invite other riders\nto ride together.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xFF718096),
                        ),
                      ),

                      const SizedBox(height: 30),

                      _buildSectionTitle('Ride Details'),

                      const SizedBox(height: 12),

                      RideInputCard(
                        controller: nameController,
                        label: "Ride Name",
                        hint: 'Kathmandu to Mustang',
                        icon: Icons.two_wheeler_outlined,
                      ),
                      const SizedBox(height: 16),

                      RideInputCard(
                        controller: destinationController,
                        label: 'Destination',
                        hint: 'Mustang',
                        icon: Icons.location_on_outlined,
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Text(
                          'Destination is optional.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      RideInfoCard(),

                      const SizedBox(height: 30),

                      Obx(
                        () => CreateRideButton(
                          isLoading: rideController.isLoading.value,
                          onPressed: submit,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
    child: Row(
      children: [
        GestureDetector(
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 19,
              color: Color(0xFF172B3A),
            ),
          ),
        ),

        Expanded(
          child: Center(
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'ride',
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'serif',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: 'Together',
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'serif',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E8B57),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 44),
      ],
    ),
  );
}

Widget _buildSectionTitle(String title) {
  return Text(
    title,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Color(0xFF172B3A),
    ),
  );
}
