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
}
