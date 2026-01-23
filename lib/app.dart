import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paw_pal_mobile/bloc/authBloc/auth_cubit.dart';
import 'package:paw_pal_mobile/bloc/dashboardBloc/dashboard_cubit.dart';
import 'package:paw_pal_mobile/bloc/profileBloc/profile_cubit.dart';
import 'package:paw_pal_mobile/core/constant.dart';
import 'package:paw_pal_mobile/routes/AppRoutes.dart';

import 'core/AppStrings.dart';
import 'core/MySharedPreferences.dart';

Future<Widget> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await fetchRemoteConfig();
  await setConfigDataFromPreference();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  firebaseCrashlytics();
  return const PawPalApp();
}

void firebaseCrashlytics() {
  const fatalError = true;
  // Non-async exceptions
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };
  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };
}

Future<void> fetchRemoteConfig() async {
  try {
    await FirebaseRemoteConfig.instance.fetchAndActivate();
    await setConfigData();
  } catch (_) {}
}

Future<void> setConfigData() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  String razorPayKey = remoteConfig.getString(Constant.razorPayKey);
  if (razorPayKey.isNotEmpty) {
    await MySharedPreferences.saveString(
      MySharedPreferences.razorPayKey,
      razorPayKey,
    );
  }
}

Future<void> setConfigDataFromPreference() async {
  final razorPayKey = await MySharedPreferences.getStringData(
    MySharedPreferences.razorPayKey,
  );
  if (razorPayKey.isNotEmpty) {
    Constant.razorPayKey = razorPayKey;
  }

  debugPrint("Final razorPay Key :- $razorPayKey");
  debugPrint(" razorPay Key :- - ${Constant.razorPayKey}");
}

class PawPalApp extends StatefulWidget {
  const PawPalApp({super.key});

  @override
  State<PawPalApp> createState() => _PawPalAppState();
}

class _PawPalAppState extends State<PawPalApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<ProfileCubit>(create: (context) => ProfileCubit()),
        BlocProvider<DashboardCubit>(create: (context) => DashboardCubit()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        routeInformationProvider: AppRoutes.router.routeInformationProvider,
        routeInformationParser: AppRoutes.router.routeInformationParser,
        routerDelegate: AppRoutes.router.routerDelegate,
        builder: (context, child) {
          final mediaQuery = MediaQuery.of(context);

          return MediaQuery(
            data: mediaQuery.copyWith(
              textScaler: mediaQuery.textScaler.clamp(
                minScaleFactor: 1.0,
                maxScaleFactor: 1.12,
              ),
             // textScaler: const TextScaler.linear(1.0),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
