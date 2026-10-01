import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rental_car/core/theme/theme.dart';

class OtpInputField extends StatefulWidget {
  const OtpInputField({
    required this.onCompleted,
    this.onChanged,
    this.enabled = true,
    this.autoFocus = true,
    this.controller,
    this.focusNode,
    super.key,
  });

  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool autoFocus;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _internalController = false;
  bool _internalFocusNode = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _internalController = true;
    }

    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _internalFocusNode = true;
    }

    _controller.addListener(_handleTextChange);

    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    if (_internalController) {
      _controller.dispose();
    }
    if (_internalFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleTextChange() {
    final text = _controller.text;
    widget.onChanged?.call(text);
    if (text.length == 6) {
      widget.onCompleted(text);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final text = _controller.text;
    final isFocused = _focusNode.hasFocus;

    return Stack(
      alignment: Alignment.center,
      children: [
        // 6 ô hiển thị số OTP
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            final isCurrent = isFocused && index == text.length;
            final isFilled = index < text.length;

            return GestureDetector(
              onTap: () {
                if (widget.enabled) {
                  _focusNode.requestFocus();
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 48,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isCurrent
                        ? AppColors.borderFocused
                        : isFilled
                        ? AppColors.primary.withValues(alpha: 0.5)
                        : AppColors.border,
                    width: isCurrent ? 2.0 : 1.2,
                  ),
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                ),
                child: Center(
                  child: isFilled
                      ? Text(
                          text[index],
                          style: AppTextStyles.heading2.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        )
                      : isCurrent
                      ? Container(
                          width: 2,
                          height: 24,
                          color: AppColors.primary,
                        )
                      : Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.border,
                            shape: BoxShape.circle,
                          ),
                        ),
                ),
              ),
            );
          }),
        ),

        // TextField ẩn tiếp nhận phím gõ, paste và backspace
        Positioned.fill(
          child: Opacity(
            opacity: 0.0,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              keyboardType: TextInputType.number,
              maxLength: 6,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
