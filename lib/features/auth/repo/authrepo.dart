import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dhani_communications/core/local_storages.dart';
import 'package:dhani_communications/core/urls.dart';
import 'package:dhani_communications/features/auth/models/profile_model.dart';
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

class Authrepo {
  final Dio dio;

  /// ✅ Dio MUST be injected (from DioClient)
  Authrepo(this.dio);

  ///----------------------send otp-----------------------------////

  Future<ApiResponse<String>> sendOtp({required String mobileNumber}) async {
    try {
      Response response = await dio.post(
        Endpoints.sendOtp,
        data: {"mobileNumber": mobileNumber},
      );
      final responseData = response.data;
      if (!responseData["error"] && responseData["status"] == 200) {
        final executiveId = responseData["data"]["userId"];
        log(executiveId);
        return ApiResponse(
          data: executiveId,
          message: responseData["message"] ?? 'Success',
          error: false,
          status: responseData["status"],
        );
      } else {
        return ApiResponse(
          data: null,
          message: responseData["message"],
          error: true,
          status: responseData["status"],
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      log(e.toString());
      return ApiResponse(
        message: 'Network or server error occured',
        error: true,
        status: 500,
      );
    }
  }

  /// Verify OTP
  Future<ApiResponse<String>> verifyOtp({
    required String userId,
    required String verifyOtp,
  }) async {
    try {
      Response response = await dio.post(
        Endpoints.verifyOtp,
        data: {"userId": int.parse(userId), "verifyOtp": int.parse(verifyOtp)},
      );
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
      Response response = await dio.post(
        Endpoints.resendOtp,
        data: {"userId": int.parse(userId)},
      );

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

  /// Get user profile
  Future<ApiResponse<ProfileData>> getProfile() async {
    try {
      Response response = await dio.get(Endpoints.getProfile);
      final responseData = response.data;
      log('getProfile response: $responseData');

      if (!responseData["error"] && responseData["status"] == 200) {
        final profileData = ProfileData.fromJson(responseData["data"]);
        return ApiResponse(
          data: profileData,
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

  /// Update user profile
  Future<ApiResponse<void>> updateProfile({
    required Map<String, dynamic> profileData,
  }) async {
    try {
      Response response = await dio.post(
        Endpoints.updateProfile,
        data: profileData,
      );

      final responseData = response.data;
      log('updateProfile response: $responseData');

      if (!responseData["error"] && responseData["status"] == 200) {
        return ApiResponse(
          data: null,
          message: responseData['message'] ?? 'Profile updated successfully',
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

  /// Update profile photo
  Future<ApiResponse<void>> updateProfilePhoto({
    required File imageFile,
  }) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      final fileName = imageFile.path.split('/').last;

      Response response = await dio.post(
        Endpoints.updateProfilePhoto,
        data: {'profilePhoto': base64Image, 'fileName': fileName},
      );

      final responseData = response.data;
      log('updateProfilePhoto response: $responseData');

      if (!responseData["error"] && responseData["status"] == 200) {
        return ApiResponse(
          data: null,
          message:
              responseData['message'] ?? 'Profile photo updated successfully',
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
//   ///////////////update token/////////////////
Future<void> updatetoken({required String token}) async {
  try {
  
    
    Response response = await dio.post(
      Endpoints.settoken, 
    
      data: {  "pushToken": token}
    );
    
    final responseData = response.data;
    if (!responseData["error"] && responseData["status"] == 200) {
      log("FCM token updated successfully");
    } else {
      log("Failed to update FCM token: ${responseData["message"]}");
    }
  } catch (e) {
    log("Error updating FCM token: $e");
  }
}
  void dispose() {
    dio.close();
  }

  /// Remove FCM push token from server (logout flow)
  Future<void> removeToken({required String token}) async {
    try {
      Response response = await dio.post(
        Endpoints.removetoken,
        data: {"pushToken": token},
      );

      final responseData = response.data;
      if (!responseData["error"] && responseData["status"] == 200) {
        log("FCM token removed from server successfully");
      } else {
        log("Failed to remove FCM token from server: ${responseData["message"]}");
      }
    } catch (e) {
      log("Error removing FCM token from server: $e");
    }
  }
}
