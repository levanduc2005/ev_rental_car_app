import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/widgets/widgets.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';
import 'package:rental_car/features/booking/domain/entities/booking_fee_entity.dart';
import 'package:rental_car/features/booking/domain/entities/vehicle_booking_summary.dart';
import 'package:rental_car/features/booking/presentation/providers/booking_form_controller.dart';
import 'package:rental_car/features/booking/presentation/providers/booking_providers.dart';
import 'package:rental_car/features/booking/presentation/utils/booking_formatters.dart';

/// Màn hình Thuê xe trực tiếp tại trạm (Instant QR Rental)
/// Giao diện chọn thời gian nhận & trả xe đồng bộ 100% với HomePage.
class InstantBookingConfirmationPage extends ConsumerStatefulWidget {
  final int vehicleId;
  const InstantBookingConfirmationPage({super.key, required this.vehicleId});

  @override
  ConsumerState<InstantBookingConfirmationPage> createState() =>
      _InstantBookingConfirmationPageState();
}

class _InstantBookingConfirmationPageState
    extends ConsumerState<InstantBookingConfirmationPage> {
  VehicleBookingSummary? _vehicle;
  bool _isLoading = true;
  String? _errorMessage;

  // Thời gian nhận và trả xe (Đồng bộ mô hình RentalHeroSearchCard trên HomePage)
  late DateTime _startDate;
  late DateTime _endDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  int _selectedHours = 4;

  BookingFeeEntity? _feeBreakdown;
  bool _isCalculatingFee = false;
  static const double _defaultDepositFallback = 10000000;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final remainder = now.minute % 5;
    final addMinutes = remainder == 0 ? 0 : 5 - remainder;
    final roundedNow = now.add(Duration(minutes: addMinutes));

    _startDate = DateTime(roundedNow.year, roundedNow.month, roundedNow.day);
    _startTime = TimeOfDay(hour: roundedNow.hour, minute: roundedNow.minute);

    // Mặc định kết thúc sau 4 giờ
    final startDt = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      _startTime.hour,
      _startTime.minute,
    );
    final endDt = startDt.add(Duration(hours: _selectedHours));
    _endDate = DateTime(endDt.year, endDt.month, endDt.day);
    _endTime = TimeOfDay(hour: endDt.hour, minute: endDt.minute);

    _loadVehicle();
  }

  String _pad(int n) => n.toString().padLeft(2, '0');
  String _formatDate(DateTime d) => '${_pad(d.day)}/${_pad(d.month)}/${d.year}';
  String _formatTime(TimeOfDay t) => '${_pad(t.hour)}:${_pad(t.minute)}';

  DateTime get _startDateTime => DateTime(
    _startDate.year,
    _startDate.month,
    _startDate.day,
    _startTime.hour,
    _startTime.minute,
  );

  DateTime get _endDateTime => DateTime(
    _endDate.year,
    _endDate.month,
    _endDate.day,
    _endTime.hour,
    _endTime.minute,
  );

  String _formatDurationSummary() {
    final totalMinutes = _endDateTime.difference(_startDateTime).inMinutes;
    if (totalMinutes <= 0) return '0 phút';

    final days = totalMinutes ~/ 1440;
    final remainingMinutes = totalMinutes % 1440;
    final hours = remainingMinutes ~/ 60;
    final minutes = remainingMinutes % 60;

    final parts = <String>[];
    if (days > 0) parts.add('$days ngày');
    if (hours > 0) parts.add('$hours giờ');
    if (minutes > 0) parts.add('$minutes phút');

    return parts.isEmpty ? '0 phút' : parts.join(' ');
  }

  Future<void> _loadVehicle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final getVehicleSummary = ref.read(getBookingVehicleSummaryUseCaseProvider);
    final result = await getVehicleSummary(widget.vehicleId);

    if (!mounted) return;

    result.when(
      ok: (vehicle) {
        setState(() {
          _vehicle = vehicle;
          _isLoading = false;
        });
        _calculateFee();
      },
      err: (failure) {
        setState(() {
          _errorMessage = failure.message;
          _isLoading = false;
        });
      },
    );
  }

  void _onSelectPresetHours(int hours) {
    final startDt = _startDateTime;
    final newEndDt = startDt.add(Duration(hours: hours));
    setState(() {
      _selectedHours = hours;
      _endDate = DateTime(newEndDt.year, newEndDt.month, newEndDt.day);
      _endTime = TimeOfDay(hour: newEndDt.hour, minute: newEndDt.minute);
    });
    _calculateFee();
  }

  void _adjustEndDateIfTooShort() {
    final startDt = _startDateTime;
    final currentEndDt = _endDateTime;
    final diffMinutes = currentEndDt.difference(startDt).inMinutes;

    if (diffMinutes < 240) {
      final newEndDt = startDt.add(const Duration(hours: 4));
      _endDate = DateTime(newEndDt.year, newEndDt.month, newEndDt.day);
      _endTime = TimeOfDay(hour: newEndDt.hour, minute: newEndDt.minute);
      _selectedHours = 4;
    } else if (currentEndDt.difference(startDt).inDays > 30) {
      final maxEndDt = startDt.add(const Duration(days: 30));
      _endDate = DateTime(maxEndDt.year, maxEndDt.month, maxEndDt.day);
      _endTime = TimeOfDay(hour: maxEndDt.hour, minute: maxEndDt.minute);
      _selectedHours = 30 * 24;
    } else {
      _selectedHours = (diffMinutes / 60).round();
    }
  }

  Future<void> _selectDate() async {
    final firstDate = _startDate;
    final lastDate = _startDate.add(const Duration(days: 30));

    final clampedInitial = _endDate.isBefore(firstDate)
        ? firstDate
        : (_endDate.isAfter(lastDate) ? lastDate : _endDate);

    final picked = await showDatePicker(
      context: context,
      initialDate: clampedInitial,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'CHỌN NGÀY TRẢ XE',
      confirmText: 'TIẾP TỤC',
      cancelText: 'HỦY',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2563EB),
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
        _adjustEndDateIfTooShort();
      });
      _calculateFee();
    }
  }

  Future<void> _selectTime() async {
    final initialHour = _endTime.hour;
    final initialMinuteIndex = (_endTime.minute / 5).round().clamp(0, 11);
    var tempHour = initialHour;
    var tempMinute = initialMinuteIndex * 5;

    final hourController = FixedExtentScrollController(
      initialItem: initialHour,
    );
    final minuteController = FixedExtentScrollController(
      initialItem: initialMinuteIndex,
    );
    final minuteOptions = List.generate(12, (index) => index * 5);

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SizedBox(
            height: 310,
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(top: 10, bottom: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey.shade600,
                        ),
                        child: const Text(
                          'Hủy',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      const Text(
                        'Chọn giờ & phút trả xe',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _endTime = TimeOfDay(
                              hour: tempHour,
                              minute: tempMinute,
                            );
                            _adjustEndDateIfTooShort();
                          });
                          Navigator.pop(ctx);
                          _calculateFee();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF2563EB),
                        ),
                        child: const Text(
                          'Xong',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: Row(
                    children: [
                      // Cột chọn Giờ
                      Expanded(
                        child: CupertinoPicker(
                          scrollController: hourController,
                          itemExtent: 44,
                          useMagnifier: true,
                          magnification: 1.15,
                          onSelectedItemChanged: (index) {
                            tempHour = index;
                          },
                          children: List.generate(24, (index) {
                            final h = index.toString().padLeft(2, '0');
                            return Center(
                              child: Text(
                                '$h giờ',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const Text(
                        ':',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      // Cột chọn Phút (bước 5 phút)
                      Expanded(
                        child: CupertinoPicker(
                          scrollController: minuteController,
                          itemExtent: 44,
                          useMagnifier: true,
                          magnification: 1.15,
                          onSelectedItemChanged: (index) {
                            tempMinute = minuteOptions[index];
                          },
                          children: minuteOptions.map((m) {
                            final mm = m.toString().padLeft(2, '0');
                            return Center(
                              child: Text(
                                '$mm phút',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _calculateFee() async {
    if (_vehicle == null) return;
    setState(() => _isCalculatingFee = true);

    final calculateFees = ref.read(calculateBookingFeesUseCaseProvider);
    final result = await calculateFees(
      vehicleId: _vehicle!.id,
      startTime: _startDateTime,
      endTime: _endDateTime,
    );

    if (!mounted) return;

    result.when(
      ok: (fee) {
        setState(() {
          _feeBreakdown = fee;
          _isCalculatingFee = false;
        });
      },
      err: (_) {
        setState(() => _isCalculatingFee = false);
      },
    );
  }

  double get _calculatedRentalPrice {
    if (_feeBreakdown != null) {
      return _feeBreakdown!.rentalFee;
    }
    if (_vehicle == null) return 0;

    final totalMinutes = _endDateTime.difference(_startDateTime).inMinutes;
    if (totalMinutes < 240) return _vehicle!.pricePer4Hours.toDouble();

    final hours = totalMinutes ~/ 60;
    final extraMinutes = totalMinutes % 60;

    final double hourlyRate;
    if (hours < 8) {
      hourlyRate = _vehicle!.pricePer4Hours / 4.0;
    } else if (hours < 12) {
      hourlyRate =
          (_vehicle!.pricePer8Hours > 0
              ? _vehicle!.pricePer8Hours
              : _vehicle!.pricePerDay / 2) /
          8.0;
    } else if (hours < 24) {
      hourlyRate =
          (_vehicle!.pricePer12Hours > 0
              ? _vehicle!.pricePer12Hours
              : _vehicle!.pricePerDay * 0.75) /
          12.0;
    } else {
      hourlyRate = _vehicle!.pricePerDay / 24.0;
    }

    final fee = (hourlyRate * hours) + (extraMinutes * (hourlyRate / 60.0));
    return fee.roundToDouble();
  }

  double get _depositFee => _vehicle?.depositFee ?? _defaultDepositFallback;
  double get _totalEstimatedAmount => _calculatedRentalPrice + _depositFee;

  Future<void> _handleConfirmInstantBooking() async {
    final authUser = ref.read(authControllerProvider).user;
    if (authUser == null || authUser.email.isEmpty) {
      context.showSnackBar(
        'Vui lòng đăng nhập tài khoản trước khi thuê xe.',
        type: SnackType.error,
      );
      return;
    }

    if (_vehicle == null) return;

    setState(() => _isSubmitting = true);

    final effectiveStartTime = _startDateTime;
    final effectiveEndTime = _endDateTime;

    final createReservation = ref.read(createReservationUseCaseProvider);
    final result = await createReservation(
      userEmail: authUser.email,
      vehicleId: _vehicle!.id,
      stationId: _vehicle!.stationId ?? 1,
      startTime: effectiveStartTime,
      endTime: effectiveEndTime,
      isInstant: true,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    result.when(
      ok: (reservation) {
        // Đồng bộ dữ liệu vào BookingFormController
        final completeReservation = reservation.copyWith(
          vehicle: _vehicle,
          totalRentAmount: _calculatedRentalPrice,
        );

        ref.read(bookingFormControllerProvider.notifier).initVehicle(_vehicle!);
        ref
            .read(bookingFormControllerProvider.notifier)
            .setPaymentReservation(completeReservation);

        // Chuyển tiếp sang màn hình thành công & nhận xe
        context.pushReplacementNamed(AppRoute.bookingSuccess.name);
      },
      err: (failure) {
        context.showSnackBar(failure.message, type: SnackType.error);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Thuê xe tại trạm (Instant)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadVehicle,
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge thông báo thuê tức thì
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF86EFAC)),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.bolt_rounded,
                          color: Color(0xFF16A34A),
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Bạn đang thực hiện thuê xe trực tiếp tại bãi. Không cần đặt trước 3 tiếng, có thể nhận xe và mở khóa ngay!',
                            style: TextStyle(
                              color: Color(0xFF15803D),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Thẻ thông tin xe
                  _buildVehicleCard(),

                  const SizedBox(height: 20),

                  // Khung chọn thời gian (Phong cách RentalHeroSearchCard trên HomePage)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Nhận xe
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Thời gian nhận xe',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF334155),
                              ),
                            ),
                            Text(
                              'Nhận ngay tại trạm',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0284C7),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _InstantPickerBox(
                              icon: Icons.calendar_today_outlined,
                              text: _formatDate(_startDate),
                              readOnly: true,
                            ),
                            const SizedBox(width: 10),
                            _InstantPickerBox(
                              icon: Icons.access_time_rounded,
                              iconSize: 17,
                              text: _formatTime(_startTime),
                              readOnly: true,
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // 2. Trả xe
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Thời gian trả xe',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF334155),
                              ),
                            ),
                            Builder(
                              builder: (context) {
                                final diffMinutes = _endDateTime
                                    .difference(_startDateTime)
                                    .inMinutes;
                                final isExactPreset =
                                    diffMinutes == 240 ||
                                    diffMinutes == 480 ||
                                    diffMinutes == 720 ||
                                    diffMinutes == 1440;
                                final badgeText = isExactPreset
                                    ? 'Gói ${diffMinutes ~/ 60} tiếng'
                                    : 'Tùy chọn: ${_formatDurationSummary()}';

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isExactPreset
                                        ? const Color(0xFFEFF6FF)
                                        : const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: isExactPreset
                                          ? const Color(0xFFBFDBFE)
                                          : const Color(0xFFFDE68A),
                                    ),
                                  ),
                                  child: Text(
                                    badgeText,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isExactPreset
                                          ? const Color(0xFF2563EB)
                                          : const Color(0xFFB45309),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _InstantPickerBox(
                              icon: Icons.calendar_today_outlined,
                              text: _formatDate(_endDate),
                              onTap: _selectDate,
                            ),
                            const SizedBox(width: 10),
                            _InstantPickerBox(
                              icon: Icons.access_time_rounded,
                              iconSize: 17,
                              text: _formatTime(_endTime),
                              onTap: _selectTime,
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.sm + 4),

                        // Gói chọn nhanh trong ngày: 4 tiếng, 8 tiếng, 12 tiếng, 24 tiếng
                        Row(
                          children: [
                            Expanded(
                              child: _buildPresetChip(
                                hours: 4,
                                label: '4 tiếng',
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: _buildPresetChip(
                                hours: 8,
                                label: '8 tiếng',
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: _buildPresetChip(
                                hours: 12,
                                label: '12 tiếng',
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: _buildPresetChip(
                                hours: 24,
                                label: '24 tiếng',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.sm + 4),

                        // Thông báo điều kiện (Tương đồng Homepage)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEFCE8),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFFEF08A)),
                          ),
                          child: const Text(
                            'Thời gian thuê tối thiểu 4 giờ. Tối đa 30 ngày (1 tháng).',
                            style: TextStyle(
                              color: Color(0xFF713F12),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Bảng kê chi phí
                  _buildCostBreakdown(),

                  const SizedBox(height: 32),

                  // Nút hành động xác nhận
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isSubmitting
                          ? null
                          : _handleConfirmInstantBooking,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Xác nhận thuê & Nhận xe ngay',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'Bằng cách bấm xác nhận, bạn đồng ý với Điều khoản thuê xe điện của e-Motion.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildPresetChip({required int hours, required String label}) {
    final diffMinutes = _endDateTime.difference(_startDateTime).inMinutes;
    final isSelected = diffMinutes == hours * 60;
    return InkWell(
      onTap: () => _onSelectPresetHours(hours),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2563EB)
                : const Color(0xFFCBD5E1),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF334155),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildVehicleCard() {
    if (_vehicle == null) return const SizedBox.shrink();

    final plate =
        (_vehicle!.plateNumber != null && _vehicle!.plateNumber!.isNotEmpty)
        ? _vehicle!.plateNumber!
        : 'Chưa cập nhật';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ảnh xe
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 90,
              height: 70,
              child:
                  (_vehicle!.imageUrl != null && _vehicle!.imageUrl!.isNotEmpty)
                  ? Image.network(
                      _vehicle!.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _buildCarPlaceholder(),
                    )
                  : _buildCarPlaceholder(),
            ),
          ),
          const SizedBox(width: 14),

          // Thông tin xe
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _vehicle!.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
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
                        plate,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.battery_charging_full_rounded,
                      size: 16,
                      color: Color(0xFF16A34A),
                    ),
                    Text(
                      ' ${_vehicle!.batteryLevel ?? 100}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _vehicle!.stationName ?? 'Trạm xe e-Motion',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarPlaceholder() {
    return Container(
      color: const Color(0xFFF1F5F9),
      child: const Center(
        child: Icon(
          Icons.directions_car_rounded,
          color: Color(0xFF94A3B8),
          size: 36,
        ),
      ),
    );
  }

  Widget _buildCostBreakdown() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Chi tiết biểu phí ước tính',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              if (_isCalculatingFee)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Giá thuê xe
          _buildFeeRow(
            label: 'Giá thuê xe (${_formatDurationSummary()}):',
            amount: _calculatedRentalPrice,
          ),
          const SizedBox(height: 8),

          // Tiền đặt cọc
          _buildFeeRow(
            label: 'Tiền cọc thế chấp xe:',
            amount: _depositFee,
            note: '(Hoàn trả sau khi kết thúc chuyến)',
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),

          // Tổng cộng
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng thanh toán dự kiến:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                BookingFormatters.formatCurrency(_totalEstimatedAmount.toInt()),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0284C7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeeRow({
    required String label,
    required double amount,
    String? note,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
            ),
            if (note != null)
              Text(
                note,
                style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
              ),
          ],
        ),
        Text(
          BookingFormatters.formatCurrency(amount.toInt()),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}

class _InstantPickerBox extends StatelessWidget {
  const _InstantPickerBox({
    required this.icon,
    required this.text,
    this.onTap,
    this.iconSize = 16,
    this.readOnly = false,
  });

  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  final double iconSize;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: readOnly ? null : onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: readOnly ? const Color(0xFFF8FAFC) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: readOnly
                  ? const Color(0xFFE2E8F0)
                  : const Color(0xFFCBD5E1),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: iconSize,
                color: readOnly
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF334155),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: readOnly
                        ? const Color(0xFF64748B)
                        : const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
