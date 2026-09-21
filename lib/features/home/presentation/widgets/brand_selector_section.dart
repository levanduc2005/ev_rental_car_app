import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_spacing.dart';

class BrandItem {
  const BrandItem({
    required this.name,
    required this.icon,
    required this.color,
  });

  final String name;
  final IconData icon;
  final Color color;
}

class BrandSelectorSection extends StatelessWidget {
  const BrandSelectorSection({super.key});

  final List<BrandItem> _brands = const [
    BrandItem(
      name: 'VinFast',
      icon: Icons.bolt_rounded,
      color: Color(0xFF1976D2),
    ),
    BrandItem(
      name: 'Hyundai',
      icon: Icons.speed_rounded,
      color: Color(0xFF0D47A1),
    ),
    BrandItem(name: 'BMW', icon: Icons.stars_rounded, color: Color(0xFF0288D1)),
    BrandItem(
      name: 'Tesla',
      icon: Icons.donut_large_rounded,
      color: Color(0xFFD32F2F),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          // Tiêu đề + Xem tất cả
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Chọn xe theo hãng',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () => context.goNamed(AppRoute.mapSearch.name),
                child: const Row(
                  children: [
                    Text(
                      'Xem tất cả',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: Color(0xFF1976D2),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // 4 Thẻ Hãng Xe bo tròn
          Row(
            children: _brands.map((brand) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Material(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: () {
                        // Chuyển sang tìm xe theo hãng
                        context.goNamed(AppRoute.mapSearch.name);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.4,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Vòng tròn icon hãng
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: brand.color.withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                brand.icon,
                                color: brand.color,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              brand.name,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
