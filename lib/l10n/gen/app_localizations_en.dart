// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'EV Rental App';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeWelcome => 'Welcome! Ready to rent an EV?';

  @override
  String get homeSubtitle => 'Find EV cars and charging stations near you.';

  @override
  String routeNotFound(String location) {
    return 'Page not found: $location';
  }

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get comingSoon => 'Coming soon.';

  @override
  String get tabRent => 'Rental';

  @override
  String get tabMyTrip => 'My Trip';

  @override
  String get tabControl => 'Control';

  @override
  String get tabNotification => 'Notification';

  @override
  String get tabSupport => 'Support';

  @override
  String get loginTitle => 'Welcome Back';

  @override
  String get loginSubtitle => 'Sign in to rent an EV car.';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailInvalid => 'Enter a valid email address.';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordTooShort => 'Password is too short.';

  @override
  String get loginButton => 'Sign in';

  @override
  String get logout => 'Log Out';

  @override
  String get logoutConfirmTitle => 'Log Out?';

  @override
  String get logoutConfirmMessage =>
      'You will need to sign in again next time.';

  @override
  String get guestName => 'Demo User';

  @override
  String get guestEmail => 'demo@evrental.com';

  @override
  String get profileAccountSection => 'Account';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileAbout => 'About App';

  @override
  String get errorNetwork => 'No internet connection. Please try again.';

  @override
  String get errorServer =>
      'Something went wrong on our end. Please try again later.';

  @override
  String get errorData => 'We received unexpected data. Please try again.';

  @override
  String get errorCache => 'Could not read local data.';

  @override
  String get errorUnknown => 'An unexpected error occurred.';

  @override
  String get loginTopBarTitle => 'Sign in';

  @override
  String get loginEmailTitle => 'Enter your email to continue';

  @override
  String get loginEmailSubtitle =>
      'Sign in to manage your trips and unlock exclusive member benefits.';

  @override
  String get emailRequired => 'Please enter your email address.';

  @override
  String get continueButton => 'Continue';

  @override
  String get orDivider => 'or';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get otpVerificationTitle => 'OTP Verification';

  @override
  String otpSentToMessage(String email) {
    return 'Enter the OTP code sent to $email';
  }

  @override
  String get changeEmail => 'Change email';

  @override
  String resendOtpIn(int seconds) {
    return 'Resend OTP (${seconds}s)';
  }

  @override
  String get resendOtpNow => 'Resend OTP';

  @override
  String get otpInvalidLength => 'Please enter a 6-digit OTP code.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get kycVerificationTitle => 'Driver License & KYC Verification';

  @override
  String get kycStatusTitle => 'Verification Status';

  @override
  String get kycApproved => 'Approved';

  @override
  String get kycPending => 'Pending';

  @override
  String get kycRejected => 'Rejected';

  @override
  String get kycNone => 'Not Verified';

  @override
  String get driverLicense => 'Driver\'s License (GPLX)';

  @override
  String get idCard => 'Citizen ID Card (CCCD)';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get reuploadDocument => 'Re-upload Document';
}
