import 'package:flutter/material.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';

/// Thẻ hiển thị xe trong danh sách tìm kiếm (100% dữ liệu từ Backend)
class VehicleListCard extends StatelessWidget {
  const VehicleListCard({
    required this.item,
    required this.onTap,
    this.targetHours,
    this.targetUnit,
    super.key,
  });

  final VehicleEntity item;
  final VoidCallback onTap;
  final int? targetHours;
  final String? targetUnit;

  @override
  Widget build(BuildContext context) {
    final int effectiveSalePriceK;
    final String effectiveUnit;

    if (targetHours != null && targetHours! > 0) {
      effectiveSalePriceK = item.priceKForDuration(targetHours!);
      effectiveUnit =
          targetUnit ??
          (targetHours! <= 4
              ? '4 giờ'
              : (targetHours! <= 8
                    ? '8 giờ'
                    : (targetHours! <= 12
                          ? '12 giờ'
                          : (targetHours! <= 24
                                ? 'ngày'
                                : '${(targetHours! / 24).ceil()} ngày'))));
    } else {
      effectiveSalePriceK = item.salePriceK;
      effectiveUnit = item.priceUnit;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HÌNH ẢNH XE
              AspectRatio(
                aspectRatio: 16 / 9.5,
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFE2E8F0),
                    child: const Center(
                      child: Icon(
                        Icons.directions_car_filled,
                        size: 60,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ),
              ),

              // 2. KHU VỰC THÔNG TIN CHI TIẾT
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hàng 1: Tên xe & Badge phân khúc/hãng xe từ Backend
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              letterSpacing: 0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (item.brand.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFFBFDBFE),
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              item.brand,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1D4ED8),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Hàng 2: Trạm sạc / Địa điểm
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Hàng 3: Khoảng cách & Giá thuê thực tế từ Backend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (item.distanceKm > 0)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.near_me_outlined,
                                size: 14,
                                color: Color(0xFF0284C7),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${item.distanceKm.toStringAsFixed(1)} km',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0284C7),
                                ),
                              ),
                            ],
                          )
                        else
                          const SizedBox.shrink(),

                        // Giá tiền thực tế theo giờ / ngày từ Backend
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${effectiveSalePriceK}K',
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F9D58),
                              ),
                            ),
                            Text(
                              '/$effectiveUnit',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0F9D58),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    const Divider(
                      height: 1,
                      thickness: 0.8,
                      color: Color(0xFFF1F5F9),
                    ),
                    const SizedBox(height: 10),

                    // Hàng 4: Thông số xe thực tế từ Backend (Số ghế, Phân khúc, Mức Pin %)
                    Row(
                      children: [
                        _buildSpecItem(
                          Icons.person_outline_rounded,
                          '${item.seats} chỗ',
                        ),
                        const SizedBox(width: 14),
                        if (item.category != null && item.category!.isNotEmpty) ...[
                          _buildSpecItem(
                            Icons.category_outlined,
                            item.category!,
                          ),
                          const SizedBox(width: 14),
                        ],
                        _buildSpecItem(
                          Icons.bolt_rounded,
                          'Pin ${item.batteryLevel}%',
                          iconColor: item.batteryLevel < 20
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF10B981),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String text, {Color? iconColor}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: iconColor ?? const Color(0xFF64748B)),
        const SizedBox(width: 4),
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF334155),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
