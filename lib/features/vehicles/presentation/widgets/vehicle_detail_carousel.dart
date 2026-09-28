import 'package:flutter/material.dart';

/// Carousel trượt ảnh xe kèm chỉ báo Dots và nút VR 360 (Slide 10)
class VehicleDetailCarousel extends StatefulWidget {
  const VehicleDetailCarousel({required this.imageUrls, super.key});

  final List<String> imageUrls;

  @override
  State<VehicleDetailCarousel> createState() => _VehicleDetailCarouselState();
}

class _VehicleDetailCarouselState extends State<VehicleDetailCarousel> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.imageUrls.isNotEmpty
        ? widget.imageUrls
        : [
            'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?q=80&w=1000&auto=format&fit=crop',
          ];

    return Stack(
      children: [
        // 1. Slider ảnh
        SizedBox(
          height: 250,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                images[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFFE2E8F0),
                  child: const Center(
                    child: Icon(
                      Icons.directions_car_filled,
                      size: 64,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // 2. Dots indicator ở giữa bên dưới ảnh
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (index) {
              final isActive = _currentIndex == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ),

        // 3. Nút VR / 360 góc dưới bên phải
        Positioned(
          bottom: 10,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.view_in_ar_rounded, color: Colors.white, size: 15),
                SizedBox(width: 4),
                Text(
                  'VR',
                  style: TextStyle(
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
    );
  }
}
