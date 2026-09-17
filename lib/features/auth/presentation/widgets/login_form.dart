import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/features/auth/presentation/auth_controller.dart';
import 'package:rental_car/features/auth/presentation/widgets/login_input_field.dart';

/// Form đăng nhập gồm các ô nhập liệu Email, Mật khẩu, Quên mật khẩu và nút Đăng nhập.
class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({this.onForgotPasswordTap, super.key});

  final VoidCallback? onForgotPasswordTap;

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController(
    text: 'demo@example.com',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: 'password',
  );
  bool _obscurePassword = true;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);

    // Giả lập round-trip mạng để hiển thị trạng thái loading
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    // Kích hoạt trạng thái đăng nhập vào AuthController
    ref.read(authControllerProvider.notifier).login();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Input Email
          LoginInputField(
            label: 'EMAIL ADDRESS',
            controller: _emailController,
            hintText: 'ryan.sc@gmail.com',
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Vui lòng nhập địa chỉ email';
              }
              if (!value.contains('@')) {
                return 'Địa chỉ email không hợp lệ';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Input Mật khẩu
          LoginInputField(
            label: 'PASSWORD',
            controller: _passwordController,
            hintText: '••••••••••••',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleSignIn(),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(0xFF94A3B8),
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mật khẩu';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),

          // Link Quên mật khẩu
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: widget.onForgotPasswordTap ?? () {},
              child: const Text(
                'Forgot password?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Nút Sign in chính (có đổ bóng dạ quang & loading state)
          Container(
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _submitting ? null : _handleSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F76F6),
                disabledBackgroundColor: const Color(
                  0xFF2F76F6,
                ).withValues(alpha: 0.7),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _submitting
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
