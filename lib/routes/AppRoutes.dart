import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/screens/authentication/login_screen.dart';
import 'package:paw_pal_mobile/screens/authentication/otp_verification_screen.dart';
import 'package:paw_pal_mobile/screens/checkout/check_out_screen.dart';
import 'package:paw_pal_mobile/screens/dashborad/dash_borad_screen.dart';
import 'package:paw_pal_mobile/screens/hospital/vet_care_detail_screen.dart';
import 'package:paw_pal_mobile/screens/myAccount/account_information_screen.dart';
import 'package:paw_pal_mobile/screens/myAccount/address_detail_screen.dart';
import 'package:paw_pal_mobile/screens/myAccount/faq_screen.dart';
import 'package:paw_pal_mobile/screens/myAccount/manage_paws_screen.dart';
import 'package:paw_pal_mobile/screens/myAccount/my_account_screen.dart';
import 'package:paw_pal_mobile/screens/onborading/address_screen.dart';
import 'package:paw_pal_mobile/screens/onborading/pet_profile_screen.dart';
import 'package:paw_pal_mobile/screens/onborading/setup_profile_screen.dart';
import 'package:paw_pal_mobile/screens/petCareVideo/pet_care_video_screen.dart';
import 'package:paw_pal_mobile/screens/product/product_detail_screen.dart';
import 'package:paw_pal_mobile/screens/splash/splash_screen.dart';
import 'package:paw_pal_mobile/screens/welcome/welcome_screen.dart';

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
      GoRoute(
        path: Routes.welcomeScreenPath,
        name: Routes.welcomeScreen,
        builder: (context, state) => WelcomeScreen(),
      ),
      GoRoute(
        path: Routes.loginScreenPath,
        name: Routes.loginScreen,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: Routes.otpScreenPath,
        name: Routes.otpScreen,
        builder: (context, state) => OtpVerificationScreen(),
      ),
      GoRoute(
        path: Routes.setupProfileScreenPath,
        name: Routes.setupProfileScreen,
        builder: (context, state) => SetupProfileScreen(),
      ),
      GoRoute(
        path: Routes.addressScreenPath,
        name: Routes.addressScreen,
        builder: (context, state) => AddressScreen(),
      ),
      GoRoute(
        path: Routes.petProfileScreenPath,
        name: Routes.petProfileScreen,
        builder: (context, state) => PetProfileScreen(),
      ),
      GoRoute(
        path: Routes.dashBoardScreenPath,
        name: Routes.dashBoardScreen,
        builder: (context, state) => DashBoardScreen(),
      ),
      GoRoute(
        path: Routes.myAccountScreenPath,
        name: Routes.myAccountScreen,
        builder: (context, state) => MyAccountScreen(),
      ),
      GoRoute(
        path: Routes.accountInfoScreenPath,
        name: Routes.accountInfoScreen,
        builder: (context, state) => AccountInformationScreen(),
      ),
      GoRoute(
        path: Routes.addressDetailScreenPath,
        name: Routes.addressDetailScreen,
        builder: (context, state) => AddressDetailScreen(),
      ),
      GoRoute(
        path: Routes.managePawScreenPath,
        name: Routes.managePawScreen,
        builder: (context, state) => ManagePawsScreen(),
      ),
      GoRoute(
        path: Routes.petCareVideoScreenPath,
        name: Routes.petCareVideoScreen,
        builder: (context, state) => PetCareVideoScreen(),
      ),
      GoRoute(
        path: Routes.faqScreenPath,
        name: Routes.faqScreen,
        builder: (context, state) => FaqScreen(),
      ),
      GoRoute(
        path: Routes.productDetailScreenPath,
        name: Routes.productDetailScreen,
        builder: (context, state) => ProductDetailScreen(),
      ),
      GoRoute(
        path: Routes.vetCareDetailScreenPath,
        name: Routes.vetCareDetailScreen,
        builder: (context, state) => VetCareDetailScreen(),
      ),
      GoRoute(
        path: Routes.checkOutScreenPath,
        name: Routes.checkOutScreen,
        builder: (context, state) => CheckOutScreen(),
      ),
    ],
  );

  static GoRouter get router => _router;
}
