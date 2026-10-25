import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rental_car/core/utils/map_launcher.dart';
import 'package:rental_car/features/active_trip/domain/entities/active_rental_entity.dart';
import 'package:rental_car/features/active_trip/presentation/providers/active_rental_providers.dart';
import 'package:rental_car/features/active_trip/presentation/widgets/countdown_box.dart';
import 'package:rental_car/features/active_trip/presentation/widgets/extend_trip_bottom_sheet.dart';
import 'package:rental_car/features/profile/domain/entities/rental_item_entity.dart';

/// Thẻ đồng hồ đếm ngược hành trình, thanh tiến trình sử dụng & thông tin trạm trả xe
class ActiveTripStatusCard extends ConsumerWidget {
  const ActiveTripStatusCard({
    super.key,
    required this.detail,
    required this.activeRentalItem,
    required this.deadline,
    required this.isOverdue,
  });

  final ActiveRentalEntity? detail;
  final RentalItemEntity? activeRentalItem;
  final DateTime deadline;
  final bool isOverdue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tự động re-render mỗi giây độc lập khi đồng hồ đếm
    ref.watch(activeTripTickerProvider);

    final now = DateTime.now();
    final diff = (!isOverdue && deadline.isAfter(now))
        ? deadline.difference(now)
        : Duration.zero;

    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;
    final seconds = diff.inSeconds % 60;

    final stationName =
        detail?.stationName ??
        activeRentalItem?.stationName ??
        'Trạm e-Motion Dĩ An';
    final stationAddress =
        detail?.stationAddress ?? '39/2/80 Thống Nhất, TP. Dĩ An';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Thời gian thuê xe còn lại & Badge "Đang trong chuyến" hoặc "Đã hết giờ"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: isOverdue
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF2563EB),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Thời gian thuê xe còn lại',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: isOverdue
                      ? const Color(0xFFFFF1F2)
                      : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isOverdue
                        ? const Color(0xFFFECDD3)
                        : const Color(0xFFDBEAFE),
                  ),
                ),
                child: Text(
                  isOverdue ? 'Đã hết giờ' : 'Đang trong chuyến',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isOverdue
                        ? const Color(0xFFE11D48)
                        : const Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Đồng hồ đếm ngược 4 ô: NGÀY | GIỜ | PHÚT | GIÂY
          Row(
            children: [
              CountdownBox(
                value: days.toString().padLeft(2, '0'),
                label: 'NGÀY',
                isHighlighted: false,
                isOverdue: isOverdue,
              ),
              const SizedBox(width: 10),
              CountdownBox(
                value: hours.toString().padLeft(2, '0'),
                label: 'GIỜ',
                isHighlighted: false,
                isOverdue: isOverdue,
              ),
              const SizedBox(width: 10),
              CountdownBox(
                value: minutes.toString().padLeft(2, '0'),
                label: 'PHÚT',
                isHighlighted: !isOverdue,
                isOverdue: isOverdue,
              ),
              const SizedBox(width: 10),
              CountdownBox(
                value: seconds.toString().padLeft(2, '0'),
                label: 'GIÂY',
                isHighlighted: !isOverdue,
                isOverdue: isOverdue,
              ),
            ],
          ),
          const SizedBox(height: 16),

          const Divider(height: 32, thickness: 1, color: Color(0xFFF1F5F9)),

          // Hạn trả: HH:mm - dd/MM/yyyy & Nút Gia hạn
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 15,
                    color: Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 7),
                  const Text(
                    'Hạn trả: ',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  Text(
                    DateFormat('HH:mm - dd/MM/yyyy').format(deadline),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  final rentalId = detail?.id ?? activeRentalItem?.id;
                  final vehicleId = detail?.vehicleId;
                  final vehicleName =
                      detail?.vehicleName ??
                      activeRentalItem?.vehicleName ??
                      'Xe điện';
                  // Tính đơn giá giờ thực tế của xe từ đơn thuê hiện tại (VD: VF8 = 900.000đ / 4h = 225.000đ/h)
                  double hourlyRate = 225000;
                  if (detail != null && detail!.rentFee > 0) {
                    final durationHours = detail!.endTime
                        .difference(detail!.startTime)
                        .inHours;
                    if (durationHours > 0) {
                      hourlyRate = detail!.rentFee / durationHours;
                    }
                  }

                  if (rentalId != null && vehicleId != null) {
                    showExtendTripBottomSheet(
                      context: context,
                      rentalId: rentalId,
                      vehicleId: vehicleId,
                      vehicleName: vehicleName,
                      currentEndTime: deadline,
                      pricePerHour: hourlyRate,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Không tìm thấy thông tin xe để gia hạn.',
                        ),
                      ),
                    );
                  }
                },
                child: const Row(
                  children: [
                    Text(
                      'Gia hạn',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 14,
                      color: Color(0xFF2563EB),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 30, thickness: 1, color: Color(0xFFF1F5F9)),

          // Trạm trả xe & Nút chỉ đường
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.location_on_rounded,
                  size: 17,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stationName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      stationAddress,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  MapLauncher.openDirections(
                    context: context,
                    latitude: detail?.stationLat,
                    longitude: detail?.stationLng,
                    stationName: stationName,
                    stationAddress: stationAddress,
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Row(
                    children: [
                      Text(
                        'Chỉ đường',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 14,
                        color: Color(0xFF2563EB),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
