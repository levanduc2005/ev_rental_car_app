import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_spacing.dart';

class FaqItem {
  const FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

class FaqSection extends StatefulWidget {
  const FaqSection({super.key});

  static const List<FaqItem> _faqs = [
    FaqItem(
      question: 'e-Motion là gì?',
      answer:
          'e-Motion là nền tảng cho thuê xe điện hàng đầu, kết nối người dùng với các chủ xe một cách tiện lợi, nhanh chóng và an toàn.',
    ),
    FaqItem(
      question: 'Làm thế nào để thuê xe?',
      answer:
          'Bạn chỉ cần chọn địa điểm, thời gian nhận và trả xe, sau đó chọn chiếc xe phù hợp từ danh sách có sẵn và tiến hành đặt xe. Thanh toán trực tuyến và nhận xe tại trạm.',
    ),
    FaqItem(
      question: 'Chi phí thuê xe được tính như thế nào?',
      answer:
          'Chi phí thuê xe phụ thuộc vào loại xe, thời gian thuê và các dịch vụ đi kèm. Bạn sẽ thấy chi tiết chi phí bao gồm phí thuê, phí cọc, VAT trước khi xác nhận đặt xe.',
    ),
    FaqItem(
      question: 'Tôi cần chuẩn bị gì khi nhận xe?',
      answer:
          'Bạn cần mang theo CCCD/CMND, giấy phép lái xe hợp lệ và điện thoại có mã đặt xe. Nhân viên sẽ hướng dẫn kiểm tra xe và ký biên bản bàn giao.',
    ),
    FaqItem(
      question: 'Nếu xe gặp sự cố trong quá trình thuê thì sao?',
      answer:
          'Hãy liên hệ ngay với tổng đài hỗ trợ 24/7 của e-Motion. Chúng tôi sẽ hỗ trợ sửa chữa hoặc cung cấp xe thay thế nếu cần thiết.',
    ),
    FaqItem(
      question: 'Tôi có thể hủy đặt xe không?',
      answer:
          'Có, bạn có thể hủy đặt xe trước thời gian nhận xe. Hủy trước 5 ngày sẽ được hoàn lại 100% phí cọc.',
    ),
    FaqItem(
      question: 'Tôi có thể thuê xe cho người khác lái không?',
      answer:
          'Không, người thuê xe phải là người trực tiếp lái xe và có giấy phép lái xe hợp lệ. Điều này đảm bảo an toàn và trách nhiệm pháp lý.',
    ),
    FaqItem(
      question: 'Làm sao để nạp điện cho xe điện?',
      answer:
          'e-Motion có hệ thống trạm sạc tại các địa điểm thuê xe. Bạn cũng có thể sử dụng các trạm sạc công cộng. Phí nạp điện sẽ được thanh toán riêng.',
    ),
    FaqItem(
      question: 'Tôi có thể gia hạn thêm thời gian thuê không?',
      answer:
          'Có, bạn có thể yêu cầu gia hạn trực tiếp trên app hoặc liên hệ tổng đài. Việc gia hạn phụ thuộc vào tình trạng đặt xe tiếp theo của xe đó.',
    ),
    FaqItem(
      question: 'Làm thế nào để trở thành đối tác cho thuê xe?',
      answer:
          'Bạn có thể đăng ký làm đối tác bằng cách điền form trên website hoặc liên hệ hotline. Xe cần đáp ứng các tiêu chuẩn về chất lượng và giấy tờ hợp lệ.',
    ),
  ];

  @override
  State<FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<FaqSection> {
  // Lưu chỉ số các câu hỏi đang mở accordion
  final Set<int> _expandedIndices = {};
  bool _showAll = false;

  void _toggleIndex(int index) {
    setState(() {
      if (_expandedIndices.contains(index)) {
        _expandedIndices.remove(index);
      } else {
        _expandedIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    const allFaqs = FaqSection._faqs;
    final displayedFaqs = _showAll ? allFaqs : allFaqs.take(5).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề phần FAQ
          const Text(
            'Câu hỏi thường gặp',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1976D2),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Giải đáp nhanh các thắc mắc về dịch vụ thuê xe điện e-Motion',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Danh sách các thẻ Accordion
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayedFaqs.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final faq = displayedFaqs[index];
              final isExpanded = _expandedIndices.contains(index);

              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isExpanded
                        ? const Color(0xFF1976D2).withValues(alpha: 0.45)
                        : colorScheme.outlineVariant.withValues(alpha: 0.35),
                    width: isExpanded ? 1.5 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isExpanded ? 0.05 : 0.02,
                      ),
                      blurRadius: isExpanded ? 8 : 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _toggleIndex(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Icon hỏi đáp nhỏ
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isExpanded
                                      ? const Color(
                                          0xFF1976D2,
                                        ).withValues(alpha: 0.12)
                                      : Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.help_outline_rounded,
                                    size: 16,
                                    color: isExpanded
                                        ? const Color(0xFF1976D2)
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),

                              // Nội dung câu hỏi
                              Expanded(
                                child: Text(
                                  faq.question,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isExpanded
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    color: isExpanded
                                        ? const Color(0xFF1976D2)
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Mũi tên xoay linh hoạt
                              AnimatedRotation(
                                duration: const Duration(milliseconds: 250),
                                turns: isExpanded ? 0.5 : 0,
                                child: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: isExpanded
                                      ? const Color(0xFF1976D2)
                                      : Colors.grey.shade500,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),

                          // Phần câu trả lời khi mở rộng
                          AnimatedCrossFade(
                            firstChild: const SizedBox.shrink(),
                            secondChild: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 38,
                                right: 6,
                                bottom: 4,
                              ),
                              child: Text(
                                faq.answer,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                  height: 1.45,
                                ),
                              ),
                            ),
                            crossFadeState: isExpanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 200),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: AppSpacing.sm),

          // Nút bấm Xem thêm / Thu gọn câu hỏi
          Center(
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _showAll = !_showAll;
                });
              },
              icon: Icon(
                _showAll
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: const Color(0xFF1976D2),
              ),
              label: Text(
                _showAll
                    ? 'Thu gọn danh sách'
                    : 'Xem thêm (${allFaqs.length - 5} câu hỏi khác)',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Thẻ liên hệ hỗ trợ nhanh
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.support_agent_rounded,
                    color: Color(0xFF1976D2),
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vẫn còn thắc mắc?',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Tổng đài hỗ trợ 24/7 luôn sẵn sàng giải đáp mọi thắc mắc của bạn.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => context.goNamed(AppRoute.support.name),
                  child: const Text(
                    'Hỗ trợ',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
