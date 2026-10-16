import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/checkout/presentation/providers/checkout_controller.dart';
import 'package:rental_car/features/checkout/presentation/widgets/checkout_vehicle_header_card.dart';
import 'package:rental_car/features/checkout/presentation/widgets/vehicle_log_damages_card.dart';

class ReturnVehicleLogPage extends ConsumerStatefulWidget {
  const ReturnVehicleLogPage({super.key, this.rentalId});

  final int? rentalId;

  @override
  ConsumerState<ReturnVehicleLogPage> createState() =>
      _ReturnVehicleLogPageState();
}

class _ReturnVehicleLogPageState extends ConsumerState<ReturnVehicleLogPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentRentalId =
          widget.rentalId ?? ref.read(checkoutControllerProvider).rentalId;
      if (currentRentalId != null && currentRentalId > 0) {
        ref
            .read(checkoutControllerProvider.notifier)
            .loadRentalOverview(currentRentalId);
      }
    });
  }

  Future<void> _handleRefresh() async {
    final currentRentalId =
        widget.rentalId ?? ref.read(checkoutControllerProvider).rentalId;
    if (currentRentalId != null && currentRentalId > 0) {
      await ref
          .read(checkoutControllerProvider.notifier)
          .loadRentalOverview(currentRentalId);
    }
  }

  void _navigateToSettlement() {
    final targetRentalId =
        widget.rentalId ?? ref.read(checkoutControllerProvider).rentalId;
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.pushReplacementNamed(
        AppRoute.checkoutSummary.name,
        extra: targetRentalId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(checkoutControllerProvider);
    final overview = state.overview;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Biên bản hư hại xe',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Làm mới dữ liệu',
            icon: state.isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh_rounded, color: Color(0xFF2563EB)),
            onPressed: state.isLoading ? null : _handleRefresh,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: const Color(0xFF2563EB),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Thẻ thông tin xe và trạm
              CheckoutVehicleHeaderCard(
                vehicleName: overview?.vehicleName ?? '--',
                plateNumber: overview?.vehiclePlateNumber ?? '--',
                stationName: overview?.stationName ?? state.stationName ?? '--',
              ),
              const SizedBox(height: 16),

              // 2. Danh sách các hư hỏng và chi phí (VehicleLog)
              VehicleLogDamagesCard(overview: overview),
              const SizedBox(height: 24),

              // 3. Nút chuyển qua phần thanh toán / quyết toán cọc
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: _navigateToSettlement,
                icon: const Icon(Icons.receipt_long_rounded, size: 20),
                label: const Text(
                  'Chuyển qua quyết toán & Thanh toán',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
