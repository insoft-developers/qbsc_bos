
import 'package:flutter/material.dart';

class SnackbarHelper {
  /// Global key untuk ScaffoldMessenger
  static final GlobalKey<ScaffoldMessengerState>
      scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // ==========================================================
  // INFO
  // ==========================================================

  static void info(
    String title,
    String message,
  ) {
    _show(
      title: title,
      message: message,
      backgroundColor: Colors.blue.shade700,
    );
  }

  // ==========================================================
  // ERROR
  // ==========================================================

  static void error(
    String title,
    String message,
  ) {
    _show(
      title: title,
      message: message,
      backgroundColor: Colors.red.shade700,
    );
  }

  // ==========================================================
  // SUCCESS
  // ==========================================================

  static void success(
    String title,
    String message,
  ) {
    _show(
      title: title,
      message: message,
      backgroundColor: Colors.green.shade700,
    );
  }

  // ==========================================================
  // SHOW
  // ==========================================================

  static void _show({
    required String title,
    required String message,
    required Color backgroundColor,
  }) {
    final messenger =
        scaffoldMessengerKey.currentState;

    if (messenger == null) {
      return;
    }

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
  }
}
