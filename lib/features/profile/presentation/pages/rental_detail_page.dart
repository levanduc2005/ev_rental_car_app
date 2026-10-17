import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/profile/presentation/providers/profile_providers.dart';
import 'package:rental_car/features/profile/presentation/widgets/rental_detail/rental_bottom_action_bar.dart';
import 'package:rental_car/features/profile/presentation/widgets/rental_detail/rental_checklists_card.dart';
import 'package:rental_car/features/profile/presentation/widgets/rental_detail/rental_contract_card.dart';
import 'package:rental_car/features/profile/presentation/widgets/rental_detail/rental_damage_log_card.dart';
import 'package:rental_car/features/profile/presentation/widgets/rental_detail/rental_financial_card.dart';
import 'package:rental_car/features/profile/presentation/widgets/rental_detail/rental_header_card.dart';
import 'package:rental_car/features/profile/presentation/widgets/rental_detail/rental_schedule_card.dart';
import 'package:rental_car/features/profile/presentation/widgets/rental_detail/rental_vehicle_station_card.dart';
import 'package:url_launcher/url_launcher.dart';

/// Trang Xem Chi tiết Đơn thuê xe thực tế e-Motion (Đã tách component Clean Architecture)
class RentalDetailPage extends ConsumerStatefulWidget {
  const RentalDetailPage({required this.rentalId, super.key});

  final int rentalId;

  @override
  ConsumerState<RentalDetailPage> createState() => _RentalDetailPageState();
}

class _RentalDetailPageState extends ConsumerState<RentalDetailPage> {
  RentalDetailEntity? _rental;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final useCase = ref.read(getRentalDetailUseCaseProvider);
    final result = await useCase(widget.rentalId);

    if (!mounted) return;

    result.when(
      ok: (item) {
        setState(() {
          _rental = item;
          _isLoading = false;
        });
      },
      err: (failure) {
        setState(() {
          _isLoading = false;
          _errorMessage = failure.message;
        });
      },
    );
  }

  Future<void> _openContractUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể mở liên kết hợp đồng điện tử.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Đơn thuê #${widget.rentalId}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Làm mới',
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            onPressed: _fetchDetail,
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _rental != null
          ? RentalBottomActionBar(rental: _rental!, onRefresh: _fetchDetail)
          : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text(
              'Đang tải chi tiết đơn thuê...',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchDetail,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    final rental = _rental!;

    return RefreshIndicator(
      onRefresh: _fetchDetail,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Thẻ Header mã đơn & trạng thái
            RentalHeaderCard(rental: rental),
            const SizedBox(height: 14),

            // 2. Thẻ Xe & Trạm giao nhận
            RentalVehicleStationCard(rental: rental),
            const SizedBox(height: 14),

            // 3. Thẻ Lịch trình thuê
            RentalScheduleCard(rental: rental),
            const SizedBox(height: 14),

            // 4. Thẻ Hợp đồng điện tử (nếu có)
            if (rental.contractUrl != null &&
                rental.contractUrl!.isNotEmpty) ...[
              RentalContractCard(
                contractUrl: rental.contractUrl!,
                onOpenContract: () => _openContractUrl(rental.contractUrl),
              ),
              const SizedBox(height: 14),
            ],

            // 5. Thẻ Biên bản bàn giao xe (Check-in & Check-out)
            RentalChecklistsCard(
              checkInChecklist: rental.checkInChecklist,
              checkOutChecklist: rental.checkOutChecklist,
            ),
            const SizedBox(height: 14),

            // 6. Thẻ Biên bản hư hại phụ tùng (VehicleLog nếu có)
            if (rental.vehicleDamages.isNotEmpty ||
                rental.vehicleDamageCost > 0) ...[
              RentalDamageLogCard(
                damages: rental.vehicleDamages,
                damageCost: rental.vehicleDamageCost,
                damageImages: rental.vehicleDamageImages,
              ),
              const SizedBox(height: 14),
            ],

            // 7. Thẻ Quyết toán tài chính & Tiền cọc
            RentalFinancialCard(rental: rental),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
