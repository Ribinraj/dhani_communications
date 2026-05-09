import 'package:dhani_communications/features/approvals/models/approvels_attendencemodel.dart';
import 'package:dhani_communications/features/approvals/models/approvels_labourattendencemodel.dart';
import 'package:dhani_communications/features/approvals/pages/screen_approveattendencedetailspage.dart';
import 'package:dhani_communications/features/approvals/pages/screen_approve_labourattendence_detailpage.dart';
import 'package:dhani_communications/features/approvals/pages/screen_expense_approvel_detailpage.dart';
import 'package:dhani_communications/features/approvals/pages/screen_leave_approvel_detailpage.dart';
import 'package:dhani_communications/features/approvals/pages/screen_approveldprpage.dart';
import 'package:dhani_communications/features/approvals/pages/screen_approveldprdetailspage.dart';
import 'package:dhani_communications/features/approvals/models/approvels_expensemodel.dart';
import 'package:dhani_communications/features/approvals/models/approvels_leavemodel.dart';
import 'package:dhani_communications/features/approvals/models/approvels_machine_hire_model.dart';
import 'package:dhani_communications/features/approvals/models/approvels_dprmodel.dart';
import 'package:dhani_communications/features/dashboard/models/attendance_model.dart';
import 'package:dhani_communications/features/dashboard/models/company_asset_model.dart';
import 'package:dhani_communications/features/dashboard/models/expense_model.dart';
import 'package:dhani_communications/features/dashboard/models/inventory_item_model.dart';
import 'package:dhani_communications/features/dashboard/blocs/inventory_consumption_bloc/inventory_consumption_bloc.dart';
import 'package:dhani_communications/features/dashboard/blocs/employees_bloc/employees_bloc.dart';
import 'package:dhani_communications/features/dashboard/blocs/inventory_transfer_bloc/inventory_transfer_bloc.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_assettransferpage/screen_asset_transferpage.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_inventoryconsumptionpage/screen_inventoryconsumptionpage.dart';
import 'package:dhani_communications/features/dashboard/models/labor_attendance_model.dart';
import 'package:dhani_communications/features/dashboard/models/leave_model.dart';
import 'package:dhani_communications/features/dashboard/models/machine_hire_model.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_inventorytransferpage/screen_inventory_transferpage.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_leavedetailspage/screen_leavedetailspage.dart';
import 'package:dhani_communications/features/multiple_action_button/pages/screen_dprprogresspage/screen_dprprogresspage.dart';
import 'package:dhani_communications/features/multiple_action_button/pages/screen_labourattendencepage/labour_puchoutpage.dart';
import 'package:dhani_communications/features/multiple_action_button/pages/screen_labourattendencepage/labour_punchinpage.dart';
import 'package:dhani_communications/features/multiple_action_button/pages/screen_labourattendencepage/screen_labourattendence_markingpage.dart';
import 'package:dhani_communications/features/multiple_action_button/pages/screen_leaveapplicationpage/screen_leaveapplicationpage.dart';
import 'package:dhani_communications/features/multiple_action_button/pages/screen_newattendencepage/screen_newattendencepage.dart';
import 'package:dhani_communications/features/multiple_action_button/pages/screen_newexpensepage/screen_newexpensepage.dart';
import 'package:dhani_communications/features/multiple_action_button/pages/screen_newmachineryhire/screen_newmachineryhire.dart';
import 'package:dhani_communications/features/multiple_action_button/pages/screen_requestpage/screen_requestpage.dart';
import 'package:dhani_communications/features/approvals/pages/screen_approvelexpensepage.dart';
import 'package:dhani_communications/features/approvals/pages/screen_approvemachinerypage.dart';
import 'package:dhani_communications/features/approvals/pages/screen_contractlabours_attendenceapprovelpage.dart';
import 'package:dhani_communications/features/approvals/pages/screen_employee_attendenceapprovelpage.dart';
import 'package:dhani_communications/features/approvals/pages/screen_leaveapprovelpage.dart';
import 'package:dhani_communications/features/approvals/pages/screen_machinehire_approve_detailpage.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_assets_detailspage/screen_assetsdetailspage.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_cashbalancepage/screen_cashbalancepage.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_projectdprpage/screen_projectdprpage.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_dprsubmissionspage/screen_dprsubmissionspage.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_dprdetailspage/screen_dprdetailspage.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_assetspage/screen_assetspage.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_attendence_detailpage/screen_attendencedetailpage.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_attendencelist/screen_attendencelist.dart';
import 'package:dhani_communications/presentation/screens/screen_bottombar/screen_bottombar.dart';
import 'package:dhani_communications/features/auth/models/profile_model.dart';
import 'package:dhani_communications/features/auth/pages/screen_editprofilepage/screen_editprofilepage.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_employeeleaves/screen_employeeleaves.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_expensedetailspage/screen_expensedetailspage.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_expenses/screen_expensespage.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_inventorydetailspage/screen_inventorydetailspage.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_inventorypage/screen_inventorypage.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_labourattendence/screen_labourattendence.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_labourattendence_details/screen_labour_attendencedetailpage.dart';
import 'package:dhani_communications/features/auth/pages/screen_loginpage/screen_loginpage.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_machinehire_detailspage/screen_machinehiredetails_page.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_machinehiringpage/screen_machinehiringpage.dart';
import 'package:dhani_communications/presentation/screens/screen_notificationpage/screen_notificationpage.dart';
import 'package:dhani_communications/features/auth/pages/screen_otppage/screen_otppage.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_requestdetailpage/screen_requestdetailpage.dart';
import 'package:dhani_communications/features/dashboard/models/request_model.dart';
import 'package:dhani_communications/features/dashboard/models/vehicle_model.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_vehiclespage/screen_vehiclespage.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_vehicledetailpage/screen_vehicledetailpage.dart';
import 'package:dhani_communications/features/dashboard/pges/screen_requestspage/screen_requestspage.dart';
import 'package:dhani_communications/presentation/screens/splash_screen/screen_splashpage.dart';
import 'package:dhani_communications/features/auth/blocs/verify_otp_bloc/verify_otp_bloc.dart';
import 'package:dhani_communications/features/auth/repo/authrepo.dart';
import 'package:dhani_communications/features/dashboard/repo/apprepo.dart';
import 'package:dhani_communications/features/dashboard/blocs/dpr_details_bloc/dpr_details_bloc.dart';
import 'package:dhani_communications/core/network_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      GoRoute(path: '/login', builder: (context, state) => LoginPage()),

      ///otppage
      GoRoute(
        path: '/otppage',
        builder: (context, state) {
          final data = state.extra as Map<String, String>;
          final phone = data['phone'] ?? '';
          final userId = data['userId'] ?? '';
          return BlocProvider(
            create: (context) =>
                VerifyOtpBloc(repository: Authrepo(DioClient.create(context))),
            child: OtpPage(phoneNumber: phone, userId: userId),
          );
        },
      ),

      ///editprofilepage
      GoRoute(
        path: '/editprofilepage',
        builder: (context, state) {
          final profileData = state.extra as ProfileData?;
          return ScreenEditProfilePage(profileData: profileData);
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
          final attendance = state.extra as AttendanceModel?;
          return ScreenAttendanceDetailsPage(attendance: attendance);
        },
      ),

      ///approveattendencedetailpage
      GoRoute(
        path: '/approvelattendencedetailspage',
        builder: (context, state) {
          final attendance = state.extra as ApprovelsAttendencemodel?;
          return ScreenApproveAttendanceDetailPage(attendance: attendance!);
        },
      ),

      ///approvelabourattendencedetailspage
      GoRoute(
        path: '/approvelabourattendencedetailspage',
        builder: (context, state) {
          final attendance = state.extra as ApprovelsLabourattendencemodel?;
          return ScreenApproveLabourAttendanceDetailPage(
            attendance: attendance!,
          );
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
          final attendance = state.extra as LaborAttendanceModel?;
          return ScreenLabourAttendanceDetailsPage(attendance: attendance);
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
          final expense = state.extra as ExpenseModel?;
          return ScreenExpenseDetailPage(expense: expense);
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
          final machineHire = state.extra as MachineHireModel?;
          return ScreenMachineHireDetailPage(machineHire: machineHire);
        },
      ),

      ///leavespage
      GoRoute(
        path: '/leavespage',
        builder: (context, state) {
          return ScreenEmployeeLeavesPage();
        },
      ),

      ///leavedetailspage
      GoRoute(
        path: '/leavedetailspage',
        builder: (context, state) {
          final leave = state.extra as LeaveModel?;
          return ScreenLeaveDetailPage(leave: leave);
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
          final asset = state.extra as CompanyAssetModel?;
          return ScreenAssetDetailsPage(asset: asset);
        },
      ),

      ///projectdprpage
      GoRoute(
        path: '/projectdprpage',
        builder: (context, state) {
          return ScreenProjectDprPage();
        },
      ),

      ///dprdetailspage
      GoRoute(
        path: '/dprdetailspage',
        builder: (context, state) {
          final dprId = state.extra as int;
          return BlocProvider(
            create: (context) =>
                DprDetailsBloc(repository: Apprepo(DioClient.create(context))),
            child: ScreenDprDetailsPage(dprId: dprId),
          );
        },
      ),

      ///dprsubmissionspage
      GoRoute(
        path: '/dprsubmissionspage',
        builder: (context, state) {
          return ScreenDprSubmissionsPage();
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
          final inventoryItem = state.extra as InventoryItem;
          return ScreenInventoryDetailPage(inventoryItem: inventoryItem);
        },
      ),

      ///assettransferpage
      ///assettransferpage
      GoRoute(
        path: '/assettransferpage',
        builder: (context, state) {
          final asset = state.extra as CompanyAssetModel;
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => EmployeesBloc(
                  repository: Apprepo(DioClient.create(context)),
                ),
              ),
            ],
            child: ScreenAssetTransferPage(asset: asset),
          );
        },
      ),

      ///inventoryconsumptionpage
      GoRoute(
        path: '/inventoryconsumptionpage',
        builder: (context, state) {
          final inventoryItem = state.extra as InventoryItem;
          return BlocProvider(
            create: (context) => InventoryConsumptionBloc(
              repository: Apprepo(DioClient.create(context)),
            ),
            child: ScreenInventoryConsumptionPage(inventoryItem: inventoryItem),
          );
        },
      ),

      ///requestspage
      GoRoute(
        path: '/requestspage',
        builder: (context, state) {
          return ScreenrequestsPage();
        },
      ),

      ///cashbalancepage
      GoRoute(
        path: '/cashbalancepage',
        builder: (context, state) {
          return const ScreenCashBalancePage();
        },
      ),

      ///cashbalsepage
      GoRoute(
        path: '/cashbalsepage',
        builder: (context, state) {
          return const ScreenCashBalancePage();
        },
      ),

      ///vehiclespage
      GoRoute(
        path: '/vehiclespage',
        builder: (context, state) {
          return const ScreenVehiclesPage();
        },
      ),

      ///vehicledetailpage
      GoRoute(
        path: '/vehicledetailpage',
        builder: (context, state) {
          final vehicle = state.extra as VehicleModel;
          return ScreenVehicleDetailPage(vehicle: vehicle);
        },
      ),

      ///requestdetailspage
      GoRoute(
        path: '/requestdetailspage',
        builder: (context, state) {
          final request = state.extra as RequestModel?;
          return ScreenRequestDetailPage(request: request);
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

      ///screenleaveapplicationpage
      GoRoute(
        path: '/notificationpage',
        builder: (context, state) {
          return NotificationPage();
        },
      ),

      ///screenapprovecontractlaboursattendencepage
      GoRoute(
        path: '/contractlaboursattendenceapprovelpage',
        builder: (context, state) {
          return ScreenContractlaboursAttendenceapprovelpage();
        },
      ),

      ///screenapprovecontractlaboursattendencepage
      GoRoute(
        path: '/expenseapprovelpage',
        builder: (context, state) {
          return ScreenExpenseApprovalPage();
        },
      ),

      ///expenseapproveldetailpage
      GoRoute(
        path: '/expenseapproveldetailpage',
        builder: (context, state) {
          final expense = state.extra as ApprovelsExpensemodel?;
          return ScreenExpenseAprvelsDetailpage(expense: expense!);
        },
      ),

      ///screenleaveapprovelpage
      GoRoute(
        path: '/screenleaveapprovelpage',
        builder: (context, state) {
          return ScreenLeaveApprovalPage();
        },
      ),

      ///leaveapproveldetailpage
      GoRoute(
        path: '/leaveapproveldetailpage',
        builder: (context, state) {
          final leave = state.extra as ApproveLeaveModel?;
          return ScreenLeaveApprovelDetailpage(leave: leave!);
        },
      ),

      ///screenapproveldprpage
      GoRoute(
        path: '/screenapproveldprpage',
        builder: (context, state) {
          return const ScreenApprovelDprPage();
        },
      ),

      ///approveldprdetailpage
      GoRoute(
        path: '/approveldprdetailpage',
        builder: (context, state) {
          final dpr = state.extra as ApproveDprDataModel?;
          return ScreenApprovelDprDetailsPage(dpr: dpr!);
        },
      ),

      ///ScreenInventoryTransferPage
      GoRoute(
        path: '/ScreenInventoryTransferPage',
        builder: (context, state) {
          final inventoryItem = state.extra as InventoryItem;
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => EmployeesBloc(
                  repository: Apprepo(DioClient.create(context)),
                ),
              ),
              BlocProvider(
                create: (context) => InventoryTransferBloc(
                  repository: Apprepo(DioClient.create(context)),
                ),
              ),
            ],
            child: ScreenInventoryTransferPage(inventoryItem: inventoryItem),
          );
        },
      ),

      ///screenapprovemachinerypage
      GoRoute(
        path: '/screenapprovemachinerypage',
        builder: (context, state) {
          return ScreenApproveMachineryPage();
        },
      ),

      ///machinehireapprovedetailpage
      GoRoute(
        path: '/machinehireapprovedetailpage',
        builder: (context, state) {
          final machineHire = state.extra as ApprovelsMachineHireModel?;
          return ScreenMachineHireApproveDetailPage(machineHire: machineHire!);
        },
      ),

      /// Main Page
      GoRoute(
        path: '/main',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const ScreenMainPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          );
        },
      ),
    ],
  );
}
