import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:rental_car/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:rental_car/features/vehicles/presentation/widgets/vehicle_filter_bottom_sheet.dart';
import 'package:rental_car/features/vehicles/presentation/widgets/vehicle_filter_chips_bar.dart';
import 'package:rental_car/features/vehicles/presentation/widgets/vehicle_list_card.dart';
import 'package:rental_car/features/vehicles/presentation/widgets/vehicle_search_header.dart';

/// Flow 2: Màn hình Tìm kiếm & Danh sách xe (Slide 08 - Danh sách tìm kiếm xe)
class MapSearchPage extends ConsumerStatefulWidget {
  const MapSearchPage({super.key});

  @override
  ConsumerState<MapSearchPage> createState() => _MapSearchPageState();
}

class _MapSearchPageState extends ConsumerState<MapSearchPage> {
  int _selectedFilterIndex = 0;

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

  void _onVehicleSelected(VehicleEntity vehicle) {
    context.pushNamed(
      AppRoute.vehicleDetail.name,
      pathParameters: {'id': vehicle.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehicleListAsync = ref.watch(vehicleListControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // 1. THANH TÌM KIẾM TRÊN CÙNG (Slide 08)
          VehicleSearchHeader(
            onBack: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.goNamed(AppRoute.home.name);
              }
            },
            onOpenFilter: _openFilterModal,
            locationText: 'VRG2+57M, Lưu Hữu Phước, Thủ Đức...',
            dateTimeRangeText: '14:00, 17/09 đến 18:00, 19/09',
            onTapSearchBox: () {},
          ),

          // 2. THANH BỘ LỌC CUỘN NGANG (Slide 08)
          VehicleFilterChipsBar(
            selectedFilterIndex: _selectedFilterIndex,
            onFilterSelected: (index) {
              setState(() {
                _selectedFilterIndex = index;
              });
            },
            onOpenFilterSheet: _openFilterModal,
          ),

          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // 3. DANH SÁCH THẺ XE (Slide 08) kết nối trực tiếp API Backend qua Riverpod
          Expanded(
            child: vehicleListAsync.when(
              data: (vehicles) {
                if (vehicles.isEmpty) {
                  return Center(
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
                            ref.read(vehicleFilterProvider.notifier).reset();
                          },
                          child: const Text('Đặt lại bộ lọc'),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                  physics: const BouncingScrollPhysics(),
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehicles[index];
                    return VehicleListCard(
                      item: vehicle,
                      onTap: () => _onVehicleSelected(vehicle),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
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
                        'Vui lòng đảm bảo backend đang chạy tại port 8080.',
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
                          ref.invalidate(vehicleListControllerProvider);
                        },
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
