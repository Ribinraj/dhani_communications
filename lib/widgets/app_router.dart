import 'package:dhani_communications/presentation/screens/screen_assetspage/screen_assetspage.dart';
import 'package:dhani_communications/presentation/screens/screen_attendence_detailpage/screen_attendencedetailpage.dart';
import 'package:dhani_communications/presentation/screens/screen_attendencelist/screen_attendencelist.dart';
import 'package:dhani_communications/presentation/screens/screen_bottombar/screen_bottombar.dart';
import 'package:dhani_communications/presentation/screens/screen_editprofilepage/screen_editprofilepage.dart';
import 'package:dhani_communications/presentation/screens/screen_employeeleaves/screen_employeeleaves.dart';
import 'package:dhani_communications/presentation/screens/screen_expensedetailspage/screen_expensedetailspage.dart';
import 'package:dhani_communications/presentation/screens/screen_expenses/screen_expensespage.dart';
import 'package:dhani_communications/presentation/screens/screen_labourattendence/screen_labourattendence.dart';
import 'package:dhani_communications/presentation/screens/screen_labourattendence_details/screen_labour_attendencedetailpage.dart';
import 'package:dhani_communications/presentation/screens/screen_loginpage/screen_loginpage.dart';
import 'package:dhani_communications/presentation/screens/screen_machinehire_detailspage/screen_machinehiredetails_page.dart';
import 'package:dhani_communications/presentation/screens/screen_machinehiringpage/screen_machinehiringpage.dart';
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
      ///editprofilepage
 GoRoute(
  path: '/editprofilepage',
  builder: (context, state) {
    final profiledata = state.extra as  Map<String, dynamic>;
    return ScreenEditProfilePage(profileData: profiledata,);
  },
),
      ///employeeatttendencepage
 GoRoute(
  path: '/employeeattendencepage',
  builder: (context, state) {
    
    return ScreenEmployeeAttendancePage();
  },
),
      ///employeeatttendencepage
 GoRoute(
  path: '/employeeattendencedetailpage',
  builder: (context, state) {
    
    return ScreenAttendanceDetailsPage();
  },
),
      ///labourattendencepage
 GoRoute(
  path: '/labourattendencepage',
  builder: (context, state) {
    
    return ScreenLabourAttendancePage();
  },
),
      ///labourattendencedetailpage
 GoRoute(
  path: '/labourattendencepagedetailpage',
  builder: (context, state) {
    
    return ScreenLabourAttendanceDetailsPage();
  },
),
      ///expensespage
 GoRoute(
  path: '/expensespage',
  builder: (context, state) {
    
    return ScreenEmployeeExpensesPage();
  },
),
      ///expensedetailspage
 GoRoute(
  path: '/expensedetailspage',
  builder: (context, state) {
    
    return ScreenExpenseDetailPage();
  },
),
      ///machinehiringpage
 GoRoute(
  path: '/machinehiringpage',
  builder: (context, state) {
    
    return ScreenMachineHiringPage();
  },
),
      ///machinehiredetailpage
 GoRoute(
  path: '/machinehiredetailpage',
  builder: (context, state) {
    
    return ScreenMachineHireDetailPage();
  },
),
      ///leavespage
 GoRoute(
  path: '/leavespage',
  builder: (context, state) {
    
    return ScreenEmployeeLeavesPage();
  },
),
      ///assetspage
 GoRoute(
  path: '/assetspage',
  builder: (context, state) {
    
    return ScreenAssetsPage();
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
