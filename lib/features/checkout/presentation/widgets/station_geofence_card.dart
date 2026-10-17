import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/checkout/presentation/providers/checkout_controller.dart';

class StationGeofenceCard extends StatelessWidget {
  const StationGeofenceCard({
    super.key,
    required this.state,
    required this.onRetryLocation,
  });

  final CheckoutState state;
  final VoidCallback onRetryLocation;

  @override
  Widget build(BuildContext context) {
    final distance = state.distanceInMeters;
    final isValid = state.isLocationValid;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (state.isLocationChecking) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Đang xác thực tọa độ GPS của thiết bị...',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (isValid) ...[
              const Icon(
                Icons.check_circle_rounded,
                size: 56,
                color: AppColors.success,
              ),
              const SizedBox(height: 12),
              const Text(
                'Vị trí trả xe hợp lệ!',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Bạn đang ở trong phạm vi trạm (${distance?.toStringAsFixed(0)} mét ≤ 100m). Sẵn sàng bàn giao xe.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ] else if (distance != null) ...[
              const Icon(
                Icons.wrong_location_rounded,
                size: 56,
                color: Color(0xFFD97706),
              ),
              const SizedBox(height: 12),
              const Text(
                'Chưa đỗ đúng phạm vi trạm',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD97706),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Khoảng cách hiện tại: ${distance.toStringAsFixed(0)} mét (Yêu cầu ≤ 100m tính từ trạm).\nVui lòng đỗ xe lại gần trạm để tiếp tục.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Thử lại định vị'),
                onPressed: onRetryLocation,
              ),
            ] else ...[
              const Icon(
                Icons.location_off_rounded,
                size: 56,
                color: Color(0xFFDC2626),
              ),
              const SizedBox(height: 12),
              const Text(
                'Chưa nhận diện được vị trí',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDC2626),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.locationError ??
                    'Không thể kết nối dịch vụ GPS. Vui lòng kiểm tra quyền vị trí trên máy và thử lại.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Thử lại định vị'),
                    onPressed: onRetryLocation,
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.settings_outlined, size: 18),
                    label: const Text('Mở Cài đặt máy'),
                    onPressed: () => Geolocator.openAppSettings(),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
