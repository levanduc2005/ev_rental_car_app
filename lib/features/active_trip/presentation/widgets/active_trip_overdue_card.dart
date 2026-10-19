import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/features/active_trip/domain/entities/active_rental_entity.dart';
import 'package:rental_car/features/active_trip/presentation/providers/active_rental_providers.dart';
import 'package:rental_car/features/active_trip/presentation/widgets/countdown_box.dart';
import 'package:rental_car/features/profile/domain/entities/rental_item_entity.dart';
import 'package:url_launcher/url_launcher.dart';

/// Thẻ cảnh báo quá hạn thuê xe & liên hệ gia hạn khẩn cấp
class ActiveTripOverdueCard extends ConsumerWidget {
  const ActiveTripOverdueCard({
    super.key,
    required this.detail,
    required this.activeRentalItem,
    required this.deadline,
  });

  final ActiveRentalEntity? detail;
  final RentalItemEntity? activeRentalItem;
  final DateTime deadline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tự động re-render mỗi giây độc lập khi đồng hồ đếm
    ref.watch(activeTripTickerProvider);

    final now = DateTime.now();
    final overdueDuration = now.difference(deadline);
    final days = overdueDuration.inDays;
    final hours = overdueDuration.inHours % 24;
    final minutes = overdueDuration.inMinutes % 60;
    final seconds = overdueDuration.inSeconds % 60;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFECDD3)), // border-rose-200
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE11D48).withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Thời gian quá hạn thuê xe & Badge "Đang tính phụ phí"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 17,
                    color: Color(0xFFE11D48),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Thời gian quá hạn thuê xe',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFECDD3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE11D48),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Đang tính phụ phí',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE11D48),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 4 Ô thời gian quá hạn màu đỏ (NGÀY | GIỜ | PHÚT | GIÂY)
          Row(
            children: [
              OverdueBox(value: days.toString().padLeft(2, '0'), label: 'NGÀY'),
              const SizedBox(width: 10),
              OverdueBox(value: hours.toString().padLeft(2, '0'), label: 'GIỜ'),
              const SizedBox(width: 10),
              OverdueBox(
                value: minutes.toString().padLeft(2, '0'),
                label: 'PHÚT',
              ),
              const SizedBox(width: 10),
              OverdueBox(
                value: seconds.toString().padLeft(2, '0'),
                label: 'GIÂY',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Khối thông báo quy định quá hạn màu hổ phách (Amber Notification Box)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB), // amber-50
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFDE68A)), // amber-200
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: Color(0xFFB45309), // amber-700
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Quy định: +100.000đ/giờ quá hạn. Vui lòng hoàn tất trả xe ngay hoặc liên hệ tổng đài để tránh phát sinh thêm phí phạt.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFB45309), // amber-700
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 28, thickness: 1, color: Color(0xFFF1F5F9)),

          // 2 Nút hành động: Gia hạn khẩn cấp & Hỗ trợ 1900 5335
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  showDialog<void>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Color(0xFFE11D48),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Gia hạn khẩn cấp',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      content: const Text(
                        'Yêu cầu gia hạn thêm giờ của bạn đang được chuyển đến nhân viên vận hành. Tổng đài viên sẽ gọi lại để xác nhận duyệt gia hạn trong 3 phút.',
                        style: TextStyle(fontSize: 13, height: 1.4),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text(
                            'Đã hiểu',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 15,
                      color: Color(0xFFE11D48),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Gia hạn khẩn cấp',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE11D48),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  final uri = Uri.parse('tel:19005335');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },
                child: const Row(
                  children: [
                    Text(
                      'Hỗ trợ 1900 5335',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 14,
                      color: Color(0xFF2563EB),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
