import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/widgets/widgets.dart';
import 'package:rental_car/features/active_trip/domain/entities/extend_rental_preview_entity.dart';
import 'package:rental_car/features/active_trip/domain/entities/extend_rental_result_entity.dart';
import 'package:rental_car/features/active_trip/domain/entities/vehicle_schedule_entity.dart';
import 'package:rental_car/features/active_trip/presentation/providers/active_rental_providers.dart';
import 'package:url_launcher/url_launcher.dart';

/// Modal BottomSheet gia hạn chuyến đi xe điện
Future<void> showExtendTripBottomSheet({
  required BuildContext context,
  required int rentalId,
  required int vehicleId,
  required String vehicleName,
  required DateTime currentEndTime,
  double pricePerHour = 100000,
  VoidCallback? onSuccess,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => ExtendTripBottomSheet(
      rentalId: rentalId,
      vehicleId: vehicleId,
      vehicleName: vehicleName,
      currentEndTime: currentEndTime,
      pricePerHour: pricePerHour,
      onSuccess: onSuccess,
    ),
  );
}

class ExtendTripBottomSheet extends ConsumerStatefulWidget {
  const ExtendTripBottomSheet({
    super.key,
    required this.rentalId,
    required this.vehicleId,
    required this.vehicleName,
    required this.currentEndTime,
    required this.pricePerHour,
    this.onSuccess,
  });

  final int rentalId;
  final int vehicleId;
  final String vehicleName;
  final DateTime currentEndTime;
  final double pricePerHour;
  final VoidCallback? onSuccess;

  @override
  ConsumerState<ExtendTripBottomSheet> createState() =>
      _ExtendTripBottomSheetState();
}

class _ExtendTripBottomSheetState extends ConsumerState<ExtendTripBottomSheet> {
  final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
  final _dateFormat = DateFormat('HH:00 - dd/MM/yyyy');

  List<VehicleScheduleEntity> _schedules = [];
  bool _isLoadingSchedule = true;

  int _selectedHours = 1;
  late DateTime _newEndTime;
  bool _isSubmitting = false;
  String? _errorMessage;

  ExtendRentalResultEntity? _paymentResult;
  ExtendRentalPreviewEntity? _previewResult;
  bool _isLoadingPreview = false;
  bool _isCheckingPayment = false;
  String? _checkPaymentMessage;

  @override
  void initState() {
    super.initState();
    // Khởi tạo thời gian gia hạn mặc định: currentEndTime + 1 giờ (làm tròn đúng giờ theo quy định BE)
    _newEndTime = _calculateNewEndTime(1);
    _loadVehicleSchedule();
    _fetchPreviewFee();
  }

