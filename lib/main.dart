import 'package:dhani_communications/core/colors.dart';
import 'package:dhani_communications/core/network_services.dart';
import 'package:dhani_communications/core/responsiveutils.dart';
import 'package:dhani_communications/domain/repositories/apprepo.dart';
import 'package:dhani_communications/features/auth/repo/authrepo.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/new_attendence_bloc/new_attendence_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/new_attendance_check_bloc/new_attendance_check_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/labor_punchin_bloc/labor_punchin_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/hq_vehicles_bloc/hq_vehicles_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/new_expense_bloc/new_expense_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/repo/multiactionrepo.dart';
import 'package:dhani_communications/presentation/blocs/attendance_check_bloc/attendance_check_bloc.dart';
import 'package:dhani_communications/presentation/blocs/attendance_list_bloc/attendance_list_bloc.dart';
import 'package:dhani_communications/presentation/blocs/bottom_navigation_bloc/bottom_navigation_bloc.dart';
import 'package:dhani_communications/presentation/blocs/create_attendance_bloc/create_attendance_bloc.dart';
import 'package:dhani_communications/presentation/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/expense_categories_bloc/expense_categories_bloc.dart';

import 'package:dhani_communications/presentation/blocs/create_leave_bloc/create_leave_bloc.dart';
import 'package:dhani_communications/presentation/blocs/dpr_details_bloc/dpr_details_bloc.dart';
import 'package:dhani_communications/presentation/blocs/dpr_list_bloc/dpr_list_bloc.dart';
import 'package:dhani_communications/presentation/blocs/dpr_submissions_bloc/dpr_submissions_bloc.dart';
import 'package:dhani_communications/presentation/blocs/expense_list_bloc/expense_list_bloc.dart';
import 'package:dhani_communications/presentation/blocs/get_inventories_bloc/get_inventories_bloc.dart';
import 'package:dhani_communications/presentation/blocs/labor_attendance_list_bloc/labor_attendance_list_bloc.dart';
import 'package:dhani_communications/presentation/blocs/leave_list_bloc/leave_list_bloc.dart';
import 'package:dhani_communications/presentation/blocs/notifications_bloc/notifications_bloc.dart';
import 'package:dhani_communications/features/auth/blocs/profile_bloc/profile_bloc.dart';
import 'package:dhani_communications/presentation/blocs/projects_bloc/projects_bloc.dart';
import 'package:dhani_communications/features/multiple_action_button/blocs/punch_in_list_bloc/punch_in_list_bloc.dart';
import 'package:dhani_communications/features/auth/blocs/send_otp_bloc/send_otp_bloc.dart';
import 'package:dhani_communications/presentation/blocs/update_dpr_bloc/update_dpr_bloc.dart';
import 'package:dhani_communications/features/auth/blocs/update_profile_bloc/update_profile_bloc.dart';
import 'package:dhani_communications/presentation/blocs/updates_bloc/updates_bloc.dart';
import 'package:dhani_communications/presentation/blocs/vehicles_bloc/vehicles_bloc.dart';
import 'package:dhani_communications/features/auth/blocs/verify_otp_bloc/verify_otp_bloc.dart';
import 'package:dhani_communications/widgets/app_router.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BottomNavigationBloc()),
        BlocProvider(create: (context) => SendOtpBloc(repository: authrepo)),
        BlocProvider(create: (context) => VerifyOtpBloc(repository: authrepo)),
        BlocProvider(create: (context) => ProfileBloc(repository: authrepo)),
        BlocProvider(
          create: (context) => UpdateProfileBloc(repository: authrepo),
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
        BlocProvider(create: (context) => CreateLeaveBloc(repository: apprepo)),
        BlocProvider(create: (context) => LeaveListBloc(repository: apprepo)),
        // DPR BLoCs
        BlocProvider(create: (context) => DprListBloc(repository: apprepo)),
        BlocProvider(create: (context) => DprDetailsBloc(repository: apprepo)),
        BlocProvider(create: (context) => UpdateDprBloc(repository: apprepo)),
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
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
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
