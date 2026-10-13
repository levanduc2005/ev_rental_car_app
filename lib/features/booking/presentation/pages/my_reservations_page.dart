import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/booking/presentation/providers/my_reservations_controller.dart';
import 'package:rental_car/features/booking/presentation/providers/my_reservations_state.dart';
import 'package:rental_car/features/booking/presentation/widgets/my_reservations/rentals_tab_content.dart';
import 'package:rental_car/features/booking/presentation/widgets/my_reservations/reservations_tab_content.dart';
import 'package:rental_car/features/profile/presentation/providers/profile_providers.dart';

/// Tab 2: Quản lý Đơn đặt trước & Đơn thuê xe e-Motion
class MyReservationsPage extends ConsumerStatefulWidget {
  const MyReservationsPage({super.key});

  @override
  ConsumerState<MyReservationsPage> createState() => _MyReservationsPageState();
}

class _MyReservationsPageState extends ConsumerState<MyReservationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myReservationsControllerProvider.notifier).loadReservations();
      ref.read(rentalHistoryControllerProvider.notifier).loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myReservationsControllerProvider);
    final controller = ref.read(myReservationsControllerProvider.notifier);
    final rentalController = ref.read(rentalHistoryControllerProvider.notifier);

    // Lắng nghe thông báo action (vd: hủy đơn thành công hoặc lỗi)
    ref.listen<MyReservationsState>(myReservationsControllerProvider, (
      previous,
      next,
    ) {
      if (next.actionMessage != null &&
          next.actionMessage != previous?.actionMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.actionMessage!),
            backgroundColor: AppColors.success,
          ),
        );
      }
      if (next.actionErrorMessage != null &&
          next.actionErrorMessage != previous?.actionErrorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.actionErrorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'Lịch sử & Đơn thuê',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'Làm mới',
              icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
              onPressed: () {
                controller.loadReservations();
                rentalController.refresh();
              },
            ),
          ],
          bottom: const TabBar(
            labelColor: Color(0xFF2563EB),
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: Color(0xFF2563EB),
            indicatorWeight: 3,
            labelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(text: 'Đơn đặt trước'),
              Tab(text: 'Đơn thuê xe'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Đơn đặt trước (Reservations)
            ReservationsTabContent(state: state, controller: controller),

            // Tab 2: Đơn thuê xe thực tế (Rentals)
            const RentalsTabContent(),
          ],
        ),
      ),
    );
  }
}
