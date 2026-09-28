import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/features/booking/presentation/providers/booking_form_controller.dart';
import 'package:rental_car/features/booking/presentation/widgets/rental_schedule_bottom_sheet.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:rental_car/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:rental_car/features/vehicles/presentation/widgets/vehicle_detail_carousel.dart';
import 'package:rental_car/features/vehicles/presentation/widgets/vehicle_detail_sections.dart';
import 'package:rental_car/features/vehicles/presentation/widgets/vehicle_price_package_grid.dart';

/// Màn hình Chi tiết xe & Đặt chuyến (Slide 10 - Chi tiết xe & Đặt chuyến)
class VehicleDetailPage extends ConsumerStatefulWidget {
  const VehicleDetailPage({required this.vehicleId, super.key});

  final String vehicleId;

  @override
  ConsumerState<VehicleDetailPage> createState() => _VehicleDetailPageState();
}

class _VehicleDetailPageState extends ConsumerState<VehicleDetailPage> {
  String _selectedPackageId = '8h';
  int _selectedLocationIndex = 0;
  bool _isInsuranceSelected = true;
  late DateTime _startDateTime;
  late DateTime _endDateTime;

  @override
  void initState() {
    super.initState();
    final filter = ref.read(vehicleFilterProvider);
    if (filter.hourPackage != null && filter.hourPackage! > 0) {
      _selectedPackageId = '${filter.hourPackage}h';
    } else if (filter.durationHours <= 4) {
      _selectedPackageId = '4h';
    } else if (filter.durationHours <= 8) {
      _selectedPackageId = '8h';
    } else if (filter.durationHours <= 12) {
      _selectedPackageId = '12h';
    } else {
      _selectedPackageId = '24h';
    }

    if (filter.startTime != null && filter.endTime != null) {
      _startDateTime = filter.startTime!;
      _endDateTime = filter.endTime!;
    } else {
      final now = DateTime.now();
      _startDateTime = DateTime(now.year, now.month, now.day + 1, 14);
      final hours = _getPackageHours(_selectedPackageId);
      _endDateTime = _startDateTime.add(Duration(hours: hours));
    }
  }

  void _onPackageSelected(String id) {
    setState(() {
      _selectedPackageId = id;
      final hours = _getPackageHours(id);
      _endDateTime = _startDateTime.add(Duration(hours: hours));
    });
  }

  void _openSchedulePicker() {
    RentalScheduleBottomSheet.show(
      context: context,
      initialStart: _startDateTime,
      initialEnd: _endDateTime,
      onScheduleChanged: (start, end) {
        setState(() {
          _startDateTime = start;
          _endDateTime = end;
          final diffHours = end.difference(start).inHours;
          if (diffHours <= 4) {
            _selectedPackageId = '4h';
          } else if (diffHours <= 8) {
            _selectedPackageId = '8h';
          } else if (diffHours <= 12) {
            _selectedPackageId = '12h';
          } else {
            _selectedPackageId = '24h';
          }
        });
      },
    );
  }

  double _getPackageRentalFee(VehicleEntity detail, String packageId) {
    final dayPrice = detail.pricePerDay ?? (detail.salePriceK * 1000.0);
    switch (packageId) {
      case '4h':
        return detail.pricePer4Hours ?? (dayPrice * 0.45).roundToDouble();
      case '8h':
        return detail.pricePer8Hours ?? (dayPrice * 0.70).roundToDouble();
      case '12h':
        return detail.pricePer12Hours ?? (dayPrice * 0.85).roundToDouble();
      case '24h':
      default:
        return dayPrice;
    }
  }

  int _getPackageHours(String packageId) {
    switch (packageId) {
      case '4h':
        return 4;
      case '8h':
        return 8;
      case '12h':
        return 12;
      case '24h':
      default:
        return 24;
    }
  }

