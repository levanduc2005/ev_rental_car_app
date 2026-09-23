import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/features/profile/domain/entities/kyc_document_entity.dart';
import 'package:rental_car/features/profile/domain/entities/user_profile_entity.dart';

void main() {
  group('KycDocumentEntity & UserProfileEntity', () {
    test('hasVerifiedLicense returns true when approved license exists', () {
      const doc = KycDocumentEntity(
        id: 1,
        imgUrl: 'https://example.com/license.jpg',
        type: DocumentType.license,
        number: '079123456789',
        status: KycStatus.approved,
      );

      const user = UserProfileEntity(
        email: 'user@example.com',
        documents: [doc],
      );

      expect(user.hasVerifiedLicense, isTrue);
      expect(user.licenseStatus, KycStatus.approved);
      expect(user.licenseDocument?.number, '079123456789');
    });

    test(
      'hasVerifiedLicense returns false when license is pending or none',
      () {
        const doc = KycDocumentEntity(
          id: 2,
          imgUrl: 'https://example.com/license.jpg',
          type: DocumentType.license,
          number: '079123456789',
          status: KycStatus.pending,
        );

        const user = UserProfileEntity(
          email: 'user@example.com',
          documents: [doc],
        );

        expect(user.hasVerifiedLicense, isFalse);
        expect(user.licenseStatus, KycStatus.pending);
      },
    );

    test('licenseStatus returns none when no documents present', () {
      const user = UserProfileEntity(email: 'user@example.com');

      expect(user.hasVerifiedLicense, isFalse);
      expect(user.licenseStatus, KycStatus.none);
      expect(user.licenseDocument, isNull);
    });
  });
}
