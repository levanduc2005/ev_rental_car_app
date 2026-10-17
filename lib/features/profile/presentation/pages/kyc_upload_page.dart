import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/theme/app_text_styles.dart';
import 'package:rental_car/core/widgets/widgets.dart';
import 'package:rental_car/features/profile/domain/entities/kyc_document_entity.dart';
import 'package:rental_car/features/profile/presentation/providers/kyc_controller.dart';
import 'package:rental_car/features/profile/presentation/providers/profile_providers.dart';
import 'package:rental_car/features/profile/presentation/widgets/image_picker_bottom_sheet.dart';

class KycUploadPage extends ConsumerStatefulWidget {
  const KycUploadPage({this.initialType, super.key});

  final DocumentType? initialType;

  @override
  ConsumerState<KycUploadPage> createState() => _KycUploadPageState();
}

class _KycUploadPageState extends ConsumerState<KycUploadPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _numberController;
  DocumentType _selectedType = DocumentType.license;
  String _selectedClass = 'B2';
  DateTime? _selectedExpiryDate;

  final List<String> _licenseClasses = ['B1', 'B2', 'BE', 'C', 'D', 'E'];

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController();
    _selectedType = widget.initialType ?? DocumentType.license;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initDocumentType();
    });
  }

  void _initDocumentType() {
    final user = ref.read(profileControllerProvider).user;
    final hasLicense = user?.licenseDocument != null;
    final hasCccd = user?.cccdDocument != null;

    DocumentType chosenType = _selectedType;
    if (widget.initialType != null) {
      chosenType = widget.initialType!;
    } else if (hasLicense && !hasCccd) {
      chosenType = DocumentType.cccd;
    } else if (hasCccd && !hasLicense) {
      chosenType = DocumentType.license;
    }

    if (chosenType != _selectedType) {
      setState(() {
        _selectedType = chosenType;
      });
    }
    ref.read(kycControllerProvider.notifier).prepareForType(chosenType);
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final path = await ImagePickerBottomSheet.show(context);
    if (path != null && mounted) {
      ref.read(kycControllerProvider.notifier).setImage(path);
    }
  }

  Future<void> _selectExpiryDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedExpiryDate ?? now.add(const Duration(days: 365 * 3)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 30)),
      helpText: 'CHỌN NGÀY HẾT HẠN',
      cancelText: 'HỦY',
      confirmText: 'CHỌN',
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedExpiryDate = picked;
      });
      ref.read(kycControllerProvider.notifier).setExpiryDate(picked);
    }
  }

  String? _validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập số giấy tờ';
    }
    final clean = value.trim();
    if (!RegExp(r'^[0-9]{9,12}$').hasMatch(clean)) {
      return 'Số giấy tờ phải từ 9 đến 12 chữ số';
    }
    return null;
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final kycState = ref.read(kycControllerProvider);
    if (kycState.selectedImagePath == null) {
      context.showSnackBar('Vui lòng chụp hoặc tải ảnh mặt trước của giấy tờ.');
      return;
    }

    final user = ref.read(profileControllerProvider).user;
    final email = user?.email ?? '';

    ref.read(kycControllerProvider.notifier)
      ..setDocumentType(_selectedType)
      ..setDocumentNumber(_numberController.text.trim())
      ..setLicenseClass(_selectedClass);

    final success = await ref
        .read(kycControllerProvider.notifier)
        .submitDocument(userEmail: email);

    if (mounted) {
      if (success) {
        // Cập nhật lại danh sách giấy tờ của user
        await ref.read(profileControllerProvider.notifier).refreshProfile();
        if (!mounted) return;

        final updatedUser = ref.read(profileControllerProvider).user;
        final hasLicenseNow = updatedUser?.licenseDocument != null;
        final hasCccdNow = updatedUser?.cccdDocument != null;

        // Nếu còn loại giấy tờ chưa tải lên, gợi ý người dùng tiếp tục tải lên loại còn lại ngay
        if (!hasLicenseNow || !hasCccdNow) {
          final remainingType = !hasLicenseNow
              ? DocumentType.license
              : DocumentType.cccd;
          final remainingName = remainingType == DocumentType.license
              ? 'Bằng lái xe (GPLX)'
              : 'Căn cước công dân (CCCD)';
          final uploadedName = _selectedType == DocumentType.license
              ? 'Bằng lái xe (GPLX)'
              : 'Căn cước công dân (CCCD)';

          final wantUploadRemaining = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              title: const Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: AppColors.success),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text('Tải lên thành công!')),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bạn đã tải lên $uploadedName thành công.'),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Bạn có muốn tiếp tục tải lên $remainingName ngay bây giờ để hoàn thiện đầy đủ hồ sơ?',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Xem hồ sơ'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text('Tải lên $remainingName ngay'),
                ),
              ],
            ),
          );

          if (!mounted) return;

          if (wantUploadRemaining == true) {
            setState(() {
              _selectedType = remainingType;
              _numberController.clear();
              _selectedExpiryDate = null;
            });
            ref
                .read(kycControllerProvider.notifier)
                .prepareForType(remainingType);
            context.showSnackBar('Hãy chụp ảnh $remainingName.');
            return;
          }
        }

        context.showSnackBar('Nộp giấy tờ xác thực thành công!');
        context.pushReplacement(AppRoute.kycStatus.path);
      } else {
        final err = ref.read(kycControllerProvider).errorMessage;
        context.showSnackBar(
          err ?? 'Xác thực thất bại. Vui lòng kiểm tra lại ảnh chụp.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final kycState = ref.watch(kycControllerProvider);
    final user = ref.watch(profileControllerProvider).user;
    final hasLicense = user?.licenseDocument != null;
    final hasCccd = user?.cccdDocument != null;
    final bothUploaded = hasLicense && hasCccd;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _selectedType == DocumentType.license
              ? 'Xác thực Bằng lái xe (GPLX)'
              : 'Xác thực Căn cước công dân (CCCD)',
        ),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (bothUploaded) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: AppColors.success.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.success,
                          size: 24,
                        ),
                        const Gap.h(AppSpacing.sm),
                        const Expanded(
                          child: Text(
                            'Bạn đã hoàn tất nộp cả GPLX và CCCD. Để cập nhật lại giấy tờ nào, vui lòng vào màn hình chi tiết để gỡ và chụp mới.',
                            style: AppTextStyles.caption,
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              context.pushReplacement(AppRoute.kycStatus.path),
                          child: const Text('Xem hồ sơ'),
                        ),
                      ],
                    ),
                  ),
                  const Gap(AppSpacing.md),
                ],

                // 1. Khung chụp / chọn ảnh
                _buildImageCaptureArea(kycState.selectedImagePath),
                const Gap(AppSpacing.lg),

                // 2. Form thông tin giấy tờ
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _selectedType == DocumentType.license
                                ? Icons.directions_car_outlined
                                : Icons.credit_card_outlined,
                            color: AppColors.primary,
                            size: 22,
                          ),
                          const Gap.h(AppSpacing.sm),
                          Expanded(
                            child: Text(
                              _selectedType == DocumentType.license
                                  ? 'Thông tin Bằng lái xe (GPLX)'
                                  : 'Thông tin Căn cước công dân (CCCD)',
                              style: AppTextStyles.heading3,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      const Text(
                        'Thông tin cần trùng khớp 100% với ảnh chụp để OCR tự động duyệt',
                        style: AppTextStyles.caption,
                      ),
                      const Divider(height: AppSpacing.lg),

                      // Số giấy tờ
                      AppTextField(
                        label: _selectedType == DocumentType.license
                            ? 'Số Giấy phép lái xe (GPLX)'
                            : 'Số Căn cước công dân (CCCD)',
                        controller: _numberController,
                        hint: 'Nhập từ 9 đến 12 chữ số',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.pin_outlined,
                        validator: _validateNumber,
                      ),

                      // Hạng bằng lái (chỉ hiển thị nếu là GPLX)
                      if (_selectedType == DocumentType.license) ...[
                        const SizedBox(height: AppSpacing.md),
                        const Text(
                          'Hạng bằng lái',
                          style: AppTextStyles.inputLabel,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedClass,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            prefixIcon: const Icon(
                              Icons.card_membership_outlined,
                            ),
                          ),
                          items: _licenseClasses
                              .map(
                                (cls) => DropdownMenuItem(
                                  value: cls,
                                  child: Text(
                                    'Hạng $cls (Đủ điều kiện thuê xe)',
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedClass = val;
                              });
                            }
                          },
                        ),
                      ],

                      // Ngày hết hạn
                      const SizedBox(height: AppSpacing.md),
                      const Text(
                        'Ngày hết hạn giấy tờ',
                        style: AppTextStyles.inputLabel,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      InkWell(
                        onTap: _selectExpiryDate,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm + 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            color: AppColors.surface,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 20,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                _selectedExpiryDate == null
                                    ? 'Chọn ngày hết hạn (Tùy chọn)'
                                    : '${_selectedExpiryDate!.day.toString().padLeft(2, '0')}/${_selectedExpiryDate!.month.toString().padLeft(2, '0')}/${_selectedExpiryDate!.year}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _selectedExpiryDate == null
                                      ? AppColors.textMuted
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(AppSpacing.md),

                // Ghi chú hệ thống OCR
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: AppColors.info.withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.auto_awesome, color: AppColors.info, size: 20),
                      Gap.h(AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Hệ thống tích hợp trí tuệ nhân tạo (AI OCR) tự động nhận diện và đối soát giấy tờ. Vui lòng đảm bảo ảnh chụp không bị mất góc hay lóa sáng.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textPrimary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (kycState.errorMessage != null) ...[
                  const Gap(AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.error),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.error),
                        const Gap.h(AppSpacing.sm),
                        Expanded(
                          child: Text(
                            kycState.errorMessage!,
                            style: const TextStyle(
                              color: AppColors.error,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const Gap(AppSpacing.xl),

                // Nút nộp
                AppButton(
                  label: kycState.stepStatus == KycStepStatus.uploadingImage
                      ? 'Đang tải ảnh...'
                      : kycState.stepStatus == KycStepStatus.verifyingOcr
                      ? 'Đang phân tích OCR...'
                      : 'Gửi xác thực ngay',
                  icon: Icons.send_rounded,
                  isLoading: kycState.isSubmitting,
                  onPressed: _onSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageCaptureArea(String? imagePath) {
    if (imagePath != null && imagePath.isNotEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.accent, width: 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              File(imagePath),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(
                  Icons.broken_image_rounded,
                  size: 48,
                  color: AppColors.error,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.5),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Đã chọn ảnh',
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
            Positioned(
              bottom: AppSpacing.sm,
              right: AppSpacing.sm,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
                onPressed: _pickImage,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Chụp lại'),
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_a_photo_rounded,
                color: AppColors.primary,
                size: 36,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _selectedType == DocumentType.license
                  ? 'Chạm để chụp hoặc tải ảnh Bằng lái xe (GPLX)'
                  : 'Chạm để chụp hoặc tải ảnh CCCD / CMND',
              style: AppTextStyles.title,
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              'Hỗ trợ định dạng JPG, PNG (Tối đa 10MB)',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}

typedef KycUploadScreen = KycUploadPage;
