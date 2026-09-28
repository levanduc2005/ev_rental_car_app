import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_spacing.dart';

class GuideStep {
  const GuideStep({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    required this.imageAsset,
  });

  final String number;
  final String title;
  final String description;
  final IconData icon;
  final String imageAsset;
}

class HowItWorksSection extends StatefulWidget {
  const HowItWorksSection({super.key});

  static const List<GuideStep> _guides = [
    GuideStep(
      number: '01',
      title: 'Đặt xe trên nền tảng e-Motion',
      description: 'Dễ dàng lựa chọn chiếc xe phù hợp với nhu cầu của bạn',
      icon: Icons.location_on_rounded,
      imageAsset: 'public/guides/step1.png',
    ),
    GuideStep(
      number: '02',
      title: 'Nhận xe',
      description: 'Nhận xe tại địa điểm đã đặt với đầy đủ tài liệu',
      icon: Icons.people_alt_rounded,
      imageAsset: 'public/guides/step2.jpg',
    ),
    GuideStep(
      number: '03',
      title: 'Bắt đầu hành trình',
      description: 'Khởi hành và tận hưởng chuyến đi thoải mái',
      icon: Icons.bolt_rounded,
      imageAsset: 'public/guides/step3.jpg',
    ),
    GuideStep(
      number: '04',
      title: 'Trả xe & kết thúc chuyến đi',
      description: 'Trả xe đúng giờ và nhận lại tiền cọc',
      icon: Icons.check_circle_rounded,
      imageAsset: 'public/guides/step4.jpg',
    ),
  ];

  @override
  State<HowItWorksSection> createState() => _HowItWorksSectionState();
}

class _HowItWorksSectionState extends State<HowItWorksSection> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.86);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề phân mục
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hướng Dẫn Thuê Xe',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1976D2),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Chỉ với 4 bước đơn giản để trải nghiệm thuê xe e-Motion một cách nhanh chóng',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Carousel các bước dạng PageView tối ưu cho Mobile
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            itemCount: HowItWorksSection._guides.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final step = HowItWorksSection._guides[index];
              final isCurrent = index == _currentPage;

              return AnimatedPadding(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                padding: EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: isCurrent ? 0 : 6,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isCurrent
                          ? const Color(0xFF1976D2).withValues(alpha: 0.4)
                          : colorScheme.outlineVariant.withValues(alpha: 0.35),
                      width: isCurrent ? 1.5 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ảnh bước thực hiện từ asset chính xác của e-Motion
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(19),
                            ),
                            child: Image.asset(
                              step.imageAsset,
                              height: 135,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                height: 135,
                                color: const Color(0xFFE3F2FD),
                                child: const Center(
                                  child: Icon(
                                    Icons.electric_car_rounded,
                                    size: 40,
                                    color: Color(0xFF1976D2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Badge số bước nổi trên ảnh
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1976D2),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    step.icon,
                                    color: Colors.white,
                                    size: 13,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Bước ${step.number}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Thông tin tiêu đề và mô tả
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              step.description,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                                height: 1.35,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // Chỉ báo Dots Indicator
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(HowItWorksSection._guides.length, (index) {
              final isSelected = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isSelected ? 22 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1976D2)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
