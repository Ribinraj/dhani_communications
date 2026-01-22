import 'dart:developer';

import 'package:dhani_communications/core/local_storages.dart';
import 'package:dhani_communications/core/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';




class ApiResponse<T> {
  final T? data;
  final String message;
  final bool error;
  final int status;

  ApiResponse(
      {this.data,
      required this.message,
      required this.error,
      required this.status});
}

class Authrepo {
  final Dio dio;

  /// ✅ Dio MUST be injected (from DioClient)
  Authrepo(this.dio);

  ///----------------------send otp-----------------------------////

  Future<ApiResponse<String>> sendOtp(
      {required String mobileNumber}) async {
    try {
      Response response = await dio
          .post(Endpoints.sendOtp, data: {  "mobileNumber": mobileNumber});
      final responseData = response.data;
      if (!responseData["error"] && responseData["status"] == 200) {
    final executiveId=responseData["data"]["userId"];
        return ApiResponse(
            data:executiveId,
            message: responseData["message"] ?? 'Success',
            error: false,
            status: responseData["status"]);
      } else {
        return ApiResponse(
            data: null,
            message: responseData["message"],
            error: true,
            status: responseData["status"]);
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
          message: 'Network or server error occured', error: true, status: 500);
    }
  }




  /// Verify OTP
  Future<ApiResponse<String>> verifyOtp({
    required String userId,
    required String verifyOtp,
  }) async {
    try {
      Response response = await dio.post(Endpoints.verifyOtp, data: {
        "userId": int.parse(userId),
        "verifyOtp": int.parse(verifyOtp),
      });
      final responseData = response.data;
      log('verifyOtp response: $responseData');

      if (!responseData["error"] && responseData["status"] == 200) {
        final token = responseData["data"]["token"];
        await LocalStorage.saveToken(token);
        return ApiResponse(
          data: token,
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

  /// Resend OTP
  Future<ApiResponse<void>> resendOtp({required String userId}) async {
    try {
      Response response = await dio.post(Endpoints.resendOtp, data: {
        "userId": int.parse(userId),
      });

      final responseData = response.data;
      log('resendOtp response: $responseData');

      if (!responseData["error"] && responseData["status"] == 200) {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'OTP resent successfully',
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
