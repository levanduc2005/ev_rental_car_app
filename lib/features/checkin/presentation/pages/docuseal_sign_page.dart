import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/widgets/widgets.dart';
import 'package:rental_car/features/checkin/presentation/providers/checkin_providers.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DocuSealSignPage extends ConsumerStatefulWidget {
  const DocuSealSignPage({
    super.key,
    required this.rentalId,
    required this.signingUrl,
    this.contractCode,
  });

  final int rentalId;
  final String signingUrl;
  final String? contractCode;

  @override
  ConsumerState<DocuSealSignPage> createState() => _DocuSealSignPageState();
}

class _DocuSealSignPageState extends ConsumerState<DocuSealSignPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isConfirming = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initWebViewController();
  }

  void _initWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
              _errorMessage = null;
            });
            _checkIfSignedUrl(url);
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
            _checkIfSignedUrl(url);
          },
          onUrlChange: (change) {
            if (change.url != null) {
              _checkIfSignedUrl(change.url!);
            }
          },
          onWebResourceError: (error) {
            setState(() {
              _isLoading = false;
              _errorMessage = error.description;
            });
          },
        ),
      );

    final uri = Uri.tryParse(widget.signingUrl);
    if (uri != null) {
      _controller.loadRequest(uri);
    } else {
      _errorMessage =
          'Đường dẫn ký hợp đồng không hợp lệ: ${widget.signingUrl}';
    }
  }

  void _checkIfSignedUrl(String url) {
    final lower = url.toLowerCase();
    if (lower.contains('completed') ||
        lower.contains('success') ||
        lower.contains('signed') ||
        lower.contains('thank_you') ||
        lower.contains('done')) {
      _onSigningCompleted();
    }
  }

  Future<void> _onSigningCompleted() async {
    if (_isConfirming) return;
    setState(() => _isConfirming = true);

    final success = await ref
        .read(checkInControllerProvider.notifier)
        .confirmContractSigned(widget.rentalId);

    if (!mounted) return;
    setState(() => _isConfirming = false);

    if (success) {
      _showSuccessHandoverDialog();
    } else {
      final error = ref.read(checkInControllerProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error ?? 'Không thể xác nhận ký hợp đồng. Vui lòng thử lại.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showSuccessHandoverDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF16A34A),
                  size: 44,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Nhận xe & Ký hợp đồng thành công!',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Hợp đồng #${widget.contractCode ?? widget.rentalId} đã được ký số thành công. '
                'Đơn thuê đã chuyển sang trạng thái HOẠT ĐỘNG (ACTIVE). '
                'Quyền điều khiển xe thông minh đã sẵn sàng!',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF475569),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    // Điều hướng sang màn hình Active Trip
                    context.goNamed(AppRoute.control.name);
                  },
                  icon: const Icon(Icons.drive_eta_rounded, size: 20),
                  label: const Text(
                    'Bắt đầu chuyến đi ngay',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ký hợp đồng số DocuSeal',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (widget.contractCode != null)
              Text(
                'Mã: ${widget.contractCode}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Tải lại trang ký',
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      label: 'Tải lại',
                      onPressed: () => _controller.reload(),
                    ),
                  ],
                ),
              ),
            )
          else
            WebViewWidget(controller: _controller),

          // Loading bar
          if (_isLoading || _isConfirming)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                backgroundColor: Color(0xFFEFF6FF),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sau khi hoàn tất thao tác ký số trên DocuSeal, hãy bấm xác nhận bên dưới:',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              AppButton(
                label: _isConfirming
                    ? 'Đang kích hoạt chuyến đi...'
                    : 'Tôi đã hoàn tất ký hợp đồng',
                icon: Icons.check_circle_outline_rounded,
                isLoading: _isConfirming,
                onPressed: _isConfirming ? null : _onSigningCompleted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
