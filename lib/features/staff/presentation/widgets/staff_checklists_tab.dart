import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_providers.dart';
import 'package:rental_car/features/staff/presentation/widgets/staff_checklist_card.dart';

class StaffChecklistsTab extends ConsumerWidget {
  const StaffChecklistsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(staffDashboardControllerProvider);
    final controller = ref.read(staffDashboardControllerProvider.notifier);
    final currentType = state.checklistFilterType ?? 'ALL';

    return RefreshIndicator(
      onRefresh: () =>
          controller.fetchChecklists(type: state.checklistFilterType),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Filter chips
            Row(
              children: [
                _buildFilterChip(
                  label: 'Tất cả (${state.checklists.length})',
                  isSelected: currentType == 'ALL',
                  onSelected: () => controller.fetchChecklists(type: 'ALL'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Nhận xe (In)',
                  isSelected: currentType == 'CHECK_IN',
                  onSelected: () =>
                      controller.fetchChecklists(type: 'CHECK_IN'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Trả xe (Out)',
                  isSelected: currentType == 'CHECK_OUT',
                  onSelected: () =>
                      controller.fetchChecklists(type: 'CHECK_OUT'),
                ),
              ],
            ),
            const SizedBox(height: 14),

            if (state.isLoadingChecklists)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.checklists.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                child: const Column(
                  children: [
                    Icon(Icons.checklist_rtl, size: 48, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'Chưa có biên bản bàn giao xe nào',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...state.checklists.map((c) => StaffChecklistCard(checklist: c)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
      ),
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFFEFF6FF),
      checkmarkColor: const Color(0xFF2563EB),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
        ),
      ),
      onSelected: (_) => onSelected(),
    );
  }
}
