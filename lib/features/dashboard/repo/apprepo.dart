import 'dart:developer';

import 'package:dhani_communications/core/local_storages.dart';
import 'package:dhani_communications/core/urls.dart';
import 'package:dhani_communications/features/dashboard/models/attendance_check_model.dart';
import 'package:dhani_communications/features/dashboard/models/attendance_model.dart';
import 'package:dhani_communications/features/dashboard/models/cash_transaction_model.dart';
import 'package:dhani_communications/features/dashboard/models/dpr_model.dart';
import 'package:dhani_communications/features/dashboard/models/expense_category_model.dart';
import 'package:dhani_communications/features/dashboard/models/expense_model.dart';
import 'package:dhani_communications/features/dashboard/models/headquarter_vehicle_model.dart';
import 'package:dhani_communications/features/dashboard/models/inventory_consumption_model.dart';
import 'package:dhani_communications/features/dashboard/models/inventory_transfer_model.dart';
import 'package:dhani_communications/features/dashboard/models/asset_transfer_model.dart';
import 'package:dhani_communications/features/dashboard/models/inventory_item_model.dart';
import 'package:dhani_communications/features/dashboard/models/labor_attendance_model.dart';
import 'package:dhani_communications/features/dashboard/models/leave_model.dart';
import 'package:dhani_communications/features/dashboard/models/machine_hire_model.dart';
import 'package:dhani_communications/features/dashboard/models/machine_type_model.dart';
import 'package:dhani_communications/features/dashboard/models/notification_model.dart';
import 'package:dhani_communications/features/dashboard/models/project_model.dart';
import 'package:dhani_communications/features/dashboard/models/employees_model.dart';

import 'package:dhani_communications/features/dashboard/models/update_model.dart';
import 'package:dhani_communications/features/dashboard/models/vehicle_model.dart';
import 'package:dhani_communications/features/dashboard/models/company_asset_model.dart';
import 'package:dhani_communications/features/dashboard/models/request_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiResponse<T> {
  final T? data;
  final String message;
  final bool error;
  final int status;

  ApiResponse({
    this.data,
    required this.message,
    required this.error,
    required this.status,
  });
}

class Apprepo {
  final Dio dio;

  /// ✅ Dio MUST be injected (from DioClient)
  Apprepo(this.dio);

