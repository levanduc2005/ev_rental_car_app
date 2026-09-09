import 'package:flutter/material.dart';

/// Shows a standard confirmation dialog and resolves to `true` when the user
/// confirms, `false` (or `null` coerced to `false`) otherwise.
///
/// ```dart
/// final ok = await showConfirmDialog(
///   context,
///   title: 'Log out?',
///   message: 'You will need to sign in again.',
///   confirmLabel: 'Log out',
///   cancelLabel: 'Cancel',
///   isDestructive: true,
/// );
/// ```
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
  bool isDestructive = false,
}) async {
  final theme = Theme.of(context);
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          style: isDestructive
              ? FilledButton.styleFrom(backgroundColor: theme.colorScheme.error)
              : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}
