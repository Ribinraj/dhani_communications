
import 'package:dhani_communications/core/local_storages.dart';
import 'package:dhani_communications/core/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dhani_communications/core/localization/app_localization.dart';

class DioClient {
  static Dio create(BuildContext context) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Endpoints.baseUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        /// ✅ ADD TOKEN AUTOMATICALLY
        onRequest: (options, handler) async {
          final token = await LocalStorage.getToken();
          if (token.isNotEmpty) {
            options.headers['Authorization'] = token;
          }
          handler.next(options);
        },

        /// ❌ HANDLE 401 GLOBALLY
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            await _handleUnauthorized(context, e);
          }
          handler.next(e);
        },
      ),
    );

    return dio;
  }

  static Future<void> _handleUnauthorized(
    BuildContext context,
    DioException e,
  ) async {
    // Clear local session
    await LocalStorage.clearAll();

    // Show popup
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(context.tr('session_expired')),
        content: Text(
          e.response?.data['message'] ??
              'Your session has expired. Please login again.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/send-otp', (_) => false);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