  Future<void> _handleCheckPayment() async {
    setState(() {
      _isCheckingPayment = true;
      _checkPaymentMessage = null;
    });

    final useCase = ref.read(checkExtendPaymentUseCaseProvider);
    final result = await useCase(widget.rentalId);

    if (!mounted) return;
    setState(() {
      _isCheckingPayment = false;
    });

    result.when(
      ok: (isPaid) {
        if (isPaid) {
          ref.invalidate(activeRentalDetailControllerProvider(widget.rentalId));
          ref.invalidate(currentActiveRentalControllerProvider);
          widget.onSuccess?.call();
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Thanh toán gia hạn thành công! Chuyến đi đã được cập nhật.',
              ),
              backgroundColor: Color(0xFF16A34A),
            ),
          );
        } else {
          setState(() {
            _checkPaymentMessage =
                'Hệ thống chưa nhận được thanh toán từ ngân hàng. Nếu bạn vừa chuyển khoản, vui lòng đợi vài giây rồi bấm thử lại nhé!';
          });
        }
      },
      err: (failure) {
        setState(() {
          _checkPaymentMessage = failure.message;
        });
      },
    );
  }

  Future<void> _fetchPreviewFee() async {
    setState(() {
      _isLoadingPreview = true;
    });

    final useCase = ref.read(previewExtendRentalUseCaseProvider);
    final result = await useCase(
      rentalId: widget.rentalId,
      newReturnTime: _newEndTime,
    );

    if (!mounted) return;

    result.when(
      ok: (data) {
        setState(() {
          _previewResult = data;
          _isLoadingPreview = false;
        });
      },
      err: (failure) {
        setState(() {
          _previewResult = null;
          _isLoadingPreview = false;
        });
      },
    );
  }

  DateTime _calculateNewEndTime(int additionalHours) {
    final base = widget.currentEndTime.add(Duration(hours: additionalHours));
    return DateTime(base.year, base.month, base.day, base.hour);
  }

  Future<void> _loadVehicleSchedule() async {
    setState(() {
      _isLoadingSchedule = true;
    });

    final useCase = ref.read(getVehicleScheduleUseCaseProvider);
    final result = await useCase(widget.vehicleId);

    if (!mounted) return;

    result.when(
      ok: (data) {
        setState(() {
          _schedules = data
              .where((b) => b.endTime.isAfter(widget.currentEndTime))
              .toList();
          _isLoadingSchedule = false;
        });
      },
      err: (failure) {
        setState(() {
          _isLoadingSchedule = false;
        });
      },
    );
  }

  /// Kiểm tra xem thời gian trả xe mới có xung đột với lịch đặt nào của xe không
  bool _hasScheduleConflict(DateTime targetTime) {
    for (final booking in _schedules) {
      // Nếu targetTime rơi vào giữa khoảng đặt trước của khách khác
      if (targetTime.isAfter(booking.startTime) &&
          (targetTime.isBefore(booking.endTime) ||
              targetTime.isAtSameMomentAs(booking.endTime))) {
        return true;
      }
      // Nếu việc gia hạn kéo dài bao trùm toàn bộ lịch đặt trước
      if (widget.currentEndTime.isBefore(booking.startTime) &&
          targetTime.isAfter(booking.endTime)) {
        return true;
      }
    }
    return false;
  }

  double get _estimatedFee {
    final hours = _newEndTime.difference(widget.currentEndTime).inHours;
    return (hours > 0 ? hours : 1) * widget.pricePerHour;
  }

  Future<void> _handleConfirmExtend() async {
    if (_hasScheduleConflict(_newEndTime)) {
      setState(() {
        _errorMessage =
            'Thời gian bạn chọn trùng với lịch bận của xe. Vui lòng chọn mốc thời gian sớm hơn.';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final useCase = ref.read(extendRentalUseCaseProvider);
    final result = await useCase(
      rentalId: widget.rentalId,
      newReturnTime: _newEndTime,
    );

    if (!mounted) return;

    result.when(
      ok: (data) {
        setState(() {
          _isSubmitting = false;
          _paymentResult = data;
          _checkPaymentMessage = null;
        });

        // Tự động làm mới dữ liệu chuyến đi
        ref.invalidate(activeRentalDetailControllerProvider(widget.rentalId));
        ref.invalidate(currentActiveRentalControllerProvider);

        if (data.url.isEmpty && (data.qrCode == null || data.qrCode!.isEmpty)) {
          // Gia hạn thành công mà không cần link thanh toán
          widget.onSuccess?.call();
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gia hạn chuyến đi thành công!'),
              backgroundColor: Color(0xFF16A34A),
            ),
          );
        }
      },
      err: (failure) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = failure.message;
        });
      },
    );
  }

  Future<void> _pickCustomDateTime() async {
    final now = DateTime.now();
    final firstSelectableDate = widget.currentEndTime.isAfter(now)
        ? widget.currentEndTime
        : now;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _newEndTime.isAfter(firstSelectableDate)
          ? _newEndTime
          : firstSelectableDate.add(const Duration(hours: 1)),
      firstDate: firstSelectableDate,
      lastDate: firstSelectableDate.add(const Duration(days: 30)),
      helpText: 'CHỌN NGÀY TRẢ XE MỚI',
    );

    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _newEndTime.hour, minute: 0),
      helpText: 'CHỌN GIỜ TRẢ XE MỚI (CHẴN GIỜ)',
    );

    if (pickedTime == null || !mounted) return;

    // BE yêu cầu chính xác tròn giờ
    final candidateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
    );

    if (candidateTime.isBefore(
      widget.currentEndTime.add(const Duration(hours: 1)),
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Thời gian gia hạn mới phải sau hạn trả xe hiện tại ít nhất 1 giờ.',
          ),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    setState(() {
      _selectedHours = -1; // Tùy chọn tự do
      _newEndTime = candidateTime;
      _errorMessage = null;
    });
    _fetchPreviewFee();
  }

  @override
  Widget build(BuildContext context) {
    final isConflict = _hasScheduleConflict(_newEndTime);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Drag Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 14),

          // Title & Close Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    Icons.more_time_rounded,
                    color: Color(0xFF2563EB),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gia hạn chuyến đi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        '#${widget.rentalId} • ${widget.vehicleName}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 24, color: Color(0xFFF1F5F9)),

          // Body Content (Scrollable)
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _paymentResult != null
                  ? _buildPaymentResultView(_paymentResult!)
                  : _buildExtendFormView(isConflict),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExtendFormView(bool isConflict) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Thông tin hạn trả hiện tại
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.access_time_filled_rounded,
                color: Color(0xFF64748B),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hạn trả xe hiện tại',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _dateFormat.format(widget.currentEndTime),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 2. Lịch bận của xe (nếu có)
        if (_isLoadingSchedule)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text(
                  'Đang kiểm tra lịch trống của xe...',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          )
        else if (_schedules.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.event_busy_rounded,
                      size: 16,
                      color: Color(0xFFD97706),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Lịch xe đã được đặt trước:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ..._schedules.map(
                  (slot) => Padding(
                    padding: const EdgeInsets.only(left: 22, top: 2),
                    child: Text(
                      '• ${_dateFormat.format(slot.startTime)}  →  ${_dateFormat.format(slot.endTime)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB45309),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // 3. Chọn thời gian gia hạn
        const Text(
          'Chọn khoảng thời gian muốn gia hạn',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildQuickChip(label: '+1 giờ', hours: 1),
            _buildQuickChip(label: '+2 giờ', hours: 2),
            _buildQuickChip(label: '+4 giờ', hours: 4),
            _buildQuickChip(label: '+1 ngày (24h)', hours: 24),
            _buildCustomDateChip(),
          ],
        ),
        const SizedBox(height: 16),

        // 4. Thời gian trả xe dự kiến mới
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isConflict
                ? const Color(0xFFFEF2F2)
                : const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: isConflict
                  ? const Color(0xFFFECACA)
                  : const Color(0xFFBFDBFE),
            ),
          ),
          child: Row(
            children: [
              Icon(
                isConflict
                    ? Icons.warning_amber_rounded
                    : Icons.check_circle_rounded,
                color: isConflict
                    ? const Color(0xFFDC2626)
                    : const Color(0xFF2563EB),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isConflict
                          ? 'Thời gian gia hạn bị trùng lịch'
                          : 'Hạn trả xe dự kiến mới',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isConflict
                            ? const Color(0xFFDC2626)
                            : const Color(0xFF1D4ED8),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _dateFormat.format(_newEndTime),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isConflict
                            ? const Color(0xFF991B1B)
                            : const Color(0xFF1E3A8A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 5. Chi phí gia hạn
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Số tiền thanh toán thêm:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF334155),
                        ),
                      ),
                      if (_isLoadingPreview) ...[
                        const SizedBox(width: 8),
                        const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    _previewResult != null
                        ? _currencyFormat.format(_previewResult!.additionalFee)
                        : _currencyFormat.format(_estimatedFee),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _previewResult != null
                    ? 'Chỉ thanh toán cho ${_previewResult!.additionalHours} giờ gia hạn thêm'
                    : 'Ước tính cho thời gian gia hạn thêm',
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),

        // Thông báo lỗi (nếu có)
        if (_errorMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            _errorMessage!,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFFDC2626),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],

        const SizedBox(height: 24),

        // 6. Nút xác nhận gia hạn
        AppButton(
          label: 'Xác nhận gia hạn & Thanh toán',
          isLoading: _isSubmitting,
          onPressed: (isConflict || _isSubmitting)
              ? null
              : _handleConfirmExtend,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildQuickChip({required String label, required int hours}) {
    final isSelected = _selectedHours == hours;

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? Colors.white : const Color(0xFF334155),
        ),
      ),
      selected: isSelected,
      selectedColor: const Color(0xFF2563EB),
      backgroundColor: const Color(0xFFF1F5F9),
      side: BorderSide(
        color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedHours = hours;
            _newEndTime = _calculateNewEndTime(hours);
            _errorMessage = null;
          });
          _fetchPreviewFee();
        }
      },
    );
  }

  Widget _buildCustomDateChip() {
    final isCustom = _selectedHours == -1;

    return ActionChip(
      avatar: Icon(
        Icons.edit_calendar_rounded,
        size: 16,
        color: isCustom ? Colors.white : const Color(0xFF2563EB),
      ),
      label: Text(
        isCustom
            ? 'Tùy chọn: ${_dateFormat.format(_newEndTime)}'
            : 'Chọn ngày khác',
        style: TextStyle(
          fontSize: 13,
          fontWeight: isCustom ? FontWeight.bold : FontWeight.w500,
          color: isCustom ? Colors.white : const Color(0xFF2563EB),
        ),
      ),
      backgroundColor: isCustom
          ? const Color(0xFF2563EB)
          : const Color(0xFFEFF6FF),
      side: BorderSide(
        color: isCustom ? const Color(0xFF2563EB) : const Color(0xFFBFDBFE),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      onPressed: _pickCustomDateTime,
    );
  }

  Widget _buildPaymentResultView(ExtendRentalResultEntity result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Success Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF16A34A),
                size: 28,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Yêu cầu gia hạn đã được tạo',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF15803D),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Vui lòng thanh toán phụ phí để hoàn tất gia hạn.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF166534)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // VietQR Code Display
        if (result.qrCode != null && result.qrCode!.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Quét mã VietQR để thanh toán',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Image.network(
                    result.qrCode!,
                    width: 220,
                    height: 220,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 220,
                      height: 220,
                      color: const Color(0xFFF1F5F9),
                      alignment: Alignment.center,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.qr_code_2_rounded,
                            size: 48,
                            color: Color(0xFF64748B),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Không tải được mã QR',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Mã QR có hiệu lực trong vòng 15 phút',
                  style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Mở liên kết thanh toán PayOS / VNPay
        if (result.url.isNotEmpty) ...[
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Color(0xFF2563EB)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            onPressed: () async {
              final uri = Uri.tryParse(result.url);
              if (uri != null && await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            icon: const Icon(
              Icons.open_in_browser_rounded,
              color: Color(0xFF2563EB),
            ),
            label: const Text(
              'Mở trang thanh toán',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2563EB),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],

        // Thông báo kiểm tra thanh toán chưa thành công (nếu có)
        if (_checkPaymentMessage != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: const Color(0xFFFECACA)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFFDC2626),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _checkPaymentMessage!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFB91C1C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        // Nút hoàn tất kiểm tra
        AppButton(
          label: 'Tôi đã thanh toán xong',
          isLoading: _isCheckingPayment,
          onPressed: _isCheckingPayment ? null : _handleCheckPayment,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
