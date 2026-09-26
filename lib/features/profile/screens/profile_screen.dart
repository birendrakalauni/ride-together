import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_together/app/routes/app_routes.dart';
import 'package:ride_together/features/auth/controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    final user = FirebaseAuth.instance.currentUser;

    final displayName = user?.displayName?.isNotEmpty == true
        ? user!.displayName!
        : 'Rider';

    final email = user?.email ?? 'No email';

    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F1F1),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Colors.grey,
          ),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'serif'),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 25),

              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFFE8D8),
                        border: Border.all(
                          color: const Color(0xFFF6CDB4),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 58,
                        color: Color(0xFFFF9B62),
                      ),
                    ),

                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0XFFFF9B62),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Edit profile ko lagi wait garnus la',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text(
                displayName,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              Text(email, style: TextStyle(fontSize: 12, color: Colors.grey)),

              const SizedBox(height: 28),

              SizedBox(
                child: OutlinedButton(
                  onPressed: () async {
                    await authController.logout();
                    if (context.mounted) context.go(AppRoutes.login);
                  },
                  child: Icon(Icons.logout, size: 18,),
                  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
