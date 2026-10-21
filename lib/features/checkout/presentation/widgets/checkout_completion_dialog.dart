import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';

import 'package:rental_car/features/profile/presentation/pages/rental_detail_page.dart';

class CheckoutCompletionDialog extends StatelessWidget {
  const CheckoutCompletionDialog({super.key, required this.rentalId});

  final int? rentalId;

  static void show(BuildContext context, {int? rentalId}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CheckoutCompletionDialog(rentalId: rentalId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actionsOverflowDirection: VerticalDirection.down,
      title: const Row(
        children: [
          Icon(Icons.check_circle, color: AppColors.success, size: 28),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Quyết toán thành công!',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: const Text(
        'Chuyến đi đã hoàn tất và tiền cọc còn lại đang được hoàn trả tự động theo quy định. '
        'Hóa đơn quyết toán chi tiết đã được gửi tới email của bạn.',
        style: TextStyle(fontSize: 13, height: 1.4),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.goNamed(AppRoute.home.name);
            }
          },
          child: const Text('Đóng'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
            if (rentalId != null && rentalId! > 0) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (_) => RentalDetailPage(rentalId: rentalId!),
                ),
              );
            } else if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.goNamed(AppRoute.home.name);
            }
          },
          child: const Text('Xem lại đơn thuê'),
        ),
      ],
    );
  }
}
