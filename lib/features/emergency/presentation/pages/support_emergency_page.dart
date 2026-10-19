import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/widgets/gap.dart';
import 'package:rental_car/features/profile/presentation/providers/profile_providers.dart';
import 'package:url_launcher/url_launcher.dart';

/// Tab Hỗ trợ khách hàng & Giải đáp thắc mắc
class SupportEmergencyPage extends ConsumerWidget {
  const SupportEmergencyPage({super.key});

  Future<void> _callCustomerService(BuildContext context) async {
    final uri = Uri.parse('tel:19001234');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Không thể kích hoạt cuộc gọi đến tổng đài 1900 1234',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rentalState = ref.watch(rentalHistoryControllerProvider);
    final activeRental = rentalState.items
        .where((item) => item.status.toUpperCase() == 'ONGOING')
        .firstOrNull;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Trung tâm hỗ trợ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thông báo chuyến đi đang chạy (nếu có)
            if (activeRental != null) ...[
              InkWell(
                onTap: () => context.pushNamed(
                  AppRoute.activeTrip.name,
                  extra: activeRental.id,
                ),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.directions_car_filled,
                        color: Color(0xFF2563EB),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Đơn thuê #${activeRental.id} (${activeRental.vehicleName}) đang diễn ra.',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E40AF),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF2563EB),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(AppSpacing.md),
            ],

            // 1. KHỐI TỔNG ĐÀI CHĂM SÓC KHÁCH HÀNG
            const Text(
              'CHĂM SÓC KHÁCH HÀNG',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Color(0xFF334155),
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.headset_mic_rounded,
                        color: Color(0xFF2563EB),
                        size: 24,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tổng đài CSKH e-Motion',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            '1900 1234 (8:00 - 21:00 hàng ngày)',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tư vấn thủ tục thuê xe, chính sách cọc, hóa đơn điện tử và phản hồi chất lượng dịch vụ.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2563EB),
                        side: const BorderSide(color: Color(0xFF2563EB)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.phone_rounded, size: 18),
                      label: const Text(
                        'Gọi tổng đài tư vấn',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      onPressed: () => _callCustomerService(context),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.lg),

            // 2. CÂU HỎI THƯỜNG GẶP (FAQ)
            const Text(
              'CÂU HỎI THƯỜNG GẶP',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Color(0xFF334155),
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),

            Material(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: AppColors.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),
                    child: const Material(
                      color: Colors.transparent,
                      child: ExpansionTile(
                        leading: Icon(
                          Icons.battery_alert_rounded,
                          color: Color(0xFFD97706),
                        ),
                        title: Text(
                          'Cần làm gì khi xe báo pin yếu dưới 20%?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Text(
                              'Bạn hãy mở bản đồ tìm trạm sạc gần nhất trên app để sạc xe. Nếu xe bị hết pin giữa đường, hãy vào màn hình "Chuyến đi" bấm "Báo cáo sự cố khẩn cấp (SOS)" hoặc liên hệ tổng đài 1900 1234 để được hỗ trợ.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),
                    child: const Material(
                      color: Colors.transparent,
                      child: ExpansionTile(
                        leading: Icon(
                          Icons.car_crash_rounded,
                          color: Color(0xFFDC2626),
                        ),
                        title: Text(
                          'Quy trình khi xe gặp tai nạn hoặc sự cố kỹ thuật?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Text(
                              '1. Đảm bảo an toàn cho mọi người trên xe.\n2. Giữ nguyên hiện trường.\n3. Vào màn hình Chuyến đi và bấm BÁO CÁO SOS để chụp ảnh gửi bằng chứng và định vị GPS.\n4. Hoặc liên hệ tổng đài CSKH 1900 1234 để được chuyên viên hướng dẫn xử lý.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),
                    child: const Material(
                      color: Colors.transparent,
                      child: ExpansionTile(
                        leading: Icon(
                          Icons.payments_rounded,
                          color: Color(0xFF16A34A),
                        ),
                        title: Text(
                          'Thời gian hoàn cọc sau khi trả xe là bao lâu?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Text(
                              'Sau khi nhân viên tại trạm kiểm tra và nghiệm thu xe, số tiền cọc (sau khi trừ các phụ phí phát sinh nếu có) sẽ được hoàn trả tự động vào tài khoản ngân hàng của bạn trong vòng 3 - 5 ngày làm việc.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
