import 'package:flutter/material.dart';

/// Hộp thông báo "Tự nhận xe thông minh" (Slide 10)
class SmartPickupBanner extends StatelessWidget {
  const SmartPickupBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF1976D2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.vpn_key_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Tự nhận xe thông minh',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildCheckItem('Tối ưu chi phí khi thuê gói linh hoạt theo giờ'),
          const SizedBox(height: 4),
          _buildCheckItem('Nhận xe và mở rộng 100% qua ứng dụng e-Motion'),
          const SizedBox(height: 4),
          _buildCheckItem(
            'Đặt xe nhanh chóng, nhận xe ngay không chờ duyệt đơn',
          ),
          const SizedBox(height: 8),
          const Text(
            'Cách thức hoạt động >',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1976D2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check, size: 15, color: Color(0xFF1976D2)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF334155),
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

/// Phần chọn thời gian thuê xe (Slide 10)
class RentalTimeCard extends StatelessWidget {
  const RentalTimeCard({
    required this.durationText,
    required this.timeRangeText,
    required this.onChangeSchedule,
    super.key,
  });

  final String durationText;
  final String timeRangeText;
  final VoidCallback onChangeSchedule;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'THỜI GIAN THUÊ XE',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Color(0xFF64748B),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_month_outlined,
                  color: Color(0xFF1976D2),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      durationText,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      timeRangeText,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: onChangeSchedule,
                child: const Text(
                  'Đổi lịch',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1976D2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Phần Vị trí nhận & trả xe (Slide 10)
class LocationSelectorCard extends StatelessWidget {
  const LocationSelectorCard({
    required this.selectedLocationIndex,
    required this.onLocationChanged,
    super.key,
  });

  final int selectedLocationIndex;
  final ValueChanged<int> onLocationChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'VỊ TRÍ NHẬN & TRẢ XE',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Color(0xFF64748B),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),

        // Lựa chọn 1: Khách nhận tại vị trí xe đậu (Miễn phí)
        _buildLocationOption(
          index: 0,
          title: 'Khách nhận tại vị trí xe đậu',
          badgeText: 'Miễn phí',
          address:
              '29D/38, đường Thống Nhất, Phường Bình An, TP. Dĩ An, Bình Dương',
          note:
              'Địa điểm xe mát có mái che & quạt, khi nhận cần thanh toán cọc xe 24/24.',
        ),
        const SizedBox(height: 10),

        // Lựa chọn 2: e-Motion giao & nhận xe tận nơi (+150.000đ)
        _buildLocationOption(
          index: 1,
          title: 'e-Motion giao & nhận xe tận nơi',
          badgeText: '+150.000đ',
          badgeColor: const Color(0xFFEA580C),
          address:
              'VRG2+57M, Lưu Hữu Phước, P. Đông Hòa, Dĩ An / TP. Thủ Đức, TP. HCM',
          note: 'Nhân viên giao nhận xe trong bán kính 15km.',
        ),
      ],
    );
  }

  Widget _buildLocationOption({
    required int index,
    required String title,
    required String badgeText,
    required String address,
    required String note,
    Color? badgeColor,
  }) {
    final isSelected = selectedLocationIndex == index;

    return InkWell(
      onTap: () => onLocationChanged(index),
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF8FAFC) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1976D2)
                : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  size: 20,
                  color: isSelected
                      ? const Color(0xFF1976D2)
                      : const Color(0xFF94A3B8),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: (badgeColor ?? const Color(0xFF1976D2)).withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: badgeColor ?? const Color(0xFF1976D2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Color(0xFF64748B),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    address,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF475569),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              note,
              style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bảo hiểm chuyến đi an tâm (Slide 10)
class TripInsuranceCard extends StatelessWidget {
  const TripInsuranceCard({
    required this.isSelected,
    required this.onToggle,
    super.key,
  });

