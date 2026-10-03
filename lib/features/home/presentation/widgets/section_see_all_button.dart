import 'package:flutter/material.dart';

/// Nút "Xem tất cả" / "Xem thêm" dùng chung cho tiêu đề các section trong trang Home
class SectionSeeAllButton extends StatelessWidget {
  const SectionSeeAllButton({
    required this.onTap,
    this.text = 'Xem tất cả',
    super.key,
  });

  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF1976D2),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: Color(0xFF1976D2),
            ),
          ],
        ),
      ),
    );
  }
}