  String _getPackageDurationLabel(String packageId) {
    switch (packageId) {
      case '4h':
        return '4 giờ';
      case '8h':
        return '8 giờ';
      case '12h':
        return '12 giờ';
      case '24h':
      default:
        return '24 giờ (1 ngày)';
    }
  }

  String _formatTimeRange(DateTime start, DateTime end) {
    String formatDt(DateTime dt) {
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      final d = dt.day.toString().padLeft(2, '0');
      final mo = dt.month.toString().padLeft(2, '0');
      final y = dt.year;
      return '$h:$m, $d/$mo/$y';
    }

    return '${formatDt(start)} - ${formatDt(end)}';
  }

  String _formatVnd(double val) {
    final str = val.round().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '$strđ';
  }

  void _onBookNow(
    VehicleEntity vehicle,
    double calculatedTotal,
    double calculatedRentalFee,
  ) {
    // Đồng bộ thời gian nhận - trả xe vào BookingFormController để flow Booking kế thừa chính xác
    try {
      ref
          .read(bookingFormControllerProvider.notifier)
          .updateRentalSchedule(_startDateTime, _endDateTime);
    } catch (_) {}

    final extraId = int.tryParse(vehicle.id) ?? 1;
    context.pushNamed(AppRoute.booking.name, extra: extraId);
  }

