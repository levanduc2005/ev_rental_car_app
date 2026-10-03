import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/home/presentation/providers/home_providers.dart';
import 'package:rental_car/features/home/presentation/widgets/brand_selector_section.dart';
import 'package:rental_car/features/home/presentation/widgets/faq_section.dart';
import 'package:rental_car/features/home/presentation/widgets/how_it_works_section.dart';
import 'package:rental_car/features/home/presentation/widgets/insurance_banner.dart';
import 'package:rental_car/features/home/presentation/widgets/rental_hero_search_card.dart';
import 'package:rental_car/features/home/presentation/widgets/vehicle_showcase_section.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_filter.dart';
import 'package:rental_car/features/vehicles/presentation/providers/vehicle_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  // Danh sách xe dự phòng: "Xe có thể bạn sẽ thích" (100% xe điện chuẩn đội xe E-Motion)
  static const List<VehicleCardData> _fallbackRecommendedVehicles = [
    VehicleCardData(
      id: 1,
      name: 'VinFast VF 3 Plus 2024',
      imageUrl:
          'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?q=80&w=800&auto=format&fit=crop',
      rating: 4.9,
      location: 'Quận 1, TP. Hồ Chí Minh',
      seats: '4 chỗ',
      transmission: 'Điện',
      fuelType: 'Điện (95% Pin)',
      price4h: '300K',
      oldPrice4h: '350K',
      price24h: '600K',
      topBadgeText: '⚡ 100% Điện',
      topBadgeColor: Color(0xFF1976D2),
      bottomBadgeText: 'Tự nhận xe',
    ),
    VehicleCardData(
      id: 2,
      name: 'VinFast VF 5 Plus',
      imageUrl:
          'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?q=80&w=800&auto=format&fit=crop',
      rating: 4.95,
      location: 'Quận 1, TP. Hồ Chí Minh',
      seats: '5 chỗ',
      transmission: 'Điện',
      fuelType: 'Điện (88% Pin)',
      price4h: '450K',
      oldPrice4h: '500K',
      price24h: '900K',
      topBadgeText: '⚡ 100% Điện',
      topBadgeColor: Color(0xFF1976D2),
      bottomBadgeText: 'Tự nhận xe',
    ),
    VehicleCardData(
      id: 7,
      name: 'BYD Atto 3 Extended',
      imageUrl:
          'https://images.unsplash.com/photo-1502877338535-766e1452684a?q=80&w=800&auto=format&fit=crop',
      rating: 4.85,
      location: 'Hoàn Kiếm, Hà Nội',
      seats: '5 chỗ',
      transmission: 'Điện',
      fuelType: 'Điện (85% Pin)',
      price4h: '600K',
      oldPrice4h: '700K',
      price24h: '1.200K',
      topBadgeText: '⚡ 100% Điện',
      topBadgeColor: Color(0xFF1976D2),
      bottomBadgeText: 'Tự nhận xe',
    ),
  ];

  // Danh sách xe dự phòng: "Xế xịn • Xe sang" (100% xe điện cao cấp chuẩn đội xe E-Motion)
  static const List<VehicleCardData> _fallbackLuxuryVehicles = [
    VehicleCardData(
      id: 3,
      name: 'VinFast VF 8 Plus',
      imageUrl:
          'https://images.unsplash.com/photo-1617788138017-80ad40651399?q=80&w=800&auto=format&fit=crop',
      rating: 4.95,
      location: 'Quận 1, TP. Hồ Chí Minh',
      seats: '5 chỗ',
      transmission: 'Điện',
      fuelType: 'Điện (72% Pin)',
      price4h: '900K',
      oldPrice4h: '1.050K',
      price24h: '1.800K',
      topBadgeText: '👑 Xế xịn',
      topBadgeColor: Color(0xFFE65100),
      bottomBadgeText: 'Tự nhận xe',
      isLuxury: true,
    ),
    VehicleCardData(
      id: 4,
      name: 'VinFast VF 9 Plus 6 Chỗ',
      imageUrl:
          'https://images.unsplash.com/photo-1563720223185-11003d516935?q=80&w=800&auto=format&fit=crop',
      rating: 5.0,
      location: 'Cầu Giấy, Hà Nội',
      seats: '7 chỗ',
      transmission: 'Điện',
      fuelType: 'Điện (100% Pin)',
      price4h: '1.400K',
      oldPrice4h: '1.600K',
      price24h: '2.800K',
      topBadgeText: '👑 Xế xịn',
      topBadgeColor: Color(0xFFE65100),
      bottomBadgeText: 'Tự nhận xe',
      isLuxury: true,
    ),
    VehicleCardData(
      id: 5,
      name: 'Tesla Model 3 Long Range',
      imageUrl:
          'https://images.unsplash.com/photo-1560958089-b8a1929cea89?q=80&w=800&auto=format&fit=crop',
      rating: 5.0,
      location: 'Cầu Giấy, Hà Nội',
      seats: '5 chỗ',
      transmission: 'Điện',
      fuelType: 'Điện (90% Pin)',
      price4h: '1.200K',
      oldPrice4h: '1.350K',
      price24h: '2.400K',
      topBadgeText: '👑 Xế xịn',
      topBadgeColor: Color(0xFFE65100),
      bottomBadgeText: 'Tự nhận xe',
      isLuxury: true,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final homeState = ref.watch(homeControllerProvider);

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
              context.goNamed(AppRoute.mapSearch.name);
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Hồ sơ cá nhân',
            onPressed: () {
              context.push(AppRoute.profile.path);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(homeControllerProvider.notifier).refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thanh trạng thái loading nhẹ khi làm mới
              if (homeState.isRefreshing)
                const LinearProgressIndicator(minHeight: 2),

              // Thông báo lỗi nếu có kèm nút thử lại
              if (homeState.errorMessage != null && !homeState.hasData)
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer.withValues(
                      alpha: 0.7,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: theme.colorScheme.error,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          homeState.errorMessage!,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => ref
                            .read(homeControllerProvider.notifier)
                            .loadHomeData(),
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),

              // 1. Hero Banner + Hộp tìm kiếm nổi
              const RentalHeroSearchCard(),
              const SizedBox(height: AppSpacing.lg),

              // 2. Chọn xe theo hãng
              BrandSelectorSection(
                brands: homeState.brands,
                selectedBrand: homeState.selectedBrand,
                onSelectBrand: (brand) {
                  ref.read(homeControllerProvider.notifier).selectBrand(brand);
                  ref
                      .read(vehicleFilterProvider.notifier)
                      .updateFilter(
                        const VehicleFilter().copyWith(
                          brand: brand,
                          clearSearch: true,
                        ),
                      );
                  context.goNamed(AppRoute.mapSearch.name);
                },
              ),
              const SizedBox(height: AppSpacing.xl),

              // 3. Xe có thể bạn sẽ thích
              if (homeState.isLoading && !homeState.hasData)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                )
              else if (homeState.recommendedVehicles.isNotEmpty)
                VehicleShowcaseSection(
                  title: 'Xe có thể bạn sẽ thích',
                  subtitle: 'Đáp ứng nhanh chóng • Nhận xe không tiếp xúc',
                  vehicleEntities: homeState.recommendedVehicles,
                )
              else
                const VehicleShowcaseSection(
                  title: 'Xe có thể bạn sẽ thích',
                  subtitle: 'Đáp ứng nhanh chóng • Nhận xe không tiếp xúc',
                  vehicles: _fallbackRecommendedVehicles,
                ),
              const SizedBox(height: AppSpacing.xl),

              // 4. Xế xịn • Xe sang
              if (homeState.luxuryVehicles.isNotEmpty)
                VehicleShowcaseSection(
                  title: 'Xế xịn • Xe sang',
                  subtitle: 'Đẳng cấp doanh nhân • Tiện nghi vượt trội',
                  vehicleEntities: homeState.luxuryVehicles,
                )
              else
                const VehicleShowcaseSection(
                  title: 'Xế xịn • Xe sang',
                  subtitle: 'Đẳng cấp doanh nhân • Tiện nghi vượt trội',
                  vehicles: _fallbackLuxuryVehicles,
                ),
              const SizedBox(height: AppSpacing.xl),

              // 5. Hướng dẫn thuê xe (4 bước đơn giản)
              const HowItWorksSection(),
              const SizedBox(height: AppSpacing.xl),

              // 6. Bảo hiểm chuyến đi trọn gói
              const InsuranceBanner(),
              const SizedBox(height: AppSpacing.xl),

              // 7. Câu hỏi thường gặp
              const FaqSection(),

              // Khoảng đệm đáy tránh che khuất bởi Bottom Navigation Bar
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
