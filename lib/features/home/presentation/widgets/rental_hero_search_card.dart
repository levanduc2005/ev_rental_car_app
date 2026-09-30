import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/home/presentation/providers/home_providers.dart';
import 'package:rental_car/features/vehicles/domain/entities/station_entity.dart';

class RentalHeroSearchCard extends ConsumerStatefulWidget {
  const RentalHeroSearchCard({super.key});

  @override
  ConsumerState<RentalHeroSearchCard> createState() =>
      _RentalHeroSearchCardState();
}

class _RentalHeroSearchCardState extends ConsumerState<RentalHeroSearchCard> {
  // 0: Thuê theo gói, 1: Thuê theo tháng (tối đa 30 ngày theo BE)
  int _selectedRentalType = 0;

  // Địa điểm nhận xe (Đồng bộ với BE StationCity: "Hà Nội" -> HANOI, "Hồ Chí Minh" -> TP_HCM)
  String _selectedCityName = 'Hà Nội';
  String _selectedCityCode = 'HANOI';
  int? _selectedStationId;
  String _selectedStationName = 'Tất cả các trạm';

  // Thời gian nhận - trả
  late DateTime _startDate;
  late DateTime _endDate;
  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 12, minute: 0);

  // Gói giờ đã chọn: 4 (tối thiểu BE), 8, 12, 24, hoặc null (tùy chỉnh)
  int? _selectedHourPackage = 4;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Quy tắc BE: Thời gian bắt đầu phải sau hiện tại ít nhất 3 giờ (VEHICLE_TIME_MUST_AFTER_NOW_3HOURS)
    // Nếu hôm nay đã quá 18:00, chuyển sang ngày mai lúc 08:00
    final earliestHourToday = now.minute > 0 ? now.hour + 4 : now.hour + 3;
    if (earliestHourToday <= 20) {
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
      // Mặc định ngày mai lúc 08:00 đến 12:00 (gói 4 tiếng chuẩn hệ thống)
      _startDate = DateTime(now.year, now.month, now.day + 1);
      _endDate = DateTime(now.year, now.month, now.day + 1);
      _startTime = const TimeOfDay(hour: 8, minute: 0);
      _endTime = const TimeOfDay(hour: 12, minute: 0);
    }
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  String get _selectedLocationText =>
      '$_selectedCityName • $_selectedStationName';

  Duration get _totalDuration {
    final start = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      _startTime.hour,
    );
    final end = DateTime(
      _endDate.year,
      _endDate.month,
      _endDate.day,
      _endTime.hour,
    );
    return end.difference(start);
  }

  String get _selectedTimeText {
    final isSameDay =
        _startDate.year == _endDate.year &&
        _startDate.month == _endDate.month &&
        _startDate.day == _endDate.day;

    final duration = _totalDuration;
    final hours = duration.inHours;
    final days = duration.inDays;
    final remainHours = hours % 24;

    String durationLabel = '';
    if (days > 0) {
      durationLabel = remainHours > 0
          ? '$days ngày $remainHours giờ'
          : '$days ngày';
    } else {
      durationLabel = '$hours giờ';
    }

    if (isSameDay) {
      final startStr = '${_pad(_startTime.hour)}:00';
      final endStr = '${_pad(_endTime.hour)}:00';
      final dateStr = '${_pad(_startDate.day)}/${_pad(_startDate.month)}';
      return '$startStr — $endStr, $dateStr ($durationLabel)';
    }

    final startStr =
        '${_pad(_startTime.hour)}:00, ${_pad(_startDate.day)}/${_pad(_startDate.month)}';
    final endStr =
        '${_pad(_endTime.hour)}:00, ${_pad(_endDate.day)}/${_pad(_endDate.month)}';
    return '$startStr — $endStr ($durationLabel)';
  }

  Future<void> _openLocationPicker() async {
    final theme = Theme.of(context);
    var currentTab = _selectedCityName;

    // Fallback stations nếu BE chưa seed data hoặc offline
    final fallbackStations = {
      'Hà Nội': const [
        StationEntity(
          id: 3,
          name: 'Trạm Sạc & Thuê Xe Cầu Giấy',
          address: 'Xuân Thủy, Cầu Giấy',
        ),
        StationEntity(
          id: 4,
          name: 'Trạm Sạc & Thuê Xe Hoàn Kiếm',
          address: 'Tràng Tiền, Hoàn Kiếm',
        ),
      ],
      'Hồ Chí Minh': const [
        StationEntity(
          id: 1,
          name: 'Trạm Sạc & Thuê Xe Quận 1',
          address: 'Lê Duẩn, Quận 1',
        ),
        StationEntity(
          id: 2,
          name: 'Trạm Sạc & Thuê Xe Khu Công Nghệ Cao',
          address: 'TP. Thủ Đức',
        ),
      ],
    };

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md,
                horizontal: AppSpacing.md,
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.75,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thanh kéo nhỏ
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

                  // Tiêu đề
                  const Text(
                    'Chọn địa điểm nhận xe',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Danh sách trạm xe đồng bộ từ hệ thống E-Motion',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Tab chọn thành phố: Hà Nội vs Hồ Chí Minh (Đồng bộ BE)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: currentTab == 'Hà Nội'
                                ? const Color(0xFF1976D2).withValues(alpha: 0.1)
                                : Colors.transparent,
                            side: BorderSide(
                              color: currentTab == 'Hà Nội'
                                  ? const Color(0xFF1976D2)
                                  : Colors.grey.shade300,
                              width: currentTab == 'Hà Nội' ? 2 : 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            setModalState(() {
                              currentTab = 'Hà Nội';
                            });
                          },
                          child: Text(
                            '🏙️ Hà Nội',
                            style: TextStyle(
                              color: currentTab == 'Hà Nội'
                                  ? const Color(0xFF1976D2)
                                  : Colors.grey.shade700,
                              fontWeight: currentTab == 'Hà Nội'
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: currentTab == 'Hồ Chí Minh'
                                ? const Color(0xFF1976D2).withValues(alpha: 0.1)
                                : Colors.transparent,
                            side: BorderSide(
                              color: currentTab == 'Hồ Chí Minh'
                                  ? const Color(0xFF1976D2)
                                  : Colors.grey.shade300,
                              width: currentTab == 'Hồ Chí Minh' ? 2 : 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            setModalState(() {
                              currentTab = 'Hồ Chí Minh';
                            });
                          },
                          child: Text(
                            '🌆 Hồ Chí Minh',
                            style: TextStyle(
                              color: currentTab == 'Hồ Chí Minh'
                                  ? const Color(0xFF1976D2)
                                  : Colors.grey.shade700,
                              fontWeight: currentTab == 'Hồ Chí Minh'
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Danh sách trạm lấy từ Backend qua Riverpod
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, _) {
                        final stationsAsync = ref.watch(
                          stationsByCityProvider(currentTab),
                        );

                        return stationsAsync.when(
                          loading: () => const Center(
                            child: Padding(
                              padding: EdgeInsets.all(AppSpacing.lg),
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          ),
                          error: (_, _) => _buildStationListView(
                            currentTab: currentTab,
                            stations: fallbackStations[currentTab] ?? const [],
                            onSelect: (station) {
                              setState(() {
                                _selectedCityName = currentTab;
                                _selectedCityCode = currentTab == 'Hà Nội'
                                    ? 'HANOI'
                                    : 'TP_HCM';
                                _selectedStationId = station?.id;
                                _selectedStationName =
                                    station?.name ?? 'Tất cả các trạm';
                              });
                              Navigator.pop(ctx);
                            },
                          ),
                          data: (stations) {
                            final list = stations.isNotEmpty
                                ? stations
                                : (fallbackStations[currentTab] ?? const []);
                            return _buildStationListView(
                              currentTab: currentTab,
                              stations: list,
                              onSelect: (station) {
                                setState(() {
                                  _selectedCityName = currentTab;
                                  _selectedCityCode = currentTab == 'Hà Nội'
                                      ? 'HANOI'
                                      : 'TP_HCM';
                                  _selectedStationId = station?.id;
                                  _selectedStationName =
                                      station?.name ?? 'Tất cả các trạm';
                                });
                                Navigator.pop(ctx);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStationListView({
    required String currentTab,
    required List<StationEntity> stations,
    required void Function(StationEntity? station) onSelect,
  }) {
    final allItems = <StationEntity?>[null, ...stations];

    return ListView.separated(
      itemCount: allItems.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final station = allItems[index];
        final isAll = station == null;
        final isSelected =
            _selectedCityName == currentTab &&
            (isAll
                ? _selectedStationId == null
                : _selectedStationId == station.id);

        final title = isAll ? 'Tất cả các trạm tại $currentTab' : station.name;
        final subtitle = !isAll && station.address.isNotEmpty
            ? station.address
            : null;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 2,
          ),
          leading: Icon(
            isAll ? Icons.location_city_rounded : Icons.ev_station_rounded,
            color: isSelected ? const Color(0xFF1976D2) : Colors.grey.shade600,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? const Color(0xFF1976D2) : null,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                )
              : null,
          trailing: isSelected
              ? const Icon(Icons.check_circle_rounded, color: Color(0xFF1976D2))
              : null,
          onTap: () => onSelect(station),
        );
      },
    );
  }

  Future<void> _openDateTimePicker() async {
    final theme = Theme.of(context);
    final now = DateTime.now();

    var tempStartDate = _startDate;
    var tempEndDate = _endDate;
    var tempStartTime = _startTime;
    var tempEndTime = _endTime;
    var tempHourPackage = _selectedHourPackage;

    // Quy định BE: Bắt đầu thuê phải sau thời điểm hiện tại ít nhất 3 giờ (VEHICLE_TIME_MUST_AFTER_NOW_3HOURS)
    final earliestHourToday = now.minute > 0 ? now.hour + 4 : now.hour + 3;
    final canBookToday = earliestHourToday <= 20;

    const allOperatingHours = [
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
    ];

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isTodaySelected =
                tempStartDate.year == now.year &&
                tempStartDate.month == now.month &&
                tempStartDate.day == now.day;

            final availableHours = isTodaySelected
                ? allOperatingHours
                      .where((h) => h >= earliestHourToday)
                      .toList()
                : allOperatingHours;

            void updatePackage(int hours) {
              setModalState(() {
                tempHourPackage = hours;
                if (hours < 24) {
                  tempEndDate = tempStartDate;
                  final endHour = tempStartTime.hour + hours;
                  if (endHour <= 23) {
                    tempEndTime = TimeOfDay(hour: endHour, minute: 0);
                  } else {
                    tempEndDate = tempStartDate.add(const Duration(days: 1));
                    tempEndTime = TimeOfDay(hour: endHour - 24, minute: 0);
                  }
                } else {
                  tempEndDate = tempStartDate.add(const Duration(days: 1));
                  tempEndTime = tempStartTime;
                }
              });
            }

            final isSameDay =
                tempStartDate.year == tempEndDate.year &&
                tempStartDate.month == tempEndDate.month &&
                tempStartDate.day == tempEndDate.day;

            return Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.88,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thanh kéo nhỏ
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

                    // Tiêu đề
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Thời gian thuê xe',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 14,
                          color: Color(0xFF1976D2),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Tối thiểu 4 giờ • Bắt đầu sau ít nhất 3 giờ so với hiện tại',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // 1. Chọn gói thuê nhanh (4h, 8h, 12h, 24h, Tùy chỉnh)
                    const Text(
                      'Gói thời gian thuê:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _PackageChip(
                          label: '⚡ 4 Giờ',
                          subtitle: 'Tối thiểu',
                          isSelected: tempHourPackage == 4,
                          onTap: () => updatePackage(4),
                        ),
                        _PackageChip(
                          label: '⚡ 8 Giờ',
                          subtitle: 'Bán ngày',
                          isSelected: tempHourPackage == 8,
                          onTap: () => updatePackage(8),
                        ),
                        _PackageChip(
                          label: '⚡ 12 Giờ',
                          subtitle: 'Trong ngày',
                          isSelected: tempHourPackage == 12,
                          onTap: () => updatePackage(12),
                        ),
                        _PackageChip(
                          label: '📅 1 Ngày',
                          subtitle: '24 giờ',
                          isSelected: tempHourPackage == 24,
                          onTap: () => updatePackage(24),
                        ),
                        _PackageChip(
                          label: '🗓️ Tùy chỉnh',
                          subtitle: 'Tối đa 30 ngày',
                          isSelected: tempHourPackage == null,
                          onTap: () async {
                            final range = await showDateRangePicker(
                              context: context,
                              firstDate: now,
                              lastDate: now.add(
                                const Duration(days: 30),
                              ), // BE giới hạn 1 tháng
                              initialDateRange: DateTimeRange(
                                start: tempStartDate,
                                end: tempEndDate,
                              ),
                            );
                            if (range != null) {
                              setModalState(() {
                                tempHourPackage = null;
                                tempStartDate = range.start;
                                tempEndDate = range.end;
                                // Đảm bảo tối thiểu 4 giờ nếu cùng ngày
                                if (tempStartDate.year == tempEndDate.year &&
                                    tempStartDate.month == tempEndDate.month &&
                                    tempStartDate.day == tempEndDate.day) {
                                  if (tempEndTime.hour <
                                      tempStartTime.hour + 4) {
                                    final newEndHour = tempStartTime.hour + 4;
                                    if (newEndHour <= 23) {
                                      tempEndTime = TimeOfDay(
                                        hour: newEndHour,
                                        minute: 0,
                                      );
                                    } else {
                                      tempEndDate = tempStartDate.add(
                                        const Duration(days: 1),
                                      );
                                      tempEndTime = TimeOfDay(
                                        hour: newEndHour - 24,
                                        minute: 0,
                                      );
                                    }
                                  }
                                }
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // 2. Chọn ngày nhận xe
                    const Text(
                      'Ngày nhận xe:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (canBookToday) ...[
                            _DateButton(
                              title: 'Hôm nay',
                              date: now,
                              isSelected: isTodaySelected,
                              onTap: () {
                                setModalState(() {
                                  tempStartDate = now;
                                  if (tempStartTime.hour < earliestHourToday) {
                                    tempStartTime = TimeOfDay(
                                      hour: earliestHourToday,
                                      minute: 0,
                                    );
                                  }
                                  if (tempHourPackage != null) {
                                    updatePackage(tempHourPackage!);
                                  }
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                          ],
                          _DateButton(
                            title: 'Ngày mai',
                            date: now.add(const Duration(days: 1)),
                            isSelected:
                                tempStartDate.year == now.year &&
                                tempStartDate.month == now.month &&
                                tempStartDate.day == now.day + 1,
                            onTap: () {
                              setModalState(() {
                                tempStartDate = now.add(
                                  const Duration(days: 1),
                                );
                                if (tempHourPackage != null) {
                                  updatePackage(tempHourPackage!);
                                }
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          _DateButton(
                            title: 'Ngày kia',
                            date: now.add(const Duration(days: 2)),
                            isSelected:
                                tempStartDate.year == now.year &&
                                tempStartDate.month == now.month &&
                                tempStartDate.day == now.day + 2,
                            onTap: () {
                              setModalState(() {
                                tempStartDate = now.add(
                                  const Duration(days: 2),
                                );
                                if (tempHourPackage != null) {
                                  updatePackage(tempHourPackage!);
                                }
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          ActionChip(
                            avatar: const Icon(
                              Icons.calendar_month_rounded,
                              size: 16,
                            ),
                            label: const Text('Chọn ngày khác'),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: tempStartDate,
                                firstDate: now,
                                lastDate: now.add(const Duration(days: 30)),
                              );
                              if (picked != null) {
                                setModalState(() {
                                  tempStartDate = picked;
                                  if (tempHourPackage != null) {
                                    updatePackage(tempHourPackage!);
                                  }
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // 3. Chọn giờ nhận xe
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Giờ nhận xe (chẵn giờ):',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isTodaySelected)
                          Text(
                            'Sớm nhất: ${_pad(earliestHourToday)}:00',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF1976D2),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    if (availableHours.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Hôm nay không còn khung giờ hợp lệ (phải đặt trước ít nhất 3 giờ). Vui lòng chọn Ngày mai.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red.shade700,
                          ),
                        ),
                      )
                    else
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: availableHours.map((h) {
                            final isSelected = tempStartTime.hour == h;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text('${_pad(h)}:00'),
                                selected: isSelected,
                                onSelected: (_) {
                                  setModalState(() {
                                    tempStartTime = TimeOfDay(
                                      hour: h,
                                      minute: 0,
                                    );
                                    if (tempHourPackage != null) {
                                      updatePackage(tempHourPackage!);
                                    }
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.md),

                    // 4. Hộp tóm tắt lịch trình
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1976D2).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF1976D2).withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_filled_rounded,
                                size: 16,
                                color: Color(0xFF1976D2),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isSameDay
                                    ? 'Thuê trong ngày: ${_pad(tempStartDate.day)}/${_pad(tempStartDate.month)}/${tempStartDate.year}'
                                    : 'Thuê từ ${_pad(tempStartDate.day)}/${_pad(tempStartDate.month)} đến ${_pad(tempEndDate.day)}/${_pad(tempEndDate.month)}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1976D2),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nhận xe',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    '${_pad(tempStartTime.hour)}:00',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.grey,
                                size: 18,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Trả xe',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    '${_pad(tempEndTime.hour)}:00${!isSameDay ? " (+${tempEndDate.difference(tempStartDate).inDays}d)" : ""}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Nút xác nhận
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _startDate = tempStartDate;
                            _endDate = tempEndDate;
                            _startTime = tempStartTime;
                            _endTime = tempEndTime;
                            _selectedHourPackage = tempHourPackage;
                          });
                          Navigator.pop(ctx);
                        },
                        child: const Text(
                          'ÁP DỤNG THỜI GIAN',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _onSearchPressed() {
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

    context.goNamed(
      AppRoute.mapSearch.name,
      queryParameters: {
        'city': _selectedCityCode,
        if (_selectedStationId != null)
          'stationId': _selectedStationId.toString(),
        'location': _selectedLocationText,
        'start': startDateTime.toIso8601String(),
        'end': endDateTime.toIso8601String(),
        'type': _selectedRentalType.toString(),
        if (_selectedHourPackage != null)
          'package': _selectedHourPackage.toString(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
            // Lớp phủ Gradient đen mờ để chữ trắng luôn nổi bật
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
                // Tag "Trải nghiệm tương lai xanh"
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1976D2),
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
                // Tiêu đề lớn
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

        // 2. Hộp tìm kiếm nổi (Search Card)
        Padding(
          padding: const EdgeInsets.only(
            top: 150,
            left: AppSpacing.md,
            right: AppSpacing.md,
          ),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bộ chuyển đổi: Thuê theo gói / Thuê theo tháng
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _TabButton(
                          title: 'Thuê theo gói',
                          icon: Icons.public_rounded,
                          isSelected: _selectedRentalType == 0,
                          onTap: () {
                            setState(() {
                              _selectedRentalType = 0;
                              _selectedHourPackage = 4;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: _TabButton(
                          title: 'Thuê theo tháng',
                          icon: Icons.calendar_month_rounded,
                          isSelected: _selectedRentalType == 1,
                          onTap: () {
                            setState(() {
                              _selectedRentalType = 1;
                              _selectedHourPackage = null;
                              // BE quy định tối đa 30 ngày (1 tháng)
                              _endDate = _startDate.add(
                                const Duration(days: 30),
                              );
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Ô chọn địa điểm nhận xe
                _SearchFieldItem(
                  icon: Icons.near_me_rounded,
                  iconColor: const Color(0xFF1976D2),
                  label: 'Địa điểm nhận xe',
                  value: _selectedLocationText,
                  trailingIcon: Icons.keyboard_arrow_down_rounded,
                  onTap: _openLocationPicker,
                ),
                const SizedBox(height: AppSpacing.sm),

                // Ô chọn thời gian nhận - trả
                _SearchFieldItem(
                  icon: Icons.access_time_rounded,
                  iconColor: const Color(0xFF1976D2),
                  label: 'Thời gian nhận - trả (Tối thiểu 4 giờ)',
                  value: _selectedTimeText,
                  trailingIcon: Icons.calendar_today_rounded,
                  onTap: _openDateTimePicker,
                ),
                const SizedBox(height: AppSpacing.md),

                // Nút "TÌM XE NGAY"
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _onSearchPressed,
                    icon: const Icon(Icons.search_rounded, size: 20),
                    label: const Text(
                      'TÌM XE NGAY',
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

class _PackageChip extends StatelessWidget {
  const _PackageChip({
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1976D2) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF1976D2) : Colors.grey.shade300,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white70 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({
    required this.title,
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: isSelected,
      onSelected: (_) => onTap(),
      label: Text(
        '$title (${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')})',
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1976D2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchFieldItem extends StatelessWidget {
  const _SearchFieldItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.trailingIcon,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final IconData trailingIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs + 2,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            // Icon tròn nền xanh nhạt
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: AppSpacing.sm),
            // Tiêu đề & Nội dung
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(trailingIcon, size: 20, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }
}
