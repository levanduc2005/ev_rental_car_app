import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_spacing.dart';

class BrandItem {
  const BrandItem({
    required this.name,
    this.logoAsset,
    this.logoUrl,
    required this.icon,
    required this.color,
  });

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

  static const List<BrandItem> _defaultBrands = [
    BrandItem(
      name: 'VinFast',
      logoAsset: 'public/brands/vinfast.png',
      logoUrl:
          'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/vinfast.png',
      icon: Icons.bolt_rounded,
      color: Color(0xFF1976D2),
    ),
    BrandItem(
      name: 'Tesla',
      logoAsset: 'public/brands/tesla.png',
      logoUrl:
          'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/tesla.png',
      icon: Icons.electric_bolt_rounded,
      color: Color(0xFFD32F2F),
    ),
    BrandItem(
      name: 'Hyundai',
      logoAsset: 'public/brands/hyundai.png',
      logoUrl:
          'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/hyundai.png',
      icon: Icons.speed_rounded,
      color: Color(0xFF0D47A1),
    ),
    BrandItem(
      name: 'BMW',
      logoAsset: 'public/brands/bmw.png',
      logoUrl:
          'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/bmw.png',
      icon: Icons.stars_rounded,
      color: Color(0xFF0288D1),
    ),
    BrandItem(
      name: 'Mercedes',
      logoAsset: 'public/brands/mercedes.png',
      logoUrl:
          'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/mercedes-benz.png',
      icon: Icons.star_border_rounded,
      color: Color(0xFF37474F),
    ),
    BrandItem(
      name: 'Toyota',
      logoAsset: 'public/brands/toyota.png',
      logoUrl:
          'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/toyota.png',
      icon: Icons.directions_car_rounded,
      color: Color(0xFFC62828),
    ),
    BrandItem(
      name: 'KIA',
      logoAsset: 'public/brands/kia.png',
      logoUrl:
          'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/kia.png',
      icon: Icons.auto_awesome_rounded,
      color: Color(0xFF880E4F),
    ),
    BrandItem(
      name: 'Audi',
      logoAsset: 'public/brands/audi.png',
      logoUrl:
          'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/audi.png',
      icon: Icons.all_inclusive_rounded,
      color: Color(0xFFB71C1C),
    ),
    BrandItem(
      name: 'BYD',
      logoAsset: 'public/brands/byd.png',
      logoUrl:
          'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/byd.png',
      icon: Icons.energy_savings_leaf_rounded,
      color: Color(0xFF00796B),
    ),
  ];

