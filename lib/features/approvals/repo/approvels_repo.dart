import 'dart:developer';

import 'package:dhani_communications/core/urls.dart';
import 'package:dhani_communications/features/approvals/models/approvels_attendencemodel.dart';
import 'package:dhani_communications/features/approvals/models/approvels_dprmodel.dart';
import 'package:dhani_communications/features/approvals/models/approvels_expensemodel.dart';
import 'package:dhani_communications/features/approvals/models/approvels_labourattendencemodel.dart';
import 'package:dhani_communications/features/approvals/models/approvels_leavemodel.dart';
import 'package:dhani_communications/features/approvals/models/approvels_machine_hire_model.dart';
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

class ApprovelsRepo {
  final Dio dio;

  /// Dio MUST be injected (from DioClient)
  ApprovelsRepo(this.dio);

  /// Get attendance list for approval
  Future<ApiResponse<List<ApprovelsAttendencemodel>>>
  approveattendence() async {
    try {
      Response response = await dio.get(Endpoints.attendencelistforapprove);
      final responseData = response.data;

      if (responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final approveattendence = dataList
            .map(
              (item) => ApprovelsAttendencemodel.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList();
        return ApiResponse(
          data: approveattendence,
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

  /// Approve or Reject attendance
  Future<ApiResponse<bool>> updateAttendanceApproval({
    required String attendanceId,
    required String status,
    String? approverRemarks,
  }) async {
    try {
      final submitData = {
        'attendanceId': int.tryParse(attendanceId) ?? attendanceId,
        'status': status,
        'approverRemarks': approverRemarks,
      };

      Response response = await dio.post(
        Endpoints.updateattendanceapproval,
        data: submitData,
      );
      final responseData = response.data;

      if (responseData["status"] == 200) {
        return ApiResponse(
          data: true,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: false,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: false,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  /// Get labour attendance list for approval
  Future<ApiResponse<List<ApprovelsLabourattendencemodel>>>
  labourapproveattendence() async {
    try {
      Response response = await dio.get(Endpoints.approvelaboursattendencelist);
      final responseData = response.data;

      if (responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final approveattendence = dataList
            .map(
              (item) => ApprovelsLabourattendencemodel.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList();
        return ApiResponse(
          data: approveattendence,
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

  /// Approve or Reject labour attendance
  Future<ApiResponse<bool>> updateLabourAttendanceApproval({
    required String attendanceId,
    required String status,
    String? approverRemarks,
  }) async {
    try {
      final submitData = {
        'attendanceId': attendanceId,
        'status': status,
        'approverRemarks': approverRemarks,
      };

      Response response = await dio.post(
        Endpoints.updatelaborapproval,
        data: submitData,
      );
      final responseData = response.data;

      if (responseData["status"] == 200) {
        return ApiResponse(
          data: true,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: false,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: false,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  /// Get expenses list for approval
  Future<ApiResponse<List<ApprovelsExpensemodel>>> approvelexpenses() async {
    try {
      Response response = await dio.get(Endpoints.approvelexpenseslist);
      final responseData = response.data;

      if (responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final approveexpenselist = dataList
            .map(
              (item) =>
                  ApprovelsExpensemodel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        return ApiResponse(
          data: approveexpenselist,
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

  /// Approve or Reject expense
  Future<ApiResponse<bool>> updateExpenseApproval({
    required String expenseId,
    required String status,
    String? approverRemarks,
  }) async {
    try {
      final submitData = {
        'expenseId': expenseId,
        'status': status,
        'approverRemarks': approverRemarks,
      };

      Response response = await dio.post(
        Endpoints.updateexpenseapproval,
        data: submitData,
      );
      final responseData = response.data;

      if (responseData["status"] == 200) {
        return ApiResponse(
          data: true,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: false,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: false,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  /// Get expenses list for approval
  Future<ApiResponse<List<ApproveLeaveModel>>> approvelleaves() async {
    try {
      Response response = await dio.get(Endpoints.approvelleaves);
      final responseData = response.data;

      if (responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final approveleavelist = dataList
            .map(
              (item) =>
                  ApproveLeaveModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        return ApiResponse(
          data: approveleavelist,
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

  /// Approve or Reject leave
  Future<ApiResponse<bool>> updateLeaveApproval({
    required String leaveId,
    required String status,
    String? approverRemarks,
  }) async {
    try {
      final submitData = {
        'leaveId': leaveId,
        'status': status,
        'approverRemarks': approverRemarks,
      };

      Response response = await dio.post(
        Endpoints.updateleaveapproval,
        data: submitData,
      );
      final responseData = response.data;

      if (responseData["status"] == 200) {
        return ApiResponse(
          data: true,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: false,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: false,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  /// Get DPR list for approval
  Future<ApiResponse<List<ApproveDprDataModel>>> approveDpr() async {
    try {
      Response response = await dio.get(Endpoints.approveldprlist);
      final responseData = response.data;

      if (responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final approveDprList = dataList
            .map(
              (item) =>
                  ApproveDprDataModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        return ApiResponse(
          data: approveDprList,
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

  /// Get machine hire list for approval
  Future<ApiResponse<List<ApprovelsMachineHireModel>>> approveMachineHireList({
    String? filterFrom,
    String? filterTo,
  }) async {
    try {
      final Map<String, dynamic> submitData = {};
      if (filterFrom != null && filterTo != null) {
        submitData['filterFrom'] = filterFrom;
        submitData['filterTo'] = filterTo;
      }

      Response response = await dio.post(
        Endpoints.approveMachineHireList,
        data: submitData,
      );
      final responseData = response.data;

      if (responseData["status"] == 200) {
        final List<dynamic> dataList = responseData["data"] ?? [];
        final machineHireList = dataList
            .map(
              (item) => ApprovelsMachineHireModel.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList();
        return ApiResponse(
          data: machineHireList,
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

  /// Approve or Reject DPR progress
  Future<ApiResponse<bool>> updateDprApproval({
    required String progressId,
    required String status,
    String? approverRemarks,
  }) async {
    try {
      final submitData = {
        'progressId': int.tryParse(progressId) ?? progressId,
        'status': status,
        'approverRemarks': approverRemarks,
      };

      Response response = await dio.post(
        Endpoints.updatedprapproval,
        data: submitData,
      );
      final responseData = response.data;

      if (responseData["status"] == 200) {
        return ApiResponse(
          data: true,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: false,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: false,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }

  /// Approve or Reject machine hire
  Future<ApiResponse<bool>> updateMachineHireApproval({
    required String hireId,
    required String status,
    String? approverRemarks,
  }) async {
    try {
      final submitData = {
        'hireId': int.tryParse(hireId) ?? hireId,
        'status': status,
        'approverRemarks': approverRemarks,
      };

      Response response = await dio.post(
        Endpoints.updateMachineHireApproval,
        data: submitData,
      );
      final responseData = response.data;

      if (responseData["status"] == 200) {
        return ApiResponse(
          data: true,
          message: responseData['message'] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: false,
          message: responseData['message'] ?? 'Something went wrong',
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        data: false,
        message: 'Network or server error occurred',
        error: true,
        status: 500,
      );
    }
  }
}
