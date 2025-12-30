import 'package:dhani_communications/presentation/screens/screen_bottombar/screen_bottombar.dart';
import 'package:dhani_communications/presentation/screens/screen_loginpage/screen_loginpage.dart';
import 'package:dhani_communications/presentation/screens/screen_otppage/screen_otppage.dart';
import 'package:dhani_communications/presentation/screens/splash_screen/screen_splashpage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',

    routes: [
      /// Splash
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
///loginpage
   GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(),
      ),
      ///otppage
 GoRoute(
  path: '/otppage',
  builder: (context, state) {
    final phone = state.extra as String;
    return OtpPage(phoneNumber: phone);
  },
),

      /// Main Page
      GoRoute(
        path: '/main',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const ScreenMainPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
    ],
  );
}
