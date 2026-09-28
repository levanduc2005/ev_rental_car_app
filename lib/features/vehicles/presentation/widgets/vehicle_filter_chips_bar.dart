import 'package:flutter/material.dart';

/// Thanh cuộn ngang các chip bộ lọc nhanh (Slide 08)
class VehicleFilterChipsBar extends StatelessWidget {
  const VehicleFilterChipsBar({
    required this.selectedFilterIndex,
    required this.onFilterSelected,
    required this.onOpenFilterSheet,
    super.key,
  });

  final int selectedFilterIndex;
  final ValueChanged<int> onFilterSelected;
  final VoidCallback onOpenFilterSheet;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            // Chip 1: "Tất cả" (Nền xanh khi chọn)
            _buildSelectableChip(
              index: 0,
              label: 'Tất cả',
              isSelected: selectedFilterIndex == 0,
            ),
            const SizedBox(width: 8),

            // Chip 2: "⚡ Sale -12%"
            _buildSpecialChip(
              index: 1,
              icon: Icons.bolt_rounded,
              iconColor: const Color(0xFFF59E0B), // Vàng cam
              label: 'Sale -12%',
              isSelected: selectedFilterIndex == 1,
            ),
            const SizedBox(width: 8),

            // Chip 3: "🔑 Hình thức thuê ▼"
            _buildDropdownChip(
              label: 'Hình thức thuê',
              icon: Icons.key_rounded,
              iconColor: const Color(0xFF10B981), // Xanh lá
              onTap: onOpenFilterSheet,
            ),
            const SizedBox(width: 8),

            // Chip 4: "Hãng xe ▼"
            _buildDropdownChip(label: 'Hãng xe', onTap: onOpenFilterSheet),
            const SizedBox(width: 8),

            // Chip 5: "Số chỗ ▼"
            _buildDropdownChip(label: 'Số chỗ', onTap: onOpenFilterSheet),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectableChip({
    required int index,
    required String label,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => onFilterSelected(index),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1976D2) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1976D2)
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF334155),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialChip({
    required int index,
    required IconData icon,
    required Color iconColor,
    required String label,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => onFilterSelected(index),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1976D2) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1976D2)
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : iconColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownChip({
    required String label,
    required VoidCallback onTap,
    IconData? icon,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 15, color: iconColor ?? const Color(0xFF64748B)),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: Color(0xFF64748B),
            ),
          ],
        ),
      ),
    );
  }
}
