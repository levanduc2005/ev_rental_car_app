import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/theme.dart';
import 'package:rental_car/l10n/l10n.dart';

class AuthTopBar extends StatelessWidget {
  const AuthTopBar({this.title, this.onClose, super.key});

  final String? title;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final displayTitle = title ?? context.l10n.loginTopBarTitle;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Nút tròn (X) bên trái
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: AppColors.textPrimary,
                ),
                padding: EdgeInsets.zero,
                onPressed:
                    onClose ??
                    () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
              ),
            ),
          ),

          Text(displayTitle, style: AppTextStyles.heading3),
        ],
      ),
    );
  }
}
