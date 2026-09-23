import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/theme/app_text_styles.dart';
import 'package:rental_car/core/widgets/widgets.dart';
import 'package:rental_car/features/profile/presentation/providers/profile_providers.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileControllerProvider).user;
    _nameController = TextEditingController(text: profile?.fullName ?? '');
    _phoneController = TextEditingController(text: profile?.phone ?? '');
    _emailController = TextEditingController(text: profile?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập họ và tên';
    }
    if (value.trim().length < 2) {
      return 'Họ tên quá ngắn';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    final cleanPhone = value.replaceAll(RegExp(r'\s+'), '');
    final phoneRegex = RegExp(r'^(0[35789])[0-9]{8}$');
    if (!phoneRegex.hasMatch(cleanPhone)) {
      return 'Số điện thoại không hợp lệ (gồm 10 số, bắt đầu 03, 05, 07, 08, 09)';
    }
    return null;
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(profileControllerProvider.notifier)
        .updateProfile(
          fullName: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
        );

    if (mounted) {
      if (success) {
        context.showSnackBar('Cập nhật hồ sơ thành công!');
        context.pop();
      } else {
        final err = ref.read(profileControllerProvider).errorMessage;
        context.showSnackBar(err ?? 'Cập nhật thất bại. Vui lòng thử lại.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Chỉnh sửa thông tin'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thông tin cá nhân',
                        style: AppTextStyles.heading3,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      const Text(
                        'Thông tin này được dùng để liên hệ và xác nhận khi nhận xe',
                        style: AppTextStyles.caption,
                      ),
                      const Divider(height: AppSpacing.lg),
                      const SizedBox(height: AppSpacing.xs),
                      AppTextField(
                        label: 'Email tài khoản',
                        controller: _emailController,
                        enabled: false,
                        prefixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'Họ và tên',
                        controller: _nameController,
                        hint: 'Nhập họ và tên đầy đủ',
                        prefixIcon: Icons.person_outline,
                        validator: _validateName,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'Số điện thoại',
                        controller: _phoneController,
                        hint: 'Ví dụ: 0987654321',
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_outlined,
                        validator: _validatePhone,
                      ),
                    ],
                  ),
                ),
                const Gap(AppSpacing.xl),
                AppButton(
                  label: 'Lưu thay đổi',
                  icon: Icons.check_circle_outline,
                  isLoading: profileState.isUpdating,
                  onPressed: _onSave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
