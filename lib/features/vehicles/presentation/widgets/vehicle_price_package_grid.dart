import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';

class PricePackage {
  const PricePackage({
    required this.id,
    required this.name,
    required this.priceText,
  });

  final String id;
  final String name;
  final String priceText;
}

/// Lưới chọn gói giá tham khảo (Slide 10)
class VehiclePricePackageGrid extends StatelessWidget {
  const VehiclePricePackageGrid({
    required this.selectedPackageId,
    required this.onSelectPackage,
    this.price4h,
    this.price8h,
    this.price12h,
    this.price24h,
    super.key,
  });

  final String selectedPackageId;
  final ValueChanged<String> onSelectPackage;
  final double? price4h;
  final double? price8h;
  final double? price12h;
  final double? price24h;

  static String _formatVnd(double val) {
    final str = val.round().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '$strđ';
  }

  static String _formatPrice(double? val) {
    if (val == null || val <= 0) return 'Liên hệ';
    return _formatVnd(val);
  }

  List<PricePackage> get packages => [
    PricePackage(
      id: '4h',
      name: 'Gói 4 giờ',
      priceText: _formatPrice(price4h),
    ),
    PricePackage(
      id: '8h',
      name: 'Gói 8 giờ',
      priceText: _formatPrice(price8h),
    ),
    PricePackage(
      id: '12h',
      name: 'Gói 12 giờ',
      priceText: _formatPrice(price12h),
    ),
    PricePackage(
      id: '24h',
      name: 'Gói 24 giờ (1 ngày)',
      priceText: _formatPrice(price24h),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'BẢNG GIÁ THAM KHẢO',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Color(0xFF64748B),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),

        // Grid 2 cột
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: packages.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.3,
          ),
          itemBuilder: (context, index) {
            final pkg = packages[index];
            final isSelected = pkg.id == selectedPackageId;

            return InkWell(
              onTap: () => onSelectPackage(pkg.id),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryLight : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.border,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      pkg.name,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pkg.priceText,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),

        const Text(
          'Đơn giá áp dụng cho ngày thường. Giá ngày Lễ/Tết có thể thay đổi tương ứng.',
          style: TextStyle(
            fontSize: 11,
            fontStyle: FontStyle.italic,
            color: Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }
}
