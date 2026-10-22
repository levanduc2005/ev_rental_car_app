import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';

/// Thanh hướng dẫn cố định ở đáy màn hình khi đang có chuyến xe
class ActiveTripBottomBar extends StatelessWidget {
  const ActiveTripBottomBar({super.key, this.targetRentalId});

  final int? targetRentalId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        MediaQuery.paddingOf(context).bottom + 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFF1F5F9))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFBFDBFE)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.storefront_rounded,
              color: Color(0xFF2563EB),
              size: 22,
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Khi trả xe, vui lòng đưa xe về trạm để nhân viên kiểm tra và làm thủ tục nhận lại xe (Check-out).',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1D4ED8),
                  height: 1.3,
                ),
              ),
            ),
            if (targetRentalId != null) ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  context.pushNamed(
                    AppRoute.rentalDetail.name,
                    pathParameters: {'id': targetRentalId.toString()},
                  );
                },
                child: const Text(
                  'Chi tiết',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
