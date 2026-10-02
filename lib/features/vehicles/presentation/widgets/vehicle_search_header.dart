import 'package:flutter/material.dart';

/// Header thanh tìm kiếm hiện đại gồm:
/// - Hàng 1: [Nút Quay lại] + [Ô Search Text] + [Nút Bộ lọc (kèm Badge số lượng)]
/// - Hàng 2: [Thanh chọn Ngày & Giờ thuê xe]
class VehicleSearchHeader extends StatefulWidget {
  const VehicleSearchHeader({
    required this.onBack,
    required this.onOpenFilter,
    this.initialSearchText,
    this.onSearchChanged,
    this.dateTimeRangeText,
    this.durationLabel,
    this.onTapTime,
    this.activeFilterCount,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onOpenFilter;
  final String? initialSearchText;
  final ValueChanged<String>? onSearchChanged;
  final String? dateTimeRangeText;
  final String? durationLabel;
  final VoidCallback? onTapTime;
  final int? activeFilterCount;

  @override
  State<VehicleSearchHeader> createState() => _VehicleSearchHeaderState();
}

class _VehicleSearchHeaderState extends State<VehicleSearchHeader> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialSearchText ?? '');
  }

  @override
  void didUpdateWidget(covariant VehicleSearchHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSearchText != null &&
        widget.initialSearchText != _controller.text &&
        widget.initialSearchText != oldWidget.initialSearchText) {
      _controller.text = widget.initialSearchText!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row 1: Nút Quay lại + Ô Search Text + Nút Bộ lọc
            Row(
              children: [
                // Nút Quay lại
                InkWell(
                  onTap: widget.onBack,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      size: 20,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Ô Search Text
                Expanded(
                  child: Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: Color(0xFF1976D2),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            onChanged: (val) {
                              widget.onSearchChanged?.call(val);
                              setState(() {});
                            },
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F172A),
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Tìm kiếm tên xe, dòng xe...',
                              hintStyle: TextStyle(
                                fontSize: 12.5,
                                color: Color(0xFF94A3B8),
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        if (_controller.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _controller.clear();
                              widget.onSearchChanged?.call('');
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.cancel_rounded,
                              size: 18,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Nút Bộ lọc (kèm Badge số lượng nếu có)
                InkWell(
                  onTap: widget.onOpenFilter,
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1976D2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      if (widget.activeFilterCount != null &&
                          widget.activeFilterCount! > 0)
                        Positioned(
                          top: -3,
                          right: -3,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEF4444),
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${widget.activeFilterCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            if (widget.onTapTime != null) ...[
              const SizedBox(height: 8),

              // Row 2: Thanh chọn Ngày & Giờ thuê xe chuyên nghiệp
              InkWell(
                onTap: widget.onTapTime,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time_filled_rounded,
                        size: 15,
                        color: Color(0xFF1976D2),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.dateTimeRangeText ?? 'Chọn ngày & giờ thuê',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: Color(0xFF64748B),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
