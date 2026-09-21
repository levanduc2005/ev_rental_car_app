import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/home/presentation/widgets/brand_selector_section.dart';
import 'package:rental_car/features/home/presentation/widgets/insurance_banner.dart';
import 'package:rental_car/features/home/presentation/widgets/rental_hero_search_card.dart';
import 'package:rental_car/features/home/presentation/widgets/vehicle_showcase_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _onRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  // Danh sách xe: "Xe có thể bạn sẽ thích"
  static const List<VehicleCardData> _recommendedVehicles = [
    VehicleCardData(
      name: 'KIA K3 2024',
      imageUrl:
          'https://images.unsplash.com/photo-1590362891991-f776e747a588?q=80&w=800&auto=format&fit=crop',
      rating: 4.9,
      location: 'Quận Cầu Giấy, Hà Nội',
      seats: '5 chỗ',
      transmission: 'Tự động',
      fuelType: 'Xăng',
      price4h: '575K',
      oldPrice4h: '650K',
      price24h: '1.145K',
      topBadgeText: '🔥 Flash Sale',
      topBadgeColor: Color(0xFFD32F2F),
      bottomBadgeText: 'Tự nhận xe',
    ),
    VehicleCardData(
      name: 'VinFast VF 8',
      imageUrl:
          'https://images.unsplash.com/photo-1563720223185-11003d516935?q=80&w=800&auto=format&fit=crop',
      rating: 4.95,
      location: 'Quận Nam Từ Liêm, Hà Nội',
      seats: '5 chỗ',
      transmission: 'Tự động',
      fuelType: 'Điện',
      price4h: '720K',
      oldPrice4h: '800K',
      price24h: '1.450K',
      topBadgeText: '⚡ 100% Điện',
      topBadgeColor: Color(0xFF1976D2),
      bottomBadgeText: 'Tự nhận xe',
    ),
  ];

  // Danh sách xe: "Xế xịn • Xe sang"
  static const List<VehicleCardData> _luxuryVehicles = [
    VehicleCardData(
      name: 'AUDI A4 2018',
      imageUrl:
          'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?q=80&w=800&auto=format&fit=crop',
      rating: 4.95,
      location: 'Quận Tây Hồ, Hà Nội',
      seats: '5 chỗ',
      transmission: 'Tự động',
      fuelType: 'Xăng',
      price4h: '1.375K',
      oldPrice4h: '1.560K',
      price24h: '1.770K',
      topBadgeText: '🏷️ Giảm 8%',
      topBadgeColor: Color(0xFFE65100),
      bottomBadgeText: 'Gặp chủ xe',
      isLuxury: true,
    ),
    VehicleCardData(
      name: 'BMW 320i Sport',
      imageUrl:
          'https://images.unsplash.com/photo-1555215695-3004980ad54e?q=80&w=800&auto=format&fit=crop',
      rating: 5.0,
      location: 'Quận Hoàn Kiếm, Hà Nội',
      seats: '5 chỗ',
      transmission: 'Tự động',
      fuelType: 'Xăng',
      price4h: '1.650K',
      oldPrice4h: '1.850K',
      price24h: '2.100K',
      topBadgeText: '🏷️ Giảm 10%',
      topBadgeColor: Color(0xFFE65100),
      bottomBadgeText: 'Gặp chủ xe',
      isLuxury: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Thuê Xe',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () {
              // Mở bộ lọc nâng cao
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              // 1. Hero Banner + Hộp tìm kiếm nổi
              RentalHeroSearchCard(),
              SizedBox(height: AppSpacing.lg),

              // 2. Chọn xe theo hãng
              BrandSelectorSection(),
              SizedBox(height: AppSpacing.xl),

              // 3. Xe có thể bạn sẽ thích
              VehicleShowcaseSection(
                title: 'Xe có thể bạn sẽ thích',
                subtitle: 'Đáp ứng nhanh chóng • Nhận xe không tiếp xúc',
                vehicles: _recommendedVehicles,
              ),
              SizedBox(height: AppSpacing.xl),

              // 4. Xế xịn • Xe sang
              VehicleShowcaseSection(
                title: 'Xế xịn • Xe sang',
                subtitle: 'Đẳng cấp doanh nhân • Tiện nghi vượt trội',
                vehicles: _luxuryVehicles,
              ),
              SizedBox(height: AppSpacing.xl),

              // 5. Bảo hiểm chuyến đi trọn gói
              InsuranceBanner(),

              // Khoảng đệm đáy tránh che khuất bởi Bottom Navigation Bar
              SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
