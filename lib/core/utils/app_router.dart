import 'package:flutter/material.dart';

import '../../features/auth/ui/views/login_view.dart';
import '../../features/auth/ui/views/register_view.dart';
import '../../features/home/ui/views/home_view.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case AppRoutes.home:

        return MaterialPageRoute(builder: (_) => const HomeView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                'No route defined for ${settings.name}',
              ),
            ),
          ),
        );
    }
  }
}
