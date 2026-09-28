import 'package:flutter/material.dart';

/// Phụ phí có thể phát sinh (Đúng với nghiệp vụ e-Motion EV Rental)
class AdditionalFeesCard extends StatelessWidget {
  const AdditionalFeesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline_rounded, size: 18, color: Color(0xFF1976D2)),
              SizedBox(width: 6),
              Text(
                'PHỤ PHÍ CÓ THỂ PHÁT SINH',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1976D2),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildFeeItem(
            stepNumber: '1',
            title: 'Phụ thu chênh lệch Pin/Điện',
            feeRight: '12.000 đ / % pin',
            desc:
                'Áp dụng khi mức % pin tại thời điểm hoàn tất trả xe (Check-out) thấp hơn mức % pin ban đầu lúc bàn giao xe (Check-in).',
          ),
          const SizedBox(height: 12),
          _buildFeeItem(
            stepNumber: '2',
            title: 'Phí trễ giờ trả xe',
            feeRight: '6% giá ngày / giờ',
            desc:
                'Áp dụng khi khách trả xe quá giờ thỏa thuận trong hợp đồng (tính theo số giờ trễ thực tế ghi nhận trên biên bản Check-out).',
          ),
          const SizedBox(height: 12),
          _buildFeeItem(
            stepNumber: '3',
            title: 'Phí khắc phục hư hại / trầy xước',
            feeRight: 'Chi phí thực tế',
            desc:
                'Căn cứ theo biên bản bàn giao xe (Check-out checklist) và báo giá sửa chữa linh kiện chính hãng nếu phát sinh va quẹt, tổn hại.',
          ),
          const SizedBox(height: 12),
          _buildFeeItem(
            stepNumber: '4',
            title: 'Phí vệ sinh & khử mùi nội thất',
            feeRight: '150k - 500k',
            desc:
                'Áp dụng nếu khoang lái bị bẩn nhiều, dính bùn đất/chất lỏng hoặc có mùi thuốc lá, hải sản trong xe.',
          ),
        ],
      ),
    );
  }

  Widget _buildFeeItem({
    required String stepNumber,
    required String title,
    required String desc,
    String? feeRight,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Color(0xFFE0F2FE),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              stepNumber,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0284C7),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  if (feeRight != null)
                    Text(
                      feeRight,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF64748B),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
