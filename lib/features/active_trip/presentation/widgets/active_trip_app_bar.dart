import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';

/// Thanh điều hướng đầu trang (App Bar) cho màn hình Chuyến đi đang hoạt động
class ActiveTripAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ActiveTripAppBar({
    super.key,
    required this.vehicleName,
    required this.vehiclePlate,
    required this.hasTrip,
    this.targetRentalId,
  });

  final String vehicleName;
  final String vehiclePlate;
  final bool hasTrip;
  final int? targetRentalId;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        border: const Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Nút Đóng '✕' bo tròn
              Material(
                color: const Color(0xFFF8FAFC),
                shape: const CircleBorder(
                  side: BorderSide(color: Color(0xFFE2E8F0)),
                ),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.goNamed(AppRoute.home.name);
                    }
                  },
                  child: const SizedBox(
                    width: 36,
                    height: 36,
                    child: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: Color(0xFF475569),
                    ),
                  ),
                ),
              ),

              // Tiêu đề căn giữa: Tên xe & Biển số
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      vehicleName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      hasTrip ? vehiclePlate : 'Chưa có chuyến đi',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),

              // Nút Cứu hộ khẩn cấp SOS bo tròn góc phải
              Material(
                color: const Color(0xFFFEF2F2),
                shape: const CircleBorder(
                  side: BorderSide(color: Color(0xFFFEE2E2)),
                ),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    context.push(
                      AppRoute.emergencyReport.path,
                      extra: targetRentalId,
                    );
                  },
                  child: const SizedBox(
                    width: 36,
                    height: 36,
                    child: Icon(
                      Icons.sos_rounded,
                      size: 20,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
