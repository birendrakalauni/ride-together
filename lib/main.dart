import 'package:flutter/material.dart';
import 'package:ride_together/app/routes/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      title: 'RideTogether',

      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF1F1F1),
        
        colorScheme: .fromSeed(seedColor: const Color(0xFF08A6B3)),
      ),
     routerConfig: AppRouter.router,
    );
  }
}

