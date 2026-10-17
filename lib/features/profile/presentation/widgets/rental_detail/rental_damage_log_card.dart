import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/booking/presentation/utils/booking_formatters.dart';
import 'package:rental_car/features/checkout/domain/entities/vehicle_damage_item_entity.dart';
import 'package:rental_car/features/profile/presentation/widgets/rental_detail/image_preview_dialog.dart';

class RentalDamageLogCard extends StatelessWidget {
  const RentalDamageLogCard({
    required this.damages,
    required this.damageCost,
    this.damageImages = const [],
    super.key,
  });

  final List<VehicleDamageItemEntity> damages;
  final double damageCost;
  final List<String> damageImages;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.build_circle_outlined,
                    size: 20,
                    color: Color(0xFFD97706),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Biên bản ghi nhận hư hại phụ tùng',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF92400E),
                    ),
                  ),
                ],
              ),
              Text(
                BookingFormatters.formatCurrency(damageCost.toInt()),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDC2626),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Các hạng mục hư hại / trầy xước ghi nhận lúc trả xe:',
            style: TextStyle(fontSize: 12, color: Color(0xFF78350F)),
          ),
          const SizedBox(height: 6),
          ...damages.map(
            (dmg) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '• ${dmg.description}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    BookingFormatters.formatCurrency(dmg.cost.toInt()),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (damageImages.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text(
              'Hình ảnh hiện trường hư hại:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF78350F),
              ),
            ),
            const SizedBox(height: 6),
            _buildDamagePhotoGrid(context, damageImages),
          ],
        ],
      ),
    );
  }

  Widget _buildDamagePhotoGrid(BuildContext context, List<String> urls) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: urls.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (ctx, idx) {
        final url = urls[idx];
        return InkWell(
          onTap: () => showImagePreviewDialog(
            context,
            imageUrl: url,
            title: 'Hiện trường hư hại #${idx + 1}',
          ),
          borderRadius: BorderRadius.circular(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: Colors.grey.shade200,
                child: const Icon(
                  Icons.broken_image,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
