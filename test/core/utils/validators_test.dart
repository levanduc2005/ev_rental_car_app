import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/core/utils/validators.dart';

void main() {
  group('AppValidators.email', () {
    const requiredMsg = 'Email is required';
    const invalidMsg = 'Invalid email';

    test('returns required message when input is null or empty', () {
      expect(
        AppValidators.email(
          null,
          requiredMessage: requiredMsg,
          invalidMessage: invalidMsg,
        ),
        equals(requiredMsg),
      );

      expect(
        AppValidators.email(
          '',
          requiredMessage: requiredMsg,
          invalidMessage: invalidMsg,
        ),
        equals(requiredMsg),
      );

      expect(
        AppValidators.email(
          '   ',
          requiredMessage: requiredMsg,
          invalidMessage: invalidMsg,
        ),
        equals(requiredMsg),
      );
    });

    test('returns invalid message when email format is invalid', () {
      final invalidEmails = [
        'plainaddress',
        r'#@%^%#$@#$@#.com',
        '@example.com',
        'Joe Smith <email@example.com>',
        'email.example.com',
        'email@example@example.com',
        'email@example',
      ];

      for (final email in invalidEmails) {
        expect(
          AppValidators.email(
            email,
            requiredMessage: requiredMsg,
            invalidMessage: invalidMsg,
          ),
          equals(invalidMsg),
          reason: 'Expected "$email" to be invalid',
        );
      }
    });

    test('returns null when email format is valid', () {
      final validEmails = [
        'email@example.com',
        'firstname.lastname@example.com',
        'email@subdomain.example.com',
        'firstname+lastname@example.com',
        '1234567890@example.com',
        'email@example-one.com',
        'email@example.co.jp',
        'firstname-lastname@example.com',
      ];

      for (final email in validEmails) {
        expect(
          AppValidators.email(
            email,
            requiredMessage: requiredMsg,
            invalidMessage: invalidMsg,
          ),
          isNull,
          reason: 'Expected "$email" to be valid',
        );
      }
    });
  });
}
