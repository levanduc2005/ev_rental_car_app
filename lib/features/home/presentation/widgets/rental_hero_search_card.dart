import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_filter.dart';
import 'package:rental_car/features/vehicles/presentation/providers/vehicle_providers.dart';

class RentalHeroSearchCard extends ConsumerStatefulWidget {
  const RentalHeroSearchCard({super.key});

  @override
  ConsumerState<RentalHeroSearchCard> createState() =>
      _RentalHeroSearchCardState();
}

class _RentalHeroSearchCardState extends ConsumerState<RentalHeroSearchCard> {
  // Địa điểm nhận xe (Mặc định Hồ Chí Minh)
  String _selectedCityName = 'Hồ Chí Minh';
  String _selectedCityCode = 'TP_HCM';

  // Thời gian nhận - trả xe
  late DateTime _startDate;
  late DateTime _endDate;
  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 12, minute: 0);

  bool _hasCustomized = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();

    // Quy tắc BE: Thời gian bắt đầu phải sau hiện tại ít nhất 3 giờ (VEHICLE_TIME_MUST_AFTER_NOW_3HOURS)
    // Nếu hôm nay đã quá 18:00, chuyển sang ngày mai lúc 08:00 - 12:00
    final earliestHourToday = now.minute > 0 ? now.hour + 4 : now.hour + 3;
    if (earliestHourToday <= 19) {
      _startDate = DateTime(now.year, now.month, now.day);
      _endDate = DateTime(now.year, now.month, now.day);
      _startTime = TimeOfDay(hour: earliestHourToday, minute: 0);
      final endH = earliestHourToday + 4;
      if (endH <= 23) {
        _endTime = TimeOfDay(hour: endH, minute: 0);
      } else {
        _endDate = _startDate.add(const Duration(days: 1));
        _endTime = TimeOfDay(hour: endH - 24, minute: 0);
      }
    } else {
      // Mặc định ngày mai lúc 08:00 đến 12:00
      _startDate = DateTime(now.year, now.month, now.day + 1);
      _endDate = DateTime(now.year, now.month, now.day + 1);
      _startTime = const TimeOfDay(hour: 8, minute: 0);
      _endTime = const TimeOfDay(hour: 12, minute: 0);
    }
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');

  static String _formatDate(DateTime d) =>
      '${_pad(d.day)}/${_pad(d.month)}/${d.year}';

  static String _formatTime(TimeOfDay t) => '${_pad(t.hour)}:${_pad(t.minute)}';

  void _openSearchModal() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _SearchBottomSheetModal(
          initialCityName: _selectedCityName,
          initialCityCode: _selectedCityCode,
          initialStartDate: _startDate,
          initialEndDate: _endDate,
          initialStartTime: _startTime,
          initialEndTime: _endTime,
          onConfirm:
              ({
                required String cityName,
                required String cityCode,
                required DateTime startDate,
                required DateTime endDate,
                required TimeOfDay startTime,
                required TimeOfDay endTime,
              }) {
                setState(() {
                  _selectedCityName = cityName;
                  _selectedCityCode = cityCode;
                  _startDate = startDate;
                  _endDate = endDate;
                  _startTime = startTime;
                  _endTime = endTime;
                  _hasCustomized = true;
                });

                _executeSearch(
                  cityName: cityName,
                  cityCode: cityCode,
                  startDate: startDate,
                  endDate: endDate,
                  startTime: startTime,
                  endTime: endTime,
                );
              },
        );
      },
    );
  }

  void _executeSearch({
    required String cityName,
    required String cityCode,
    required DateTime startDate,
    required DateTime endDate,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
  }) {
    final startDateTime = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      startTime.hour,
    );
    final endDateTime = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      endTime.hour,
    );

    // Cập nhật bộ lọc trước khi điều hướng để MapSearchPage nhận diện ngay Frame 0
    ref
        .read(vehicleFilterProvider.notifier)
        .updateFilter(
          const VehicleFilter().copyWith(
            city: cityCode,
            location: cityName,
            startTime: startDateTime,
            endTime: endDateTime,
            brand: 'Tất cả',
            clearSearch: true,
          ),
        );

    // Điều hướng sang màn hình tìm kiếm & bản đồ xe
    context.goNamed(
      AppRoute.mapSearch.name,
      queryParameters: {
        'city': cityCode,
        'location': cityName,
        'start': startDateTime.toIso8601String(),
        'end': endDateTime.toIso8601String(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?q=80&w=1200&auto=format&fit=crop',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.8),
              Colors.black.withValues(alpha: 0.45),
              Colors.black.withValues(alpha: 0.75),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Badge giới thiệu
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt_rounded, size: 14, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'Trải nghiệm tương lai xanh',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Thuê xe tự lái',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const Text(
              'ấn tượng khó phai',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSpacing.md + 2),

            // Nút search thanh lịch
            InkWell(
              onTap: _openSearchModal,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.search_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _hasCustomized
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _selectedCityName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${_formatDate(_startDate)} ${_formatTime(_startTime)} - ${_formatDate(_endDate)} ${_formatTime(_endTime)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Tìm kiếm xe tự lái',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Chọn địa điểm, ngày & giờ nhận xe',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.tune_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Tìm xe',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Modal Bottom Sheet chọn thông tin tìm xe
class _SearchBottomSheetModal extends StatefulWidget {
  const _SearchBottomSheetModal({
    required this.initialCityName,
    required this.initialCityCode,
    required this.initialStartDate,
    required this.initialEndDate,
    required this.initialStartTime,
    required this.initialEndTime,
    required this.onConfirm,
  });

  final String initialCityName;
  final String initialCityCode;
  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final TimeOfDay initialStartTime;
  final TimeOfDay initialEndTime;
  final void Function({
    required String cityName,
    required String cityCode,
    required DateTime startDate,
    required DateTime endDate,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
  })
  onConfirm;

  @override
  State<_SearchBottomSheetModal> createState() =>
      _SearchBottomSheetModalState();
}

class _SearchBottomSheetModalState extends State<_SearchBottomSheetModal> {
  late String _cityName;
  late String _cityCode;
  late DateTime _startDate;
  late DateTime _endDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    _cityName = widget.initialCityName;
    _cityCode = widget.initialCityCode;
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
    _startTime = widget.initialStartTime;
    _endTime = widget.initialEndTime;
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');

  static String _formatDate(DateTime d) =>
      '${_pad(d.day)}/${_pad(d.month)}/${d.year}';

  static String _formatTime(TimeOfDay t) => '${_pad(t.hour)}:${_pad(t.minute)}';

  void _adjustEndDateIfTooShort() {
    final startDt = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      _startTime.hour,
    );
    final currentEndDt = DateTime(
      _endDate.year,
      _endDate.month,
      _endDate.day,
      _endTime.hour,
    );
    if (currentEndDt.difference(startDt).inHours < 4) {
      final newEndDt = startDt.add(const Duration(hours: 4));
      _endDate = DateTime(newEndDt.year, newEndDt.month, newEndDt.day);
      _endTime = TimeOfDay(hour: newEndDt.hour, minute: 0);
    } else if (currentEndDt.difference(startDt).inDays > 30) {
      _endDate = _startDate.add(const Duration(days: 30));
    }
  }

  Future<void> _selectDate({required bool isStart}) async {
    final now = DateTime.now();
    final initialDate = isStart ? _startDate : _endDate;
    final firstDate = isStart
        ? DateTime(now.year, now.month, now.day)
        : _startDate;
    final lastDate = isStart
        ? DateTime(now.year + 1, now.month, now.day)
        : _startDate.add(const Duration(days: 30));

    final clampedInitial = initialDate.isBefore(firstDate)
        ? firstDate
        : (initialDate.isAfter(lastDate) ? lastDate : initialDate);

    final picked = await showDatePicker(
      context: context,
      initialDate: clampedInitial,
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
          _startDate = picked;
          _adjustEndDateIfTooShort();
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectHour({required bool isStart}) async {
    final initialHour = isStart ? _startTime.hour : _endTime.hour;
    var tempHour = initialHour;
    final scrollController = FixedExtentScrollController(
      initialItem: initialHour,
    );

    await showDialog<void>(
      context: context,
      builder: (dialogCtx) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              height: 290,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogCtx),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey.shade600,
                          ),
                          child: const Text(
                            'Hủy',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Text(
                          isStart ? 'Chọn giờ nhận xe' : 'Chọn giờ trả xe',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              if (isStart) {
                                _startTime = TimeOfDay(
                                  hour: tempHour,
                                  minute: 0,
                                );
                                _adjustEndDateIfTooShort();
                              } else {
                                _endTime = TimeOfDay(hour: tempHour, minute: 0);
                              }
                            });
                            Navigator.pop(dialogCtx);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
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
                    child: CupertinoPicker(
                      scrollController: scrollController,
                      itemExtent: 44,
                      useMagnifier: true,
                      magnification: 1.15,
                      onSelectedItemChanged: (index) {
                        tempHour = index;
                      },
                      children: List.generate(24, (index) {
                        return Center(
                          child: Text(
                            '${_pad(index)}:00',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onConfirmPressed() {
    final startDateTime = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      _startTime.hour,
    );
    final endDateTime = DateTime(
      _endDate.year,
      _endDate.month,
      _endDate.day,
      _endTime.hour,
    );

    final now = DateTime.now();

    // 1. BE Rule: Thời gian bắt đầu phải sau hiện tại ít nhất 3 giờ
    if (startDateTime.isBefore(now.add(const Duration(hours: 3)))) {
      _showWarningSnackBar(
        'Thời gian nhận xe phải sau thời điểm hiện tại ít nhất 3 giờ.',
      );
      return;
    }

    // 2. BE Rule: Thời gian thuê tối thiểu 4 giờ
    if (endDateTime.difference(startDateTime).inHours < 4) {
      _showWarningSnackBar('Thời gian thuê tối thiểu là 4 giờ.');
      return;
    }

    // 3. BE Rule: Tối đa 30 ngày (1 tháng)
    if (endDateTime.difference(startDateTime).inDays > 30) {
      _showWarningSnackBar(
        'Chỉ được thuê tối đa 1 tháng (30 ngày) kể từ ngày nhận xe.',
      );
      return;
    }

    Navigator.pop(context);
    widget.onConfirm(
      cityName: _cityName,
      cityCode: _cityCode,
      startDate: _startDate,
      endDate: _endDate,
      startTime: _startTime,
      endTime: _endTime,
    );
  }

  void _showWarningSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildCityCard({
    required String cityName,
    required String cityCode,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _cityCode = cityCode;
          _cityName = cityName;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on_rounded,
              size: 20,
              color: isSelected ? AppColors.primary : const Color(0xFF64748B),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                cityName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFF0F172A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                size: 18,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md + 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thanh kéo drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header: Tiêu đề & Nút đóng
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tìm kiếm xe',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Nhập thông tin để tìm chiếc xe phù hợp với bạn.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Trường 1: Địa điểm nhận xe
              const _SearchFieldLabel('Địa điểm nhận xe'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildCityCard(
                      cityName: 'Hồ Chí Minh',
                      cityCode: 'TP_HCM',
                      isSelected: _cityCode == 'TP_HCM',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildCityCard(
                      cityName: 'Hà Nội',
                      cityCode: 'HANOI',
                      isSelected: _cityCode == 'HANOI',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Trường 2: Thời gian nhận xe
              const _SearchFieldLabel('Thời gian nhận xe'),
              const SizedBox(height: 6),
              Row(
                children: [
                  _DateTimePickerBox(
                    icon: Icons.calendar_today_outlined,
                    text: _formatDate(_startDate),
                    onTap: () => _selectDate(isStart: true),
                  ),
                  const SizedBox(width: 10),
                  _DateTimePickerBox(
                    icon: Icons.access_time_rounded,
                    iconSize: 17,
                    text: _formatTime(_startTime),
                    onTap: () => _selectHour(isStart: true),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Trường 3: Thời gian trả xe
              const _SearchFieldLabel('Thời gian trả xe'),
              const SizedBox(height: 6),
              Row(
                children: [
                  _DateTimePickerBox(
                    icon: Icons.calendar_today_outlined,
                    text: _formatDate(_endDate),
                    onTap: () => _selectDate(isStart: false),
                  ),
                  const SizedBox(width: 10),
                  _DateTimePickerBox(
                    icon: Icons.access_time_rounded,
                    iconSize: 17,
                    text: _formatTime(_endTime),
                    onTap: () => _selectHour(isStart: false),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Thông báo quy tắc 30 ngày
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEFCE8),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFEF08A)),
                ),
                child: const Text(
                  'Chỉ được thuê tối đa 1 tháng (30 ngày) kể từ ngày nhận xe.',
                  style: TextStyle(
                    color: Color(0xFF713F12),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.md + 4),

              // Nút XÁC NHẬN
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _onConfirmPressed,
                  child: const Text(
                    'TÌM XE',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchFieldLabel extends StatelessWidget {
  const _SearchFieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF334155),
      ),
    );
  }
}

class _DateTimePickerBox extends StatelessWidget {
  const _DateTimePickerBox({
    required this.icon,
    required this.text,
    required this.onTap,
    this.iconSize = 16,
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Icon(icon, size: iconSize, color: const Color(0xFF334155)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0F172A),
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
