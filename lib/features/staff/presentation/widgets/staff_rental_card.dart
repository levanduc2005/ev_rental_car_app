import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';

class StaffRentalCard extends StatelessWidget {
  const StaffRentalCard({
    super.key,
    required this.rental,
    required this.onTapDetail,
    this.onTapAction,
  });

  final RentalDetailEntity rental;
  final VoidCallback onTapDetail;
  final VoidCallback? onTapAction;

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return const Color(0xFFD97706);
      case 'CONTRACTING':
        return const Color(0xFF8B5CF6);
      case 'CONFIRM':
        return const Color(0xFF16A34A);
      case 'ONGOING':
        return const Color(0xFF2563EB);
      case 'OVERDUE':
        return const Color(0xFFDC2626);
      case 'COMPLETED':
        return const Color(0xFF059669);
      default:
        return const Color(0xFF64748B);
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Chờ ký HĐ';
      case 'CONTRACTING':
        return 'Đang ký HĐ';
      case 'CONFIRM':
        return 'Chờ bàn giao';
      case 'ONGOING':
        return 'Đang di chuyển';
      case 'OVERDUE':
        return 'Quá hạn trả';
      case 'COMPLETED':
        return 'Hoàn tất';
      default:
        return status;
    }
  }

  String _getActionLabel(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Ký hợp đồng DocuSeal (Bước 2)';
      case 'CONTRACTING':
        return 'Ký hợp đồng & Thanh toán (Bước 2 - 3)';
      case 'CONFIRM':
        return 'Kiểm tra xe & Bàn giao (Bước 4)';
      case 'ONGOING':
        return 'Xem tiến trình các bước (Hoàn tất)';
      default:
        return 'Xem tiến trình các bước';
    }
  }

  IconData _getActionIcon(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
      case 'CONTRACTING':
        return Icons.edit_document;
      case 'CONFIRM':
        return Icons.camera_alt_outlined;
      default:
        return Icons.arrow_forward_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(rental.status);
    final statusLabel = _getStatusLabel(rental.status);
    final actionLabel = _getActionLabel(rental.status);
    final actionIcon = _getActionIcon(rental.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTapAction ?? onTapDetail,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Mã đơn + Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Đơn #${rental.id}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF334155),
                            ),
                          ),
                        ),
                        if (rental.vehiclePlateNumber != null) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: const Color(0xFFBFDBFE),
                              ),
                            ),
                            child: Text(
                              rental.vehiclePlateNumber!,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E40AF),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 18),

                // Thông tin xe & khách
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child:
                          (rental.vehicleImage != null &&
                              rental.vehicleImage!.startsWith('http'))
                          ? Image.network(
                              rental.vehicleImage!,
                              width: 64,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => _buildPlaceholder(),
                            )
                          : _buildPlaceholder(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rental.vehicleName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          if (rental.userEmail != null)
                            Text(
                              'Khách: ${rental.userEmail}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (rental.currentBattery != null)
                            Text(
                              'Pin: ${rental.currentBattery!.toInt()}%',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF16A34A),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Nút hành động: Chi tiết & Tiếp tục các bước bàn giao
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2563EB),
                          side: const BorderSide(color: Color(0xFFBFDBFE)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: onTapDetail,
                        icon: const Icon(Icons.visibility_outlined, size: 15),
                        label: const Text(
                          'Chi tiết',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: statusColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: onTapAction ?? onTapDetail,
                        icon: Icon(actionIcon, size: 15),
                        label: Text(
                          actionLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 64,
      height: 48,
      color: const Color(0xFFEFF6FF),
      child: const Center(
        child: Icon(Icons.directions_car_rounded, color: Color(0xFF2563EB)),
      ),
    );
  }
}
