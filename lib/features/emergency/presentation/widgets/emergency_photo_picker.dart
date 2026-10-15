import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/theme/app_text_styles.dart';

class EmergencyPhotoPicker extends StatelessWidget {
  const EmergencyPhotoPicker({
    super.key,
    required this.imagePath,
    required this.uploadedImageUrl,
    required this.isUploading,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  final String? imagePath;
  final String? uploadedImageUrl;
  final bool isUploading;
  final ValueChanged<ImageSource> onPickImage;
  final VoidCallback onRemoveImage;

  void _showSourcePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Chọn ảnh hiện trường sự cố',
                  style: AppTextStyles.heading3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.primary,
                  ),
                  title: const Text('Chụp ảnh trực tiếp (Camera)'),
                  subtitle: const Text(
                    'Khuyên dùng để nhân viên cứu hộ nắm rõ tình trạng',
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    onPickImage(ImageSource.camera);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_rounded,
                    color: AppColors.accent,
                  ),
                  title: const Text('Chọn từ thư viện ảnh (Gallery)'),
                  onTap: () {
                    Navigator.pop(ctx);
                    onPickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              color: AppColors.textPrimary,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'Ảnh chụp hiện trường sự cố:',
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Chụp rõ phần xe bị hỏng hoặc vị trí va chạm để đội cứu hộ chuẩn bị trang thiết bị phù hợp.',
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (imagePath != null) ...[
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Image.file(
                  File(imagePath!),
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              if (isUploading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                          SizedBox(height: AppSpacing.sm),
                          Text(
                            'Đang tải ảnh hiện trường lên máy chủ...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (!isUploading)
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.black.withValues(alpha: 0.6),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: onRemoveImage,
                    ),
                  ),
                ),
              if (!isUploading && uploadedImageUrl != null)
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Đã tải ảnh lên thành công',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ] else ...[
          InkWell(
            onTap: () => _showSourcePicker(context),
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Container(
              height: 110,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    size: 32,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'Bấm để chụp ảnh hiện trường',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Hỗ trợ chụp Camera hoặc thư viện ảnh',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
