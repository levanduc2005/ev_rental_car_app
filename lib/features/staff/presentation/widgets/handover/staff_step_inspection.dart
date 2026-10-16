import 'package:flutter/material.dart';
import 'package:rental_car/core/widgets/widgets.dart';
import 'package:rental_car/features/checkin/presentation/widgets/car_inspection_photos_section.dart';
import 'package:rental_car/features/staff/presentation/controllers/staff_handover_controller.dart';
import 'package:rental_car/features/staff/presentation/controllers/staff_handover_state.dart';

class StaffStepInspection extends StatefulWidget {
  const StaffStepInspection({
    super.key,
    required this.state,
    required this.controller,
    required this.staffEmail,
  });

  final StaffHandoverState state;
  final StaffHandoverController controller;
  final String staffEmail;

  @override
  State<StaffStepInspection> createState() => _StaffStepInspectionState();
}

class _StaffStepInspectionState extends State<StaffStepInspection> {
  late final TextEditingController _batteryController;
  late final TextEditingController _odoController;

  @override
  void initState() {
    super.initState();
    _batteryController = TextEditingController(
      text: widget.state.batteryPercentage.toString(),
    );
    _odoController = TextEditingController(
      text: widget.state.odometer?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _batteryController.dispose();
    _odoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final controller = widget.controller;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Chụp ảnh ngoại quan tự do
        CarInspectionPhotosSection(
          photos: state.photos,
          isUploadingPhoto: state.isUploadingPhoto,
          onPickPhotos: (source) => controller.pickPhotos(source),
          onRemovePhoto: (id) => controller.removePhoto(id),
        ),
        const SizedBox(height: 14),

        // Nhập pin & ODO
        Container(
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
                'Thông số xe lúc nhận',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _batteryController,
                label: 'Phần trăm pin ban đầu (%)',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.battery_charging_full_rounded,
                onChanged: (val) {
                  final p = int.tryParse(val.trim());
                  if (p != null) controller.setBattery(p);
                },
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _odoController,
                label: 'Số công-tơ-mét xuất phát (ODO km)',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.speed_rounded,
                onChanged: (val) {
                  final o = int.tryParse(val.trim());
                  controller.setOdometer(o);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Nút Hoàn tất
        AppButton(
          label: state.isSubmitting
              ? 'Đang kích hoạt xe...'
              : 'Hoàn tất biên bản & Bàn giao xe',
          icon: Icons.key_rounded,
          isLoading: state.isSubmitting,
          onPressed: !state.isInspectionValid || state.isSubmitting
              ? null
              : () => controller.submitCheckinChecklist(widget.staffEmail),
        ),
      ],
    );
  }
}
