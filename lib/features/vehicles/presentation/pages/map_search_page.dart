import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:rental_car/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:rental_car/features/vehicles/presentation/widgets/rental_time_bottom_sheet.dart';
import 'package:rental_car/features/vehicles/presentation/widgets/vehicle_filter_bottom_sheet.dart';
import 'package:rental_car/features/vehicles/presentation/widgets/vehicle_list_card.dart';
import 'package:rental_car/features/vehicles/presentation/widgets/vehicle_search_header.dart';

/// Flow 2: Màn hình Tìm kiếm & Danh sách xe (Slide 08 - Danh sách tìm kiếm xe)
class MapSearchPage extends ConsumerStatefulWidget {
  const MapSearchPage({super.key});

  @override
  ConsumerState<MapSearchPage> createState() => _MapSearchPageState();
}

class _MapSearchPageState extends ConsumerState<MapSearchPage> {
  ScrollController? _scrollController;

  ScrollController get _effectiveScrollController =>
      _scrollController ??= ScrollController()..addListener(_onScroll);

  @override
  void initState() {
    super.initState();
    _effectiveScrollController;
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  void _onScroll() {
    final controller = _scrollController;
    if (controller != null && controller.hasClients) {
      if (controller.position.pixels >=
          controller.position.maxScrollExtent - 200) {
        ref.read(paginatedVehicleListControllerProvider.notifier).loadMore();
      }
    }
  }

  Future<void> _openFilterModal() async {
    final currentFilter = ref.read(vehicleFilterProvider);
    final selectedFilter = await VehicleFilterBottomSheet.show(
      context,
      initialFilter: currentFilter,
    );
    if (selectedFilter != null) {
      ref.read(vehicleFilterProvider.notifier).updateFilter(selectedFilter);
    }
  }

  Future<void> _openRentalTimeModal() async {
    final current = ref.read(vehicleFilterProvider);
    final result = await RentalTimeBottomSheet.show(
      context,
      initialStartTime: current.startTime,
      initialEndTime: current.endTime,
      initialHourPackage: current.hourPackage,
    );
    if (result != null) {
      ref
          .read(vehicleFilterProvider.notifier)
          .updateFilter(
            current.copyWith(
              startTime: result['startTime'] as DateTime?,
              endTime: result['endTime'] as DateTime?,
              hourPackage: result['hourPackage'] as int?,
            ),
          );
    }
  }

  void _onVehicleSelected(VehicleEntity vehicle) {
    context.pushNamed(
      AppRoute.vehicleDetail.name,
      pathParameters: {'id': vehicle.stringId},
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentFilter = ref.watch(vehicleFilterProvider);
    final paginatedState = ref.watch(paginatedVehicleListControllerProvider);

    int activeFilterCount = 0;
    if (currentFilter.city != null &&
        currentFilter.city!.isNotEmpty &&
        !currentFilter.city!.contains('Hà Nội')) {
      activeFilterCount++;
    }
    if (currentFilter.seats != 'Tất cả') activeFilterCount++;
    if (currentFilter.brand != 'Tất cả' && currentFilter.brand.isNotEmpty) {
      activeFilterCount++;
    }
    if (currentFilter.carType != 'Tất cả') activeFilterCount++;
    if (currentFilter.priceRange != 'Tất cả') activeFilterCount++;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // 1. THANH TÌM KIẾM TRÊN CÙNG: Ô tìm kiếm + Nút Lọc + Thanh chọn Ngày & Giờ thuê
          VehicleSearchHeader(
            onBack: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.goNamed(AppRoute.home.name);
              }
            },
            onOpenFilter: _openFilterModal,
            initialSearchText: currentFilter.search,
            onSearchChanged: (query) {
              final current = ref.read(vehicleFilterProvider);
              ref
                  .read(vehicleFilterProvider.notifier)
                  .updateFilter(
                    current.copyWith(
                      search: query,
                      clearSearch: query.trim().isEmpty,
                    ),
                  );
            },
            dateTimeRangeText: currentFilter.formattedTimeRange,
            durationLabel: currentFilter.durationUnitLabel,
            onTapTime: _openRentalTimeModal,
            activeFilterCount: activeFilterCount,
          ),

          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // 2. DANH SÁCH THẺ XE có hỗ trợ phân trang & infinite scrolling
          Expanded(
            child: Builder(
              builder: (context) {
                if (paginatedState.isLoading &&
                    paginatedState.vehicles.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (paginatedState.errorMessage != null &&
                    paginatedState.vehicles.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await ref
                          .read(paginatedVehicleListControllerProvider.notifier)
                          .loadInitial(currentFilter);
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.65,
                        padding: const EdgeInsets.all(24),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.wifi_off_rounded,
                              size: 48,
                              color: Color(0xFFEF4444),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Không thể kết nối tới máy chủ E-Motion',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              paginatedState.errorMessage ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 14),
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF1976D2),
                              ),
                              onPressed: () {
                                ref
                                    .read(
                                      paginatedVehicleListControllerProvider
                                          .notifier,
                                    )
                                    .loadInitial(currentFilter);
                              },
                              icon: const Icon(Icons.refresh, size: 18),
                              label: const Text('Thử lại'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                if (paginatedState.vehicles.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await ref
                          .read(paginatedVehicleListControllerProvider.notifier)
                          .loadInitial(currentFilter);
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.65,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.car_crash_outlined,
                              size: 64,
                              color: Color(0xFF94A3B8),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Không có xe nào khả dụng theo bộ lọc',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(vehicleFilterProvider.notifier)
                                    .reset();
                              },
                              child: const Text('Đặt lại bộ lọc'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref
                        .read(paginatedVehicleListControllerProvider.notifier)
                        .loadInitial(currentFilter);
                  },
                  child: ListView.builder(
                    controller: _effectiveScrollController,
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    itemCount:
                        paginatedState.vehicles.length +
                        (paginatedState.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == paginatedState.vehicles.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                              ),
                            ),
                          ),
                        );
                      }
                      final vehicle = paginatedState.vehicles[index];
                      return VehicleListCard(
                        item: vehicle,
                        targetHours: currentFilter.durationHours,
                        targetUnit: currentFilter.durationUnitLabel,
                        onTap: () => _onVehicleSelected(vehicle),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
