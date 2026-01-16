import 'package:flutter/material.dart';
import 'package:flutter_ui_prototyping/features/home/home.dart';

class AppRouter {
  static const splashWidget = HomeScreen();

  static Map<String, Widget Function(BuildContext)> routes = {
    HomeScreen.id: (_) => const HomeScreen(),
  };
}