  final bool isSelected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.shield_outlined, size: 20, color: Color(0xFF1976D2)),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Bảo hiểm chuyến đi an tâm',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              Icon(Icons.info_outline, size: 16, color: Color(0xFF94A3B8)),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Bảo hiểm toàn diện bao gồm: Vật chất thân vỏ và Bảo hiểm Người ngồi trên xe trong suốt hành trình.',
            style: TextStyle(
              fontSize: 11.5,
              color: Color(0xFF64748B),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),

          // Gói bảo vệ nâng cao
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F7FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1976D2)
                      : const Color(0xFFE2E8F0),
                  width: isSelected ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Bảo vệ nâng cao',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1976D2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Khuyên dùng',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          '64.217đ / ngày',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1976D2),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Bao gồm trọn bộ 18 quyền lợi bảo hiểm.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Xem chi tiết quyền lợi',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1976D2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isSelected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: isSelected
                        ? const Color(0xFF1976D2)
                        : const Color(0xFF94A3B8),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Đổi gói bảo hiểm khác ⌵',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1976D2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Chi tiết thanh toán (Slide 10)
class PricingBreakdownCard extends StatelessWidget {
  const PricingBreakdownCard({
    required this.rentalFeeText,
    required this.insuranceFeeText,
    required this.discountText,
    required this.vatText,
    required this.totalRentalText,
    required this.holdingDepositText,
    required this.collateralDepositText,
    this.rentalDurationLabel = 'Phí thuê xe (8 giờ)',
    this.locationFeeText,
    super.key,
  });

  final String rentalFeeText;
  final String insuranceFeeText;
  final String discountText;
  final String vatText;
  final String totalRentalText;
  final String holdingDepositText;
  final String collateralDepositText;
  final String rentalDurationLabel;
  final String? locationFeeText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CHI TIẾT THANH TOÁN',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF64748B),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildRow(rentalDurationLabel, rentalFeeText, hasInfoIcon: true),
          if (locationFeeText != null) ...[
            const SizedBox(height: 8),
            _buildRow('Phí giao nhận tận nơi', locationFeeText!),
          ],
          const SizedBox(height: 8),
          _buildRow('Phí bảo hiểm chuyến đi', insuranceFeeText),
          const SizedBox(height: 8),

          // Mã giảm giá voucher
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🎟️ ', style: TextStyle(fontSize: 11)),
                    Text(
                      'EMOTIONBANMOI (-10%)',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                discountText,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEF4444),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildRow('Thuế GTGT (VAT 10%)', vatText),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFE2E8F0)),
          ),

          // Tổng tiền thuê
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng tiền thuê',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                totalRentalText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1976D2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Tiền giữ chỗ
          _buildRow('Tiền giữ chỗ', holdingDepositText, hasInfoIcon: true),
          const SizedBox(height: 2),
          const Text(
            'Tiền giữ chỗ không phải phụ phí và sẽ được hoàn lại 100% sau chuyến đi.',
            style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 12),

          // Cọc khi nhận xe
          _buildRow('Cọc khi nhận xe (thế chấp)', collateralDepositText),
          const SizedBox(height: 2),
          const Text(
            'Thanh toán khi nhận xe hoặc gửi lại xe máy & giấy tờ xe chính chủ.',
            style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool hasInfoIcon = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
              if (hasInfoIcon) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.info_outline,
                  size: 14,
                  color: Color(0xFF94A3B8),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}

