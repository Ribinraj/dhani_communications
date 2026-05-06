import 'dart:io';

import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/network_services.dart';
import 'package:dhani_communications/core/pushnotification_controller.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/features/approvals/bloc/fetch_approvel_attendence/fetch_approvelattendence_bloc.dart';
import 'package:dhani_communications/features/approvals/bloc/fetch_approvel_dprbloc/fetch_approvel_dpr_bloc.dart';
import 'package:dhani_communications/features/approvals/bloc/fetch_approvel_expense_bloc/fetch_approvel_expense_bloc.dart';
import 'package:dhani_communications/features/approvals/bloc/fetch_approvel_leave_bloc/fetch_approvel_leave_bloc.dart';
import 'package:dhani_communications/features/approvals/bloc/fetch_labour_approvelattendence_bloc/fetch_labour_approvelattendence_bloc.dart';
import 'package:dhani_communications/features/approvals/bloc/update_approvel_attendence/update_approvel_attendence_bloc.dart';
import 'package:dhani_communications/features/approvals/bloc/update_labour_approvel_attendence/update_labour_approvel_attendence_bloc.dart';
import 'package:dhani_communications/features/approvals/bloc/update_approvel_expense/update_approvel_expense_bloc.dart';
import 'package:dhani_communications/features/approvals/bloc/update_approvel_leave/update_approvel_leave_bloc.dart';
import 'package:dhani_communications/features/approvals/bloc/update_approvel_dpr/update_approvel_dpr_bloc.dart';
import 'package:dhani_communications/features/approvals/repo/approvels_repo.dart';
import 'package:dhani_communications/features/dashboard/repo/apprepo.dart';
import 'package:dhani_communications/features/auth/repo/authrepo.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/leave_categories_bloc/leave_categories_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/new_attendence_bloc/new_attendence_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/new_attendance_check_bloc/new_attendance_check_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/labor_punchin_bloc/labor_punchin_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/hq_vehicles_bloc/hq_vehicles_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/new_expense_bloc/new_expense_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/new_leave_bloc/new_leave_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/repo/multiactionrepo.dart';
import 'package:dhani_communications/features/dashboard/blocs/asset_transfer_bloc/asset_transfer_bloc.dart';
import 'package:dhani_communications/features/dashboard/blocs/attendance_check_bloc/attendance_check_bloc.dart';
import 'package:dhani_communications/features/dashboard/blocs/attendance_list_bloc/attendance_list_bloc.dart';
import 'package:dhani_communications/features/dashboard/blocs/bottom_navigation_bloc/bottom_navigation_bloc.dart';
import 'package:dhani_communications/features/dashboard/blocs/create_attendance_bloc/create_attendance_bloc.dart';
import 'package:dhani_communications/features/dashboard/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/expense_categories_bloc/expense_categories_bloc.dart';

import 'package:dhani_communications/features/dashboard/blocs/dpr_details_bloc/dpr_details_bloc.dart';
import 'package:dhani_communications/features/dashboard/blocs/dpr_list_bloc/dpr_list_bloc.dart';
import 'package:dhani_communications/features/dashboard/blocs/dpr_submissions_bloc/dpr_submissions_bloc.dart';
import 'package:dhani_communications/features/dashboard/blocs/expense_list_bloc/expense_list_bloc.dart';
import 'package:dhani_communications/features/dashboard/blocs/get_inventories_bloc/get_inventories_bloc.dart';
import 'package:dhani_communications/features/dashboard/blocs/labor_attendance_list_bloc/labor_attendance_list_bloc.dart';
import 'package:dhani_communications/features/dashboard/blocs/leave_list_bloc/leave_list_bloc.dart';
import 'package:dhani_communications/features/dashboard/blocs/notifications_bloc/notifications_bloc.dart';
import 'package:dhani_communications/features/auth/blocs/profile_bloc/profile_bloc.dart';
import 'package:dhani_communications/features/dashboard/blocs/projects_bloc/projects_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/punch_in_list_bloc/punch_in_list_bloc.dart';
import 'package:dhani_communications/features/auth/blocs/send_otp_bloc/send_otp_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/update_dpr_bloc/update_dpr_bloc.dart';
import 'package:dhani_communications/features/auth/blocs/update_profile_bloc/update_profile_bloc.dart';
import 'package:dhani_communications/features/dashboard/blocs/updates_bloc/updates_bloc.dart';
import 'package:dhani_communications/features/dashboard/blocs/vehicles_bloc/vehicles_bloc.dart';
import 'package:dhani_communications/features/auth/blocs/verify_otp_bloc/verify_otp_bloc.dart';
import 'package:dhani_communications/widgets/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Optional: initialize firebase here if you need (only if you use Firebase in background)
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PushNotifications.backgroundMessageHandler(message);
}

