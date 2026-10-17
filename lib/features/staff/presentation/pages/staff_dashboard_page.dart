import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/profile/presentation/pages/rental_detail_page.dart';
import 'package:rental_car/features/staff/presentation/pages/staff_handover_page.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_dashboard_controller.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_providers.dart';
import 'package:rental_car/features/staff/presentation/widgets/staff_checklists_tab.dart';
import 'package:rental_car/features/staff/presentation/widgets/staff_rentals_tab.dart';
import 'package:rental_car/features/staff/presentation/widgets/staff_reservations_tab.dart';
import 'package:rental_car/features/staff/presentation/widgets/staff_scanner_view.dart';
import 'package:rental_car/features/staff/presentation/widgets/staff_vehicles_tab.dart';

class StaffDashboardPage extends ConsumerStatefulWidget {
  const StaffDashboardPage({super.key});

  @override
  ConsumerState<StaffDashboardPage> createState() => _StaffDashboardPageState();
}

class _StaffDashboardPageState extends ConsumerState<StaffDashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(staffDashboardControllerProvider.notifier).init();
    });
  }

  void _onStartHandoverReservation(ReservationEntity reservation) {
    ref
        .read(staffHandoverControllerProvider.notifier)
        .setup(reservation: reservation);

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StaffHandoverPage(reservation: reservation),
      ),
    );
  }

  void _onContinueRental(RentalDetailEntity rental) {
    ref.read(staffHandoverControllerProvider.notifier).setup(rental: rental);

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StaffHandoverPage(rental: rental),
      ),
    );
  }

  void _onOpenRentalDetail(RentalDetailEntity rental) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RentalDetailPage(rentalId: rental.id),
      ),
    );
  }

  int _tabToIndex(StaffBottomTab tab) {
    switch (tab) {
      case StaffBottomTab.reservations:
        return 0;
      case StaffBottomTab.rentals:
        return 1;
      case StaffBottomTab.scanner:
        return 2;
      case StaffBottomTab.checklists:
        return 3;
      case StaffBottomTab.vehicles:
        return 4;
    }
  }

  StaffBottomTab _indexToTab(int index) {
    switch (index) {
      case 0:
        return StaffBottomTab.reservations;
      case 1:
        return StaffBottomTab.rentals;
      case 2:
        return StaffBottomTab.scanner;
      case 3:
        return StaffBottomTab.checklists;
      case 4:
        return StaffBottomTab.vehicles;
      default:
        return StaffBottomTab.reservations;
    }
  }

  String _getAppBarTitle(StaffBottomTab tab) {
    switch (tab) {
      case StaffBottomTab.reservations:
        return 'Đơn đặt trước tại trạm';
      case StaffBottomTab.rentals:
        return 'Đơn thuê xe tại trạm';
      case StaffBottomTab.scanner:
        return 'Quét mã & Chụp ảnh';
      case StaffBottomTab.checklists:
        return 'Biên bản nhận - trả xe';
      case StaffBottomTab.vehicles:
        return 'Danh sách xe tại trạm';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffDashboardControllerProvider);
    final controller = ref.read(staffDashboardControllerProvider.notifier);
    final currentTabIndex = _tabToIndex(state.selectedTab);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          _getAppBarTitle(state.selectedTab),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 20, color: Color(0xFF64748B)),
            tooltip: 'Làm mới',
            onPressed: controller.refreshData,
          ),
          IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              size: 20,
              color: Color(0xFFEF4444),
            ),
            tooltip: 'Đăng xuất',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Đăng xuất'),
                  content: const Text(
                    'Bạn có chắc chắn muốn đăng xuất tài khoản nhân viên?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Hủy'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Đăng xuất'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await ref.read(authControllerProvider.notifier).logout();
              }
            },
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text(
                    'Đang tải thông tin trạm trực & dữ liệu...',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : IndexedStack(
              index: currentTabIndex,
              children: [
                StaffReservationsTab(
                  onStartHandover: _onStartHandoverReservation,
                ),
                StaffRentalsTab(
                  onOpenDetail: _onOpenRentalDetail,
                  onContinueRental: _onContinueRental,
                ),
                StaffScannerView(onStartHandover: _onStartHandoverReservation),
                const StaffChecklistsTab(),
                const StaffVehiclesTab(),
              ],
            ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          height: 64,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFEFF6FF),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final isSelected = states.contains(WidgetState.selected);
            return TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF2563EB)
                  : const Color(0xFF64748B),
              overflow: TextOverflow.ellipsis,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final isSelected = states.contains(WidgetState.selected);
            return IconThemeData(
              size: 22,
              color: isSelected
                  ? const Color(0xFF2563EB)
                  : const Color(0xFF64748B),
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: currentTabIndex,
          onDestinationSelected: (index) {
            controller.switchTab(_indexToTab(index));
          },
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: Badge(
                isLabelVisible: state.reservations.isNotEmpty,
                label: Text('${state.reservations.length}'),
                child: const Icon(Icons.event_note_outlined),
              ),
              selectedIcon: Badge(
                isLabelVisible: state.reservations.isNotEmpty,
                label: Text('${state.reservations.length}'),
                child: const Icon(Icons.event_note),
              ),
              label: 'Đặt trước',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: state.rentals.isNotEmpty,
                label: Text('${state.rentals.length}'),
                child: const Icon(Icons.assignment_outlined),
              ),
              selectedIcon: Badge(
                isLabelVisible: state.rentals.isNotEmpty,
                label: Text('${state.rentals.length}'),
                child: const Icon(Icons.assignment),
              ),
              label: 'Đơn thuê',
            ),
            const NavigationDestination(
              icon: Icon(Icons.qr_code_scanner_outlined),
              selectedIcon: Icon(Icons.qr_code_scanner),
              label: 'Quét mã',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: state.checklists.isNotEmpty,
                label: Text('${state.checklists.length}'),
                child: const Icon(Icons.fact_check_outlined),
              ),
              selectedIcon: Badge(
                isLabelVisible: state.checklists.isNotEmpty,
                label: Text('${state.checklists.length}'),
                child: const Icon(Icons.fact_check),
              ),
              label: 'Biên bản',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: state.vehicles.isNotEmpty,
                label: Text('${state.vehicles.length}'),
                child: const Icon(Icons.directions_car_outlined),
              ),
              selectedIcon: Badge(
                isLabelVisible: state.vehicles.isNotEmpty,
                label: Text('${state.vehicles.length}'),
                child: const Icon(Icons.directions_car),
              ),
              label: 'Xe trạm',
            ),
          ],
        ),
      ),
    );
  }
}
