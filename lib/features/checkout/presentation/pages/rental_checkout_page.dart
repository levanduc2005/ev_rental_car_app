import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/widgets/widgets.dart';
import 'package:rental_car/features/checkin/presentation/widgets/car_inspection_photos_section.dart';
import 'package:rental_car/features/checkout/presentation/pages/checkout_summary_page.dart';
import 'package:rental_car/features/checkout/presentation/providers/checkout_controller.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_providers.dart';

class RentalCheckoutPage extends ConsumerStatefulWidget {
  const RentalCheckoutPage({
    super.key,
    required this.rentalId,
    this.initialRental,
  });

  final int rentalId;
  final RentalDetailEntity? initialRental;

  @override
  ConsumerState<RentalCheckoutPage> createState() => _RentalCheckoutPageState();
}

class _RentalCheckoutPageState extends ConsumerState<RentalCheckoutPage> {
  late final TextEditingController _odoController;
  late final TextEditingController _batteryController;
  late final TextEditingController _noteController;
  late final TextEditingController _damageDescController;
  late final TextEditingController _damageCostController;

  final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  @override
  void initState() {
    super.initState();
    _odoController = TextEditingController();
    _batteryController = TextEditingController();
    _noteController = TextEditingController();
    _damageDescController = TextEditingController();
    _damageCostController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(checkoutControllerProvider.notifier)
          .initCheckoutInspection(
            widget.rentalId,
            initialRental: widget.initialRental,
          );
    });
  }

  @override
  void dispose() {
    _odoController.dispose();
    _batteryController.dispose();
    _noteController.dispose();
    _damageDescController.dispose();
    _damageCostController.dispose();
    super.dispose();
  }

  void _syncControllers(CheckoutState state) {
    if (_batteryController.text.isEmpty && state.returnBattery != null) {
      _batteryController.text = state.returnBattery.toString();
    }
  }

  void _addDamageItem(CheckoutController controller) {
    final desc = _damageDescController.text.trim();
    final costText = _damageCostController.text.trim();
    final cost = double.tryParse(costText.replaceAll(RegExp(r'[^0-9]'), ''));

    if (desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập mô tả vị trí hoặc chi tiết hư hại'),
        ),
      );
      return;
    }

    if (cost == null || cost <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập chi phí sửa chữa dự kiến')),
      );
      return;
    }

    controller.addDamageItem(desc, cost);
    _damageDescController.clear();
    _damageCostController.clear();
  }

  Future<void> _handleSubmit(CheckoutController controller) async {
    // Lấy thông tin tài khoản nhân viên nếu đang ở chế độ Staff
    final staffProfile = ref
        .read(staffDashboardControllerProvider)
        .staffProfile;

    final success = await controller.submitCheckoutInspection(
      staffEmail: staffProfile?.email,
      staffId: staffProfile?.staffId,
    );

    if (success && mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CheckoutSummaryPage(rentalId: widget.rentalId),
        ),
      );
      if (mounted) {
        ref.invalidate(staffDashboardControllerProvider);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(checkoutControllerProvider);
    final controller = ref.read(checkoutControllerProvider.notifier);

    _syncControllers(state);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Biên bản trả xe #${widget.rentalId}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
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
                    'Đang tải thông tin chuyến đi và xe...',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Tiến trình các bước
                  _buildStepProgressHeader(
                    isInspectionCompleted: state.checkOutChecklist != null,
                  ),
                  const SizedBox(height: 14),

                  // Thông báo nếu biên bản đã được lập từ trước
                  if (state.checkOutChecklist != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFA7F3D0)),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF059669),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Biên bản kiểm tra trả xe đã hoàn thành. Vui lòng bấm tiếp tục bên dưới để tiến hành quyết toán hoàn cọc.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF065F46),
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // 2. Thẻ tóm tắt xe & mức pin lúc nhận
                  _buildVehicleSummaryCard(state),
                  const SizedBox(height: 14),

                  // 3. Chụp ảnh ngoại quan xe lúc trả
                  CarInspectionPhotosSection(
                    description:
                        'Chụp ảnh xe lúc trả để lưu hồ sơ biên bản nhận lại xe:',
                    photos: state.photos,
                    isUploadingPhoto: state.isUploadingPhoto,
                    onPickPhotos: (source) =>
                        controller.pickAndUploadPhotos(source: source),
                    onRemovePhoto: (photoId) => controller.removePhoto(photoId),
                  ),
                  const SizedBox(height: 14),

                  // 4. Số ODO và Pin lúc trả xe
                  _buildOdoAndBatteryCard(state, controller),
                  const SizedBox(height: 14),

                  // 5. Ghi nhận sự cố & Hư hại xe mới
                  _buildDamageSection(state, controller),
                  const SizedBox(height: 14),

                  // 6. Ghi chú tình trạng xe lúc trả
                  _buildNoteCard(controller),
                  const SizedBox(height: 18),

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

                  // Nút kiểm tra xe hoặc tiếp tục quyết toán
                  if (state.checkOutChecklist != null)
                    AppButton(
                      label: 'Tiếp tục bước quyết toán cọc →',
                      icon: Icons.payments_rounded,
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                CheckoutSummaryPage(rentalId: widget.rentalId),
                          ),
                        );
                        if (mounted) {
                          ref.invalidate(staffDashboardControllerProvider);
                        }
                      },
                    )
                  else
                    AppButton(
                      label: state.isSubmitting
                          ? 'Đang gửi biên bản trả xe...'
                          : 'Xác nhận kiểm tra & Tiếp tục quyết toán',
                      icon: Icons.assignment_turned_in_rounded,
                      isLoading: state.isSubmitting,
                      onPressed:
                          (!state.isInspectionFormValid || state.isSubmitting)
                          ? null
                          : () => _handleSubmit(controller),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildStepProgressHeader({bool isInspectionCompleted = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStepItem(
              stepNumber: '1',
              title: 'Kiểm tra xe',
              isActive: !isInspectionCompleted,
              isCompleted: isInspectionCompleted,
            ),
          ),
          Container(
            width: 14,
            height: 1,
            color: const Color(0xFFCBD5E1),
            margin: const EdgeInsets.symmetric(horizontal: 2),
          ),
          Expanded(
            child: _buildStepItem(
              stepNumber: '2',
              title: 'Quyết toán',
              isActive: isInspectionCompleted,
              isCompleted: false,
            ),
          ),
          Container(
            width: 14,
            height: 1,
            color: const Color(0xFFCBD5E1),
            margin: const EdgeInsets.symmetric(horizontal: 2),
          ),
          Expanded(
            child: _buildStepItem(
              stepNumber: '3',
              title: 'Hoàn tất',
              isActive: false,
              isCompleted: false,
            ),
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
          child: isCompleted
              ? const Icon(Icons.check, size: 12, color: Colors.white)
              : Text(
                  stepNumber,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive || isCompleted
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: isActive
                  ? const Color(0xFF2563EB)
                  : const Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleSummaryCard(CheckoutState state) {
    final rental = state.rentalDetail;
    final checkInBattery = state.checkInChecklist?.currentBattery.toInt();

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
          Row(
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
                            state.stationName ??
                                rental?.stationName ??
                                'Trạm trả xe quy định',
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
          if (checkInBattery != null) ...[
            const Divider(height: 20),
            Row(
              children: [
                const Icon(
                  Icons.battery_charging_full_rounded,
                  size: 16,
                  color: Color(0xFF16A34A),
                ),
                const SizedBox(width: 6),
                Text(
                  'Pin lúc nhận xe ban đầu: $checkInBattery%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF166534),
                  ),
                ),
              ],
            ),
          ],
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
    CheckoutState state,
    CheckoutController controller,
  ) {
    final checkInBattery = state.checkInChecklist?.currentBattery.toInt();
    final currentReturnBattery = state.returnBattery;
    final isBatteryDeficit =
        checkInBattery != null &&
        currentReturnBattery != null &&
        currentReturnBattery < checkInBattery;

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
                'Số ODO & Phần trăm Pin lúc trả xe',
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
            label: 'Số đo đồng hồ ODO lúc trả (km)',
            hint: 'Ví dụ: 12650',
            keyboardType: TextInputType.number,
            controller: _odoController,
            prefixIcon: Icons.shutter_speed_rounded,
            onChanged: (val) {
              final odo = int.tryParse(val.trim());
              controller.setReturnOdometer(odo);
            },
          ),
          const SizedBox(height: 12),

          // Ô Pin
          AppTextField(
            label: 'Phần trăm pin hoàn trả (%) *',
            hint: 'Ví dụ: 85',
            keyboardType: TextInputType.number,
            controller: _batteryController,
            prefixIcon: Icons.battery_charging_full_rounded,
            onChanged: (val) {
              final pin = int.tryParse(val.trim());
              if (pin != null) {
                controller.setReturnBattery(pin);
              }
            },
          ),

          if (isBatteryDeficit) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFFD97706),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pin trả ($currentReturnBattery%) thấp hơn lúc nhận ($checkInBattery%). Có thể áp dụng phụ phí sạc hoàn trả theo quy định.',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDamageSection(
    CheckoutState state,
    CheckoutController controller,
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
          Row(
            children: [
              const Icon(
                Icons.car_crash_outlined,
                color: Color(0xFFDC2626),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Ghi nhận sự cố & Hư hại phát sinh',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              Switch.adaptive(
                value: state.isVehicleDamaged,
                activeTrackColor: const Color(0xFFDC2626),
                activeThumbColor: Colors.white,
                onChanged: controller.setIsVehicleDamaged,
              ),
            ],
          ),
          if (state.isVehicleDamaged) ...[
            const Divider(height: 18),
            const Text(
              'Thêm các hạng mục hư hại, trầy xước cần sửa chữa:',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 10),
            AppTextField(
              controller: _damageDescController,
              label: 'Vị trí / Chi tiết hư hại',
              hint: 'Ví dụ: Trầy cản trước bên phụ, móp cửa sau...',
              prefixIcon: Icons.description_outlined,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _damageCostController,
                    label: 'Chi phí dự kiến (VNĐ)',
                    hint: 'Ví dụ: 500000',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.payments_outlined,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => _addDamageItem(controller),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text(
                    'Thêm',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Danh sách các hạng mục hư hại đã thêm
            if (state.damageItems.isNotEmpty) ...[
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFECDD3)),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.damageItems.length,
                  separatorBuilder: (ctx, index) =>
                      const Divider(height: 1, color: Color(0xFFFECDD3)),
                  itemBuilder: (context, index) {
                    final item = state.damageItems[index];
                    return ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 2,
                      ),
                      title: Text(
                        item.description,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF991B1B),
                        ),
                      ),
                      subtitle: Text(
                        _currencyFormat.format(item.cost),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Color(0xFFDC2626),
                          size: 18,
                        ),
                        onPressed: () => controller.removeDamageItem(index),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Tổng phí hư hại: ${_currencyFormat.format(state.totalDamageCost)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDC2626),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildNoteCard(CheckoutController controller) {
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
                'Ghi chú tình trạng xe lúc trả (Không bắt buộc)',
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
              labelText: 'Ghi chú ngoại quan xe lúc trả',
              hintText: 'Ví dụ: Xe sạch sẽ, không có va quẹt thêm...',
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
