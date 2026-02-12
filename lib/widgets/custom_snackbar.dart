import 'package:flutter/material.dart';

enum SnackBarType { success, error, info }

class CustomSnackbar {
  static void show({
    required BuildContext context,
    required String message,
    required SnackBarType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    final Color backgroundColor;
    final IconData icon;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = const Color(0xFF49CF41);
        icon = Icons.check_circle;
        break;
      case SnackBarType.error:
        backgroundColor = Colors.red;
        icon = Icons.error_outline;
        break;
      case SnackBarType.info:
        backgroundColor = Colors.orange;
        icon = Icons.info_outline;
        break;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: duration,
      ),
    );
  }
}
