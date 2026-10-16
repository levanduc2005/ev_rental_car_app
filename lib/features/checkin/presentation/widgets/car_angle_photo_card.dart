import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/theme/app_text_styles.dart';
import 'package:rental_car/features/checkin/presentation/controllers/checkin_state.dart';

class CarAnglePhotoCard extends StatelessWidget {
  const CarAnglePhotoCard({
    super.key,
    required this.angle,
    required this.indexNumber,
    required this.localImagePath,
    required this.uploadedUrl,
    required this.isUploading,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  final CarAngle angle;
  final int indexNumber;
  final String? localImagePath;
  final String uploadedUrl;
  final bool isUploading;
  final void Function(ImageSource source) onPickImage;
  final VoidCallback onRemoveImage;

  bool get hasImage =>
      (localImagePath != null && localImagePath!.isNotEmpty) ||
      uploadedUrl.trim().isNotEmpty;

  void _showImagePickerSheet(BuildContext context) {
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
                Text(
                  'Chụp ảnh: ${angle.title}',
                  style: AppTextStyles.heading3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  angle.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
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
                    'Đề xuất để ghi nhận đúng góc xe thực tế',
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
                    color: Color(0xFF10B981),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasImage ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
          width: hasImage ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Số thứ tự + Tên góc xe + Badge trạng thái
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: hasImage
                          ? const Color(0xFF10B981)
                          : const Color(0xFF2563EB),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      indexNumber.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    angle.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              _buildStatusBadge(),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            angle.subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),

          // Container ảnh hoặc nút chụp
          if (hasImage)
            _buildImagePreview(context)
          else
            _buildPlaceholderButton(context),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    if (isUploading) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 4),
            Text(
              'Đang tải lên...',
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    if (hasImage) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFECFDF5),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              size: 12,
              color: Color(0xFF10B981),
            ),
            SizedBox(width: 4),
            Text(
              'Đã tải lên',
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF059669),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        'Bắt buộc',
        style: TextStyle(
          fontSize: 10,
          color: Color(0xFFE11D48),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 130,
            width: double.infinity,
            child: localImagePath != null && localImagePath!.isNotEmpty
                ? Image.file(
                    File(localImagePath!),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _buildFallbackNetImage(),
                  )
                : _buildFallbackNetImage(),
          ),
        ),
        // Overlay loading khi đang upload
        if (isUploading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          ),
        // Nút xóa ảnh & chụp lại
        if (!isUploading)
          Positioned(
            top: 6,
            right: 6,
            child: Row(
              children: [
                InkWell(
                  onTap: () => _showImagePickerSheet(context),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: onRemoveImage,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFDC2626),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildFallbackNetImage() {
    if (uploadedUrl.isNotEmpty) {
      return Image.network(
        uploadedUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _buildEmptyBox(),
      );
    }
    return _buildEmptyBox();
  }

  Widget _buildEmptyBox() {
    return Container(
      color: const Color(0xFFF1F5F9),
      child: const Center(
        child: Icon(Icons.broken_image_outlined, color: Colors.grey),
      ),
    );
  }

  Widget _buildPlaceholderButton(BuildContext context) {
    return InkWell(
      onTap: () => _showImagePickerSheet(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFCBD5E1)),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, size: 28, color: Color(0xFF2563EB)),
            SizedBox(height: 6),
            Text(
              'Chạm để chụp / tải ảnh lên',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
