import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
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

  String _pad(int n) => n.toString().padLeft(2, '0');

  String _formatDate(DateTime d) => '${_pad(d.day)}/${_pad(d.month)}/${d.year}';

  String _formatTime(TimeOfDay t) => '${_pad(t.hour)}:${_pad(t.minute)}';

  String get _selectedLocationDisplayText => _selectedCityName;

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
        if (isStart) {
          _startDate = picked;
          _adjustEndDateIfTooShort();
        } else {
          _endDate = picked;
        }
      });
    }
  }

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

  Future<void> _selectTime({required bool isStart}) async {
    final initialHour = isStart ? _startTime.hour : _endTime.hour;
    var tempHour = initialHour;
    final scrollController = FixedExtentScrollController(
      initialItem: initialHour,
    );

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SizedBox(
            height: 300,
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
                              _startTime = TimeOfDay(hour: tempHour, minute: 0);
                              _adjustEndDateIfTooShort();
                            } else {
                              _endTime = TimeOfDay(hour: tempHour, minute: 0);
                            }
                          });
                          Navigator.pop(ctx);
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
        );
      },
    );
  }

  Future<void> _openLocationPicker() async {
    final theme = Theme.of(context);

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.md,
              horizontal: AppSpacing.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const Text(
                  'Chọn địa điểm nhận xe',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _buildCityOption(
                  ctx: ctx,
                  cityName: 'Hồ Chí Minh',
                  cityCode: 'TP_HCM',
                  isSelected: _selectedCityName == 'Hồ Chí Minh',
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildCityOption(
                  ctx: ctx,
                  cityName: 'Hà Nội',
                  cityCode: 'HANOI',
                  isSelected: _selectedCityName == 'Hà Nội',
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCityOption({
    required BuildContext ctx,
    required String cityName,
    required String cityCode,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCityName = cityName;
          _selectedCityCode = cityCode;
        });
        Navigator.pop(ctx);
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2563EB).withValues(alpha: 0.06)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2563EB)
                : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF2563EB).withValues(alpha: 0.12)
                    : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_city_rounded,
                size: 22,
                color: isSelected
                    ? const Color(0xFF2563EB)
                    : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                cityName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF2563EB)
                      : const Color(0xFF0F172A),
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF2563EB),
                size: 22,
              ),
          ],
        ),
      ),
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

    // Cập nhật bộ lọc trước khi điều hướng để MapSearchPage nhận diện ngay Frame 0
    ref
        .read(vehicleFilterProvider.notifier)
        .updateFilter(
          const VehicleFilter().copyWith(
            city: _selectedCityCode,
            location: _selectedCityName,
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
        'city': _selectedCityCode,
        'location': _selectedCityName,
        'start': startDateTime.toIso8601String(),
        'end': endDateTime.toIso8601String(),
      },
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Ảnh nền Hero Banner
        Container(
          height: 250,
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.75),
                  Colors.black.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
              top: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
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
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const Text(
                  'ấn tượng khó phai',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        // 2. Hộp tìm kiếm nổi (Thiết kế đồng bộ bản Web theo ảnh mẫu)
        Padding(
          padding: const EdgeInsets.only(
            top: 140,
            left: AppSpacing.md,
            right: AppSpacing.md,
          ),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md + 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề & phụ đề
                const Text(
                  'Tìm xe',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Nhập thông tin để tìm chiếc xe phù hợp với bạn.',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: AppSpacing.md),

                // Trường 1: Địa điểm nhận xe
                const Text(
                  'Địa điểm nhận xe',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: _openLocationPicker,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _selectedLocationDisplayText,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: Color(0xFF64748B),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Trường 2: Thời gian nhận xe (Ngày & Giờ)
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
                      onTap: () => _selectTime(isStart: true),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Trường 3: Thời gian trả xe (Ngày & Giờ)
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
                      onTap: () => _selectTime(isStart: false),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Thông báo: Chỉ được thuê tối đa 1 tháng (30 ngày) kể từ ngày nhận xe
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 13,
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
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _onConfirmPressed,
                    child: const Text(
                      'XÁC NHẬN',
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
      ],
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
              Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
