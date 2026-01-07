

import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/routes/routes.dart';

class AppRoutes {
  static final GoRouter _router = GoRouter(
    initialLocation: Routes.rootNamePath,
    debugLogDiagnostics: true,
    routes: [

    ],
  );

  static GoRouter get router => _router;
}
