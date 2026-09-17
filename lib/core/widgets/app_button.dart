import 'package:flutter/material.dart';
import 'package:rental_car/core/widgets/gap.dart';

/// Visual style of an [AppButton].
enum AppButtonVariant { primary, secondary, outline, text }

/// The app's standard button.
///
/// Wraps Material's button family behind one API so every button in the app
/// shares sizing, loading behavior and icon handling. When [isLoading] is true
/// the button is disabled and shows a spinner in place of its label.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.expanded = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;

  /// When true, the button stretches to the full available width.
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;
    final child = _buildChild(context);

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: effectiveOnPressed,
        child: child,
      ),
      AppButtonVariant.secondary => FilledButton.tonal(
        onPressed: effectiveOnPressed,
        child: child,
      ),
      AppButtonVariant.outline => OutlinedButton(
        onPressed: effectiveOnPressed,
        child: child,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: effectiveOnPressed,
        child: child,
      ),
    };

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }

  Widget _buildChild(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2.5),
      );
    }
    if (icon == null) return Text(label);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon, size: 20), const Gap.h(8), Text(label)],
    );
  }
}
