import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/widgets/widgets.dart';
import 'package:rental_car/features/checkin/presentation/pages/docuseal_sign_page.dart';
import 'package:rental_car/features/checkin/presentation/providers/checkin_controller.dart';
import 'package:rental_car/features/checkin/presentation/providers/checkin_providers.dart';
import 'package:rental_car/features/checkin/presentation/widgets/accessories_checklist_card.dart';
import 'package:rental_car/features/checkin/presentation/widgets/car_inspection_photos_section.dart';
import 'package:rental_car/features/checkin/presentation/widgets/checkin_kyc_warning_dialog.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';

class CheckInPage extends ConsumerStatefulWidget {
  const CheckInPage({super.key, required this.rentalId, this.initialRental});

  final int rentalId;
  final RentalDetailEntity? initialRental;

  @override
  ConsumerState<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends ConsumerState<CheckInPage> {
  final _odoController = TextEditingController();
  final _batteryController = TextEditingController();
  final _noteController = TextEditingController();
  bool _hasPromptedKyc = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(checkInControllerProvider.notifier)
          .init(widget.rentalId, widget.initialRental);
    });
  }

  @override
  void dispose() {
    _odoController.dispose();
    _batteryController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _syncControllers(CheckInState state) {
    if (_batteryController.text.isEmpty && state.batteryPercentage > 0) {
      _batteryController.text = state.batteryPercentage.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(checkInControllerProvider);
    final controller = ref.read(checkInControllerProvider.notifier);

    _syncControllers(state);

    // Kiểm tra điều kiện KYC bằng lái khi tải xong
    if (!state.isLoading &&
        state.licenseStatus != null &&
        !state.licenseStatus!.isApproved &&
        !_hasPromptedKyc) {
      _hasPromptedKyc = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        CheckInKycWarningDialog.show(
          context,
          licenseStatus: state.licenseStatus!.licenseStatus,
          rejectReason: state.licenseStatus!.rejectReason,
        );
      });
    }

    // Nếu chuyển sang bước ký hợp đồng DocuSeal, chuyển thẳng đến màn hình ký
    ref.listen<CheckInState>(checkInControllerProvider, (prev, next) {
      if (prev?.currentStep != CheckInStep.contractSigning &&
          next.currentStep == CheckInStep.contractSigning &&
          next.contract != null) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => DocuSealSignPage(
              rentalId: widget.rentalId,
              signingUrl: next.contract!.signingUrl,
              contractCode: next.contract!.contractCode,
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Biên bản nhận xe #${widget.rentalId}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
      ),
      body: state.isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text(
                    'Đang kiểm tra điều kiện nhận xe & KYC...',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            )
          : _buildBody(context, state, controller),
    );
  }

  Widget _buildBody(
    BuildContext context,
    CheckInState state,
    CheckInController controller,
  ) {
    final isKycApproved = state.licenseStatus?.isApproved ?? false;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Thanh tiến trình các bước
          _buildStepProgressHeader(state),
          const SizedBox(height: 14),

          // 2. Thẻ cảnh báo KYC nếu chưa duyệt
          if (!isKycApproved && state.licenseStatus != null) ...[
            _buildKycWarningBanner(context, state, controller),
            const SizedBox(height: 14),
          ],

          // 3. Thông tin xe & trạm
          _buildVehicleSummaryCard(state),
          const SizedBox(height: 14),

          // 4. Chụp ảnh ngoại quan xe (tự do)
          CarInspectionPhotosSection(
            photos: state.photos,
            isUploadingPhoto: state.isUploadingPhoto,
            onPickPhotos: (source) =>
                controller.pickAndUploadPhotos(source: source),
            onRemovePhoto: (photoId) => controller.removePhoto(photoId),
          ),
          const SizedBox(height: 14),

          // 5. Ô nhập ODO và Pin ban đầu
          _buildOdoAndBatteryCard(state, controller),
          const SizedBox(height: 14),

          // 6. Checklist phụ kiện đi kèm
          AccessoriesChecklistCard(
            accessories: state.accessories,
            onChanged:
                ({hasPortableCharger, hasTireRepairKit, hasChargingCard}) {
                  controller.updateAccessory(
                    hasPortableCharger: hasPortableCharger,
                    hasTireRepairKit: hasTireRepairKit,
                    hasChargingCard: hasChargingCard,
                  );
                },
          ),
          const SizedBox(height: 14),

          // 7. Ghi chú ngoại quan xe
          _buildNoteCard(controller),
          const SizedBox(height: 20),

          // Thông báo lỗi nếu có
          if (state.errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFECDD3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.errorMessage!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9F1239),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // 8. Nút hoàn tất biên bản nhận xe & Chuyển sang ký hợp đồng
          AppButton(
            label: state.isSubmitting
                ? 'Đang gửi biên bản nhận xe...'
                : 'Xác nhận & Tiếp tục ký hợp đồng DocuSeal',
            icon: Icons.assignment_turned_in_rounded,
            isLoading: state.isSubmitting,
            onPressed:
                (!isKycApproved ||
                    !state.isInspectionFormValid ||
                    state.isSubmitting)
                ? null
                : () => controller.submitChecklist(widget.rentalId),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStepProgressHeader(CheckInState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepItem(
            stepNumber: '1',
            title: 'Kiểm tra xe',
            isActive: state.currentStep == CheckInStep.inspection,
            isCompleted: state.currentStep != CheckInStep.inspection,
          ),
          Container(width: 24, height: 1, color: const Color(0xFFCBD5E1)),
          _buildStepItem(
            stepNumber: '2',
            title: 'Ký hợp đồng',
            isActive: state.currentStep == CheckInStep.contractSigning,
            isCompleted: state.isContractSigned,
          ),
          Container(width: 24, height: 1, color: const Color(0xFFCBD5E1)),
          _buildStepItem(
            stepNumber: '3',
            title: 'Bàn giao xe',
            isActive: state.currentStep == CheckInStep.completed,
            isCompleted: false,
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required String stepNumber,
    required String title,
    required bool isActive,
    required bool isCompleted,
  }) {
    final bgColor = isCompleted
        ? const Color(0xFF10B981)
        : (isActive ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0));
    final textColor = isCompleted || isActive
        ? Colors.white
        : const Color(0xFF64748B);

    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
          child: isCompleted
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : Text(
                  stepNumber,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive || isCompleted
                ? FontWeight.bold
                : FontWeight.normal,
            color: isActive ? const Color(0xFF2563EB) : const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildKycWarningBanner(
    BuildContext context,
    CheckInState state,
    CheckInController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFD97706),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Bằng lái xe chưa được phê duyệt',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF92400E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Bạn cần được duyệt giấy phép lái xe trước khi hoàn tất nhận xe tại trạm.',
            style: TextStyle(fontSize: 12, color: Color(0xFF78350F)),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD97706),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => context.pushNamed(AppRoute.kycUpload.name),
                icon: const Icon(Icons.upload_file_rounded, size: 16),
                label: const Text('Nộp bằng lái ngay'),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF92400E),
                  side: const BorderSide(color: Color(0xFFD97706)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  textStyle: const TextStyle(fontSize: 12),
                ),
                onPressed: () => controller.refreshLicenseStatus(),
                child: const Text('Kiểm tra lại'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleSummaryCard(CheckInState state) {
    final rental = state.rentalDetail;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:
                (rental?.vehicleImage != null &&
                    rental!.vehicleImage!.startsWith('http'))
                ? Image.network(
                    rental.vehicleImage!,
                    width: 70,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _buildCarIconPlaceholder(),
                  )
                : _buildCarIconPlaceholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rental?.vehicleName ?? 'Xe điện e-Motion',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                if (rental?.vehiclePlateNumber != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: Text(
                      rental!.vehiclePlateNumber!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Color(0xFF2563EB),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        rental?.stationName ?? 'Trạm nhận xe',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarIconPlaceholder() {
    return Container(
      width: 70,
      height: 52,
      color: const Color(0xFFEFF6FF),
      child: const Center(
        child: Icon(
          Icons.directions_car_rounded,
          color: Color(0xFF2563EB),
          size: 28,
        ),
      ),
    );
  }

  Widget _buildOdoAndBatteryCard(
    CheckInState state,
    CheckInController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.speed_rounded, color: Color(0xFF2563EB), size: 20),
              SizedBox(width: 8),
              Text(
                'Số ODO & Phần trăm Pin lúc nhận xe',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Ô ODO
          AppTextField(
            label: 'Số đo đồng hồ ODO xuất phát (km) *',
            hint: 'Ví dụ: 12540',
            keyboardType: TextInputType.number,
            controller: _odoController,
            prefixIcon: Icons.shutter_speed_rounded,
            onChanged: (val) {
              final odo = int.tryParse(val.trim());
              controller.setOdometer(odo);
            },
          ),
          const SizedBox(height: 12),

          // Ô Pin
          AppTextField(
            label: 'Phần trăm pin ban đầu (%) *',
            hint: 'Ví dụ: 95',
            keyboardType: TextInputType.number,
            controller: _batteryController,
            prefixIcon: Icons.battery_charging_full_rounded,
            onChanged: (val) {
              final pin = int.tryParse(val.trim());
              if (pin != null) {
                controller.setBatteryPercentage(pin);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(CheckInController controller) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.edit_note_rounded, color: Color(0xFF2563EB), size: 22),
              SizedBox(width: 8),
              Text(
                'Ghi chú tình trạng xe lúc nhận (Không bắt buộc)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _noteController,
            maxLines: 3,
            onChanged: controller.setNote,
            decoration: const InputDecoration(
              labelText: 'Ghi chú ngoại quan xe',
              hintText: 'Ví dụ: Xe sạch sẽ, có vết xước dăm nhỏ ở cản trước...',
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Color(0xFFCBD5E1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Color(0xFFCBD5E1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Color(0xFF2563EB)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
