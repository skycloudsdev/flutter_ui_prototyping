import 'package:flutter/material.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/bill_splitter.dart';
import 'package:flutter_ui_prototyping/features/home/home.dart';
import 'package:flutter_ui_prototyping/features/schedule/schedule.dart';

class AppRouter {
  static const splashWidget = HomeScreen();

  static Map<String, Widget Function(BuildContext)> routes = {
    HomeScreen.id: (_) => const HomeScreen(),
    ScheduleScreen.id: (_) => const ScheduleScreen(),
    BillSplitterHomeScreen.id: (_) => const BillSplitterHomeScreen(),
  };
}
