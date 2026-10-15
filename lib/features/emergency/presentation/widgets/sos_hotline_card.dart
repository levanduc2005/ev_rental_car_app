import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/theme/app_text_styles.dart';
import 'package:rental_car/core/widgets/gap.dart';
import 'package:url_launcher/url_launcher.dart';

class SosHotlineCard extends StatelessWidget {
  const SosHotlineCard({
    super.key,
    this.hotline = '19006868',
    this.displayHotline = '1900 6868',
  });

  final String hotline;
  final String displayHotline;

  Future<void> _makeCall(BuildContext context) async {
    final uri = Uri.parse('tel:$hotline');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể kích hoạt cuộc gọi đến số $displayHotline'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFDC2626), Color(0xFF991B1B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDC2626).withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const Gap.h(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TỔNG ĐÀI CỨU HỘ 24/7',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      displayHotline,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Hỗ trợ kỹ thuật, kích pin, chở xe cứu hộ và xử lý sự cố khẩn cấp trên toàn quốc.',
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFDC2626),
              padding: const EdgeInsets.symmetric(vertical: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            icon: const Icon(Icons.phone_in_talk_rounded, size: 20),
            label: const Text(
              'GỌI NGAY CỨU HỘ (MIỄN PHÍ)',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            ),
            onPressed: () => _makeCall(context),
          ),
        ],
      ),
    );
  }
}
