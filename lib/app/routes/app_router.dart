import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_together/app/routes/app_routes.dart';
import 'package:ride_together/features/auth/screens/login_screen.dart';
import 'package:ride_together/features/auth/screens/register_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        // path: AppRoutes.login,
        path: '/',
        name: 'login',
        builder: (context, state) {
          return const LoginScreen();
        },
      ),

      GoRoute(path: AppRoutes.register,
      name: 'register',
      builder: (context, state) {
        return const RegisterScreen() ;
      },)
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child:  Text('Page not found'),
        ),
      );
    },
  );
}

/**
 * class AppRouter {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const RxdartDebounceScreen();
        },

        routes: <RouteBase>[
          GoRoute(
            path: '/product',
            builder: (BuildContext context, GoRouterState state) {
              return const ProductScreen();
            },
          ),
          GoRoute(
            path: 'profile',
            builder: (BuildContext context, GoRouterState state) {
              final data = state.extra as String;
              return ProfileScreen(data: data);
            },
            routes: <RouteBase>[
              GoRoute(
                path: 'settings',
                builder: (BuildContext context, GoRouterState state) {
                  return const SettingsScreen();
                },
                routes: <RouteBase>[
                  GoRoute(
                    path: 'more',
                    builder: (BuildContext context, GoRouterState state) {
                      return const MoreScreen();
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    // errorBuilder:
    errorPageBuilder: (context, state) {
      return MaterialPage(child: Text('something went wrong'));
    },
  );
}

 */
