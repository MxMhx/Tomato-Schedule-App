import 'package:flutter/material.dart';
import 'package:tomato_schedule/screens/screens.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return LoadingScreen.route();
      case '/loading':
        return LoadingScreen.route();
      case '/home':
        return HomeScreen.route();
      case '/addtask':
        return AddTask.route();
      default:
        return _errorRoute();
    }
  }

  Route? _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
      ),
    );
  }
}
