import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/home/presentation/providers/home_providers.dart';
import 'package:rental_car/features/home/presentation/widgets/brand_selector_section.dart';
import 'package:rental_car/features/home/presentation/widgets/insurance_banner.dart';
import 'package:rental_car/features/home/presentation/widgets/rental_hero_search_card.dart';
import 'package:rental_car/features/home/presentation/widgets/vehicle_showcase_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  // Danh sách xe dự phòng: "Xe có thể bạn sẽ thích" (fallback khi chưa khởi động BE)
  static const List<VehicleCardData> _fallbackRecommendedVehicles = [
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

  // Danh sách xe dự phòng: "Xế xịn • Xe sang" (fallback khi chưa khởi động BE)
  static const List<VehicleCardData> _fallbackLuxuryVehicles = [
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
              else if (homeState.hasData &&
                  homeState.recommendedVehicles.isNotEmpty)
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
              if (homeState.hasData && homeState.luxuryVehicles.isNotEmpty)
                VehicleShowcaseSection(
                  title: 'Xế xịn • Xe sang',
                  subtitle: 'Đẳng cấp doanh nhân • Tiện nghi vượt trội',
                  vehicleEntities: homeState.luxuryVehicles,
                )
              else if (!homeState.isLoading)
                const VehicleShowcaseSection(
                  title: 'Xế xịn • Xe sang',
                  subtitle: 'Đẳng cấp doanh nhân • Tiện nghi vượt trội',
                  vehicles: _fallbackLuxuryVehicles,
                ),
              const SizedBox(height: AppSpacing.xl),

              // 5. Bảo hiểm chuyến đi trọn gói
              const InsuranceBanner(),

              // Khoảng đệm đáy tránh che khuất bởi Bottom Navigation Bar
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
