import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_spacing.dart';

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
    for (final (k, name, slug, rSlug, icon, color) in const [
      (
        'VINFAST',
        'VinFast',
        'vinfast',
        null,
        Icons.bolt_rounded,
        Color(0xFF1976D2),
      ),
      (
        'TESLA',
        'Tesla',
        'tesla',
        null,
        Icons.electric_bolt_rounded,
        Color(0xFFD32F2F),
      ),
      (
        'HYUNDAI',
        'Hyundai',
        'hyundai',
        null,
        Icons.speed_rounded,
        Color(0xFF0D47A1),
      ),
      ('BMW', 'BMW', 'bmw', null, Icons.stars_rounded, Color(0xFF0288D1)),
      (
        'MERCEDES',
        'Mercedes',
        'mercedes',
        'mercedes-benz',
        Icons.star_border_rounded,
        Color(0xFF37474F),
      ),
      (
        'TOYOTA',
        'Toyota',
        'toyota',
        null,
        Icons.directions_car_rounded,
        Color(0xFFC62828),
      ),
      (
        'KIA',
        'KIA',
        'kia',
        null,
        Icons.auto_awesome_rounded,
        Color(0xFF880E4F),
      ),
      (
        'AUDI',
        'Audi',
        'audi',
        null,
        Icons.all_inclusive_rounded,
        Color(0xFFB71C1C),
      ),
      (
        'BYD',
        'BYD',
        'byd',
        null,
        Icons.energy_savings_leaf_rounded,
        Color(0xFF00796B),
      ),
      (
        'MAZDA',
        'Mazda',
        'mazda',
        null,
        Icons.motion_photos_on_rounded,
        Color(0xFFC2185B),
      ),
      (
        'FORD',
        'Ford',
        'ford',
        null,
        Icons.airport_shuttle_rounded,
        Color(0xFF1565C0),
      ),
      (
        'LEXUS',
        'Lexus',
        'lexus',
        null,
        Icons.diamond_rounded,
        Color(0xFF263238),
      ),
      (
        'HONDA',
        'Honda',
        'honda',
        null,
        Icons.directions_car_rounded,
        Color(0xFFC62828),
      ),
      (
        'PEUGEOT',
        'Peugeot',
        'peugeot',
        null,
        Icons.directions_car_rounded,
        Color(0xFF1565C0),
      ),
      (
        'NISSAN',
        'Nissan',
        'nissan',
        null,
        Icons.directions_car_rounded,
        Color(0xFFC2185B),
      ),
      (
        'MITSUBISHI',
        'Mitsubishi',
        'mitsubishi',
        null,
        Icons.directions_car_rounded,
        Color(0xFFD32F2F),
      ),
    ])
      k: BrandItem.create(
        name: name,
        slug: slug,
        remoteSlug: rSlug,
        icon: icon,
        color: color,
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
    final displayList = _displayBrands;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'Chọn xe theo hãng',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Danh sách thương hiệu cuộn ngang
        SizedBox(
          height: 92,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            scrollDirection: Axis.horizontal,
            itemCount: displayList.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final brand = displayList[index];
              final isSelected =
                  selectedBrand?.toUpperCase() == brand.name.toUpperCase();

              return Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () {
                    onSelectBrand?.call(brand.name);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 76,
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 4,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Vòng tròn chứa logo hãng xe phẳng, không viền nổi
                        Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? brand.color.withValues(alpha: 0.12)
                                : const Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: _BrandLogoImage(brand: brand)),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          brand.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w800
                                : FontWeight.w600,
                            color: isSelected
                                ? brand.color
                                : const Color(0xFF334155),
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
