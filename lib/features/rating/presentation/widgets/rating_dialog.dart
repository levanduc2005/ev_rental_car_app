import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/theme/app_text_styles.dart';
import 'package:rental_car/core/widgets/widgets.dart';
import 'package:rental_car/features/profile/presentation/providers/profile_providers.dart';
import 'package:rental_car/features/rating/domain/entities/rating_entity.dart';
import 'package:rental_car/features/rating/presentation/providers/rating_providers.dart';
import 'package:rental_car/features/rating/presentation/widgets/rating_stars_bar.dart';

class RatingDialog extends ConsumerStatefulWidget {
  const RatingDialog({
    super.key,
    required this.rentalId,
    required this.vehicleName,
    this.existingRating,
  });

  final int rentalId;
  final String vehicleName;
  final RatingEntity? existingRating;

  static const List<String> defaultQuickTags = [
    'Xe sạch sẽ',
    'Pin khỏe',
    'Trạm sạc tiện lợi',
    'Thủ tục nhanh gọn',
    'Nhân viên thân thiện',
    'Giá cả hợp lý',
  ];

  static Future<bool?> show(
    BuildContext context, {
    required int rentalId,
    required String vehicleName,
    RatingEntity? existingRating,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RatingDialog(
        rentalId: rentalId,
        vehicleName: vehicleName,
        existingRating: existingRating,
      ),
    );
  }

  @override
  ConsumerState<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends ConsumerState<RatingDialog> {
  late int _rating;
  late final TextEditingController _commentController;
  final Set<String> _selectedTags = {};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _rating = widget.existingRating?.score ?? 5;
    _commentController = TextEditingController(
      text: widget.existingRating?.comment ?? '',
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _onTagTapped(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
        // Remove tag from text if present
        final current = _commentController.text;
        final updated = current
            .replaceAll(tag, '')
            .replaceAll(RegExp(r',\s*,'), ',')
            .replaceAll(RegExp(r'^\s*,\s*'), '')
            .replaceAll(RegExp(r',\s*$'), '')
            .trim();
        _commentController.text = updated;
      } else {
        _selectedTags.add(tag);
        // Append tag to text
        final current = _commentController.text.trim();
        if (current.isEmpty) {
          _commentController.text = tag;
        } else {
          _commentController.text = '$current, $tag';
        }
      }
      _commentController.selection = TextSelection.fromPosition(
        TextPosition(offset: _commentController.text.length),
      );
      _errorMessage = null;
    });
  }

  Future<void> _handleSubmit() async {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng chọn tag hoặc nhập nhận xét chuyến đi.';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    // Lấy userId nếu có từ profile/auth
    final userProfile = ref.read(profileControllerProvider).user;
    int? resolvedUserId;
    if (userProfile != null && userProfile.email.isNotEmpty) {
      // Backend createRating tự động map hoặc fallback an toàn
    }

    final result = await ref
        .read(ratingControllerProvider.notifier)
        .submitRating(
          rentalId: widget.rentalId,
          score: _rating,
          comment: comment,
          userId: resolvedUserId,
        );

    if (!mounted) return;

    result.when(
      ok: (rating) {
        Navigator.of(context).pop(true);
        context.showSnackBar('Cảm ơn bạn đã gửi đánh giá chuyến đi! ⭐');
      },
      err: (failure) {
        setState(() {
          _errorMessage = failure.message;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ratingState = ref.watch(ratingControllerProvider);
    final isSubmitting = ratingState.isSubmitting;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      backgroundColor: AppColors.surface,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Icon & Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.xs),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: const Icon(
                            Icons.star_rate_rounded,
                            color: Color(0xFFD97706),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        const Expanded(
                          child: Text(
                            'Đánh giá chuyến đi',
                            style: AppTextStyles.heading3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Đóng',
                    onPressed: isSubmitting
                        ? null
                        : () => Navigator.of(context).pop(false),
                  ),
                ],
              ),
              const Divider(height: AppSpacing.lg),

              // Vehicle name subtitle
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.directions_car_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        widget.vehicleName,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '#${widget.rentalId}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(AppSpacing.md),

              // Star rating selector
              Center(
                child: RatingStarsBar(
                  rating: _rating,
                  starSize: 42,
                  onRatingChanged: isSubmitting
                      ? null
                      : (newScore) {
                          setState(() {
                            _rating = newScore;
                          });
                        },
                ),
              ),
              const Gap(AppSpacing.lg),

              // Quick tags
              Text(
                'Gợi ý nhận xét nhanh:',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: RatingDialog.defaultQuickTags.map((tag) {
                  final isSelected = _selectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    selectedColor: AppColors.primary.withValues(alpha: 0.15),
                    backgroundColor: AppColors.background,
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                    onSelected: isSubmitting ? null : (_) => _onTagTapped(tag),
                  );
                }).toList(),
              ),
              const Gap(AppSpacing.md),

              // Comment input
              Text(
                'Chi tiết trải nghiệm:',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: _commentController,
                maxLines: 3,
                maxLength: 300,
                enabled: !isSubmitting,
                decoration: InputDecoration(
                  hintText: 'Chia sẻ thêm trải nghiệm của bạn (tùy chọn)...',
                  hintStyle: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
                onChanged: (_) {
                  if (_errorMessage != null) {
                    setState(() {
                      _errorMessage = null;
                    });
                  }
                },
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _errorMessage!,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const Gap(AppSpacing.md),

              // Actions: Cancel & Submit
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Bỏ qua',
                      variant: AppButtonVariant.secondary,
                      onPressed: isSubmitting
                          ? null
                          : () => Navigator.of(context).pop(false),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      label: isSubmitting ? 'Đang gửi...' : 'Gửi đánh giá',
                      icon: Icons.send_rounded,
                      isLoading: isSubmitting,
                      onPressed: isSubmitting ? null : _handleSubmit,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
