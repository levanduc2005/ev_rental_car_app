import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_spacing.dart';

class RentalHeroSearchCard extends StatefulWidget {
  const RentalHeroSearchCard({super.key});

  @override
  State<RentalHeroSearchCard> createState() => _RentalHeroSearchCardState();
}

class _RentalHeroSearchCardState extends State<RentalHeroSearchCard> {
  // 0: Thuê theo gói, 1: Thuê theo tháng
  int _selectedRentalType = 0;
  String _selectedLocation = 'Hà Nội • Tất cả quận huyện';
  String _selectedTime = '16:00, 14/09 — 20:00, 16/09';

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
                          onTap: () => setState(() => _selectedRentalType = 0),
                        ),
                      ),
                      Expanded(
                        child: _TabButton(
                          title: 'Thuê theo tháng',
                          icon: Icons.calendar_month_rounded,
                          isSelected: _selectedRentalType == 1,
                          onTap: () => setState(() => _selectedRentalType = 1),
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
                  value: _selectedLocation,
                  trailingIcon: Icons.keyboard_arrow_down_rounded,
                  onTap: () {
                    // Mở chọn vị trí
                  },
                ),
                const SizedBox(height: AppSpacing.sm),

                // Ô chọn thời gian nhận - trả
                _SearchFieldItem(
                  icon: Icons.calendar_today_rounded,
                  iconColor: const Color(0xFF1976D2),
                  label: 'Thời gian nhận - trả',
                  value: _selectedTime,
                  trailingIcon: Icons.access_time_rounded,
                  onTap: () {
                    // Mở chọn lịch
                  },
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
                    onPressed: () => context.goNamed(AppRoute.mapSearch.name),
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
