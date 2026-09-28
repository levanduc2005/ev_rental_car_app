import 'package:flutter/material.dart';

/// Tiện nghi khác (Slide 10)
class AmenitiesSection extends StatelessWidget {
  const AmenitiesSection({super.key});

  static const List<Map<String, dynamic>> amenities = [
    {'icon': Icons.bluetooth_rounded, 'name': 'Bluetooth'},
    {'icon': Icons.center_focus_strong_rounded, 'name': 'Camera 360'},
    {'icon': Icons.videocam_outlined, 'name': 'Camera hành trình'},
    {'icon': Icons.tire_repair_rounded, 'name': 'Cảm biến lốp'},
    {'icon': Icons.navigation_outlined, 'name': 'Định vị GPS'},
    {'icon': Icons.warning_amber_rounded, 'name': 'Cảnh báo tốc độ'},
    {'icon': Icons.credit_card_outlined, 'name': 'Thu phí tự động ETC'},
    {'icon': Icons.camera_rear_outlined, 'name': 'Camera lùi'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Các tiện nghi khác',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: amenities.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3.8,
          ),
          itemBuilder: (context, index) {
            final item = amenities[index];
            return Row(
              children: [
                Icon(
                  item['icon'] as IconData,
                  size: 18,
                  color: const Color(0xFF1976D2),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item['name'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF334155),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
