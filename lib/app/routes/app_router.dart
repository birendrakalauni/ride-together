import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_together/app/routes/app_routes.dart';
import 'package:ride_together/features/auth/screens/forgot_password_screen.dart';
import 'package:ride_together/features/auth/screens/login_screen.dart';
import 'package:ride_together/features/auth/screens/register_screen.dart';
import 'package:ride_together/features/auth/screens/splash_screen.dart';
import 'package:ride_together/features/home/screens/home_screen.dart';
import 'package:ride_together/features/profile/screens/profile_screen.dart';
import 'package:ride_together/features/ride/screens/create_ride_screen.dart';
import 'package:ride_together/features/ride/screens/join_ride_screen.dart';
import 'package:ride_together/features/ride/screens/live_ride_screen_stub.dart';
import 'package:ride_together/features/ride/screens/ride_waiting_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    // initialLocation: AppRoutes.splash,
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        // path: AppRoutes.login,
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) {
          return const LoginScreen();
        },
      ),

      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) {
          return const RegisterScreen();
        },
      ),

      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) {
          return const HomeScreen();
        },
      ),

      GoRoute(
        path: AppRoutes.forgetPassword,
        name: 'forgot-password',
        builder: (context, state) {
          return const ForgotPasswordScreen();
        },
      ),

      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) {
          return const ProfileScreen();
        },
      ),

      GoRoute(
        path: AppRoutes.createRide,
        name: 'createRide',
        builder: (context, state) {
          return const CreateRideScreen();
        },
      ),

      GoRoute(
        path: AppRoutes.joinRide,
        name: 'joinRide',
        builder: (context, state) {
          return const JoinRideScreen();
        },
      ),

      // GoRoute(
      //   path: '${AppRoutes.rideWaiting}/:rideId',
      //   name: 'rideWaiting',
      //   builder: (context, state) {
      //     final rideId = state.pathParameters['rideId']!;
      //     return RideWaitingScreen(rideId: rideId);
      //   },
      // ),
      
      // GoRoute(
      //   path: '${AppRoutes.liveRide}/:rideId',
      //   name: 'liveRide',
      //   builder: (context, state) {
      //     final rideId = state.pathParameters['rideId']!;
      //     return LiveRideScreenStub(rideId: rideId);
      //   },
      // ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(body: Center(child: Text('Page not found')));
    },
  );
}
