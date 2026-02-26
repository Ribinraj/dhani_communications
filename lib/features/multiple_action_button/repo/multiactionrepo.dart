import 'dart:developer';

import 'package:dhani_communications/core/urls.dart';
import 'package:dhani_communications/features/multiple_action_button/models/dpr_update_model.dart';
import 'package:dhani_communications/features/dashboard/models/employees_model.dart';
import 'package:dhani_communications/features/multiple_action_button/models/hq_vehicle_model.dart';
import 'package:dhani_communications/features/multiple_action_button/models/leave_categories_model.dart';
import 'package:dhani_communications/features/multiple_action_button/models/new_expense_request_model.dart';
import 'package:dhani_communications/features/multiple_action_button/models/new_leave_request_model.dart';
import 'package:dhani_communications/features/multiple_action_button/models/punch_in_list_model.dart';
import 'package:dhani_communications/features/multiple_action_button/models/attendance_check_response_model.dart';
import 'package:dhani_communications/features/multiple_action_button/models/attendence_requestmodel.dart';
import 'package:dhani_communications/features/multiple_action_button/models/labor_attendance_request_model.dart';
import 'package:dhani_communications/features/multiple_action_button/models/labor_punchout_request_model.dart';

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

class Multiactionrepo {
  final Dio dio;

  /// ✅ Dio MUST be injected (from DioClient)
  Multiactionrepo(this.dio);

  //==========================newattendence===============//
  Future<ApiResponse<String>> newattendence({
    required AttendanceRequestModel attendence,
  }) async {
    try {
      Response response = await dio.post(
        Endpoints.newattendence,
        data: attendence.toJson(),
      );
      final responseData = response.data;
      log('newattendence response: $responseData');

      if (!responseData["error"] && responseData["status"] == 200) {
        return ApiResponse(
          data: null,
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

  //==========================checkAttendance===============//
  Future<ApiResponse<AttendanceCheckResponseModel>> checkAttendance() async {
    try {
      Response response = await dio.get(Endpoints.checkAttendance);
      final responseData = response.data;
      log('checkAttendance response: $responseData');

      if (!responseData["error"] && responseData["status"] == 200) {
        final data = AttendanceCheckResponseModel.fromJson(
          responseData['data'] as Map<String, dynamic>,
        );
        return ApiResponse(
          data: data,
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

  /// Get punch in list (labors who have punched in)
  Future<ApiResponse<List<PunchInListModel>>> getPunchInList() async {
    try {
      Response response = await dio.get(Endpoints.getPunchInList);
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

  /// Get leave categories
  Future<ApiResponse<List<LeaveCategory>>> getleavecategories() async {
    try {
      Response response = await dio.get(Endpoints.leavecategories);
      final responseData = response.data;

      if (responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final leavecategories = dataList
            .map((item) => LeaveCategory.fromJson(item as Map<String, dynamic>))
            .toList();
        return ApiResponse(
          data: leavecategories,
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

  //==========================createLaborAttendance===============//
  Future<ApiResponse<String>> createLaborAttendance({
    required LaborAttendanceRequestModel laborAttendance,
  }) async {
    try {
      Response response = await dio.post(
        Endpoints.createLaborAttendance,
        data: laborAttendance.toJson(),
      );
      final responseData = response.data;
      log('createLaborAttendance response: $responseData');

      if (!responseData["error"] && responseData["status"] == 200) {
        return ApiResponse(
          data: null,
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

  //==========================createLaborPunchOut===============//
  Future<ApiResponse<String>> createLaborPunchOut({
    required LaborPunchOutRequestModel punchOut,
  }) async {
    try {
      Response response = await dio.post(
        Endpoints.createLaborAttendance,
        data: punchOut.toJson(),
      );
      final responseData = response.data;
      log('createLaborPunchOut response: $responseData');

      if (!responseData["error"] && responseData["status"] == 200) {
        return ApiResponse(
          data: null,
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

  //==========================getHqVehicles===============//
  Future<ApiResponse<List<HqVehicleModel>>> getHqVehicles() async {
    try {
      Response response = await dio.get(Endpoints.getHeadquarterVehicles);
      final responseData = response.data;
      log('getHqVehicles response: $responseData');

      if (!responseData["error"] && responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final vehicles = dataList
            .map(
              (item) => HqVehicleModel.fromJson(item as Map<String, dynamic>),
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

  //==========================createNewExpense===============//
  Future<ApiResponse<String>> createNewExpense({
    required NewExpenseRequestModel expense,
  }) async {
    try {
      Response response = await dio.post(
        Endpoints.createExpense,
        data: expense.toJson(),
      );
      final responseData = response.data;
      log('createNewExpense response: $responseData');

      if (!responseData["error"] && responseData["status"] == 200) {
        return ApiResponse(
          data: responseData['data']?.toString(),
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
  /// Update DPR
  Future<ApiResponse> updateDpr({
required DprUpdateModel dpr
  }) async {
    try {

      Response response = await dio.post(
        Endpoints.updateDpr,
        data:dpr,
     
      );
      final responseData = response.data;
      log('updateDpr response: $responseData');

      if (responseData["status"] == 200) {
        return ApiResponse(
          data:null,
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
  //==========================createNewLeave===============//
  Future<ApiResponse<String>> createNewLeave({
    required NewLeaveRequestModel leave,
  }) async {
    try {
      Response response = await dio.post(
        Endpoints.createLeave,
        data: leave.toJson(),
      );
      final responseData = response.data;
      log('createNewLeave response: $responseData');

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

  void dispose() {
    dio.close();
  }
}