// Global navigator key so we can navigate from notification handlers
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main()async {
      WidgetsFlutterBinding.ensureInitialized();
      // Initialize Firebase
  await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform,
  );

  // Register FCM background handler BEFORE runApp
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize PushNotifications helper (this will request permissions, create channel, etc.)
  // It's okay to await this so notifications are ready by the time the app runs.
  await PushNotifications.instance.init();

  // Optional: request permissions again for iOS if you want explicit control here
  if (Platform.isIOS) {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils().init(context);
    final dio = DioClient.create(context);
    final authrepo = Authrepo(dio);
    final apprepo = Apprepo(dio);
    final multirepo = Multiactionrepo(dio);
    final approvelreppo = ApprovelsRepo(dio);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BottomNavigationBloc()),
        BlocProvider(create: (context) => SendOtpBloc(repository: authrepo)),
        BlocProvider(create: (context) => VerifyOtpBloc(repository: authrepo)),
        BlocProvider(create: (context) => ProfileBloc(repository: authrepo)),
        BlocProvider(
          create: (context) => UpdateProfileBloc(repository: authrepo),
        ),
        BlocProvider(
          create: (context) => AssetTransferBloc(repository: apprepo),
        ),
        BlocProvider(create: (context) => UpdatesBloc(repository: apprepo)),
        BlocProvider(create: (context) => ProjectsBloc(repository: apprepo)),
        BlocProvider(create: (context) => VehiclesBloc(repository: apprepo)),
        BlocProvider(
          create: (context) => NotificationsBloc(repository: apprepo),
        ),
        // Attendance BLoCs
        BlocProvider(
          create: (context) => AttendanceCheckBloc(repository: apprepo),
        ),
        BlocProvider(
          create: (context) => CreateAttendanceBloc(repository: apprepo),
        ),
        BlocProvider(
          create: (context) => AttendanceListBloc(repository: apprepo),
        ),
        // Labor Attendance BLoCs
        BlocProvider(
          create: (context) => LaborAttendanceListBloc(repository: apprepo),
        ),

        BlocProvider(
          create: (context) => PunchInListBloc(repository: multirepo),
        ),
        // Expenses BLoCs
        BlocProvider(
          create: (context) => CreateExpenseBloc(repository: apprepo),
        ),
        BlocProvider(create: (context) => ExpenseListBloc(repository: apprepo)),
        BlocProvider(
          create: (context) => ExpenseCategoriesBloc(repository: apprepo),
        ),

        // Leaves BLoCs
        BlocProvider(create: (context) => LeaveListBloc(repository: apprepo)),
        // DPR BLoCs
        BlocProvider(create: (context) => DprListBloc(repository: apprepo)),
        BlocProvider(create: (context) => DprDetailsBloc(repository: apprepo)),
        BlocProvider(create: (context) => UpdateDprBloc(repository: multirepo)),
        BlocProvider(
          create: (context) => DprSubmissionsBloc(repository: apprepo),
        ),
        BlocProvider(
          create: (context) => GetInventoriesBloc(repository: apprepo),
        ),

        //multiactionblocs
        BlocProvider(
          create: (context) => NewAttendenceBloc(repository: multirepo),
        ),
        BlocProvider(
          create: (context) => NewAttendanceCheckBloc(repository: multirepo),
        ),
        BlocProvider(
          create: (context) => LaborPunchInBloc(repository: multirepo),
        ),
        BlocProvider(
          create: (context) => HqVehiclesBloc(repository: multirepo),
        ),
        BlocProvider(
          create: (context) => NewExpenseBloc(repository: multirepo),
        ),
        BlocProvider(
          create: (context) => LeaveCategoriesBloc(repository: multirepo),
        ),
        BlocProvider(create: (context) => NewLeaveBloc(repository: multirepo)),
        BlocProvider(
          create: (context) =>
              FetchApprovelattendenceBloc(repository: approvelreppo),
        ),
        BlocProvider(
          create: (context) =>
              UpdateApprovelAttendenceBloc(repository: approvelreppo),
        ),
        BlocProvider(
          create: (context) =>
              FetchLabourApprovelattendenceBloc(repository: approvelreppo),
        ),
        BlocProvider(
          create: (context) =>
              UpdateLabourApprovelAttendenceBloc(repository: approvelreppo),
        ),
        BlocProvider(
          create: (context) =>
              FetchApprovelExpenseBloc(repository: approvelreppo),
        ),
        BlocProvider(
          create: (context) =>
              UpdateApprovelExpenseBloc(repository: approvelreppo),
        ),
        BlocProvider(
          create: (context) =>
              FetchApprovelLeaveBloc(repository: approvelreppo),
        ),
        BlocProvider(
          create: (context) =>
              UpdateApprovelLeaveBloc(repository: approvelreppo),
        ),
        BlocProvider(
          create: (context) => FetchApprovelDprBloc(repository: approvelreppo),
        ),
        BlocProvider(
          create: (context) => UpdateApprovelDprBloc(repository: approvelreppo),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
            surfaceTintColor: Appcolors.kappbarbackgroundcolor,
            elevation: 1,
            shadowColor: Appcolors.kgreyColor.withValues(alpha: 0.1),
          ),
          fontFamily: 'Helvetica',
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          scaffoldBackgroundColor: Appcolors.kwhitecolor,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
