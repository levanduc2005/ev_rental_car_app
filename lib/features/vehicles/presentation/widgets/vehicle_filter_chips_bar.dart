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
            // Chip 1: "Tất cả"
            _ChipItem(
              label: 'Tất cả',
              isSelected: selectedFilterIndex == 0,
              onTap: () => onFilterSelected(0),
            ),
            const SizedBox(width: 8),

            // Chip 2: "⚡ VinFast"
            _ChipItem(
              label: 'VinFast',
              icon: Icons.electric_car_rounded,
              iconColor: const Color(0xFF1976D2),
              isSelected: selectedFilterIndex == 1,
              onTap: () => onFilterSelected(1),
            ),
            const SizedBox(width: 8),

            // Chip 3: "Hãng xe ▼"
            _ChipItem(
              label: 'Hãng xe',
              isDropdown: true,
              onTap: onOpenFilterSheet,
            ),
            const SizedBox(width: 8),

            // Chip 4: "Loại xe ▼"
            _ChipItem(
              label: 'Loại xe',
              isDropdown: true,
              onTap: onOpenFilterSheet,
            ),
            const SizedBox(width: 8),

            // Chip 5: "Số chỗ ▼"
            _ChipItem(
              label: 'Số chỗ',
              isDropdown: true,
              onTap: onOpenFilterSheet,
            ),
            const SizedBox(width: 8),

            // Chip 6: "Mức giá ▼"
            _ChipItem(
              label: 'Mức giá',
              isDropdown: true,
              onTap: onOpenFilterSheet,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipItem extends StatelessWidget {
  const _ChipItem({
    required this.label,
    required this.onTap,
    this.isSelected = false,
    this.isDropdown = false,
    this.icon,
    this.iconColor,
  });

  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isDropdown;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final activeBg = isSelected ? const Color(0xFF1976D2) : Colors.white;
    final activeBorder = isSelected
        ? const Color(0xFF1976D2)
        : const Color(0xFFE2E8F0);
    final activeTextColor = isSelected ? Colors.white : const Color(0xFF1E293B);
    final effectiveIconColor = isSelected
        ? Colors.white
        : (iconColor ?? const Color(0xFF64748B));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isDropdown ? 12 : (icon != null ? 14 : 18),
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: activeBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: activeBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: effectiveIconColor),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: activeTextColor,
              ),
            ),
            if (isDropdown) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: Color(0xFF64748B),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