/// Phụ phí có thể phát sinh (Slide 10)
class AdditionalFeesCard extends StatelessWidget {
  const AdditionalFeesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: Color(0xFF1976D2),
              ),
              SizedBox(width: 6),
              Text(
                'PHỤ PHÍ CÓ THỂ PHÁT SINH',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1976D2),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildFeeItem(
            stepNumber: '1',
            title: 'Phí vượt định mức di chuyển',
            feeRight: '5.000 đ/km',
            desc:
                'Giới hạn 400km/ngày (hoặc 20km/giờ). Quá 400km: 5.000đ/km. Thu thêm trên mỗi km vượt.',
          ),
          const SizedBox(height: 12),
          _buildFeeItem(
            stepNumber: '2',
            title: 'Phí cầu đường (VETC / ePass)',
            desc:
                'Thanh toán đúng số tiền thực tế phát sinh trên tài khoản thu phí tự động trong hành trình.',
          ),
          const SizedBox(height: 12),
          _buildFeeItem(
            stepNumber: '3',
            title: 'Phụ thu chênh lệch nhiên liệu',
            feeRight: '120% giá thị trường',
            desc:
                'Áp dụng nếu mức xăng/pin khi trả thấp hơn mức ban đầu lúc nhận xe.',
          ),
        ],
      ),
    );
  }

  Widget _buildFeeItem({
    required String stepNumber,
    required String title,
    required String desc,
    String? feeRight,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Color(0xFFE0F2FE),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              stepNumber,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0284C7),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  if (feeRight != null)
                    Text(
                      feeRight,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF64748B),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Đặc điểm xe (Slide 10)
class VehicleSpecsGrid extends StatelessWidget {
  const VehicleSpecsGrid({
    required this.seats,
    required this.transmission,
    required this.fuelType,
    required this.consumption,
    super.key,
  });

  final String seats;
  final String transmission;
  final String fuelType;
  final String consumption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Đặc điểm xe',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildSpecCard(
                icon: Icons.group_outlined,
                label: 'Số ghế',
                value: seats,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSpecCard(
                icon: Icons.tune_rounded,
                label: 'Truyền động',
                value: transmission,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildSpecCard(
                icon: Icons.local_gas_station_outlined,
                label: 'Nhiên liệu',
                value: fuelType,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSpecCard(
                icon: Icons.speed_rounded,
                label: 'Tiêu hao',
                value: consumption,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F7FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF1976D2), size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Tiện nghi khác (Slide 10)
class AmenitiesSection extends StatelessWidget {
  const AmenitiesSection({super.key});

  static const List<Map<String, dynamic>> amenities = [
    {'icon': Icons.bluetooth_rounded, 'name': 'Bluetooth'},
    {'icon': Icons.center_focus_strong_rounded, 'name': 'Camera 360'},
    {'icon': Icons.videocam_outlined, 'name': 'Camera hành trình'},
    {'icon': Icons.tire_repair_rounded, 'name': 'Cảm biến lốp'},
    {'icon': Icons.navigation_outlined, 'name': 'Định vị GPS'},
    {'icon': Icons.warning_amber_rounded, 'name': 'Cảnh báo tốc độ'},
    {'icon': Icons.credit_card_outlined, 'name': 'Thu phí tự động ETC'},
    {'icon': Icons.camera_rear_outlined, 'name': 'Camera lùi'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Các tiện nghi khác',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: amenities.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3.8,
          ),
          itemBuilder: (context, index) {
            final item = amenities[index];
            return Row(
              children: [
                Icon(
                  item['icon'] as IconData,
                  size: 18,
                  color: const Color(0xFF1976D2),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item['name'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF334155),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Bảng chính sách huỷ chuyến (Slide 10)
class CancellationPolicyTable extends StatelessWidget {
  const CancellationPolicyTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chính sách huỷ chuyến',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Table(
            border: const TableBorder.symmetric(
              inside: BorderSide(color: Color(0xFFF1F5F9)),
            ),
            columnWidths: const {
              0: FlexColumnWidth(1.2),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
            },
            children: [
              // Header
              const TableRow(
                decoration: BoxDecoration(color: Color(0xFFF8FAFC)),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Text(
                      'Quy định',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text(
                      'Ngày thường',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text(
                      'Lễ, Tết',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              // Dòng 1: Hoàn 100%
              _buildTableRow(
                title: '🟢 Hoàn 100% cọc',
                normalDay: 'Trước > 10 ngày',
                holiday: 'Không áp dụng',
              ),
              // Dòng 2: Hoàn 50%
              _buildTableRow(
                title: '🟠 Hoàn 50% cọc',
                normalDay: 'Trước 4-9 ngày',
                holiday: 'Trước > 30 ngày',
              ),
              // Dòng 3: Không hoàn
              _buildTableRow(
                title: '🔴 Không hoàn',
                normalDay: 'Trong vòng 3 ngày',
                holiday: 'Trong vòng 30 ngày',
              ),
            ],
          ),
        ),
      ],
    );
  }

  static TableRow _buildTableRow({
    required String title,
    required String normalDay,
    required String holiday,
  }) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            title,
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Text(
            normalDay,
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF475569)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Text(
            holiday,
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF475569)),
          ),
        ),
      ],
    );
  }
}
