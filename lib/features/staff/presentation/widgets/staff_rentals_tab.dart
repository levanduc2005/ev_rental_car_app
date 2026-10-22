import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/staff/presentation/pages/staff_select_vehicle_page.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_dashboard_controller.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_providers.dart';
import 'package:rental_car/features/staff/presentation/widgets/staff_rental_card.dart';
import 'package:rental_car/features/staff/presentation/widgets/staff_station_header_card.dart';

class StaffRentalsTab extends ConsumerWidget {
  const StaffRentalsTab({
    super.key,
    required this.onOpenDetail,
    required this.onContinueRental,
  });

  final void Function(RentalDetailEntity rental) onOpenDetail;
  final void Function(RentalDetailEntity rental) onContinueRental;

  Future<void> _showCreateRentalEmailDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final emailController = TextEditingController();
    String? errorMessage;
    bool isLoading = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> handleLookup() async {
              final email = emailController.text.trim();
              if (email.isEmpty) {
                setDialogState(() {
                  errorMessage = 'Vui lòng nhập địa chỉ email của khách hàng.';
                });
                return;
              }

              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(email)) {
                setDialogState(() {
                  errorMessage = 'Địa chỉ email không đúng định dạng.';
                });
                return;
              }

              setDialogState(() {
                isLoading = true;
                errorMessage = null;
              });

              final getRenterByEmail = ref.read(
                getRenterByEmailUseCaseProvider,
              );
              final result = await getRenterByEmail(email);

              result.when(
                ok: (renter) {
                  if (renter.blocked) {
                    setDialogState(() {
                      isLoading = false;
                      errorMessage =
                          'Tài khoản khách hàng này đang bị khóa, không thể tạo đơn thuê.';
                    });
                    return;
                  }

                  Navigator.of(dialogContext).pop();

                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => StaffSelectVehiclePage(renter: renter),
                    ),
                  );
                },
                err: (failure) {
                  setDialogState(() {
                    isLoading = false;
                    errorMessage = failure.message.isNotEmpty
                        ? failure.message
                        : 'Không tìm thấy thông tin khách hàng với email này.';
                  });
                },
              );
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Row(
                children: [
                  Icon(
                    Icons.person_add_alt_1,
                    color: AppColors.primary,
                    size: 22,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Tạo đơn thuê tại trạm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nhập địa chỉ email tài khoản khách hàng để bắt đầu tạo hợp đồng thuê xe tại trạm:',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: true,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        labelText: 'Email khách hàng',
                        hintText: 'vidu@gmail.com',
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          size: 20,
                          color: Color(0xFF64748B),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFCBD5E1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFCBD5E1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                      onSubmitted: (_) {
                        if (!isLoading) handleLookup();
                      },
                    ),
                    if (errorMessage != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFECACA)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 16,
                              color: Color(0xFFDC2626),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                errorMessage!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFDC2626),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text(
                    'Hủy',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  onPressed: isLoading ? null : handleLookup,
                  child: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Tiếp tục',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(staffDashboardControllerProvider);
    final controller = ref.read(staffDashboardControllerProvider.notifier);

    return RefreshIndicator(
      onRefresh: controller.refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state.staffProfile != null)
              StaffStationHeaderCard(
                profile: state.staffProfile!,
                onRefresh: controller.init,
              ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hợp đồng thuê thực tế (${state.rentals.length})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text(
                    'Tạo đơn thuê',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => _showCreateRentalEmailDialog(context, ref),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildRentalsList(state),
          ],
        ),
      ),
    );
  }

  Widget _buildRentalsList(StaffDashboardState state) {
    if (state.rentals.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: const Column(
          children: [
            Icon(Icons.car_rental, size: 48, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              'Chưa có đơn thuê nào đang diễn ra tại trạm',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Column(
      children: state.rentals
          .map(
            (rental) => StaffRentalCard(
              rental: rental,
              onTapDetail: () => onOpenDetail(rental),
              onTapAction: () => onContinueRental(rental),
            ),
          )
          .toList(),
    );
  }
}
