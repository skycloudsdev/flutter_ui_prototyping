import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_prototyping/core/core.dart';

final _kAppNavigatorKey = GlobalKey<NavigatorState>();

class UIPrototypingApp extends StatelessWidget {
  static const _kRestorationId = 'root';
  static const _kName = 'ui_prototyping_app';

  const UIPrototypingApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return GestureDetector(
      onTap: FocusManager.instance.primaryFocus?.unfocus,
      child: MaterialApp(
        key: const Key(_kName),
        debugShowCheckedModeBanner: false,
        navigatorKey: _kAppNavigatorKey,
        restorationScopeId: _kRestorationId,
        title: _kName,
        routes: AppRouter.routes,
        themeAnimationCurve: Curves.easeIn,
        themeAnimationDuration: const Duration(milliseconds: 500),
        // themeMode: ThemeMode.dark,
        // theme: _buildLightTheme(),
        // darkTheme: _buildDarkTheme(),
      ),
    );
  }
}
