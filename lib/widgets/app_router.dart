import 'package:dhani_communications/presentation/screens/multiactonbutton_options/screen_dprprogresspage/screen_dprprogresspage.dart';
import 'package:dhani_communications/presentation/screens/multiactonbutton_options/screen_labourattendencepage/labour_puchoutpage.dart';
import 'package:dhani_communications/presentation/screens/multiactonbutton_options/screen_labourattendencepage/labour_punchinpage.dart';
import 'package:dhani_communications/presentation/screens/multiactonbutton_options/screen_labourattendencepage/screen_labourattendence_markingpage.dart';
import 'package:dhani_communications/presentation/screens/multiactonbutton_options/screen_leaveapplicationpage/screen_leaveapplicationpage.dart';
import 'package:dhani_communications/presentation/screens/multiactonbutton_options/screen_newattendencepage/screen_newattendencepage.dart';
import 'package:dhani_communications/presentation/screens/multiactonbutton_options/screen_newexpensepage/screen_newexpensepage.dart';
import 'package:dhani_communications/presentation/screens/multiactonbutton_options/screen_newmachineryhire/screen_newmachineryhire.dart';
import 'package:dhani_communications/presentation/screens/multiactonbutton_options/screen_requestpage/screen_requestpage.dart';
import 'package:dhani_communications/presentation/screens/screen_approvelspage/screen_employee_attendenceapprovelpage.dart';
import 'package:dhani_communications/presentation/screens/screen_assets_detailspage/screen_assetsdetailspage.dart';
import 'package:dhani_communications/presentation/screens/screen_assetspage/screen_assetspage.dart';
import 'package:dhani_communications/presentation/screens/screen_attendence_detailpage/screen_attendencedetailpage.dart';
import 'package:dhani_communications/presentation/screens/screen_attendencelist/screen_attendencelist.dart';
import 'package:dhani_communications/presentation/screens/screen_bottombar/screen_bottombar.dart';
import 'package:dhani_communications/presentation/screens/screen_editprofilepage/screen_editprofilepage.dart';
import 'package:dhani_communications/presentation/screens/screen_employeeleaves/screen_employeeleaves.dart';
import 'package:dhani_communications/presentation/screens/screen_expensedetailspage/screen_expensedetailspage.dart';
import 'package:dhani_communications/presentation/screens/screen_expenses/screen_expensespage.dart';
import 'package:dhani_communications/presentation/screens/screen_inventorydetailspage/screen_inventorydetailspage.dart';
import 'package:dhani_communications/presentation/screens/screen_inventorypage/screen_inventorypage.dart';
import 'package:dhani_communications/presentation/screens/screen_labourattendence/screen_labourattendence.dart';
import 'package:dhani_communications/presentation/screens/screen_labourattendence_details/screen_labour_attendencedetailpage.dart';
import 'package:dhani_communications/presentation/screens/screen_loginpage/screen_loginpage.dart';
import 'package:dhani_communications/presentation/screens/screen_machinehire_detailspage/screen_machinehiredetails_page.dart';
import 'package:dhani_communications/presentation/screens/screen_machinehiringpage/screen_machinehiringpage.dart';
import 'package:dhani_communications/presentation/screens/screen_otppage/screen_otppage.dart';
import 'package:dhani_communications/presentation/screens/screen_requestdetailpage/screen_requestdetailpage.dart';
import 'package:dhani_communications/presentation/screens/screen_requestspage/screen_requestspage.dart';
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
      ///assetsdetailspage
 GoRoute(
  path: '/assetdetailspage',
  builder: (context, state) {
    
    return ScreenAssetDetailsPage();
  },
),
      ///inventorypage
 GoRoute(
  path: '/inventorypage',
  builder: (context, state) {
    
    return ScreenInventorypage();
  },
), 
      ///inventorydetailspage
 GoRoute(
  path: '/inventorydetailspage',
  builder: (context, state) {
    
    return ScreenInventoryDetailPage();
  },
), 
      ///requestspage
 GoRoute(
  path: '/requestspage',
  builder: (context, state) {
    
    return ScreenrequestsPage();
  },
), 
      ///requestdetailspage
 GoRoute(
  path: '/requestdetailspage',
  builder: (context, state) {
    
    return ScreenRequestDetailPage();
  },
), 
      ///dialyattendencepage
 GoRoute(
  path: '/dailyattendencepage',
  builder: (context, state) {
    
    return DailyAttendancePage();
  },
), 
      ///labourAttendencepage
 GoRoute(
  path: '/labourAttendencemarkingpage',
  builder: (context, state) {
    
    return ScreenLabourattendenceMarkingpage();
  },
), 
      ///labourAttendencepage
 GoRoute(
  path: '/labourPunchinpage',
  builder: (context, state) {
    
    return LabourPunchInPage();
  },
), 
      ///labourpunchoutpage
 GoRoute(
  path: '/labourPunchoutpage',
  builder: (context, state) {
    
    return LabourPunchOutPage();
  },
), 
      ///approveemployeeattenedencepage
 GoRoute(
  path: '/approveemployeeattenedencepage',
  builder: (context, state) {
    
    return ScreenApproveEmployeesAttendancePage();
  },
), 
      ///newmachinehirepage
 GoRoute(
  path: '/newmachinehirepage',
  builder: (context, state) {
    
    return ScreenNewmachineryhire();
  },
), 
      ///newexpensepage
 GoRoute(
  path: '/newexpensepage',
  builder: (context, state) {
    
    return ScreenNewexpensepage();
  },
), 
      ///screenleaveapplicationpage
 GoRoute(
  path: '/leaveapplicationpage',
  builder: (context, state) {
    
    return ScreenLeaveApplicationPage();
  },
), 
      ///screenleaveapplicationpage
 GoRoute(
  path: '/dprprogress',
  builder: (context, state) {
    
    return ScreenDprProgressPage();
  },
),
      ///screenleaveapplicationpage
 GoRoute(
  path: '/newrequestpage',
  builder: (context, state) {
    
    return ScreenNewRequestPage();
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
