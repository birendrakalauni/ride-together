import 'package:flutter/material.dart';
import 'package:ride_together/app/core/services/firebase_service.dart';
import 'package:ride_together/app/routes/app_router.dart';
import 'package:ride_together/app/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseService.initialize();
  
  runApp(const RideTogetherApp());
}

class RideTogetherApp extends StatelessWidget {
  const RideTogetherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      title: 'rideTogether',

      theme: AppTheme.light,

      routerConfig: AppRouter.router,
    );
  }
}
