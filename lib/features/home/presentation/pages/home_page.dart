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
import 'package:rental_car/features/vehicles/presentation/fallback_vehicles.dart';
import 'package:rental_car/features/vehicles/presentation/providers/vehicle_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

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
                  vehicles: FallbackVehicles.recommended,
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
                  vehicles: FallbackVehicles.luxury,
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
