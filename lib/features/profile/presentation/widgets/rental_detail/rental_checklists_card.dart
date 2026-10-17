import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_checklist_entity.dart';
import 'package:rental_car/features/profile/presentation/widgets/rental_detail/image_preview_dialog.dart';

class RentalChecklistsCard extends StatelessWidget {
  const RentalChecklistsCard({
    this.checkInChecklist,
    this.checkOutChecklist,
    super.key,
  });

  final RentalChecklistEntity? checkInChecklist;
  final RentalChecklistEntity? checkOutChecklist;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Biên bản bàn giao xe',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // Mục 1: Lúc nhận xe (Check-in)
          if (checkInChecklist != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.login_rounded,
                      size: 16,
                      color: Color(0xFF2563EB),
                    ),
                    SizedBox(width: 6),
                    Text(
                      '1. Lúc nhận xe (Check-in)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Pin: ${checkInChecklist!.currentBattery.toInt()}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildPhotoGrid(
              context,
              checkInChecklist!.imageUrls,
              'Lúc nhận xe',
            ),
          ] else
            const Text(
              'Chưa có biên bản nhận xe.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),

          // Mục 2: Lúc trả xe (Check-out)
          if (checkOutChecklist != null) ...[
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      size: 16,
                      color: Color(0xFFD97706),
                    ),
                    SizedBox(width: 6),
                    Text(
                      '2. Lúc trả xe (Check-out)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Pin: ${checkOutChecklist!.currentBattery.toInt()}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFD97706),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildPhotoGrid(
              context,
              checkOutChecklist!.imageUrls,
              'Lúc trả xe',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPhotoGrid(
    BuildContext context,
    List<String> urls,
    String phaseTitle,
  ) {
    if (urls.isEmpty) {
      return const Text(
        'Không có hình ảnh đính kèm',
        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
      );
    }

    final labels = ['Đầu xe', 'Đuôi xe', 'Sườn trái', 'Sườn phải'];

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
        final label = idx < labels.length ? labels[idx] : 'Ảnh ${idx + 1}';

        return InkWell(
          onTap: () => showImagePreviewDialog(
            context,
            imageUrl: url,
            title: '$phaseTitle - $label',
          ),
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
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
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.6),
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
