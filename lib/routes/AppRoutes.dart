

import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/screens/splash/splash_screen.dart';

class AppRoutes {
  static final GoRouter _router = GoRouter(
    initialLocation: Routes.rootNamePath,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: Routes.rootNamePath,
        name: Routes.rootName,
        builder: (context, state) => SplashScreen(),
      ),
    ],
  );

  static GoRouter get router => _router;
}
