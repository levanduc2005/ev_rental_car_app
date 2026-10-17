import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/theme/app_text_styles.dart';

class RatingStarsBar extends StatelessWidget {
  const RatingStarsBar({
    super.key,
    required this.rating,
    this.onRatingChanged,
    this.starSize = 36.0,
    this.showLabel = true,
  });

  final int rating;
  final ValueChanged<int>? onRatingChanged;
  final double starSize;
  final bool showLabel;

  bool get isInteractive => onRatingChanged != null;

  String _getRatingLabel(int score) {
    return switch (score) {
      1 => 'Rất không hài lòng 😞',
      2 => 'Chưa hài lòng 😐',
      3 => 'Bình thường 🙂',
      4 => 'Hài lòng 😊',
      5 => 'Tuyệt vời, cực kỳ hài lòng! 🌟',
      _ => 'Vui lòng chọn số sao',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starNumber = index + 1;
            final isFilled = starNumber <= rating;

            final starIcon = AnimatedScale(
              scale: isFilled ? 1.08 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: Icon(
                isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                color: isFilled ? const Color(0xFFFFB300) : AppColors.border,
                size: starSize,
              ),
            );

            if (!isInteractive) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: starIcon,
              );
            }

            return InkWell(
              onTap: () => onRatingChanged?.call(starNumber),
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.xs,
                ),
                child: starIcon,
              ),
            );
          }),
        ),
        if (showLabel) ...[
          const SizedBox(height: AppSpacing.sm),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              _getRatingLabel(rating),
              key: ValueKey<int>(rating),
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: rating >= 4
                    ? const Color(0xFFD97706)
                    : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
