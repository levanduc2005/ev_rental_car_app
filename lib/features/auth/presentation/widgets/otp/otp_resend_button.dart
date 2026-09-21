import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/theme.dart';
import 'package:rental_car/l10n/l10n.dart';

/// Nút "Gửi lại mã OTP" kèm bộ đếm ngược thời gian (mặc định 200 giây theo thiết kế).
class OtpResendButton extends StatefulWidget {
  const OtpResendButton({
    required this.onResend,
    this.initialCountdownSeconds = 200,
    this.isLoading = false,
    super.key,
  });

  final Future<void> Function() onResend;
  final int initialCountdownSeconds;
  final bool isLoading;

  @override
  State<OtpResendButton> createState() => _OtpResendButtonState();
}

class _OtpResendButtonState extends State<OtpResendButton> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialCountdownSeconds;
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _handleResend() async {
    if (_remainingSeconds > 0 || widget.isLoading) return;

    await widget.onResend();

    if (!mounted) return;
    setState(() {
      _remainingSeconds = widget.initialCountdownSeconds;
    });
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    final canResend = _remainingSeconds == 0 && !widget.isLoading;

    final label = _remainingSeconds > 0
        ? context.l10n.resendOtpIn(_remainingSeconds)
        : context.l10n.resendOtpNow;

    return Container(
      height: 52,
      width: double.infinity,
      decoration: BoxDecoration(
        color: canResend ? AppColors.surface : AppColors.background,
        borderRadius: AppRadius.lgAll,
        border: Border.all(
          color: canResend ? AppColors.primary : AppColors.border,
          width: 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.lgAll,
          onTap: canResend ? _handleResend : null,
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.primary,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.refresh_rounded,
                        size: 18,
                        color: canResend
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: AppTextStyles.buttonOutlined.copyWith(
                          color: canResend
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
