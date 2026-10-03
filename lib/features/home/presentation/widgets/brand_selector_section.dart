import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/home/presentation/widgets/section_see_all_button.dart';

class BrandItem {
  const BrandItem({
    required this.name,
    this.logoAsset,
    this.logoUrl,
    required this.icon,
    required this.color,
  });

  factory BrandItem.create({
    required String name,
    required String slug,
    required IconData icon,
    required Color color,
    String? remoteSlug,
  }) {
    return BrandItem(
      name: name,
      logoAsset: 'public/brands/$slug.png',
      logoUrl:
          'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/${remoteSlug ?? slug}.png',
      icon: icon,
      color: color,
    );
  }

  final String name;
  final String? logoAsset;
  final String? logoUrl;
  final IconData icon;
  final Color color;
}

class BrandSelectorSection extends StatelessWidget {
  const BrandSelectorSection({
    this.brands,
    this.selectedBrand,
    this.onSelectBrand,
    super.key,
  });

  final List<String>? brands;
  final String? selectedBrand;
  final ValueChanged<String>? onSelectBrand;

  static final Map<String, BrandItem> _knownBrands = {
    'VINFAST': BrandItem.create(
      name: 'VinFast',
      slug: 'vinfast',
      icon: Icons.bolt_rounded,
      color: const Color(0xFF1976D2),
    ),
    'TESLA': BrandItem.create(
      name: 'Tesla',
      slug: 'tesla',
      icon: Icons.electric_bolt_rounded,
      color: const Color(0xFFD32F2F),
    ),
    'HYUNDAI': BrandItem.create(
      name: 'Hyundai',
      slug: 'hyundai',
      icon: Icons.speed_rounded,
      color: const Color(0xFF0D47A1),
    ),
    'BMW': BrandItem.create(
      name: 'BMW',
      slug: 'bmw',
      icon: Icons.stars_rounded,
      color: const Color(0xFF0288D1),
    ),
    'MERCEDES': BrandItem.create(
      name: 'Mercedes',
      slug: 'mercedes',
      remoteSlug: 'mercedes-benz',
      icon: Icons.star_border_rounded,
      color: const Color(0xFF37474F),
    ),
    'TOYOTA': BrandItem.create(
      name: 'Toyota',
      slug: 'toyota',
      icon: Icons.directions_car_rounded,
      color: const Color(0xFFC62828),
    ),
    'KIA': BrandItem.create(
      name: 'KIA',
      slug: 'kia',
      icon: Icons.auto_awesome_rounded,
      color: const Color(0xFF880E4F),
    ),
    'AUDI': BrandItem.create(
      name: 'Audi',
      slug: 'audi',
      icon: Icons.all_inclusive_rounded,
      color: const Color(0xFFB71C1C),
    ),
    'BYD': BrandItem.create(
      name: 'BYD',
      slug: 'byd',
      icon: Icons.energy_savings_leaf_rounded,
      color: const Color(0xFF00796B),
    ),
    'MAZDA': BrandItem.create(
      name: 'Mazda',
      slug: 'mazda',
      icon: Icons.motion_photos_on_rounded,
      color: const Color(0xFFC2185B),
    ),
    'FORD': BrandItem.create(
      name: 'Ford',
      slug: 'ford',
      icon: Icons.airport_shuttle_rounded,
      color: const Color(0xFF1565C0),
    ),
    'LEXUS': BrandItem.create(
      name: 'Lexus',
      slug: 'lexus',
      icon: Icons.diamond_rounded,
      color: const Color(0xFF263238),
    ),
    'HONDA': BrandItem.create(
      name: 'Honda',
      slug: 'honda',
      icon: Icons.directions_car_rounded,
      color: const Color(0xFFC62828),
    ),
    'PEUGEOT': BrandItem.create(
      name: 'Peugeot',
      slug: 'peugeot',
      icon: Icons.directions_car_rounded,
      color: const Color(0xFF1565C0),
    ),
    'NISSAN': BrandItem.create(
      name: 'Nissan',
      slug: 'nissan',
      icon: Icons.directions_car_rounded,
      color: const Color(0xFFC2185B),
    ),
    'MITSUBISHI': BrandItem.create(
      name: 'Mitsubishi',
      slug: 'mitsubishi',
      icon: Icons.directions_car_rounded,
      color: const Color(0xFFD32F2F),
    ),
  };

