import 'package:flutter/material.dart';
import 'package:rental_car/features/auth/presentation/widgets/auth_top_bar.dart';
import 'package:rental_car/features/auth/presentation/widgets/login_form.dart';
import 'package:rental_car/features/auth/presentation/widgets/login_header.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            AuthTopBar(),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    LoginHeader(),
                    SizedBox(height: 32),
                    LoginForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
