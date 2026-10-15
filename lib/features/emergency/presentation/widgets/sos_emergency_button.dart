import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_spacing.dart';

class SosEmergencyButton extends StatefulWidget {
  const SosEmergencyButton({super.key, this.rentalId, this.isFullWidth = true});

  final int? rentalId;
  final bool isFullWidth;

  @override
  State<SosEmergencyButton> createState() => _SosEmergencyButtonState();
}

class _SosEmergencyButtonState extends State<SosEmergencyButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onPressed() {
    context.push(AppRoute.emergencyReport.path, extra: widget.rentalId);
  }

  @override
  Widget build(BuildContext context) {
    final buttonChild = ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFDC2626).withValues(alpha: 0.45),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFDC2626),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            elevation: 0,
          ),
          icon: const Icon(Icons.sos_rounded, size: 24, color: Colors.white),
          label: const Text(
            'BÁO CÁO SỰ CỐ KHẨN CẤP (SOS)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          onPressed: _onPressed,
        ),
      ),
    );

    if (widget.isFullWidth) {
      return SizedBox(width: double.infinity, child: buttonChild);
    }

    return buttonChild;
  }
}
