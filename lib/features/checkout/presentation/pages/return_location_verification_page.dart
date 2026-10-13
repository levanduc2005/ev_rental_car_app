import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/checkout/presentation/providers/checkout_controller.dart';
import 'package:rental_car/features/checkout/presentation/widgets/station_geofence_card.dart';
import 'package:rental_car/features/checkout/presentation/widgets/station_info_card.dart';

class ReturnLocationVerificationPage extends ConsumerStatefulWidget {
  const ReturnLocationVerificationPage({
    super.key,
    this.rentalId,
    this.vehicleId,
    this.staffId,
    this.stationName,
    this.stationAddress,
    this.stationLat,
    this.stationLng,
  });

  final int? rentalId;
  final int? vehicleId;
  final int? staffId;
  final String? stationName;
  final String? stationAddress;
  final double? stationLat;
  final double? stationLng;

  @override
  ConsumerState<ReturnLocationVerificationPage> createState() =>
      _ReturnLocationVerificationPageState();
}

class _ReturnLocationVerificationPageState
    extends ConsumerState<ReturnLocationVerificationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = widget.rentalId;
      if (id != null && id > 0) {
        ref.read(checkoutControllerProvider.notifier).initialize(
              id,
              vehicleId: widget.vehicleId,
              staffId: widget.staffId,
              stationName: widget.stationName,
              stationAddress: widget.stationAddress,
              stationLat: widget.stationLat,
              stationLng: widget.stationLng,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(checkoutControllerProvider);
    final controller = ref.read(checkoutControllerProvider.notifier);

    final isValid = state.isLocationValid;

    final displayStationName = state.stationName ??
        widget.stationName ??
        '--';
    final displayStationAddress = state.stationAddress ??
        widget.stationAddress ??
        '--';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Xác thực vị trí trả xe',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Làm mới vị trí',
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: state.isLocationChecking ? null : controller.verifyLocation,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Thẻ Trạm sạc quy định
            StationInfoCard(
              stationName: displayStationName,
              stationAddress: displayStationAddress,
            ),
            const SizedBox(height: 16),

            // 2. Thẻ Kết quả Định vị GPS Geofence
            StationGeofenceCard(
              state: state,
              onRetryLocation: controller.verifyLocation,
            ),
            const SizedBox(height: 24),

            // 3. Nút tiếp tục
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              onPressed: isValid
                  ? () {
                      context.pushNamed(
                        AppRoute.checkoutSummary.name,
                        extra: state.rentalId,
                      );
                    }
                  : null,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_turned_in_rounded, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Xác nhận bàn giao xe tại trạm',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
