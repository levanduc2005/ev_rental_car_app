import 'package:flutter/material.dart';

/// Semantic flavor of a snackbar.
enum SnackType { info, success, error }

/// Convenience helpers for showing consistent snackbars.
///
/// Usage: `context.showSnackBar('Saved', type: SnackType.success);`
extension AppSnackBar on BuildContext {
  void showSnackBar(String message, {SnackType type = SnackType.info}) {
    final theme = Theme.of(this);
    final (background, foreground) = switch (type) {
      SnackType.info => (
        theme.colorScheme.inverseSurface,
        theme.colorScheme.onInverseSurface,
      ),
      SnackType.success => (const Color(0xFF1B5E20), Colors.white),
      SnackType.error => (theme.colorScheme.error, theme.colorScheme.onError),
    };

    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyle(color: foreground)),
          backgroundColor: background,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
