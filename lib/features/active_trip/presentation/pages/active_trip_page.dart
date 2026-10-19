import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/features/active_trip/domain/entities/active_rental_entity.dart';
import 'package:rental_car/features/active_trip/presentation/providers/active_rental_providers.dart';
import 'package:rental_car/features/active_trip/presentation/widgets/widgets.dart';
import 'package:rental_car/features/profile/domain/entities/rental_item_entity.dart';
import 'package:rental_car/features/profile/presentation/providers/profile_providers.dart';

/// Màn hình Chuyến đi đang hoạt động (Active Trip) - Giao diện Digital Cockpit gọn gàng & hiện đại
class ActiveTripPage extends ConsumerWidget {
  const ActiveTripPage({super.key, this.rentalId});

  final int? rentalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Ticker nhịp đếm mỗi giây để trạng thái hạn giờ và countdown cập nhật tự động
    ref.watch(activeTripTickerProvider);

    // 2. Tìm đơn thuê từ rentalHistory
    final rentalState = ref.watch(rentalHistoryControllerProvider);
    RentalItemEntity? activeRentalItem;
    int? targetRentalId = rentalId;

    if (targetRentalId != null) {
      for (final item in rentalState.items) {
        if (item.id == targetRentalId) {
          activeRentalItem = item;
          break;
        }
      }
    } else {
      for (final item in rentalState.items) {
        final s = item.status.toUpperCase();
        if (s == 'ONGOING' ||
            s == 'IN_PROGRESS' ||
            s == 'ACTIVE' ||
            s == 'OVERDUE') {
          activeRentalItem = item;
          targetRentalId = item.id;
          break;
        }
      }
    }

    // 3. Tải chi tiết đơn thuê đầy đủ nếu có targetRentalId
    final activeDetailAsync = targetRentalId != null
        ? ref.watch(activeRentalDetailControllerProvider(targetRentalId))
        : const AsyncValue<ActiveRentalEntity?>.data(null);

    final detail = activeDetailAsync.whenOrNull(data: (d) => d);
    final now = DateTime.now();

    final hasTrip =
        detail != null || activeRentalItem != null || targetRentalId != null;

    final vehicleName =
        detail?.vehicleName ??
        activeRentalItem?.vehicleName ??
        'Chuyến xe e-Motion';
    final vehiclePlate = (detail != null && detail.vehiclePlate.isNotEmpty)
        ? detail.vehiclePlate
        : '59T2-${targetRentalId ?? 87343}';
    final imageUrl = (detail != null && detail.vehicleImageUrl.isNotEmpty)
        ? detail.vehicleImageUrl
        : (activeRentalItem?.vehicleImage ?? '');

    final deadline =
        detail?.endTime ??
        activeRentalItem?.createdAt?.add(const Duration(hours: 4)) ??
        now.add(const Duration(hours: 24));

    final isOverdue =
        now.isAfter(deadline) ||
        (activeRentalItem?.status.toUpperCase() == 'OVERDUE') ||
        (detail?.status.toUpperCase() == 'OVERDUE');

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: ActiveTripAppBar(
        vehicleName: vehicleName,
        vehiclePlate: vehiclePlate,
        hasTrip: hasTrip,
        targetRentalId: targetRentalId,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(rentalHistoryControllerProvider.notifier).refresh();
          if (targetRentalId != null) {
            ref.invalidate(
              activeRentalDetailControllerProvider(targetRentalId),
            );
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (activeDetailAsync.isLoading && detail == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: LinearProgressIndicator(minHeight: 2),
                ),

              if (hasTrip) ...[
                // 1. Thẻ hình ảnh xe gọn gàng
                ActiveVehicleBannerCard(
                  imageUrl: imageUrl,
                  batteryLevel: detail?.batteryLevel,
                  targetRentalId: targetRentalId,
                ),
                const SizedBox(height: 16),

                // 2. Đồng hồ đếm ngược & thông tin hành trình
                ActiveTripStatusCard(
                  detail: detail,
                  activeRentalItem: activeRentalItem,
                  deadline: deadline,
                  isOverdue: isOverdue,
                ),
                const SizedBox(height: 16),

                // 3. Thẻ cảnh báo quá hạn thuê xe (khi bị quá giờ)
                if (isOverdue) ...[
                  ActiveTripOverdueCard(
                    detail: detail,
                    activeRentalItem: activeRentalItem,
                    deadline: deadline,
                  ),
                  const SizedBox(height: 20),
                ] else
                  const SizedBox(height: 4),
              ] else ...[
                const ActiveTripEmptyView(),
              ],
            ],
          ),
        ),
      ),
      // Nút Trả xe đặt cố định ở đáy màn hình (Bottom End)
      bottomNavigationBar: hasTrip
          ? ActiveTripBottomBar(targetRentalId: targetRentalId)
          : null,
    );
  }
}
