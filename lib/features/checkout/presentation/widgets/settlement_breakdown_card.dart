import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_overview_entity.dart';
import 'package:rental_car/features/checkout/domain/entities/vehicle_damage_item_entity.dart';
import 'package:rental_car/features/checkout/presentation/widgets/settlement_balance_box.dart';

class SettlementBreakdownCard extends StatelessWidget {
  const SettlementBreakdownCard({
    super.key,
    required this.overview,
    required this.checkOutFee,
    required this.vehicleDamageFee,
    required this.totalDeposits,
    required this.balance,
    this.onViewDamageDetail,
    this.vehicleDamages,
  });

  final RentalOverviewEntity? overview;
  final double checkOutFee;
  final double vehicleDamageFee;
  final double totalDeposits;
  final double balance;
  final VoidCallback? onViewDamageDetail;
  final List<VehicleDamageItemEntity>? vehicleDamages;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );

    final damages = (overview != null && overview!.vehicleDamages.isNotEmpty)
        ? overview!.vehicleDamages
        : (vehicleDamages ?? const []);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bảng kê tiền cọc & Phụ phí phát sinh',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20),

            // Tiền cọc đã đóng
            _buildRow(
              'Tiền cọc giữ chỗ ban đầu:',
              currencyFormat.format(overview?.reservationDeposit ?? 0.0),
            ),
            const SizedBox(height: 8),
            _buildRow(
              'Tiền cọc nhận xe (Collateral):',
              currencyFormat.format(overview?.rentalDeposit ?? 0.0),
            ),
            const SizedBox(height: 8),
            _buildRow(
              'Tổng tiền cọc ban đầu:',
              currencyFormat.format(totalDeposits),
              isBold: true,
            ),

            const Divider(height: 24),

            // Phụ phí phát sinh
            const Text(
              'Phụ phí phát sinh khi trả xe:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildRow(
              'Phí phạt trễ giờ & bù sạc pin:',
              checkOutFee > 0
                  ? '-${currencyFormat.format(checkOutFee)}'
                  : '0 đ',
              color: checkOutFee > 0
                  ? AppColors.error
                  : AppColors.textSecondary,
            ),
            const SizedBox(height: 8),

            // Phí hư hại từ VehicleLog
            _buildRow(
              'Phí sửa chữa hư hại (VehicleLog):',
              vehicleDamageFee > 0
                  ? '-${currencyFormat.format(vehicleDamageFee)}'
                  : '0 đ (Không có)',
              color: vehicleDamageFee > 0
                  ? AppColors.error
                  : AppColors.textSecondary,
            ),

            // Danh sách chi tiết từng lỗi hư hỏng nếu có
            if (damages.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: damages.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '• ${item.description}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF991B1B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '-${currencyFormat.format(item.cost)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF991B1B),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

            const Divider(height: 24),

            // BẢNG TỔNG KẾT
            SettlementBalanceBox(balance: balance),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
