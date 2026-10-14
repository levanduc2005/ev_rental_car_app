import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/booking/presentation/providers/booking_providers.dart';

/// Trang Quét mã QR dán trên kính/vô lăng xe để thuê tức thì tại trạm
class QrScannerPage extends ConsumerStatefulWidget {
  const QrScannerPage({super.key});

  @override
  ConsumerState<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends ConsumerState<QrScannerPage> {
  final MobileScannerController _cameraController = MobileScannerController();

  bool _isProcessing = false;
  bool _isTorchOn = false;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  /// Trích xuất vehicleId từ chuỗi QR code đa dạng
  int? parseVehicleIdFromQr(String rawData) {
    final cleaned = rawData.trim();
    if (cleaned.isEmpty) return null;

    // 1. Số thuần túy: "1", "5", "12"
    final directId = int.tryParse(cleaned);
    if (directId != null && directId > 0) return directId;

    // 2. Định dạng JSON: {"vehicleId": 5} hoặc {"id": 5}
    if (cleaned.startsWith('{') && cleaned.endsWith('}')) {
      try {
        final Map<String, dynamic> json =
            jsonDecode(cleaned) as Map<String, dynamic>;
        final dynamic val = json['vehicleId'] ?? json['id'] ?? json['carId'];
        if (val != null) {
          final parsed = int.tryParse(val.toString());
          if (parsed != null && parsed > 0) return parsed;
        }
      } catch (_) {}
    }

    // 3. Định dạng URL: https://.../vehicles/5 hoặc ?vehicleId=5
    final uri = Uri.tryParse(cleaned);
    if (uri != null) {
      if (uri.queryParameters.containsKey('vehicleId')) {
        final parsed = int.tryParse(uri.queryParameters['vehicleId']!);
        if (parsed != null && parsed > 0) return parsed;
      }
      if (uri.queryParameters.containsKey('id')) {
        final parsed = int.tryParse(uri.queryParameters['id']!);
        if (parsed != null && parsed > 0) return parsed;
      }
      final segments = uri.pathSegments;
      for (int i = 0; i < segments.length; i++) {
        if ((segments[i] == 'vehicles' || segments[i] == 'cars') &&
            i + 1 < segments.length) {
          final parsed = int.tryParse(segments[i + 1]);
          if (parsed != null && parsed > 0) return parsed;
        }
      }
    }

    // 4. Định dạng tiền tố: "VEHICLE_5", "EMOTION_VEHICLE:5", "CAR_12"
    final regex = RegExp(
      r'(?:vehicle|car|xe)[_:\s-]*(\d+)',
      caseSensitive: false,
    );
    final match = regex.firstMatch(cleaned);
    if (match != null && match.group(1) != null) {
      final parsed = int.tryParse(match.group(1)!);
      if (parsed != null && parsed > 0) return parsed;
    }

    return null;
  }

  Future<void> _processVehicleId(int vehicleId, {String? rawValue}) async {
    setState(() => _isProcessing = true);

    try {
      final getVehicleSummary = ref.read(
        getBookingVehicleSummaryUseCaseProvider,
      );
      final result = await getVehicleSummary(vehicleId);

      if (!mounted) return;

      result.when(
        ok: (vehicle) {
          if (vehicle.isAvailable) {
            // Xe sẵn sàng -> Chuyển sang màn hình InstantBookingConfirmationPage
            context
                .pushNamed(AppRoute.instantBooking.name, extra: vehicleId)
                .then((_) => _resumeScanning());
          } else {
            String statusText;
            final statusUpper = vehicle.status?.toUpperCase() ?? '';
            if (statusUpper.contains('THUÊ') ||
                statusUpper == 'ONGOING' ||
                statusUpper == 'RENTED') {
              statusText = 'Xe hiện đang được khách hàng khác thuê.';
            } else if (statusUpper.contains('BẢO TRÌ') ||
                statusUpper.contains('BẢO DƯỠNG') ||
                statusUpper == 'MAINTAINED' ||
                statusUpper == 'MAINTENANCE') {
              statusText = 'Xe đang trong lịch bảo dưỡng định kỳ.';
            } else if (statusUpper.contains('CHUYỂN') ||
                statusUpper == 'TRANSFERRING') {
              statusText = 'Xe đang trong quá trình luân chuyển trạm.';
            } else if (statusUpper.contains('PIN') ||
                statusUpper == 'RECHARGE') {
              statusText = 'Xe đang được sạc pin tại trạm.';
            } else if (statusUpper.contains('KIỂM TRA') ||
                statusUpper == 'CHECKING') {
              statusText = 'Xe đang trong quy trình kiểm tra kỹ thuật.';
            } else {
              statusText =
                  'Trạng thái hiện tại: ${vehicle.status ?? "Không xác định"} (chưa sẵn sàng).';
            }
            final plate =
                (vehicle.plateNumber != null && vehicle.plateNumber!.isNotEmpty)
                    ? vehicle.plateNumber!
                    : 'Chưa cập nhật';
            _showErrorDialog(
              title: 'Phương tiện không sẵn sàng',
              message: '${vehicle.name} (Biển số: $plate)\n$statusText',
            );
          }
        },
        err: (failure) {
          _showErrorDialog(
            title: 'Không tìm thấy xe',
            message: failure.message,
          );
        },
      );
    } catch (e) {
      if (mounted) {
        _showErrorDialog(
          title: 'Lỗi kiểm tra xe',
          message: 'Không thể kết nối máy chủ để xác thực phương tiện: $e',
        );
      }
    }
  }

  void _resumeScanning() {
    if (!mounted) return;
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    });
  }

  Future<void> _handleBarcode(BarcodeCapture capture) async {
    if (_isProcessing) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final rawValue = barcodes.first.rawValue;
    if (rawValue == null || rawValue.isEmpty) return;

    final vehicleId = parseVehicleIdFromQr(rawValue);
    if (vehicleId == null) {
      if (!mounted) return;
      _showErrorDialog(
        title: 'Mã QR không hợp lệ',
        message:
            'Mã QR không đúng định dạng nhận diện của phương tiện e-Motion: "$rawValue".',
      );
      return;
    }

    await _processVehicleId(vehicleId, rawValue: rawValue);
  }

  void _showManualInputDialog() {
    final textController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.keyboard_alt_rounded, color: AppColors.primary),
              SizedBox(width: 8),
              Text('Nhập mã số xe', style: TextStyle(fontSize: 18)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nhập ID định danh xe (dùng khi test trên máy ảo hoặc mã QR xe bị mờ):',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textController,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Mã xe (ví dụ: 1, 2, 5)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.directions_car_rounded),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final input = textController.text.trim();
                final parsed = int.tryParse(input);
                if (parsed != null && parsed > 0) {
                  Navigator.of(dialogCtx).pop();
                  _processVehicleId(parsed);
                }
              },
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog({required String title, required String message}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.redAccent),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 14)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              _resumeScanning();
            },
            child: const Text('Quét lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner({double? top, double? bottom, double? left, double? right}) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border(
            top: top != null
                ? const BorderSide(color: Color(0xFF38BDF8), width: 4)
                : BorderSide.none,
            bottom: bottom != null
                ? const BorderSide(color: Color(0xFF38BDF8), width: 4)
                : BorderSide.none,
            left: left != null
                ? const BorderSide(color: Color(0xFF38BDF8), width: 4)
                : BorderSide.none,
            right: right != null
                ? const BorderSide(color: Color(0xFF38BDF8), width: 4)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Quét mã QR xe tại trạm',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isTorchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
              color: _isTorchOn ? Colors.amberAccent : Colors.white70,
            ),
            tooltip: 'Bật/Tắt đèn pin',
            onPressed: () async {
              await _cameraController.toggleTorch();
              setState(() => _isTorchOn = !_isTorchOn);
            },
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios_rounded, color: Colors.white70),
            tooltip: 'Đổi camera',
            onPressed: () => _cameraController.switchCamera(),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Camera scanner
          MobileScanner(
            controller: _cameraController,
            onDetect: _handleBarcode,
          ),

          // Lớp phủ tối mờ xung quanh khung ngắm
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.65),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Center(
                  child: Container(
                    width: 270,
                    height: 270,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Khung ngắm quét mã QR với 4 góc phát sáng
          Center(
            child: Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24, width: 1.5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  _buildCorner(top: -2, left: -2),
                  _buildCorner(top: -2, right: -2),
                  _buildCorner(bottom: -2, left: -2),
                  _buildCorner(bottom: -2, right: -2),
                ],
              ),
            ),
          ),

          // Lời nhắc và thanh công cụ hỗ trợ
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.qr_code_scanner_rounded,
                        color: Color(0xFF38BDF8),
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Hướng camera vào mã QR dán trên kính lái hoặc vô lăng của xe điện để thuê ngay.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white38),
                    backgroundColor: Colors.black54,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _showManualInputDialog,
                  icon: const Icon(Icons.keyboard_alt_outlined, size: 18),
                  label: const Text(
                    'Nhập mã xe thủ công (Test Emulator)',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

          // Loading overlay
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF38BDF8)),
                    SizedBox(height: 16),
                    Text(
                      'Đang kiểm tra xe tại trạm...',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
