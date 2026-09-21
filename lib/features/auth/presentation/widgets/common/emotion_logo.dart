import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Logo thương hiệu e-Motion tải từ file SVG trong thư mục public.
class EmotionLogo extends StatelessWidget {
  const EmotionLogo({
    this.width = 110,
    this.height,
    this.fit = BoxFit.contain,
    super.key,
  });

  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'public/logo.svg',
      width: width,
      height: height,
      fit: fit,
    );
  }
}
