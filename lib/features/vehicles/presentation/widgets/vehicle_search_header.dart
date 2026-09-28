import 'package:flutter/material.dart';

/// Header thanh tìm kiếm trên cùng theo Slide 08
class VehicleSearchHeader extends StatelessWidget {
  const VehicleSearchHeader({
    required this.onBack,
    required this.onOpenFilter,
    required this.locationText,
    required this.dateTimeRangeText,
    this.onTapSearchBox,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onOpenFilter;
  final VoidCallback? onTapSearchBox;
  final String locationText;
  final String dateTimeRangeText;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 6),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Nút Quay lại (Back arrow)
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF0F172A),
                size: 24,
              ),
              onPressed: onBack,
              tooltip: 'Quay lại',
            ),

            // Khung tìm kiếm ở giữa: gồm 2 dòng chữ
            Expanded(
              child: GestureDetector(
                onTap: onTapSearchBox,
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9), // Màu xám nhạt nền
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search_rounded,
                        color: Color(0xFF1976D2), // Màu xanh thương hiệu
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              locationText,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              dateTimeRangeText,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Nút "Bộ lọc" bên phải
            InkWell(
              onTap: onOpenFilter,
              borderRadius: BorderRadius.circular(10),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.tune_rounded,
                      size: 20,
                      color: Color(0xFF1E293B),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Bộ lọc',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
