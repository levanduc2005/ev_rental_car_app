import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/theme/theme.dart';
import 'package:rental_car/core/widgets/widgets.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';

/// Form nhập họ và tên cùng các nút hành động (Xác nhận / Bỏ qua).
class CompleteProfileForm extends ConsumerStatefulWidget {
  const CompleteProfileForm({super.key});

  @override
  ConsumerState<CompleteProfileForm> createState() =>
      _CompleteProfileFormState();
}

class _CompleteProfileFormState extends ConsumerState<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final fullName = _nameController.text.trim();
    final success = await ref
        .read(authControllerProvider.notifier)
        .completeProfile(fullName);

    if (!mounted) return;

    if (!success) {
      final error = ref.read(authControllerProvider).errorMessage;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _handleSkip() {
    ref.read(authControllerProvider.notifier).skipProfileSetup();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      authControllerProvider.select((s) => s.isLoading),
    );

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _nameController,
            label: 'Họ và tên',
            hint: 'Ví dụ: Nguyễn Văn A',
            prefixIcon: Icons.person_outline_rounded,
            textInputAction: TextInputAction.done,
            enabled: !isLoading,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Vui lòng nhập họ và tên của bạn';
              }
              if (value.trim().length < 2) {
                return 'Họ và tên phải có ít nhất 2 ký tự';
              }
              return null;
            },
            onSubmitted: (_) => _handleSubmit(),
          ),
          const Gap(28),
          AppButton(
            label: 'Xác nhận & Tiếp tục',
            onPressed: _handleSubmit,
            isLoading: isLoading,
            expanded: true,
          ),
          const Gap(14),
          AppButton(
            label: 'Để sau (Bỏ qua)',
            onPressed: isLoading ? null : _handleSkip,
            expanded: true,
            variant: AppButtonVariant.text,
          ),
        ],
      ),
    );
  }
}
