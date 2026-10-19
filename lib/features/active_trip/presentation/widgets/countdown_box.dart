import 'package:flutter/material.dart';

/// Ô hiển thị thời gian đếm ngược thông thường trong hành trình
class CountdownBox extends StatelessWidget {
  const CountdownBox({
    super.key,
    required this.value,
    required this.label,
    required this.isHighlighted,
    this.isOverdue = false,
  });

  final String value;
  final String label;
  final bool isHighlighted;
  final bool isOverdue;

  @override
  Widget build(BuildContext context) {
    final textColor = isOverdue
        ? const Color(0xFF94A3B8)
        : (isHighlighted ? const Color(0xFF2563EB) : const Color(0xFF1E293B));

    final labelColor = isOverdue
        ? const Color(0xFFCBD5E1)
        : (isHighlighted ? const Color(0xFF3B82F6) : const Color(0xFF94A3B8));

    final borderColor = (!isOverdue && isHighlighted)
        ? const Color(0xFFDBEAFE)
        : const Color(0xFFF1F5F9);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: textColor,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: labelColor,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ô hiển thị thời gian quá hạn màu đỏ cảnh báo
class OverdueBox extends StatelessWidget {
  const OverdueBox({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1F2).withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFECDD3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFFE11D48),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFB7185),
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
