import 'package:flutter/material.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';

/// Thẻ hiển thị xe chuẩn xác 100% theo Slide 08 - Danh sách tìm kiếm xe
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
    final int effectiveOriginalPriceK;
    final String effectiveUnit;
    final String effectiveDuration;

    if (targetHours != null && targetHours! > 0) {
      effectiveSalePriceK = item.priceKForDuration(targetHours!);
      effectiveOriginalPriceK = item.originalPriceKForDuration(targetHours!);
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
      effectiveDuration = targetHours! < 24
          ? '≈ $effectiveUnit'
          : '≈ ${(targetHours! / 24).ceil()} ngày';
    } else {
      effectiveSalePriceK = item.salePriceK;
      effectiveOriginalPriceK = item.originalPriceK;
      effectiveUnit = item.priceUnit;
      effectiveDuration = item.estimatedDuration;
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
              // 1. KHU VỰC HÌNH ẢNH XE & CÁC BADGE
              Stack(
                children: [
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

                  // Badge góc trên bên phải: "🏷️ Giảm 12%"
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_offer_outlined,
                            size: 13,
                            color: Color(0xFFE53935),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.discountText,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFE53935),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Badge góc dưới bên phải trên ảnh: "🔑 Gặp chủ xe"
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7E22CE), // Màu tím đặc trưng
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.key_rounded,
                            size: 13,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.deliveryType,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // 2. KHU VỰC THÔNG TIN CHI TIẾT
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hàng 1: Tên xe + Badge "👑 Xế xịn"
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
                        if (item.isLuxury) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFFFDE68A),
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '👑',
                                  style: TextStyle(fontSize: 11),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  item.luxuryTag,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF92400E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),

                    // Hàng 2: Địa điểm
                    Text(
                      item.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Hàng 3: Khoảng cách & Giá tiền
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        // Khoảng cách
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  '~ ${item.distanceKm.toStringAsFixed(1)} km',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF334155),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.info_outline_rounded,
                                size: 14,
                                color: Color(0xFF94A3B8),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Giá tiền: Giá gạch ngang + Giá giảm màu xanh lục
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            if (effectiveOriginalPriceK >
                                effectiveSalePriceK) ...[
                              Text(
                                '${effectiveOriginalPriceK}K',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xFF94A3B8),
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Color(0xFF94A3B8),
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                            Text(
                              '${effectiveSalePriceK}K',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F9D58), // Màu xanh lục
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
                    const SizedBox(height: 4),

                    // Hàng 4: Người đang xem & Thời gian ước tính
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.local_fire_department_rounded,
                                size: 15,
                                color: Color(0xFFFF5722),
                              ),
                              const SizedBox(width: 3),
                              Flexible(
                                child: Text(
                                  '${item.viewingCount} người đang xem',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: Color(0xFFEA580C),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          effectiveDuration,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF94A3B8),
                            fontWeight: FontWeight.w400,
                          ),
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

                    // Hàng 5: Thông số xe (số chỗ, số tự động, loại nhiên liệu) & Chú thích VAT
                    Row(
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildSpecItem(
                                  Icons.person_outline_rounded,
                                  '${item.seats} chỗ',
                                ),
                                const SizedBox(width: 10),
                                _buildSpecItem(
                                  Icons.tune_rounded,
                                  item.transmission.replaceAll('Số ', ''),
                                ),
                                const SizedBox(width: 10),
                                _buildSpecItem(
                                  item.fuelType.toLowerCase().contains('điện')
                                      ? Icons.bolt_rounded
                                      : Icons.local_gas_station_outlined,
                                  _formatShortFuel(item.fuelType),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Giá chưa gồm VAT',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF94A3B8),
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
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF64748B)),
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

  String _formatShortFuel(String fuel) {
    if (fuel.contains('Điện')) return 'Điện';
    if (fuel.contains('Xăng')) return 'Xăng';
    if (fuel.contains('Dầu')) return 'Dầu';
    return fuel;
  }
}
