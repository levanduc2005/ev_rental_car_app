import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';

/// Semantic flavor of a snackbar.
enum SnackType { info, success, error }

/// Convenience helpers for showing consistent snackbars.
///
/// Usage: `context.showSnackBar('Saved', type: SnackType.success);`
extension AppSnackBar on BuildContext {
  void showSnackBar(String message, {SnackType type = SnackType.info}) {
    final (background, icon) = switch (type) {
      SnackType.info => (
        AppColors.textPrimary,
        Icons.info_outline_rounded,
      ),
      SnackType.success => (
        AppColors.success,
        Icons.check_circle_outline_rounded,
      ),
      SnackType.error => (
        AppColors.error,
        Icons.error_outline_rounded,
      ),
    };

    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: background,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
  }
}
