import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paw_pal_mobile/bloc/authBloc/auth_cubit.dart';
import 'package:paw_pal_mobile/bloc/cartBloc/cart_cubit.dart';
import 'package:paw_pal_mobile/bloc/dashboardBloc/dashboard_cubit.dart';
import 'package:paw_pal_mobile/bloc/faqBloc/faq_cubit.dart';
import 'package:paw_pal_mobile/bloc/homeCubit/home_cubit.dart';
import 'package:paw_pal_mobile/bloc/hospitalBloc/hospital_cubit.dart';
import 'package:paw_pal_mobile/bloc/mangePawBloc/manage_paw_cubit.dart';
import 'package:paw_pal_mobile/bloc/myAccountBloc/my_account_cubit.dart';
import 'package:paw_pal_mobile/bloc/orderBloc/order_cubit.dart';
import 'package:paw_pal_mobile/bloc/petCubit/pet_cubit.dart';
import 'package:paw_pal_mobile/bloc/productDetailBloc/product_detail_cubit.dart';
import 'package:paw_pal_mobile/bloc/profileBloc/profile_cubit.dart';
import 'package:paw_pal_mobile/bloc/videoBloc/video_cubit.dart';
import 'package:paw_pal_mobile/core/constant.dart';
import 'package:paw_pal_mobile/routes/AppRoutes.dart';
import 'package:paw_pal_mobile/services/firebase_auth_service.dart';
import 'package:paw_pal_mobile/services/notification_service.dart';
import 'package:paw_pal_mobile/theme/AppTheme.dart';

import 'bloc/productBloc/product_cubit.dart';
import 'core/AppStrings.dart';
import 'core/MySharedPreferences.dart';

Future<Widget> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().setUpInteractedMessage();
  await NotificationService.setupFcmTokenListener();
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
  String stateWiseCityApiKey = remoteConfig.getString(
    Constant.stateWiseCityApiKey,
  );
  if (razorPayKey.isNotEmpty) {
    await MySharedPreferences.saveString(
      MySharedPreferences.razorPayKey,
      razorPayKey,
    );
  }
  if (stateWiseCityApiKey.isNotEmpty) {
    await MySharedPreferences.saveString(
      MySharedPreferences.stateWiseCityApiKey,
      stateWiseCityApiKey,
    );
  }
}

Future<void> setConfigDataFromPreference() async {
  final razorPayKey = await MySharedPreferences.getStringData(
    MySharedPreferences.razorPayKey,
  );
  final stateWiseCityApiKey = await MySharedPreferences.getStringData(
    MySharedPreferences.stateWiseCityApiKey,
  );
  if (razorPayKey.isNotEmpty) {
    Constant.razorPayKey = razorPayKey;
  }
  if (stateWiseCityApiKey.isNotEmpty) {
    Constant.stateWiseCityApiKey = stateWiseCityApiKey;
  }

  debugPrint("Final razorPay Key :- $razorPayKey");
  debugPrint(" razorPay Key :- - ${Constant.razorPayKey}");
  debugPrint("Final stateWiseCityApiKey Key :- $stateWiseCityApiKey");
  debugPrint(" stateWiseCityApiKey Key :- - ${Constant.stateWiseCityApiKey}");
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
        BlocProvider<MyAccountCubit>(create: (context) => MyAccountCubit()),
        BlocProvider<PetCubit>(create: (context) => PetCubit()),
        BlocProvider<VideoCubit>(create: (context) => VideoCubit()),
        BlocProvider<ProductCubit>(
          create: (context) => ProductCubit(FirebaseService()),
        ),
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(
            petCubit: context.read<PetCubit>(),
            videoCubit: context.read<VideoCubit>(),
            productCubit: context.read<ProductCubit>(),
          ),
        ),
        BlocProvider<ManagePawCubit>(create: (context) => ManagePawCubit()),
        BlocProvider<FaqCubit>(
          create: (context) => FaqCubit(FirebaseService()),
        ),
        BlocProvider<HospitalCubit>(
          create: (context) => HospitalCubit(FirebaseService()),
        ),
        BlocProvider<ProductDetailCubit>(
          create: (context) => ProductDetailCubit(FirebaseService()),
        ),
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(FirebaseService()),
        ),
        BlocProvider<OrderCubit>(
          create: (context) => OrderCubit(FirebaseService()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        // showPerformanceOverlay: true,
        title: AppStrings.appName,
        routeInformationProvider: AppRoutes.router.routeInformationProvider,
        routeInformationParser: AppRoutes.router.routeInformationParser,
        routerDelegate: AppRoutes.router.routerDelegate,
        theme: AppTheme.lightThem(),
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
