import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/features/profile/data/models/kyc_document_model.dart';
import 'package:rental_car/features/profile/data/models/user_profile_model.dart';
import 'package:rental_car/features/profile/domain/entities/kyc_document_entity.dart';

void main() {
  group('UserProfileModel & KycDocumentModel', () {
    test('fromJson and toEntity map backend response correctly', () {
      final json = {
        'fullName': 'Nguyễn Văn A',
        'email': 'user@example.com',
        'phone': '0987654321',
        'role': 'RENTER',
        'createdAt': '2026-03-01T00:00:00.000Z',
        'point': 150,
        'blocked': false,
        'documents': [
          {
            'id': 1,
            'imgUrl':
                'https://res.cloudinary.com/dy45rrkhf/image/upload/sample.jpg',
            'type': 'LICENSE',
            'number': '079123456789',
            'email': 'user@example.com',
          },
        ],
      };

      final model = UserProfileModel.fromJson(json);
      expect(model.fullName, 'Nguyễn Văn A');
      expect(model.point, 150);
      expect(model.documents.length, 1);

      final entity = model.toEntity();
      expect(entity.fullName, 'Nguyễn Văn A');
      expect(entity.point, 150);
      expect(entity.documents.first.type, DocumentType.license);
      expect(entity.documents.first.number, '079123456789');
      expect(entity.hasVerifiedLicense, isTrue);
    });

    test('KycDocumentModel parses CCCD and rejected status', () {
      final json = {
        'id': 5,
        'imgUrl': 'https://res.cloudinary.com/dy45rrkhf/image/upload/cccd.jpg',
        'type': 'CCCD',
        'number': '012345678901',
        'status': 'REJECTED',
        'rejectReason': 'Ảnh chụp bị lóa sáng',
      };

      final model = KycDocumentModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.type, DocumentType.cccd);
      expect(entity.status, KycStatus.rejected);
      expect(entity.rejectReason, 'Ảnh chụp bị lóa sáng');
    });
  });
}
