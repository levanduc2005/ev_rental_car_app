import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/features/checkin/data/models/docuseal_contract_model.dart';
import 'package:rental_car/features/checkin/data/models/license_status_model.dart';
import 'package:rental_car/features/checkin/data/models/pickup_checklist_model.dart';
import 'package:rental_car/features/checkin/domain/entities/pickup_checklist_entity.dart';

void main() {
  group('LicenseStatusModel', () {
    test('fromJson and toJson map correctly', () {
      final json = <String, dynamic>{
        'userId': 12,
        'licenseStatus': 'APPROVED',
        'licenseNumber': '790123456789',
        'licenseExpiryDate': '2030-12-31',
        'rejectReason': null,
      };

      final model = LicenseStatusModel.fromJson(json);
      expect(model.userId, 12);
      expect(model.licenseStatus, 'APPROVED');
      expect(model.isApproved, true);
      expect(model.licenseNumber, '790123456789');

      final serialized = model.toJson();
      expect(serialized['userId'], 12);
      expect(serialized['licenseStatus'], 'APPROVED');
    });

    test('isApproved is false when pending or not submitted', () {
      final model = LicenseStatusModel.fromJson({
        'userId': 12,
        'licenseStatus': 'PENDING',
      });
      expect(model.isApproved, false);
      expect(model.isPending, true);
    });
  });

  group('PickupChecklistModel', () {
    test('fromJson and toJson map correctly', () {
      final json = <String, dynamic>{
        'checklistId': 88,
        'rentalId': 105,
        'type': 'PICKUP',
        'odometer': 12540,
        'batteryPercentage': 95,
        'hasPortableCharger': true,
        'hasTireRepairKit': true,
        'hasChargingCard': true,
        'photoCount': 4,
        'createdAt': '2026-10-15T13:45:22.000',
      };

      final model = PickupChecklistModel.fromJson(json);
      expect(model.checklistId, 88);
      expect(model.rentalId, 105);
      expect(model.odometer, 12540);
      expect(model.batteryPercentage, 95);
      expect(model.hasPortableCharger, true);
      expect(model.hasTireRepairKit, true);
      expect(model.hasChargingCard, true);

      final serialized = model.toJson();
      expect(serialized['rentalId'], 105);
      expect(serialized['odometer'], 12540);
    });
  });

  group('CarImagesEntity & AccessoryChecklistEntity', () {
    test('CarImagesEntity calculates isComplete correctly', () {
      const incomplete = CarImagesEntity(
        frontUrl: 'https://img.com/front.jpg',
        backUrl: 'https://img.com/back.jpg',
      );
      expect(incomplete.isComplete, false);
      expect(incomplete.uploadedCount, 2);

      const complete = CarImagesEntity(
        frontUrl: 'https://img.com/front.jpg',
        backUrl: 'https://img.com/back.jpg',
        leftSideUrl: 'https://img.com/left.jpg',
        rightSideUrl: 'https://img.com/right.jpg',
      );
      expect(complete.isComplete, true);
      expect(complete.uploadedCount, 4);

      const freePhotos = CarImagesEntity(
        urls: [
          'https://img.com/car1.jpg',
          'https://img.com/car2.jpg',
          'https://img.com/car3.jpg',
        ],
      );
      expect(freePhotos.isComplete, true);
      expect(freePhotos.uploadedCount, 3);
      expect(freePhotos.allUrls.length, 3);
      expect(
        freePhotos.toJson()['img'],
        'https://img.com/car1.jpg|https://img.com/car2.jpg|https://img.com/car3.jpg',
      );
    });

    test('AccessoryChecklistEntity toJson includes flags', () {
      const acc = AccessoryChecklistEntity();
      expect(acc.hasPortableCharger, true);
      expect(acc.hasTireRepairKit, true);
      expect(acc.hasChargingCard, true);

      final json = acc.toJson();
      expect(json['hasPortableCharger'], true);
    });
  });

  group('DocuSealContractModel', () {
    test('fromJson and toJson map correctly', () {
      final json = <String, dynamic>{
        'rentalId': 105,
        'contractId': 32,
        'contractCode': 'HD-EMOTION-105',
        'contractStatus': 'PENDING_SIGNATURE',
        'signingUrl': 'https://docuseal.com/s/abcdef123456',
        'slug': 'abcdef123456',
      };

      final model = DocuSealContractModel.fromJson(json);
      expect(model.rentalId, 105);
      expect(model.contractId, 32);
      expect(model.contractCode, 'HD-EMOTION-105');
      expect(model.isPending, true);
      expect(model.isSigned, false);
      expect(model.signingUrl, 'https://docuseal.com/s/abcdef123456');

      final serialized = model.toJson();
      expect(serialized['contractCode'], 'HD-EMOTION-105');
    });
  });

  group('ContractConfirmResultModel', () {
    test('fromJson and toJson map correctly', () {
      final json = <String, dynamic>{
        'rentalId': 105,
        'status': 'ACTIVE',
        'contractStatus': 'SIGNED',
        'activatedAt': '2026-10-15T13:50:00.000',
      };

      final model = ContractConfirmResultModel.fromJson(json);
      expect(model.rentalId, 105);
      expect(model.isActive, true);
      expect(model.status, 'ACTIVE');
      expect(model.contractStatus, 'SIGNED');
    });
  });
}
