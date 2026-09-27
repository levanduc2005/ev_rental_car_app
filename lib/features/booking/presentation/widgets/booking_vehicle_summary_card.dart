import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';

/// Card tóm tắt phương tiện thuê (hình ảnh, tên xe, biển số / thông số kỹ thuật)
class BookingVehicleSummaryCard extends StatelessWidget {
  const BookingVehicleSummaryCard({
    required this.name,
    this.imageUrl,
    this.plateNumber,
    this.specs,
    this.badge,
    super.key,
  });

  final String name;
  final String? imageUrl;
  final String? plateNumber;
  final String? specs;
  final Widget? badge;

  static const String _defaultCarImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDiVxOjLTj5JjghKDMPBd4UdJ_tVbMRIeMLtOgIdtKfkOojv_PO48hcEhHu1lCas852tOakhx5EzvZJr18RncORxAd4wzE7iOCrGu_pPeT-2UMEUMKEpG3yg41U4Hlgx7U25hQTa-DQRn9VBaL14InoB6SsnBprAJMduwVP7G4v3VwNRuYGwPChVd6ICkoZKdZb8VD9ArMtDvKRmJ_hfeO9hL7cMcvEW-Tl6bD6UBZ3wkMr1XAQC9z4mSM3WB7MLeiiIcw';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Image.network(
              imageUrl ?? _defaultCarImage,
              width: 90,
              height: 65,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 90,
                height: 65,
                color: Colors.grey.shade200,
                child: const Icon(Icons.directions_car, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (plateNumber != null && plateNumber!.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    'Biển số: $plateNumber',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ],
                if (specs != null && specs!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    specs!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                if (badge != null) ...[
                  const SizedBox(height: 6),
                  badge!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
