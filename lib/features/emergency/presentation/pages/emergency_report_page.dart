import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/theme/app_text_styles.dart';
import 'package:rental_car/core/widgets/widgets.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';
import 'package:rental_car/features/emergency/presentation/providers/emergency_providers.dart';
import 'package:rental_car/features/emergency/presentation/widgets/emergency_location_card.dart';
import 'package:rental_car/features/emergency/presentation/widgets/emergency_photo_picker.dart';
import 'package:rental_car/features/emergency/presentation/widgets/emergency_type_selector.dart';
import 'package:rental_car/features/emergency/presentation/widgets/sos_hotline_card.dart';

class EmergencyReportPage extends ConsumerStatefulWidget {
  const EmergencyReportPage({super.key, this.rentalId});

  final int? rentalId;

  @override
  ConsumerState<EmergencyReportPage> createState() =>
      _EmergencyReportPageState();
}

class _EmergencyReportPageState extends ConsumerState<EmergencyReportPage> {
  final TextEditingController _descController = TextEditingController();
  final Set<String> _selectedQuickNotes = {};
  String? _validationError;

  static const List<String> _quickNotes = [
    'Xe dừng hẳn không khởi động được',
    'Bánh xe bị xẹp / thủng đinh',
    'Pin còn dưới 5%, không tới được trạm',
    'Va quẹt trên đường, cần kéo xe',
    'Hệ thống cảnh báo lỗi động cơ / phanh',
  ];

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  void _onToggleNote(String note) {
    setState(() {
      if (_selectedQuickNotes.contains(note)) {
        _selectedQuickNotes.remove(note);
        final current = _descController.text;
        final updated = current
            .replaceAll(note, '')
            .replaceAll(RegExp(r',\s*,'), ',')
            .replaceAll(RegExp(r'^\s*,\s*'), '')
            .replaceAll(RegExp(r',\s*$'), '')
            .trim();
        _descController.text = updated;
      } else {
        _selectedQuickNotes.add(note);
        final current = _descController.text.trim();
        if (current.isEmpty) {
          _descController.text = note;
        } else {
          _descController.text = '$current, $note';
        }
      }
      _descController.selection = TextSelection.fromPosition(
        TextPosition(offset: _descController.text.length),
      );
      _validationError = null;
    });
  }

  Future<void> _handleSubmit() async {
    final text = _descController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _validationError = 'Vui lòng mô tả chi tiết sự cố đang gặp phải.';
      });
      return;
    }

    setState(() {
      _validationError = null;
    });

    final authUser = ref.read(authControllerProvider).user;
    final result = await ref
        .read(emergencyControllerProvider.notifier)
        .submitEmergencyReport(
          description: text,
          rentalId: widget.rentalId,
          userEmail: authUser?.email,
        );

    if (!mounted) return;

    result.when(
      ok: (report) {
        _showSuccessDialog();
      },
      err: (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text(failure.message),
          ),
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          icon: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: Color(0xFFDC2626),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
          title: const Text(
            'Đã gửi yêu cầu cứu hộ!',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Yêu cầu cứu hộ khẩn cấp của bạn đã được chuyển tới Đội phản ứng nhanh 24/7. Điều phối viên sẽ liên hệ với bạn trong ít phút.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, height: 1.4),
              ),
              const Gap(AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone_in_talk_rounded,
                      size: 16,
                      color: Color(0xFFDC2626),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Hotline hỗ trợ: 1900 6868',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: const Text('Đã hiểu & Quay lại'),
                onPressed: () {
                  Navigator.pop(ctx);
                  context.pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(emergencyControllerProvider);
    final controller = ref.read(emergencyControllerProvider.notifier);
    final isSubmitting = state.isSubmitting;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Báo cáo sự cố khẩn cấp (SOS)'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Quay lại',
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Hotline 24/7 Call Card
              const SosHotlineCard(),
              const Gap(AppSpacing.lg),

              // Trip ID badge (if present)
              if (widget.rentalId != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.directions_car_filled_rounded,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Chuyến xe gặp sự cố: #${widget.rentalId}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(AppSpacing.md),
              ],

              // 2. Incident Type Selector
              EmergencyTypeSelector(
                selectedType: state.selectedType,
                onTypeSelected: isSubmitting
                    ? (_) {}
                    : (type) => controller.selectType(type),
              ),
              const Gap(AppSpacing.lg),

              // 3. Location GPS Card
              EmergencyLocationCard(
                latitude: state.latitude,
                longitude: state.longitude,
                isLoading: state.isLoadingLocation,
                errorMessage: state.locationError,
                onRefreshLocation: controller.fetchCurrentLocation,
              ),
              const Gap(AppSpacing.lg),

              // 4. Incident Photo Picker
              EmergencyPhotoPicker(
                imagePath: state.selectedImagePath,
                uploadedImageUrl: state.uploadedImageUrl,
                isUploading: state.isUploadingImage,
                onPickImage: controller.pickAndUploadImage,
                onRemoveImage: controller.removeImage,
              ),
              const Gap(AppSpacing.lg),

              // 5. Description input
              Row(
                children: [
                  const Icon(
                    Icons.edit_note_rounded,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Mô tả chi tiết sự cố:',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Gợi ý chọn nhanh tình trạng:',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: _quickNotes.map((note) {
                  final isSelected = _selectedQuickNotes.contains(note);
                  return FilterChip(
                    label: Text(note),
                    selected: isSelected,
                    selectedColor: const Color(
                      0xFFDC2626,
                    ).withValues(alpha: 0.12),
                    checkmarkColor: const Color(0xFFDC2626),
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? const Color(0xFFDC2626)
                          : AppColors.textPrimary,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFFDC2626)
                          : AppColors.border,
                    ),
                    onSelected: isSubmitting
                        ? null
                        : (_) => _onToggleNote(note),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _descController,
                maxLines: 4,
                maxLength: 400,
                enabled: !isSubmitting,
                decoration: InputDecoration(
                  hintText:
                      'Nhập mô tả cụ thể về tình trạng xe hoặc vị trí cần cứu hộ...',
                  hintStyle: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(
                      color: Color(0xFFDC2626),
                      width: 1.5,
                    ),
                  ),
                ),
                onChanged: (_) {
                  if (_validationError != null) {
                    setState(() {
                      _validationError = null;
                    });
                  }
                },
              ),
              if (_validationError != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _validationError!,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const Gap(AppSpacing.lg),

              // 6. Submit Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                icon: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Icon(Icons.send_rounded, size: 20),
                label: Text(
                  isSubmitting
                      ? 'ĐANG GỬI BÁO CÁO...'
                      : 'GỬI YÊU CẦU CỨU HỘ NGAY',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                onPressed: isSubmitting ? null : _handleSubmit,
              ),
              const Gap(AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
