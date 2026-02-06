import 'dart:developer';

import 'package:dhani_communications/core/local_storages.dart';
import 'package:dhani_communications/core/urls.dart';
import 'package:dhani_communications/data/models/attendance_check_model.dart';
import 'package:dhani_communications/data/models/attendance_model.dart';
import 'package:dhani_communications/data/models/dpr_model.dart';
import 'package:dhani_communications/data/models/expense_model.dart';
import 'package:dhani_communications/data/models/headquarter_vehicle_model.dart';
import 'package:dhani_communications/data/models/labor_attendance_model.dart';
import 'package:dhani_communications/data/models/leave_model.dart';
import 'package:dhani_communications/data/models/notification_model.dart';
import 'package:dhani_communications/data/models/project_model.dart';
import 'package:dhani_communications/data/models/punch_in_list_model.dart';
import 'package:dhani_communications/data/models/update_model.dart';
import 'package:dhani_communications/data/models/vehicle_model.dart';
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

  /// Get vehicles list assigned to user (POST with empty body)
  Future<ApiResponse<List<VehicleModel>>> getVehicles() async {
    try {
      final token = await LocalStorage.getToken();
      Response response = await dio.post(
        Endpoints.getVehicles,
        data: {},
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
    required int meterReading,
    required String vehicleNumber,
  }) async {
    try {
      final token = await LocalStorage.getToken();
      Response response = await dio.post(
        Endpoints.updateVehicle,
        data: {
          'vehicleId': vehicleId,
          'meterReading': meterReading,
          'vehicleNumber': vehicleNumber,
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

  /// Create new labor attendance record
  Future<ApiResponse<int>> createLaborAttendance({
    required int projectId,
    required String laborName,
    required String laborMobile,
    required String laborType,
    required String attendanceDate,
    required String punchInTime,
    required double punchInLatt,
    required double punchInLong,
    String? userRemarks,
    String? picture,
  }) async {
    try {
      final token = await LocalStorage.getToken();
      Response response = await dio.post(
        Endpoints.createLaborAttendance,
        data: {
          'projectId': projectId,
          'laborName': laborName,
          'laborMobile': laborMobile,
          'laborType': laborType,
          'attendanceDate': attendanceDate,
          'punchInTime': punchInTime,
          'punchInLatt': punchInLatt,
          'punchInLong': punchInLong,
          if (userRemarks != null) 'userRemarks': userRemarks,
          if (picture != null) 'picture': picture,
        },
        options: Options(headers: {'Authorization': token}),
      );
      final responseData = response.data;
      log('createLaborAttendance response: $responseData');

      if (responseData["status"] == 200) {
        return ApiResponse(
          data: responseData["data"] as int?,
          message:
              responseData['message'] ??
              'Labor attendance recorded successfully',
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

  /// Get punch in list (labors who have punched in)
  Future<ApiResponse<List<PunchInListModel>>> getPunchInList() async {
    try {
      final token = await LocalStorage.getToken();
      Response response = await dio.get(
        Endpoints.getPunchInList,
        options: Options(headers: {'Authorization': token}),
      );
      final responseData = response.data;
      log('getPunchInList response: $responseData');

      if (responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final punchInList = dataList
            .map(
              (item) => PunchInListModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        return ApiResponse(
          data: punchInList,
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

  // ==================== LEAVES APIs ====================

  /// Create new leave application
  Future<ApiResponse<int>> createLeave({
    required int projectId,
    required int leaveCategoryId,
    required String leaveFromDate,
    required String leaveToDate,
    String? userRemarks,
    double? leaveLatt,
    double? leaveLong,
    String? picture,
  }) async {
    try {
      final token = await LocalStorage.getToken();
      Response response = await dio.post(
        Endpoints.createLeave,
        data: {
          'projectId': projectId,
          'leaveCategoryId': leaveCategoryId,
          'leaveFromDate': leaveFromDate,
          'leaveToDate': leaveToDate,
          if (userRemarks != null) 'userRemarks': userRemarks,
          if (leaveLatt != null) 'leaveLatt': leaveLatt,
          if (leaveLong != null) 'leaveLong': leaveLong,
          if (picture != null) 'picture': picture,
        },
        options: Options(headers: {'Authorization': token}),
      );
      final responseData = response.data;
      log('createLeave response: $responseData');

      if (responseData["status"] == 200) {
        return ApiResponse(
          data: responseData["data"] as int?,
          message:
              responseData['message'] ??
              'Leave application submitted successfully',
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
    required String startDate,
    required String endDate,
  }) async {
    try {
      final token = await LocalStorage.getToken();
      Response response = await dio.post(
        Endpoints.getDprList,
        data: {
          'projectId': projectId,
          'startDate': startDate,
          'endDate': endDate,
        },
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

  /// Update DPR
  Future<ApiResponse<int>> updateDpr({
    int? dprId,
    required int projectId,
    required String dprDate,
    required int progress,
    String? userRemarks,
  }) async {
    try {
      final token = await LocalStorage.getToken();
      Response response = await dio.post(
        Endpoints.updateDpr,
        data: {
          if (dprId != null) 'dprId': dprId,
          'projectId': projectId,
          'dprDate': dprDate,
          'progress': progress,
          if (userRemarks != null) 'userRemarks': userRemarks,
        },
        options: Options(headers: {'Authorization': token}),
      );
      final responseData = response.data;
      log('updateDpr response: $responseData');

      if (responseData["status"] == 200) {
        return ApiResponse(
          data: responseData["data"] as int?,
          message: responseData['message'] ?? 'DPR updated successfully',
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
    required int projectId,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final token = await LocalStorage.getToken();
      Response response = await dio.post(
        Endpoints.getMyDprSubmissions,
        data: {
          'projectId': projectId,
          'startDate': startDate,
          'endDate': endDate,
        },
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

  void dispose() {
    dio.close();
  }
}
