import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/booking/domain/entities/booking_fee_entity.dart';
import 'package:rental_car/features/booking/domain/entities/vehicle_booking_summary.dart';
import 'package:rental_car/features/booking/presentation/providers/booking_form_controller.dart';
import 'package:rental_car/features/booking/presentation/providers/booking_form_state.dart';
import 'package:rental_car/features/booking/presentation/providers/booking_providers.dart';
import 'package:rental_car/features/booking/presentation/utils/booking_formatters.dart';
import 'package:rental_car/features/booking/presentation/widgets/rental_schedule_bottom_sheet.dart';

/// Trang Chi tiết xe & Đặt chuyến (Hiện thực hóa 100% theo stitch_car_detail.html)
class VehicleDetailPage extends ConsumerStatefulWidget {
  const VehicleDetailPage({required this.vehicleId, super.key});

  final String vehicleId;

  @override
  ConsumerState<VehicleDetailPage> createState() => _VehicleDetailPageState();
}

class _VehicleDetailPageState extends ConsumerState<VehicleDetailPage> {
  int _activeImageIndex = 0;
  VehicleBookingSummary? _vehicleDetail;
  bool _isLoadingVehicle = true;
  String? _vehicleError;

  @override
  void initState() {
    super.initState();
    _fetchVehicleDetail();
  }

