import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_providers.dart';
import 'package:rental_car/features/staff/presentation/widgets/staff_reservation_card.dart';

class StaffScannerView extends ConsumerStatefulWidget {
  const StaffScannerView({required this.onStartHandover, super.key});

  final void Function(ReservationEntity reservation) onStartHandover;

  @override
  ConsumerState<StaffScannerView> createState() => _StaffScannerViewState();
}

class _StaffScannerViewState extends ConsumerState<StaffScannerView> {
  final MobileScannerController _scannerController = MobileScannerController();
  final TextEditingController _codeController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  bool _isProcessing = false;
  bool _isTorchOn = false;
  String? _lastScannedCode;
  ReservationEntity? _matchedReservation;
  String? _capturedPhotoPath;

  @override
  void dispose() {
    _scannerController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleBarcode(BarcodeCapture capture) async {
    if (_isProcessing) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final rawValue = barcodes.first.rawValue?.trim();
    if (rawValue == null || rawValue.isEmpty || rawValue == _lastScannedCode) {
      return;
    }

    setState(() {
      _isProcessing = true;
      _lastScannedCode = rawValue;
      _codeController.text = rawValue;
    });

    await _lookupCode(rawValue);

    if (mounted) {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _lookupCode(String code) async {
    final cleanCode = code.trim();
    final reservations = ref
        .read(staffDashboardControllerProvider)
        .reservations;

    // 1. Kiểm tra khớp mã reservation trong danh sách hiện tại
    final matched = reservations.where((r) {
      final codeMatches =
          r.reservationCode.toLowerCase() == cleanCode.toLowerCase();
      final idMatches = r.id.toString() == cleanCode;
      return codeMatches || idMatches;
    }).toList();

    if (matched.isNotEmpty) {
      setState(() {
        _matchedReservation = matched.first;
      });
      return;
    }

    // 2. Nếu chưa có trong danh sách local, gọi API tìm kiếm
    final searchResult = await ref
        .read(filterStaffReservationsUseCaseProvider)
        .call(search: cleanCode, limit: 1);

    searchResult.when(
      ok: (items) {
        if (items.isNotEmpty && mounted) {
          setState(() {
            _matchedReservation = items.first;
          });
        } else if (mounted) {
          setState(() {
            _matchedReservation = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Không tìm thấy đơn đặt nào với mã "$cleanCode"'),
              backgroundColor: Colors.orange.shade800,
            ),
          );
        }
      },
      err: (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi tra cứu đơn: ${failure.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }

  Future<void> _takeQuickInspectionPhoto() async {
    try {
      final photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (photo != null && mounted) {
        setState(() {
          _capturedPhotoPath = photo.path;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã chụp ảnh phương tiện thành công!'),
            backgroundColor: Color(0xFF059669),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể mở camera chụp: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header title & instruction
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner,
                    color: Color(0xFF2563EB),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quét mã đơn nhận xe',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Hướng camera vào mã QR trên app của khách hàng hoặc nhập mã đơn.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Camera Viewport
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 260,
              decoration: const BoxDecoration(color: Colors.black),
              child: Stack(
                children: [
                  MobileScanner(
                    controller: _scannerController,
                    onDetect: _handleBarcode,
                    errorBuilder: (context, error, child) {
                      return Center(
                        child: Text(
                          'Không thể mở camera: ${error.errorCode.name}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                  // Viewfinder Overlay
                  Center(
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF3B82F6),
                          width: 2.5,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  // Flash & Camera controls
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Row(
                      children: [
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            foregroundColor: Colors.white,
                          ),
                          icon: Icon(
                            _isTorchOn ? Icons.flash_on : Icons.flash_off,
                            size: 20,
                          ),
                          onPressed: () async {
                            await _scannerController.toggleTorch();
                            setState(() => _isTorchOn = !_isTorchOn);
                          },
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.flip_camera_ios, size: 20),
                          onPressed: () => _scannerController.switchCamera(),
                        ),
                      ],
                    ),
                  ),
                  // Processing indicator
                  if (_isProcessing)
                    Container(
                      color: Colors.black45,
                      alignment: Alignment.center,
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 8),
                          Text(
                            'Đang tra cứu mã đơn...',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Quick Action: Take inspection photo button
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _takeQuickInspectionPhoto,
                  icon: const Icon(Icons.camera_alt_outlined, size: 18),
                  label: const Text(
                    'Chụp ảnh hiện trạng xe',
                    style: TextStyle(fontSize: 13),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_capturedPhotoPath != null) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFF059669),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Đã chụp ảnh: ${_capturedPhotoPath!.split(RegExp(r'[/\\]')).last}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF065F46),
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),

          // Manual Code Entry
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hoặc nhập mã đơn thủ công:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _codeController,
                        decoration: InputDecoration(
                          hintText: 'Nhập mã đơn (VD: 790123)...',
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF94A3B8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFCBD5E1),
                            ),
                          ),
                        ),
                        onSubmitted: (val) {
                          if (val.trim().isNotEmpty) {
                            _lookupCode(val.trim());
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (_codeController.text.trim().isNotEmpty) {
                          _lookupCode(_codeController.text.trim());
                        }
                      },
                      child: const Text(
                        'Tìm',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Found Reservation Result
          if (_matchedReservation != null) ...[
            const SizedBox(height: 16),
            const Text(
              'Đã tìm thấy đơn đặt xe:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF059669),
              ),
            ),
            const SizedBox(height: 8),
            StaffReservationCard(
              reservation: _matchedReservation!,
              onStartHandover: () =>
                  widget.onStartHandover(_matchedReservation!),
            ),
          ],
        ],
      ),
    );
  }
}