  static BrandItem _mapBrand(String brandName) {
    final upper = brandName.trim().toUpperCase();
    if (upper == 'VINFAST') {
      return const BrandItem(
        name: 'VinFast',
        logoAsset: 'public/brands/vinfast.png',
        logoUrl:
            'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/vinfast.png',
        icon: Icons.bolt_rounded,
        color: Color(0xFF1976D2),
      );
    } else if (upper == 'TESLA') {
      return const BrandItem(
        name: 'Tesla',
        logoAsset: 'public/brands/tesla.png',
        logoUrl:
            'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/tesla.png',
        icon: Icons.electric_bolt_rounded,
        color: Color(0xFFD32F2F),
      );
    } else if (upper == 'BMW') {
      return const BrandItem(
        name: 'BMW',
        logoAsset: 'public/brands/bmw.png',
        logoUrl:
            'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/bmw.png',
        icon: Icons.stars_rounded,
        color: Color(0xFF0288D1),
      );
    } else if (upper == 'HYUNDAI') {
      return const BrandItem(
        name: 'Hyundai',
        logoAsset: 'public/brands/hyundai.png',
        logoUrl:
            'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/hyundai.png',
        icon: Icons.speed_rounded,
        color: Color(0xFF0D47A1),
      );
    } else if (upper == 'MERCEDES_BENZ' ||
        upper == 'MERCEDES' ||
        upper == 'MERCEDES-BENZ') {
      return const BrandItem(
        name: 'Mercedes',
        logoAsset: 'public/brands/mercedes.png',
        logoUrl:
            'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/mercedes-benz.png',
        icon: Icons.star_border_rounded,
        color: Color(0xFF37474F),
      );
    } else if (upper == 'KIA') {
      return const BrandItem(
        name: 'KIA',
        logoAsset: 'public/brands/kia.png',
        logoUrl:
            'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/kia.png',
        icon: Icons.auto_awesome_rounded,
        color: Color(0xFF880E4F),
      );
    } else if (upper == 'TOYOTA') {
      return const BrandItem(
        name: 'Toyota',
        logoAsset: 'public/brands/toyota.png',
        logoUrl:
            'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/toyota.png',
        icon: Icons.directions_car_rounded,
        color: Color(0xFFC62828),
      );
    } else if (upper == 'AUDI') {
      return const BrandItem(
        name: 'Audi',
        logoAsset: 'public/brands/audi.png',
        logoUrl:
            'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/audi.png',
        icon: Icons.all_inclusive_rounded,
        color: Color(0xFFB71C1C),
      );
    } else if (upper == 'BYD') {
      return const BrandItem(
        name: 'BYD',
        logoAsset: 'public/brands/byd.png',
        logoUrl:
            'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/byd.png',
        icon: Icons.energy_savings_leaf_rounded,
        color: Color(0xFF00796B),
      );
    } else if (upper == 'MAZDA') {
      return const BrandItem(
        name: 'Mazda',
        logoAsset: 'public/brands/mazda.png',
        logoUrl:
            'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/mazda.png',
        icon: Icons.motion_photos_on_rounded,
        color: Color(0xFFC2185B),
      );
    } else if (upper == 'FORD') {
      return const BrandItem(
        name: 'Ford',
        logoAsset: 'public/brands/ford.png',
        logoUrl:
            'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/ford.png',
        icon: Icons.airport_shuttle_rounded,
        color: Color(0xFF1565C0),
      );
    } else if (upper == 'LEXUS') {
      return const BrandItem(
        name: 'Lexus',
        logoAsset: 'public/brands/lexus.png',
        logoUrl:
            'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/lexus.png',
        icon: Icons.diamond_rounded,
        color: Color(0xFF263238),
      );
    } else if (upper == 'HONDA') {
      return const BrandItem(
        name: 'Honda',
        logoAsset: 'public/brands/honda.png',
        logoUrl:
            'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/honda.png',
        icon: Icons.directions_car_rounded,
        color: Color(0xFFC62828),
      );
    } else if (upper == 'PEUGEOT') {
      return const BrandItem(
        name: 'Peugeot',
        logoAsset: 'public/brands/peugeot.png',
        logoUrl:
            'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/peugeot.png',
        icon: Icons.directions_car_rounded,
        color: Color(0xFF1565C0),
      );
    } else if (upper == 'NISSAN') {
      return const BrandItem(
        name: 'Nissan',
        logoAsset: 'public/brands/nissan.png',
        logoUrl:
            'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/nissan.png',
        icon: Icons.directions_car_rounded,
        color: Color(0xFFC2185B),
      );
    } else if (upper == 'MITSUBISHI') {
      return const BrandItem(
        name: 'Mitsubishi',
        logoAsset: 'public/brands/mitsubishi.png',
        logoUrl:
            'https://cdn.jsdelivr.net/gh/filippofilip95/car-logos-dataset@master/logos/thumb/mitsubishi.png',
        icon: Icons.directions_car_rounded,
        color: Color(0xFFD32F2F),
      );
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
      return brands!.map(_mapBrand).toList();
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
              InkWell(
                onTap: () => context.goNamed(AppRoute.mapSearch.name),
                child: const Row(
                  children: [
                    Text(
                      'Xem tất cả',
                      style: TextStyle(
                        fontSize: 12,
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
