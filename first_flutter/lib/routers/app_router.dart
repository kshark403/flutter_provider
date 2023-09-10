import 'package:first_flutter/screens/dashboard_screen.dart';
import 'package:first_flutter/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static final Map<String, WidgetBuilder> routes = {
    '/': (context) => const WelcomeScreen(),
    '/dashboard': (context) => const DashboardScreen(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final builder = routes[settings.name];

    if (builder != null) {
      return MaterialPageRoute(
        builder: (context) => builder(context),
      );
    } else {
      return MaterialPageRoute(
        builder: (contet) => const Scaffold(
          body: Center(
            child: Text('404 - Page not found'),
          ),
        ),
      );
    }
  }
}
