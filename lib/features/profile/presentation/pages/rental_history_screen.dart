import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/theme/app_text_styles.dart';
import 'package:rental_car/core/widgets/widgets.dart';
import 'package:rental_car/features/profile/domain/entities/rental_item_entity.dart';
import 'package:rental_car/features/profile/presentation/controllers/rental_history_state.dart';
import 'package:rental_car/features/profile/presentation/providers/profile_providers.dart';

class RentalHistoryScreen extends ConsumerWidget {
  const RentalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(rentalHistoryControllerProvider);
    final controller = ref.read(rentalHistoryControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Lịch sử thuê xe'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Quay lại',
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 4 Filter Tabs (Tất cả, Đang thuê, Hoàn thành, Đã hủy)
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: RentalHistoryTab.values.map((tab) {
                    final isSelected = historyState.selectedTab == tab;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: ChoiceChip(
                        label: Text(tab.label),
                        selected: isSelected,
                        selectedColor: AppColors.primary.withValues(
                          alpha: 0.15,
                        ),
                        labelStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                        onSelected: (_) => controller.changeTab(tab),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const Divider(height: 1),

            // Content Area
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.refresh(),
                child: _buildContent(context, ref, historyState),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    RentalHistoryState state,
  ) {
    if (state.isLoading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: AppColors.error,
              ),
              const Gap(AppSpacing.md),
              Text(
                state.errorMessage!,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(color: AppColors.error),
              ),
              const Gap(AppSpacing.md),
              AppButton(
                label: 'Thử lại',
                icon: Icons.refresh_rounded,
                onPressed: () {
                  ref
                      .read(rentalHistoryControllerProvider.notifier)
                      .loadHistory();
                },
              ),
            ],
          ),
        ),
      );
    }

    if (state.items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: EmptyView(
              message:
                  'Không có chuyến đi nào trong mục "${state.selectedTab.label}".',
              icon: Icons.directions_car_outlined,
              actionLabel: 'Thuê xe ngay',
              onAction: () => context.go(AppRoute.home.path),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: state.items.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        return _buildRentalCard(context, state.items[index]);
      },
    );
  }

  Widget _buildRentalCard(BuildContext context, RentalItemEntity item) {
    final dateFormat = DateFormat('HH:mm - dd/MM/yyyy');
    final formattedDate = item.createdAt != null
        ? dateFormat.format(item.createdAt!)
        : 'Chưa cập nhật';

    return AppCard(
      child: InkWell(
        onTap: () => _showRentalDetailSheet(context, item),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: ID + Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.tag_rounded,
                      size: 16,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Mã chuyến: #${item.id}',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                _buildStatusBadge(item.status),
              ],
            ),
            const Divider(height: AppSpacing.md),

            // Vehicle Image + Name
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child:
                      item.vehicleImage != null && item.vehicleImage!.isNotEmpty
                      ? Image.network(
                          item.vehicleImage!,
                          width: 88,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              _buildCarImagePlaceholder(),
                        )
                      : _buildCarImagePlaceholder(),
                ),
                const Gap.h(AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.vehicleName,
                        style: AppTextStyles.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      if (item.stationName != null &&
                          item.stationName!.isNotEmpty)
                        Row(
                          children: [
                            const Icon(
                              Icons.ev_station_rounded,
                              size: 14,
                              color: AppColors.accent,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item.stationName!,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.sm),

            // Time & Meta Container
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    size: 15,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      'Tạo ngày: $formattedDate',
                      style: AppTextStyles.caption,
                    ),
                  ),
                ],
              ),
            ),

            // Payment Url Button (if payment is needed)
            if (item.paymentUrl != null && item.paymentUrl!.isNotEmpty) ...[
              const Gap(AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Thanh toán phí chuyến đi',
                  icon: Icons.payment_rounded,
                  onPressed: () {
                    context.showSnackBar(
                      'Mở liên kết thanh toán: ${item.paymentUrl}',
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCarImagePlaceholder() {
    return Container(
      width: 88,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: const Center(
        child: Icon(
          Icons.directions_car_rounded,
          color: AppColors.primary,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final (label, bgColor, textColor) = switch (status.toUpperCase()) {
      'ONGOING' => (
        'Đang thuê',
        AppColors.primary.withValues(alpha: 0.12),
        AppColors.primary,
      ),
      'CONFIRM' => (
        'Đã xác nhận',
        AppColors.info.withValues(alpha: 0.12),
        AppColors.info,
      ),
      'PENDING_FEE' => (
        'Chờ thanh toán phí',
        const Color(0xFFF59E0B).withValues(alpha: 0.15),
        const Color(0xFFD97706),
      ),
      'OVERDUE' => (
        'Quá hạn',
        AppColors.error.withValues(alpha: 0.15),
        AppColors.error,
      ),
      'COMPLETED' => (
        'Đã hoàn thành',
        AppColors.success.withValues(alpha: 0.12),
        AppColors.success,
      ),
      'CANCELLED' => (
        'Đã hủy',
        const Color(0xFF6B7280).withValues(alpha: 0.15),
        const Color(0xFF4B5563),
      ),
      _ => (status, AppColors.border, AppColors.textSecondary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  void _showRentalDetailSheet(BuildContext context, RentalItemEntity item) {
    final dateFormat = DateFormat('HH:mm - dd/MM/yyyy');
    final formattedDate = item.createdAt != null
        ? dateFormat.format(item.createdAt!)
        : 'Chưa cập nhật';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Gap(AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Chi tiết chuyến thuê',
                      style: AppTextStyles.heading3,
                    ),
                    _buildStatusBadge(item.status),
                  ],
                ),
                const Divider(height: AppSpacing.lg),
                _buildInfoRow('Mã chuyến', '#${item.id}'),
                const Gap(AppSpacing.xs),
                _buildInfoRow('Tên dòng xe', item.vehicleName),
                const Gap(AppSpacing.xs),
                _buildInfoRow(
                  'Trạm giao nhận',
                  item.stationName ?? 'Trạm trung tâm EV',
                ),
                const Gap(AppSpacing.xs),
                _buildInfoRow('Thời gian tạo đơn', formattedDate),
                if (item.paymentUrl != null && item.paymentUrl!.isNotEmpty) ...[
                  const Gap(AppSpacing.md),
                  AppButton(
                    label: 'Thanh toán phí phát sinh',
                    icon: Icons.open_in_new_rounded,
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.showSnackBar(
                        'Đang chuyển tới cổng thanh toán...',
                      );
                    },
                  ),
                ],
                const Gap(AppSpacing.md),
                AppButton(
                  label: 'Đóng',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
