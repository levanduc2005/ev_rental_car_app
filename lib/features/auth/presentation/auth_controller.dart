import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthController extends Notifier<bool> {
  @override
  bool build() => false;

  /// Marks the user as signed in.
  void login() => state = true;

  /// Signs the user out.
  void logout() => state = false;
}

/// `true` when a user is signed in.
final authControllerProvider = NotifierProvider<AuthController, bool>(
  AuthController.new,
);
