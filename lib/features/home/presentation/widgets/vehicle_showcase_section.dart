import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_spacing.dart';

class VehicleCardData {
  const VehicleCardData({
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.location,
    required this.seats,
    required this.transmission,
    required this.fuelType,
    required this.price4h,
    required this.oldPrice4h,
    required this.price24h,
    this.topBadgeText,
    this.topBadgeColor,
    this.bottomBadgeText,
    this.isLuxury = false,
  });

  final String name;
  final String imageUrl;
  final double rating;
  final String location;
  final String seats;
  final String transmission;
  final String fuelType;
  final String price4h;
  final String oldPrice4h;
  final String price24h;
  final String? topBadgeText;
  final Color? topBadgeColor;
  final String? bottomBadgeText;
  final bool isLuxury;
}

class VehicleShowcaseSection extends StatelessWidget {
  const VehicleShowcaseSection({
    required this.title,
    required this.subtitle,
    required this.vehicles,
    super.key,
  });

  final String title;
  final String subtitle;
  final List<VehicleCardData> vehicles;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header phân mục
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => context.goNamed(AppRoute.mapSearch.name),
                child: const Row(
                  children: [
                    Text(
                      'Xem thêm',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: Color(0xFF1976D2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Danh sách thẻ xe cuộn ngang
        SizedBox(
          height: 330,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            scrollDirection: Axis.horizontal,
            itemCount: vehicles.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              return _RentalVehicleCard(vehicle: vehicles[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _RentalVehicleCard extends StatelessWidget {
  const _RentalVehicleCard({required this.vehicle});

  final VehicleCardData vehicle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => context.pushNamed(
        AppRoute.vehicleDetail.name,
        pathParameters: {'id': '1'},
      ),
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // 1. Khung ảnh xe + Các tag nổi trên ảnh
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  vehicle.imageUrl,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    height: 130,
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.directions_car_rounded,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              if (vehicle.topBadgeText != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: vehicle.topBadgeColor ?? const Color(0xFFD32F2F),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      vehicle.topBadgeText!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              if (vehicle.bottomBadgeText != null)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1976D2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.phone_android_rounded,
                          size: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          vehicle.bottomBadgeText!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // 2. Nội dung chi tiết xe
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên xe + Rating sao
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        vehicle.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: Color(0xFF1976D2),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${vehicle.rating}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1976D2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 2),

                // Vị trí xe
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        vehicle.location,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Dãy Chip thông số
                Row(
                  children: [
                    _SpecChip(
                      label: vehicle.seats,
                      icon: Icons.people_outline_rounded,
                    ),
                    const SizedBox(width: 4),
                    _SpecChip(
                      label: vehicle.transmission,
                      icon: Icons.settings_outlined,
                    ),
                    const SizedBox(width: 4),
                    _SpecChip(
                      label: vehicle.fuelType,
                      icon: Icons.bolt_rounded,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Giá tiền + Nút Đặt ngay / Chọn xe
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cột giá
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              vehicle.price4h,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1976D2),
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Text(
                              '/4 giờ',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              vehicle.oldPrice4h,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade400,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${vehicle.price24h} / 24 giờ',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),

                    // Nút bấm
                    SizedBox(
                      height: 32,
                      child: vehicle.isLuxury
                          ? FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF1976D2),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => context.pushNamed(
                                AppRoute.vehicleDetail.name,
                                pathParameters: {'id': '1'},
                              ),
                              child: const Text(
                                'Chọn xe',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF1976D2),
                                side: const BorderSide(
                                  color: Color(0xFF1976D2),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => context.pushNamed(
                                AppRoute.vehicleDetail.name,
                                pathParameters: {'id': '1'},
                              ),
                              child: const Text(
                                'Đặt ngay',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                  ],
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

class _SpecChip extends StatelessWidget {
  const _SpecChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: Colors.grey.shade700),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