  static const List<String> _defaultBrandKeys = ['VINFAST', 'TESLA', 'BYD'];

  static List<BrandItem> get _defaultBrands =>
      _defaultBrandKeys.map((k) => _knownBrands[k]!).toList();

  static String _normalizeKey(String brandName) {
    final upper = brandName.trim().toUpperCase().replaceAll('-', '_');
    if (upper == 'MERCEDES_BENZ' || upper == 'MERCEDES') {
      return 'MERCEDES';
    }
    return upper;
  }

  static BrandItem _mapBrand(String brandName) {
    final key = _normalizeKey(brandName);
    final known = _knownBrands[key];
    if (known != null) {
      return known;
    }

    final slug = brandName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-');
    return BrandItem(
      name: brandName,
      logoUrl:
          'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/$slug.png',
      icon: Icons.directions_car_filled_rounded,
      color: const Color(0xFF1976D2),
    );
  }

  List<BrandItem> get _displayBrands {
    if (brands != null && brands!.isNotEmpty) {
      final seen = <String>{};
      final uniqueBrands = <BrandItem>[];
      for (final raw in brands!) {
        final item = _mapBrand(raw);
        if (seen.add(item.name.toUpperCase())) {
          uniqueBrands.add(item);
        }
      }
      return uniqueBrands;
    }
    return _defaultBrands;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayList = _displayBrands;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề + Xem tất cả / Bỏ chọn
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Chọn xe theo hãng',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (selectedBrand != null) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => onSelectBrand?.call(selectedBrand!),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1976D2).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              selectedBrand!,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF1976D2),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              Icons.close_rounded,
                              size: 12,
                              color: Color(0xFF1976D2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              SectionSeeAllButton(
                onTap: () => context.goNamed(AppRoute.mapSearch.name),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Danh sách thương hiệu cuộn ngang
        SizedBox(
          height: 102,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            scrollDirection: Axis.horizontal,
            itemCount: displayList.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final brand = displayList[index];
              final isSelected =
                  selectedBrand?.toUpperCase() == brand.name.toUpperCase();

              return Material(
                color: isSelected
                    ? brand.color.withValues(alpha: 0.12)
                    : colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () {
                    if (onSelectBrand != null) {
                      onSelectBrand!(brand.name);
                    } else {
                      context.goNamed(AppRoute.mapSearch.name);
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 84,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? brand.color
                            : colorScheme.outlineVariant.withValues(
                                alpha: 0.35,
                              ),
                        width: isSelected ? 1.8 : 1.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Vòng tròn chứa logo hãng xe thực tế
                        Container(
                          width: 44,
                          height: 44,
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? brand.color
                                  : colorScheme.outlineVariant.withValues(
                                      alpha: 0.25,
                                    ),
                              width: isSelected ? 1.8 : 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(child: _BrandLogoImage(brand: brand)),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          brand.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w900
                                : FontWeight.w600,
                            color: isSelected ? brand.color : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Widget hiển thị logo hãng thực tế với fallback nhiều tầng (Local asset -> Network CDN -> Icon)
class _BrandLogoImage extends StatelessWidget {
  const _BrandLogoImage({required this.brand});

  final BrandItem brand;

  @override
  Widget build(BuildContext context) {
    if (brand.logoAsset != null) {
      return Image.asset(
        brand.logoAsset!,
        width: 28,
        height: 28,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => _buildNetworkOrIcon(),
      );
    }
    return _buildNetworkOrIcon();
  }

  Widget _buildNetworkOrIcon() {
    if (brand.logoUrl != null) {
      return Image.network(
        brand.logoUrl!,
        width: 28,
        height: 28,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) =>
            Icon(brand.icon, color: brand.color, size: 22),
      );
    }
    return Icon(brand.icon, color: brand.color, size: 22);
  }
}