  @override
  Widget build(BuildContext context) {
    final vehicleDetailAsync = ref.watch(
      vehicleDetailControllerProvider(widget.vehicleId),
    );

    return vehicleDetailAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(
        appBar: AppBar(title: const Text('Chi tiết xe')),
        body: Center(child: Text('Lỗi: $err')),
      ),
      data: (detail) {
        final images = detail.imageUrls ?? [detail.imageUrl];

        // Tính toán chi phí động theo gói thời gian thuê và tùy chọn
        final rentalFee = _getPackageRentalFee(detail, _selectedPackageId);
        final locationFee = (_selectedLocationIndex == 1) ? 150000.0 : 0.0;
        final insuranceFee = _isInsuranceSelected
            ? (rentalFee * 0.08).roundToDouble()
            : 0.0;
        final discountAmount = (rentalFee * 0.10)
            .roundToDouble(); // Voucher 10%
        final vatAmount =
            ((rentalFee + locationFee + insuranceFee - discountAmount) * 0.10)
                .roundToDouble();
        final totalRental =
            rentalFee + locationFee + insuranceFee - discountAmount + vatAmount;
        final durationLabel = _getPackageDurationLabel(_selectedPackageId);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
              onPressed: () => context.pop(),
            ),
            title: Text(
              detail.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.share_outlined,
                  color: Color(0xFF0F172A),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã sao chép liên kết xe!')),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. CAROUSEL ẢNH XE KÈM NÚT VR 360
                VehicleDetailCarousel(imageUrls: images),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. TÊN XE, NÚT CHIA SẺ & ĐỊA ĐIỂM
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              detail.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.share_outlined,
                                  size: 14,
                                  color: Color(0xFF64748B),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Chia sẻ',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF475569),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Địa điểm
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Color(0xFF1976D2),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            detail.location,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 3. BANNER "TỰ NHẬN XE THÔNG MINH"
                      const SmartPickupBanner(),
                      const SizedBox(height: 20),

                      // 4. BẢNG GIÁ THAM KHẢO (Động theo giá xe và phản hồi khi nhấn chọn)
                      VehiclePricePackageGrid(
                        selectedPackageId: _selectedPackageId,
                        price4h: detail.pricePer4Hours,
                        price8h: detail.pricePer8Hours,
                        price12h: detail.pricePer12Hours,
                        price24h: detail.pricePerDay,
                        onSelectPackage: _onPackageSelected,
                      ),
                      const SizedBox(height: 20),

                      // 5. THỜI GIAN THUÊ XE
                      RentalTimeCard(
                        durationText: 'Thời gian thuê ($durationLabel)',
                        timeRangeText: _formatTimeRange(
                          _startDateTime,
                          _endDateTime,
                        ),
                        onChangeSchedule: _openSchedulePicker,
                      ),
                      const SizedBox(height: 20),

                      // 6. VỊ TRÍ NHẬN & TRẢ XE
                      LocationSelectorCard(
                        selectedLocationIndex: _selectedLocationIndex,
                        onLocationChanged: (index) {
                          setState(() {
                            _selectedLocationIndex = index;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // 7. BẢO HIỂM CHUYẾN ĐI AN TÂM
                      TripInsuranceCard(
                        isSelected: _isInsuranceSelected,
                        onToggle: () {
                          setState(() {
                            _isInsuranceSelected = !_isInsuranceSelected;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // 8. CHI TIẾT THANH TOÁN (Cập nhật động theo gói và tùy chọn)
                      PricingBreakdownCard(
                        rentalDurationLabel: 'Phí thuê xe ($durationLabel)',
                        rentalFeeText: _formatVnd(rentalFee),
                        locationFeeText: (_selectedLocationIndex == 1)
                            ? '+150.000đ'
                            : null,
                        insuranceFeeText: _isInsuranceSelected
                            ? _formatVnd(insuranceFee)
                            : '0đ (Không chọn)',
                        discountText: '-${_formatVnd(discountAmount)}',
                        vatText: _formatVnd(vatAmount),
                        totalRentalText: _formatVnd(totalRental),
                        holdingDepositText: detail.holdingDeposit ?? '500.000đ',
                        collateralDepositText:
                            detail.collateralDeposit ?? '3.000.000đ',
                      ),
                      const SizedBox(height: 20),

                      // 9. PHỤ PHÍ CÓ THỂ PHÁT SINH
                      const AdditionalFeesCard(),
                      const SizedBox(height: 20),

                      // 10. ĐẶC ĐIỂM XE
                      VehicleSpecsGrid(
                        seats: '${detail.seats} chỗ',
                        transmission: detail.transmission,
                        fuelType: detail.fuelType,
                        consumption: detail.consumption ?? '6.3L / 100km',
                      ),
                      const SizedBox(height: 20),

                      // 11. MÔ TẢ XE
                      const Text(
                        'Mô tả',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        detail.description ??
                            'Xe đời mới, trang bị hiện đại, vận hành êm ái và tiết kiệm.',
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 12. VỊ TRÍ XE TRÊN BẢN ĐỒ PREVIEW
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Vị trí xe',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              detail.location.split('•').first.trim(),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1976D2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=800&auto=format&fit=crop',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1976D2),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.directions_car_filled,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Vị trí ${detail.name}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 13. CÁC TIỆN NGHI KHÁC
                      const AmenitiesSection(),
                      const SizedBox(height: 20),

                      // 14. CHÍNH SÁCH HUỶ CHUYẾN
                      const CancellationPolicyTable(),
                      const SizedBox(height: 20),

                      // 15. THÔNG TIN CHỦ XE
                      const Text(
                        'Thông tin chủ xe',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1976D2),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  'e',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Vận hành bởi e-Motion',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(
                                        Icons.verified,
                                        size: 16,
                                        color: Color(0xFF1976D2),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Xe tự lái thông minh, hỗ trợ kỹ thuật 24/7',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Khoảng đệm tránh bị che bởi thanh Sticky Bottom Bar
                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 16. STICKY BOTTOM BAR (THANH ĐẶT XE CỐ ĐỊNH PHÍA DƯỚI)
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
                border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                children: [
                  // Thông tin giá bên trái
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Tổng tiền thuê',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2FE),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Thanh toán',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0284C7),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: _formatVnd(totalRental),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1976D2),
                                ),
                              ),
                              TextSpan(
                                text: ' / $durationLabel',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Nút Thuê xe bên phải -> Điều hướng sang Booking của Khang
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _onBookNow(detail, totalRental, rentalFee),
                    icon: const Icon(
                      Icons.bolt_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Thuê xe',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
