import 'package:flutter/material.dart';

/// Wraps [child] and, while [isLoading] is true, dims it behind a modal
/// spinner and blocks interaction.
///
/// Handy for submit flows: keep the form visible but prevent taps while a
/// request is in flight.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    required this.isLoading,
    required this.child,
    super.key,
  });

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          const Positioned.fill(
            child: ColoredBox(
              color: Color(0x66000000),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
