import 'package:flutter/material.dart';

class RentalContractCard extends StatelessWidget {
  const RentalContractCard({
    required this.contractUrl,
    required this.onOpenContract,
    super.key,
  });

  final String contractUrl;
  final VoidCallback onOpenContract;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.verified_user_rounded,
            color: Color(0xFF16A34A),
            size: 24,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hợp đồng thuê xe điện tử',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF15803D),
                  ),
                ),
                Text(
                  'Đã xác nhận & ký hợp đồng hợp lệ.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF166534)),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              visualDensity: VisualDensity.compact,
            ),
            onPressed: onOpenContract,
            child: const Text('Xem hợp đồng', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
