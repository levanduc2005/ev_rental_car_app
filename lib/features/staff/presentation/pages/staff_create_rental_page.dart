import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/widgets/app_button.dart';
import 'package:rental_car/features/booking/domain/entities/booking_fee_entity.dart';
import 'package:rental_car/features/booking/presentation/providers/booking_providers.dart';
import 'package:rental_car/features/booking/presentation/utils/booking_formatters.dart';
import 'package:rental_car/features/staff/domain/entities/renter_entity.dart';
import 'package:rental_car/features/staff/presentation/pages/staff_handover_page.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_providers.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';

class StaffCreateRentalPage extends ConsumerStatefulWidget {
  const StaffCreateRentalPage({
    required this.vehicle,
    required this.renter,
    super.key,
  });

  final VehicleEntity vehicle;
  final RenterEntity renter;

  @override
  ConsumerState<StaffCreateRentalPage> createState() =>
      _StaffCreateRentalPageState();
}

class _StaffCreateRentalPageState extends ConsumerState<StaffCreateRentalPage> {
  late DateTime _startTime;
  late DateTime _endTime;
  int? _selectedPackage =
      8; // Gói mặc định 8 giờ (4, 8, 12, 24 hoặc null/custom)

  bool _isLoadingFees = false;
  BookingFeeEntity? _bookingFees;
  String? _feeErrorMessage;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startTime = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      (now.minute / 5).ceil() * 5,
    );
    _selectedPackage = 8;
    _endTime = _startTime.add(const Duration(hours: 8));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchFees();
    });
  }

  int get _totalHours {
    final diff = _endTime.difference(_startTime).inHours;
    return diff > 0 ? diff : 4;
  }

  String get _durationSummary {
    final hours = _totalHours;
    if (hours < 24) return '$hours giờ';
    final days = hours ~/ 24;
    final rem = hours % 24;
    if (rem == 0) return '$days ngày ($hours giờ)';
    return '$days ngày $rem giờ ($hours giờ)';
  }

  Future<void> _fetchFees() async {
    setState(() {
      _isLoadingFees = true;
      _feeErrorMessage = null;
    });

    final calculateFees = ref.read(calculateBookingFeesUseCaseProvider);
    final result = await calculateFees(
      vehicleId: widget.vehicle.id,
      startTime: _startTime,
      endTime: _endTime,
      rental: true,
    );

    if (!mounted) return;

    result.when(
      ok: (fees) {
        setState(() {
          _bookingFees = fees;
          _isLoadingFees = false;
        });
      },
      err: (failure) {
        setState(() {
          _feeErrorMessage = failure.message;
          _isLoadingFees = false;
        });
      },
    );
  }

  void _selectQuickPackage(int hours) {
    setState(() {
      _selectedPackage = hours;
      _endTime = _startTime.add(Duration(hours: hours));
    });
    _fetchFees();
  }

  Future<void> _pickDate(bool isStart) async {
    final initialDate = isStart ? _startTime : _endTime;
    final firstDate = isStart
        ? DateTime.now().subtract(const Duration(days: 1))
        : _startTime;
    final lastDate = DateTime.now().add(const Duration(days: 30));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(firstDate) ? firstDate : initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            _startTime.hour,
            _startTime.minute,
          );
          if (_endTime.isBefore(_startTime.add(const Duration(hours: 4)))) {
            _endTime = _startTime.add(Duration(hours: _selectedPackage ?? 4));
          }
        } else {
          _endTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            _endTime.hour,
            _endTime.minute,
          );
          if (_endTime.isBefore(_startTime.add(const Duration(hours: 4)))) {
            _endTime = _startTime.add(const Duration(hours: 4));
          }
          _selectedPackage = null;
        }
      });
      _fetchFees();
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final currentTime = TimeOfDay.fromDateTime(isStart ? _startTime : _endTime);
    final picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = DateTime(
            _startTime.year,
            _startTime.month,
            _startTime.day,
            picked.hour,
            picked.minute,
          );
          if (_endTime.isBefore(_startTime.add(const Duration(hours: 4)))) {
            _endTime = _startTime.add(Duration(hours: _selectedPackage ?? 4));
          }
        } else {
          DateTime newEnd = DateTime(
            _endTime.year,
            _endTime.month,
            _endTime.day,
            picked.hour,
            picked.minute,
          );
          if (newEnd.isBefore(_startTime.add(const Duration(hours: 4)))) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Thời gian trả xe phải sau giờ nhận tối thiểu 4 giờ.',
                ),
                backgroundColor: Color(0xFFEF4444),
                duration: Duration(seconds: 2),
              ),
            );
            newEnd = _startTime.add(const Duration(hours: 4));
          }
          _endTime = newEnd;
          _selectedPackage = null;
        }
      });
      _fetchFees();
    }
  }

  Future<void> _handleCreateRental() async {
    final staffProfile = ref
        .read(staffDashboardControllerProvider)
        .staffProfile;
    final staffId = staffProfile?.staffId;

    if (staffId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không tìm thấy thông tin nhân viên đăng nhập.'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final now = DateTime.now();
    DateTime effectiveStart = _startTime;
    DateTime effectiveEnd = _endTime;

    // Nếu thời gian bắt đầu đã trôi vào quá khứ so với thời điểm bấm nút
    if (effectiveStart.isBefore(now)) {
      final duration = effectiveEnd.difference(effectiveStart);
      effectiveStart = now;
      effectiveEnd = effectiveStart.add(
        duration.inHours >= 4 ? duration : const Duration(hours: 4),
      );
    }

    // Đảm bảo thời gian thuê tối thiểu 4 giờ
    if (effectiveEnd.difference(effectiveStart).inHours < 4) {
      effectiveEnd = effectiveStart.add(const Duration(hours: 4));
    }

    final createRental = ref.read(createRentalUseCaseProvider);
    final result = await createRental(
      startTime: effectiveStart,
      endTime: effectiveEnd,
      vehicleId: widget.vehicle.id,
      email: widget.renter.email,
      staffId: staffId,
    );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    result.when(
      ok: (createdRental) {
        // Làm mới dữ liệu tab quản lý đơn
        ref.read(staffDashboardControllerProvider.notifier).refreshData();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Tạo đơn thuê xe thành công! Chuyển sang bước bàn giao.',
            ),
            backgroundColor: Color(0xFF059669),
          ),
        );

        // Chuyển thẳng sang trang bàn giao xe cho đơn vừa tạo
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => StaffHandoverPage(rental: createdRental),
          ),
        );
      },
      err: (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi tạo đơn thuê: ${failure.message}'),
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(staffDashboardControllerProvider);
    final stationName =
        dashboardState.currentStation?.name ??
        widget.vehicle.stationName ??
        'Trạm xe hiện tại';

    final canSubmit = !_isSubmitting && !_isLoadingFees && _bookingFees != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Xác nhận thông tin thuê xe',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildVehicleSummaryCard(stationName),
            const SizedBox(height: 12),
            _buildRenterSummaryCard(),
            const SizedBox(height: 12),
            _buildRentalTimeCard(),
            const SizedBox(height: 12),
            _buildPaymentDetailCard(),
            const SizedBox(height: 24),
            AppButton(
              label: 'Xác nhận & Tạo đơn thuê xe',
              icon: Icons.check_circle_outline,
              isLoading: _isSubmitting,
              onPressed: canSubmit ? _handleCreateRental : null,
              expanded: true,
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Bằng việc tạo đơn thuê, khách hàng đồng ý với Điều khoản và Quy định của e-Motion.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleSummaryCard(String stationName) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 80,
              height: 64,
              color: const Color(0xFFF1F5F9),
              child:
                  widget.vehicle.mainImage != null &&
                      widget.vehicle.mainImage!.isNotEmpty
                  ? Image.network(
                      widget.vehicle.mainImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.directions_car, color: Colors.grey),
                    )
                  : const Icon(Icons.directions_car, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.vehicle.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                if (widget.vehicle.plateNumber != null &&
                    widget.vehicle.plateNumber!.isNotEmpty)
                  Text(
                    'Biển số: ${widget.vehicle.plateNumber!}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF334155),
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: Color(0xFF059669),
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        stationName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
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

  Widget _buildRenterSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.person_pin, size: 18, color: AppColors.primary),
              SizedBox(width: 6),
              Text(
                'THÔNG TIN NGƯỜI THUÊ',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            'Họ và tên:',
            widget.renter.fullName.isNotEmpty
                ? widget.renter.fullName
                : 'Chưa cập nhật',
          ),
          const SizedBox(height: 6),
          _buildInfoRow('Email:', widget.renter.email),
          const SizedBox(height: 6),
          _buildInfoRow(
            'Số điện thoại:',
            (widget.renter.phone != null && widget.renter.phone!.isNotEmpty)
                ? widget.renter.phone!
                : 'Chưa cập nhật',
          ),
          const SizedBox(height: 6),
          _buildInfoRow('Điểm e-Points:', '${widget.renter.point} điểm'),
        ],
      ),
    );
  }

  Widget _buildRentalTimeCard() {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');

    final packages = [
      {'label': '4 giờ', 'hours': 4},
      {'label': '8 giờ', 'hours': 8},
      {'label': '12 giờ', 'hours': 12},
      {'label': '24 giờ (1 ngày)', 'hours': 24},
    ];

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
          const Row(
            children: [
              Icon(Icons.calendar_month, size: 18, color: AppColors.primary),
              SizedBox(width: 6),
              Text(
                'THỜI GIAN THUÊ XE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Khối chọn Nhận xe và Trả xe (Đồng bộ chuẩn search)
          Row(
            children: [
              // Cột Nhận xe
              Expanded(
                child: _DateTimeBox(
                  title: 'NHẬN XE',
                  titleColor: const Color(0xFF10B981),
                  dateText: dateFormat.format(_startTime),
                  timeText: timeFormat.format(_startTime),
                  onTapDate: () => _pickDate(true),
                  onTapTime: () => _pickTime(true),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Color(0xFF94A3B8),
                  size: 18,
                ),
              ),
              // Cột Trả xe
              Expanded(
                child: _DateTimeBox(
                  title: 'TRẢ XE',
                  titleColor: const Color(0xFFEF4444),
                  dateText: dateFormat.format(_endTime),
                  timeText: timeFormat.format(_endTime),
                  onTapDate: () => _pickDate(false),
                  onTapTime: () => _pickTime(false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tiêu đề chọn gói nhanh
          const Text(
            'Chọn nhanh gói thời gian thuê:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 8),

          // Các gói: 4h, 8h, 12h, 24h và Tùy chọn
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...packages.map((pkg) {
                final hours = pkg['hours'] as int;
                final label = pkg['label'] as String;
                final isSelected = _selectedPackage == hours;

                return ChoiceChip(
                  label: Text(label),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF334155),
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: const Color(0xFFF1F5F9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  onSelected: (_) => _selectQuickPackage(hours),
                );
              }),
              ChoiceChip(
                label: Text(
                  _selectedPackage == null ? 'Tùy chọn' : 'Tùy chọn...',
                ),
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: _selectedPackage == null
                      ? FontWeight.bold
                      : FontWeight.w500,
                  color: _selectedPackage == null
                      ? Colors.white
                      : const Color(0xFF334155),
                ),
                selected: _selectedPackage == null,
                selectedColor: AppColors.primary,
                backgroundColor: const Color(0xFFF1F5F9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: _selectedPackage == null
                        ? AppColors.primary
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                onSelected: (_) => _pickDate(false),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Thanh tóm tắt tổng thời gian
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  size: 18,
                  color: Color(0xFF16A34A),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Tổng thời gian thuê: ',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF166534),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _durationSummary,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF15803D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.receipt_long, size: 18, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text(
                    'CHI TIẾT THANH TOÁN',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
              if (_isLoadingFees)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (_feeErrorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 18,
                    color: Color(0xFFDC2626),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _feeErrorMessage!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _fetchFees,
                    child: const Text(
                      'Thử lại',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (_bookingFees != null) ...[
            _buildPriceRow(
              'Tiền thuê xe',
              BookingFormatters.formatCurrency(_bookingFees!.bookingCost),
            ),
            const SizedBox(height: 8),
            _buildPriceRow(
              'Tiền cọc xe',
              BookingFormatters.formatCurrency(_bookingFees!.collateralFee),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1, color: Color(0xFFE2E8F0)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng cộng',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  BookingFormatters.formatCurrency(_bookingFees!.totalCost),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Color(0xFF16A34A)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Khách hàng sẽ thanh toán tiền cọc xe qua VietQR PayOS khi nhân viên tiến hành bàn giao xe.',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF166534),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Đang tính toán biểu phí...',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}

class _DateTimeBox extends StatelessWidget {
  const _DateTimeBox({
    required this.title,
    required this.titleColor,
    required this.dateText,
    required this.timeText,
    required this.onTapDate,
    required this.onTapTime,
  });

  final String title;
  final Color titleColor;
  final String dateText;
  final String timeText;
  final VoidCallback onTapDate;
  final VoidCallback onTapTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: titleColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Nút bấm chọn ngày
          InkWell(
            onTap: onTapDate,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.event_rounded,
                    size: 14,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      dateText,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Nút bấm chọn giờ
          InkWell(
            onTap: onTapTime,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      timeText,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