  /// Get updates/news/images for home screen
  Future<ApiResponse<List<UpdateModel>>> getUpdates() async {
    try {
      final token = await LocalStorage.getToken();
      Response response = await dio.get(
        Endpoints.getUpdates,
        options: Options(headers: {'Authorization': token}),
      );
      final responseData = response.data;
      log('getUpdates response: $responseData');

      if (responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final updates = dataList
            .map((item) => UpdateModel.fromJson(item as Map<String, dynamic>))
            .toList();
        return ApiResponse(
          data: updates,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  /// Get projects list assigned to user
  Future<ApiResponse<List<ProjectModel>>> getProjects() async {
    try {
      final token = await LocalStorage.getToken();
      Response response = await dio.get(
        Endpoints.getProjects,
        options: Options(headers: {'Authorization': token}),
      );
      final responseData = response.data;
      log('getProjects response: $responseData');

      if (responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final projects = dataList
            .map((item) => ProjectModel.fromJson(item as Map<String, dynamic>))
            .toList();
        return ApiResponse(
          data: projects,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  /// Get current cash balance
  Future<ApiResponse<String>> getCashBalance() async {
    try {
      Response response = await dio.get(Endpoints.cashBalance);
      final responseData = response.data;
      log('getCashBalance response: $responseData');

      if (responseData["status"] == 200) {
        return ApiResponse(
          data: responseData["data"]?.toString() ?? '0.00',
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  /// Get cash transactions
  Future<ApiResponse<List<CashTransactionModel>>> getCashTransactions() async {
    try {
      Response response = await dio.get(Endpoints.cashTransactions);
      final responseData = response.data;
      log('getCashTransactions response: $responseData');

      if (responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final transactions = dataList
            .map(
              (item) =>
                  CashTransactionModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        return ApiResponse(
          data: transactions,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  /// Get vehicles list assigned to user
  Future<ApiResponse<List<VehicleModel>>> getVehicles() async {
    try {
      final token = await LocalStorage.getToken();
      Response response = await dio.get(
        Endpoints.getVehicles,
        options: Options(headers: {'Authorization': token}),
      );
      final responseData = response.data;
      log('getVehicles response: $responseData');

      if (responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final vehicles = dataList
            .map((item) => VehicleModel.fromJson(item as Map<String, dynamic>))
            .toList();
        return ApiResponse(
          data: vehicles,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  /// Get headquarters vehicles list
  Future<ApiResponse<List<HeadquarterVehicleModel>>>
  getHeadquarterVehicles() async {
    try {
      final token = await LocalStorage.getToken();
      Response response = await dio.get(
        Endpoints.getHeadquarterVehicles,
        options: Options(headers: {'Authorization': token}),
      );
      final responseData = response.data;
      log('getHeadquarterVehicles response: $responseData');

      if (responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final vehicles = dataList
            .map(
              (item) => HeadquarterVehicleModel.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList();
        return ApiResponse(
          data: vehicles,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  /// Update vehicle information
  Future<ApiResponse<void>> updateVehicle({
    required int vehicleId,
    required double vehicleLastServiceKm,
    required String vehicleLastServiceDate,
    required String vehiclePucValidity,
    required String vehicleInsuranceValidity,
  }) async {
    try {
      final token = await LocalStorage.getToken();
      Response response = await dio.post(
        Endpoints.updateVehicle,
        data: {
          'vehicleId': vehicleId,
          'vehicleLastServiceKm': vehicleLastServiceKm,
          'vehicleLastServiceDate': vehicleLastServiceDate,
          'vehiclePucValidity': vehiclePucValidity,
          'vehicleInsuranceValidity': vehicleInsuranceValidity,
        },
        options: Options(headers: {'Authorization': token}),
      );
      final responseData = response.data;
      log('updateVehicle response: $responseData');

      if (responseData["status"] == 200) {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Vehicle updated successfully',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  /// Get notifications for user (POST with empty body)
  Future<ApiResponse<List<NotificationModel>>> getNotifications() async {
    try {
      final token = await LocalStorage.getToken();
      Response response = await dio.post(
        Endpoints.getNotifications,
        data: {},
        options: Options(headers: {'Authorization': token}),
      );
      final responseData = response.data;
      log('getNotifications response: $responseData');

      if (responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final notifications = dataList
            .map(
              (item) =>
                  NotificationModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        return ApiResponse(
          data: notifications,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  /// Update notification status (mark as read)
  Future<ApiResponse<void>> updateNotification({
    required int notificationId,
  }) async {
    try {
      final token = await LocalStorage.getToken();
      Response response = await dio.post(
        Endpoints.updateNotification,
        data: {'notificationId': notificationId},
        options: Options(headers: {'Authorization': token}),
      );
      final responseData = response.data;
      log('updateNotification response: $responseData');

      if (responseData["status"] == 200) {
        return ApiResponse(
          data: null,
          message:
              responseData['message'] ?? 'Notification updated successfully',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  // ==================== ATTENDANCE APIs ====================

  /// Check if attendance can be marked
  Future<ApiResponse<AttendanceCheckModel>> checkAttendance() async {
    try {
      final token = await LocalStorage.getToken();
      Response response = await dio.get(
        Endpoints.checkAttendance,
        options: Options(headers: {'Authorization': token}),
      );
      final responseData = response.data;
      log('checkAttendance response: $responseData');

      if (responseData["status"] == 200) {
        final checkData = AttendanceCheckModel.fromJson(
          responseData["data"] as Map<String, dynamic>,
        );
        return ApiResponse(
          data: checkData,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  /// Create new attendance record
  Future<ApiResponse<int>> createAttendance({
    required int projectId,
    required double attendance,
    required double attendanceLatt,
    required double attendanceLong,
    String? userRemarks,
    String? picture,
  }) async {
    try {
      final token = await LocalStorage.getToken();
      Response response = await dio.post(
        Endpoints.createAttendance,
        data: {
          'projectId': projectId,
          'attendance': attendance,
          'attendanceLatt': attendanceLatt,
          'attendanceLong': attendanceLong,
          if (userRemarks != null) 'userRemarks': userRemarks,
          if (picture != null) 'picture': picture,
        },
        options: Options(headers: {'Authorization': token}),
      );
      final responseData = response.data;
      log('createAttendance response: $responseData');

      if (responseData["status"] == 200) {
        return ApiResponse(
          data: responseData["data"] as int?,
          message:
              responseData['message'] ?? 'Attendance recorded successfully',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  /// Get attendance list
  Future<ApiResponse<List<AttendanceModel>>> getAttendanceList({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final token = await LocalStorage.getToken();
      final requestData = {
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
      };
      log('getAttendanceList request data: $requestData');

      Response response = await dio.post(
        Endpoints.getAttendanceList,
        data: requestData,
        options: Options(headers: {'Authorization': token}),
      );
      final responseData = response.data;
      log('getAttendanceList response: $responseData');

      if (responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final attendanceList = dataList
            .map(
              (item) => AttendanceModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        return ApiResponse(
          data: attendanceList,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  // ==================== LABOR ATTENDANCE APIs ====================

  /// Get labor attendance list
  Future<ApiResponse<List<LaborAttendanceModel>>> getLaborAttendanceList({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final token = await LocalStorage.getToken();
      final requestData = {
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
      };
      log('getLaborAttendanceList request data: $requestData');

      Response response = await dio.post(
        Endpoints.getLaborAttendanceList,
        data: requestData,
        options: Options(headers: {'Authorization': token}),
      );
      final responseData = response.data;
      log('getLaborAttendanceList response: $responseData');

      if (responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final laborAttendanceList = dataList
            .map(
              (item) =>
                  LaborAttendanceModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        return ApiResponse(
          data: laborAttendanceList,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  // ==================== EXPENSES APIs ====================

  /// Create new expense record
  Future<ApiResponse<int>> createExpense({
    required int projectId,
    required String expenseDate,
    required int expenseCategoryId,
    required double expenseAmount,
    int? vehicleId,
    int? fuelFillKm,
    String? userRemarks,
    List<ExpenseAttachment>? attachements,
  }) async {
    try {
      final token = await LocalStorage.getToken();
      Response response = await dio.post(
        Endpoints.createExpense,
        data: {
          'projectId': projectId,
          'expenseDate': expenseDate,
          'expenseCategoryId': expenseCategoryId,
          'expenseAmount': expenseAmount,
          if (vehicleId != null) 'vehicleId': vehicleId,
          if (fuelFillKm != null) 'fuelFillKm': fuelFillKm,
          if (userRemarks != null) 'userRemarks': userRemarks,
          if (attachements != null)
            'attachements': attachements.map((a) => a.toJson()).toList(),
        },
        options: Options(headers: {'Authorization': token}),
      );
      final responseData = response.data;
      log('createExpense response: $responseData');

      if (responseData["status"] == 200) {
        return ApiResponse(
          data: responseData["data"] as int?,
          message: responseData['message'] ?? 'Expense submitted successfully',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  /// Get expenses list
  Future<ApiResponse<List<ExpenseModel>>> getExpensesList({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final token = await LocalStorage.getToken();
      final requestData = {
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
      };
      log('getExpensesList request data: $requestData');

      Response response = await dio.post(
        Endpoints.getExpensesList,
        data: requestData,
        options: Options(headers: {'Authorization': token}),
      );
      final responseData = response.data;
      log('getExpensesList response: $responseData');

      if (responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final expensesList = dataList
            .map((item) => ExpenseModel.fromJson(item as Map<String, dynamic>))
            .toList();
        return ApiResponse(
          data: expensesList,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  /// Get leaves list
  Future<ApiResponse<List<LeaveModel>>> getLeavesList({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final token = await LocalStorage.getToken();
      final requestData = {
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
      };
      log('getLeavesList request data: $requestData');

      Response response = await dio.post(
        Endpoints.getLeavesList,
        data: requestData,
        options: Options(headers: {'Authorization': token}),
      );
      final responseData = response.data;
      log('getLeavesList response: $responseData');

      if (responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final leavesList = dataList
            .map((item) => LeaveModel.fromJson(item as Map<String, dynamic>))
            .toList();
        return ApiResponse(
          data: leavesList,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  // ==================== DPR APIs ====================

  /// Get DPR list
  Future<ApiResponse<List<DprModel>>> getDprList({
    required int projectId,
  }) async {
    try {
      final token = await LocalStorage.getToken();
      Response response = await dio.post(
        Endpoints.getDprList,
        data: {'projectId': projectId},
        options: Options(headers: {'Authorization': token}),
      );
      final responseData = response.data;
      log('getDprList response: $responseData');

      if (responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final dprList = dataList
            .map((item) => DprModel.fromJson(item as Map<String, dynamic>))
            .toList();
        return ApiResponse(
          data: dprList,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  /// Get DPR details
  Future<ApiResponse<DprDetailsModel>> getDprDetails({
    required int dprId,
  }) async {
    try {
      final token = await LocalStorage.getToken();
      Response response = await dio.post(
        Endpoints.getDprDetails,
        data: {'dprId': dprId},
        options: Options(headers: {'Authorization': token}),
      );
      final responseData = response.data;
      log('getDprDetails response: $responseData');

      if (responseData["status"] == 200) {
        final dprDetails = DprDetailsModel.fromJson(
          responseData["data"] as Map<String, dynamic>,
        );
        return ApiResponse(
          data: dprDetails,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  /// Get my DPR submissions
  Future<ApiResponse<List<DprSubmissionModel>>> getMyDprSubmissions({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final token = await LocalStorage.getToken();
      final requestData = {
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
      };
      log('getMyDprSubmissions request data: $requestData');

      Response response = await dio.post(
        Endpoints.getMyDprSubmissions,
        data: requestData,
        options: Options(headers: {'Authorization': token}),
      );
      final responseData = response.data;
      log('getMyDprSubmissions response: $responseData');

      if (responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final submissions = dataList
            .map(
              (item) =>
                  DprSubmissionModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        return ApiResponse(
          data: submissions,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  // ==================== COMPANY ASSETS APIs ====================

  /// Get company assets list assigned to user
  Future<ApiResponse<List<CompanyAssetModel>>> getCompanyAssets() async {
    try {
      final token = await LocalStorage.getToken();
      Response response = await dio.post(
        Endpoints.companyassets,
        data: {},
        options: Options(headers: {'Authorization': token}),
      );
      final responseData = response.data;
      log('getCompanyAssets response: $responseData');

      if (responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final assetsList = dataList
            .map(
              (item) =>
                  CompanyAssetModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        return ApiResponse(
          data: assetsList,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  // ========================= inventory list ========================= //
  Future<ApiResponse<List<InventoryItem>>> getInventories() async {
    try {
      Response response = await dio.post(Endpoints.getInventories, data: {});

      final responseData = response.data;
      log('getInventories response: $responseData');

      if (responseData != null && responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];

        final inventories = dataList
            .map((item) => InventoryItem.fromJson(item as Map<String, dynamic>))
            .toList();

        return ApiResponse(
          data: inventories,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData?['message'] ?? 'Something went wrong',
          error: true,
          status: responseData?["status"] ?? 400,
        );
      }
    } on DioException catch (e) {
      log('Dio error: ${e.response?.data ?? e.message}');
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      log('Unexpected error: $e');
      return ApiResponse(
        data: null,
        message: 'Unexpected error occurred',
        error: true,
        status: 500,
      );
    }
  }

  /// Get expense categories
  Future<ApiResponse<List<ExpenseCategoryModel>>> getExpenseCategories() async {
    try {
      Response response = await dio.get(Endpoints.expensescategories);
      final responseData = response.data;
      log('getExpenseCategories response: $responseData');

      if (!responseData['error'] && responseData['status'] == 200) {
        final List<dynamic> dataList = responseData['data'] ?? [];
        final categories = dataList
            .map(
              (item) =>
                  ExpenseCategoryModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        return ApiResponse(
          data: categories,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData['status'],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData['status'],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  /// Get machine types from masters/machinelist
  Future<ApiResponse<List<MachineTypeModel>>> getMachineTypes() async {
    try {
      Response response = await dio.get(Endpoints.machineTypes);
      final responseData = response.data;
      log('getMachineTypes response: $responseData');

      if (!responseData['error'] && responseData['status'] == 200) {
        final List<dynamic> dataList = responseData['data'] ?? [];
        final machineTypes = dataList
            .map(
              (item) => MachineTypeModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        return ApiResponse(
          data: machineTypes,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData['status'],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData['status'],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  //==========================Inventory cunsumption===============//
  Future<ApiResponse<String>> inventoryconsumption({
    required InventoryConsumptionModel inventorydata,
  }) async {
    try {
      Response response = await dio.post(
        Endpoints.inventoryconsumption,
        data: inventorydata.toJson(),
      );
      final responseData = response.data;

      if (!responseData["error"] && responseData["status"] == 200) {
        return ApiResponse(
          data: responseData['data']?.toString(),
          message: responseData['message'] ?? 'Leave submitted successfully',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  //==========================Inventory transfer===============//
  Future<ApiResponse<String>> inventoryTransfer({
    required InventoryTransferModel transferData,
  }) async {
    try {
      Response response = await dio.post(
        Endpoints.inventoryTransfer,
        data: transferData.toJson(),
      );
      final responseData = response.data;
      log('inventoryTransfer response: $responseData');

      if (!responseData["error"] && responseData["status"] == 200) {
        return ApiResponse(
          data: responseData['data']?.toString(),
          message: responseData['message'] ?? 'Transfer submitted successfully',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  //==========================Asset transfer===============//
  Future<ApiResponse<String>> assetTransfer({
    required AssetTransferModel transferData,
  }) async {
    try {
      Response response = await dio.post(
        Endpoints.assetTransfer,
        data: transferData.toJson(),
      );
      final responseData = response.data;
      log('assetTransfer response: $responseData');

      if (!responseData["error"] && responseData["status"] == 200) {
        return ApiResponse(
          data: responseData['data']?.toString(),
          message: responseData['message'] ?? 'Asset transferred successfully',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  //==========================getemployees===============//
  Future<ApiResponse<List<EmployeeModel>>> geemployees() async {
    try {
      Response response = await dio.get(Endpoints.employees);
      final responseData = response.data;
      log('getHqVehicles response: $responseData');

      if (!responseData["error"] && responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final employees = dataList
            .map((item) => EmployeeModel.fromJson(item as Map<String, dynamic>))
            .toList();
        return ApiResponse(
          data: employees,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  // ========================= machinehirelist list ========================= //
  Future<ApiResponse<List<MachineHireModel>>> machinehirelist() async {
    try {
      Response response = await dio.post(Endpoints.machinehire, data: {});

      final responseData = response.data;
      log('machinehire response: $responseData');

      if (responseData != null && responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];

        final machinelist = dataList
            .map(
              (item) => MachineHireModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();

        return ApiResponse(
          data: machinelist,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData?['message'] ?? 'Something went wrong',
          error: true,
          status: responseData?["status"] ?? 400,
        );
      }
    } on DioException catch (e) {
      log('Dio error: ${e.response?.data ?? e.message}');
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      log('Unexpected error: $e');
      return ApiResponse(
        data: null,
        message: 'Unexpected error occurred',
        error: true,
        status: 500,
      );
    }
  }

  // ========================= Request list ========================= //
  Future<ApiResponse<List<RequestModel>>> getRequestList() async {
    try {
      final token = await LocalStorage.getToken();
      Response response = await dio.get(
        Endpoints.requestList,
        options: Options(headers: {'Authorization': token}),
      );

      final responseData = response.data;
      log('getRequestList response: $responseData');

      if (responseData != null && responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final requestList = dataList
            .map((item) => RequestModel.fromJson(item as Map<String, dynamic>))
            .toList();

        return ApiResponse(
          data: requestList,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData?['message'] ?? 'Something went wrong',
          error: true,
          status: responseData?["status"] ?? 400,
        );
      }
    } on DioException catch (e) {
      log('Dio error: ${e.response?.data ?? e.message}');
      return ApiResponse(
        data: null,
        message: 'Network or server error occurred',
        error: true,
        status: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      log('Unexpected error: $e');
      return ApiResponse(
        data: null,
        message: 'Unexpected error occurred',
        error: true,
        status: 500,
      );
    }
  }

  void dispose() {
    dio.close();
  }
}
