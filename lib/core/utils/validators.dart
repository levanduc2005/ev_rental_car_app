/// Utility class for reusable input validations across the app.
abstract final class AppValidators {
  static final _emailRegex = RegExp(
    r'^[\w\+\-\.]+@([\w\-]+\.)+[\w\-]{2,}$',
  );

  /// Validates an email address.
  ///
  /// Returns `null` if valid, or the appropriate localized message on failure.
  static String? email(
    String? value, {
    required String requiredMessage,
    required String invalidMessage,
  }) {
    if (value == null || value.trim().isEmpty) {
      return requiredMessage;
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return invalidMessage;
    }
    return null;
  }
}