  Future<void> _fetchVehicleDetail() async {
    setState(() {
      _isLoadingVehicle = true;
      _vehicleError = null;
    });

    final repo = ref.read(bookingRepositoryProvider);
    final result =
        await repo.getVehicleDetail(int.tryParse(widget.vehicleId) ?? 1);

    if (!mounted) return;

    result.when(
      ok: (vehicle) {
        setState(() {
          _vehicleDetail = vehicle;
          _isLoadingVehicle = false;
        });
        // Khởi tạo xe vào BookingFormController để tự động tính phí thật qua API
        ref.read(bookingFormControllerProvider.notifier).initVehicle(vehicle);
      },
      err: (failure) {
        setState(() {
          _isLoadingVehicle = false;
          _vehicleError = failure.message;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final BookingFormState bookingState =
        ref.watch(bookingFormControllerProvider);
    final BookingFormController bookingController =
        ref.read(bookingFormControllerProvider.notifier);

    if (_isLoadingVehicle) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chi tiết xe')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Đang tải thông tin xe từ hệ thống...',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    if (_vehicleError != null || _vehicleDetail == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chi tiết xe')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 56, color: AppColors.error),
                const SizedBox(height: 16),
                Text(
                  _vehicleError ?? 'Không tìm thấy thông tin xe.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchVehicleDetail,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final VehicleBookingSummary vehicle = _vehicleDetail!;
    final BookingFeeEntity? fee = bookingState.feeBreakdown;
    final int totalRent = bookingState.estimatedTotalRent;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          vehicle.name.toUpperCase(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- 1. Gallery Slider ---
            Stack(
              children: [
                Container(
                  height: 230,
                  width: double.infinity,
                  color: Colors.black,
                  child: PageView(
                    onPageChanged: (index) {
                      setState(() => _activeImageIndex = index);
                    },
                    children: [
                      Image.network(
                        vehicle.imageUrl ??
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuDiVxOjLTj5JjghKDMPBd4UdJ_tVbMRIeMLtOgIdtKfkOojv_PO48hcEhHu1lCas852tOakhx5EzvZJr18RncORxAd4wzE7iOCrGu_pPeT-2UMEUMKEpG3yg41U4Hlgx7U25hQTa-DQRn9VBaL14InoB6SsnBprAJMduwVP7G4v3VwNRuYGwPChVd6ICkoZKdZb8VD9ArMtDvKRmJ_hfeO9hL7cMcvEW-Tl6bD6UBZ3wkMr1XAQC9z4mSM3WB7MLeiiIcw',
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.directions_car,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.photo_camera,
                            color: Colors.white, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          '${_activeImageIndex + 1}/1',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 2. Identity Header ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vehicle.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    size: 15, color: Color(0xFF2563EB)),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    vehicle.location,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.share, size: 13, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(
                              'Chia sẻ',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // --- 3. Self-pickup Smart Banner (Badge Tự nhận xe thông minh) ---
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.key,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tự nhận xe thông minh',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                              SizedBox(height: 6),
                              _CheckItem(
                                  text:
                                      'Tối ưu chi phí khi thuê gói linh hoạt theo giờ'),
                              SizedBox(height: 4),
                              _CheckItem(
                                  text:
                                      'Nhận và trả xe chủ động 100% qua ứng dụng e-Motion'),
                              SizedBox(height: 4),
                              _CheckItem(
                                  text:
                                      'Đặt xe nhanh chóng, nhận xe ngay không chờ duyệt đơn'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- 4. Reference Pricing Packages ---
                  const Text(
                    'BẢNG GIÁ THAM KHẢO',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 2.2,
                    children: [
                      _PricePackageCard(
                        title: 'Gói 4 giờ',
                        price: BookingFormatters.formatCurrency(vehicle.price4h),
                        isHighlight: false,
                      ),
                      _PricePackageCard(
                        title: 'Gói 8 giờ',
                        price: BookingFormatters.formatCurrency(vehicle.price8h),
                        isHighlight: true,
                        badge: '-328K',
                      ),
                      _PricePackageCard(
                        title: 'Gói 12 giờ',
                        price: BookingFormatters.formatCurrency(vehicle.price12h),
                        isHighlight: false,
                      ),
                      _PricePackageCard(
                        title: 'Gói 24 giờ (1 ngày)',
                        price: BookingFormatters.formatCurrency(vehicle.price24h),
                        isHighlight: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // --- 5. Rental Schedule Selector ---
                  const Text(
                    'THỜI GIAN THUÊ XE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.calendar_today,
                              color: Color(0xFF2563EB), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Thời gian chọn (${bookingState.rentalHours} giờ)',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                BookingFormatters.formatDateTime(
                                    bookingState.startDateTime),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                BookingFormatters.formatDateTime(
                                    bookingState.endDateTime),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2563EB),
                            side: const BorderSide(color: Color(0xFF93C5FD)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          onPressed: () {
                            RentalScheduleBottomSheet.show(
                              context: context,
                              initialStart: bookingState.startDateTime,
                              initialEnd: bookingState.endDateTime,
                              onScheduleChanged: (start, end) {
                                bookingController.updateRentalSchedule(
                                    start, end);
                              },
                            );
                          },
                          child: const Text('Đổi lịch'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- 6. Chi nhánh nhận & trả xe (Trạm xe e-Motion) ---
                  const Text(
                    'CHI NHÁNH NHẬN & TRẢ XE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.ev_station,
                                color: Color(0xFF2563EB),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          vehicle.stationName ?? 'Chi nhánh e-Motion',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFDBEAFE),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: const Text(
                                          'Chi nhánh',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1D4ED8),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    vehicle.stationAddress ??
                                        vehicle.location,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.info_outline,
                                  size: 15, color: Color(0xFF2563EB)),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Quý khách nhận xe và hoàn trả xe trực tiếp tại chi nhánh này.',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: Color(0xFF334155),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- 7. Insurance Card (Đã bao gồm mặc định) ---
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.shield_outlined,
                                color: Color(0xFF16A34A), size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Bảo hiểm chuyến đi an tâm',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Bảo hiểm vật chất thân xe và bảo hiểm bắt buộc TNDS đã được bao gồm sẵn trong giá thuê xe của e-Motion.',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            border: Border.all(color: const Color(0xFF86EFAC)),
                          ),
                          child: const Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Đã bao gồm trong gói thuê • An tâm trọn hành trình',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF15803D),
                                  ),
                                ),
                              ),
                              Icon(Icons.check_circle,
                                  color: Color(0xFF16A34A), size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- 8. Price Breakdown Card (Dữ liệu từ API Backend) ---
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'CHI TIẾT THANH TOÁN',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (bookingState.isCalculatingFee)
                              const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                          ],
                        ),
                        const Divider(height: 20),
                        _FeeRow(
                          label: 'Phí thuê xe (${bookingState.rentalHours} giờ)',
                          value: BookingFormatters.formatCurrency(
                              fee?.bookingCost ?? vehicle.price4h),
                        ),
                        const SizedBox(height: 8),
                        _FeeRow(
                          label: 'Tiền cọc thế chấp (hoàn trả khi trả xe)',
                          value: BookingFormatters.formatCurrency(
                              fee?.collateralFee ??
                                  ((vehicle.depositFee != null &&
                                          vehicle.depositFee! > 0)
                                      ? vehicle.depositFee!.toInt()
                                      : 3000000)),
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tổng tiền thuê',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              BookingFormatters.formatCurrency(totalRent),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Cọc giữ chỗ & thế chấp info
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Tiền giữ chỗ trực tuyến:',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    BookingFormatters.formatCurrency(
                                        fee?.holdDepositFee ?? 500000),
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '• Tiền giữ chỗ để xác nhận đơn, sẽ hoàn trả 100% hoặc cấn trừ tiền cọc khi nhận xe.',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Cọc tài sản thế chấp:',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    BookingFormatters.formatCurrency(
                                        fee?.collateralFee ?? 3000000),
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                '• Thanh toán lúc nhận xe hoặc để lại xe máy & giấy tờ xe chính chủ.',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- 9. Specs Grid ---
                  const Text(
                    'ĐẶC ĐIỂM XE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 2.8,
                    children: [
                      _SpecBox(
                        icon: Icons.people_outline,
                        label: 'Số ghế',
                        value: '${vehicle.seats} chỗ',
                      ),
                      _SpecBox(
                        icon: Icons.settings_suggest_outlined,
                        label: 'Truyền động',
                        value: vehicle.transmission,
                      ),
                      _SpecBox(
                        icon: Icons.bolt_outlined,
                        label: 'Nhiên liệu',
                        value: vehicle.fuelType,
                      ),
                      _SpecBox(
                        icon: Icons.battery_charging_full_outlined,
                        label: 'Pin / Tiêu hao',
                        value: '${vehicle.batteryCapacity} kWh',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // --- 10. Cancellation Policy Table ---
                  const Text(
                    'CHÍNH SÁCH HUỶ CHUYẾN',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: const Column(
                      children: [
                        _PolicyRow(
                          rule: 'Hoàn 100% cọc',
                          regular: 'Trước > 10 ngày',
                          holiday: 'Không áp dụng',
                          iconColor: Colors.green,
                        ),
                        Divider(height: 1),
                        _PolicyRow(
                          rule: 'Hoàn 30% cọc',
                          regular: 'Trước > 5 ngày',
                          holiday: 'Trước > 30 ngày',
                          iconColor: Colors.amber,
                        ),
                        Divider(height: 1),
                        _PolicyRow(
                          rule: 'Không hoàn cọc',
                          regular: 'Trong vòng 5 ngày',
                          holiday: 'Trong vòng 30 ngày',
                          iconColor: Colors.red,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),

      // --- 11. Sticky Bottom Bar ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tổng tiền thuê',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        BookingFormatters.formatCurrency(totalRent),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '/ ${bookingState.rentalHours} giờ',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                onPressed: () {
                  // Chuyển sang màn hình xác nhận thông tin trước khi giữ chỗ
                  context.pushNamed(AppRoute.booking.name);
                },
                icon: const Icon(Icons.bolt, size: 18),
                label: const Text(
                  'Thuê xe ngay',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Supporting UI Components for Car Detail ---
class _CheckItem extends StatelessWidget {
  const _CheckItem({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check, size: 14, color: Color(0xFF2563EB)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B)),
          ),
        ),
      ],
    );
  }
}

class _PricePackageCard extends StatelessWidget {
  const _PricePackageCard({
    required this.title,
    required this.price,
    required this.isHighlight,
    this.badge,
  });

  final String title;
  final String price;
  final bool isHighlight;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isHighlight ? const Color(0xFFEFF6FF) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isHighlight ? const Color(0xFF2563EB) : AppColors.border,
          width: isHighlight ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isHighlight
                        ? const Color(0xFF1D4ED8)
                        : AppColors.textSecondary,
                  ),
                ),
              ),
              if (badge != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            price,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color:
                  isHighlight ? const Color(0xFF1D4ED8) : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}


class _FeeRow extends StatelessWidget {
  const _FeeRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style:
                const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _SpecBox extends StatelessWidget {
  const _SpecBox({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF2563EB)),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PolicyRow extends StatelessWidget {
  const _PolicyRow({
    required this.rule,
    required this.regular,
    required this.holiday,
    required this.iconColor,
  });

  final String rule;
  final String regular;
  final String holiday;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              rule,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              regular,
              style: const TextStyle(fontSize: 11, color: Colors.black87),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              holiday,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
