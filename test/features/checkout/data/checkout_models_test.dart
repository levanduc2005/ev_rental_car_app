import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/features/checkout/data/models/rental_checklist_model.dart';
import 'package:rental_car/features/checkout/data/models/rental_overview_model.dart';
import 'package:rental_car/features/checkout/data/models/vehicle_damage_item_model.dart';
import 'package:rental_car/features/checkout/data/models/vehicle_log_model.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_overview_entity.dart';
import 'package:rental_car/features/checkout/domain/entities/vehicle_damage_item_entity.dart';

void main() {
  group('RentalOverviewEntity & Model', () {
    test(
      'calculates balances, refundAmount and additionalPayment correctly',
      () {
        const positiveOverview = RentalOverviewEntity(
          rentalId: 1,
          reservationDeposit: 500000,
          rentalDeposit: 2000000,
          checkListFee: 200000,
          vehicleDamageFee: 300000,
        );

        expect(positiveOverview.totalDeposits, 2500000);
        expect(positiveOverview.totalCharges, 500000);
        expect(positiveOverview.balance, 2000000);
        expect(positiveOverview.requiresAdditionalPayment, isFalse);
        expect(positiveOverview.refundAmount, 2000000);
        expect(positiveOverview.additionalPaymentAmount, 0.0);

        const negativeOverview = RentalOverviewEntity(
          rentalId: 2,
          reservationDeposit: 500000,
          checkListFee: 300000,
          vehicleDamageFee: 800000,
        );

        expect(negativeOverview.balance, -600000);
        expect(negativeOverview.requiresAdditionalPayment, isTrue);
        expect(negativeOverview.refundAmount, 0.0);
        expect(negativeOverview.additionalPaymentAmount, 600000);
      },
    );

    test('RentalOverviewModel fromJson parses nested data accurately', () {
      final json = {
        'rentalResponse': {
          'id': 100,
          'vehicle': {
            'id': 15,
            'name': 'VinFast VF9',
            'plateNumber': '51H-99999',
          },
          'station': {
            'name': 'Trạm Quận 7',
            'address': 'Nguyen Van Linh',
            'latitude': 10.73,
            'longitude': 106.71,
          },
          'vehicleLog': {
            'imgs': ['https://damage1.png', 'https://damage2.png'],
          },
        },
        'vehicleDamages': [
          {'description': 'Vết trầy cửa sổ', 'cost': 500000},
        ],
        'checkListFee': 100000,
        'reservationDeposit': 500000,
        'rentalDeposit': 3000000,
        'vehicleDamageFee': 500000,
        'refundEligible': true,
      };

      final model = RentalOverviewModel.fromJson(json);

      expect(model.rentalId, 100);
      expect(model.vehicleId, 15);
      expect(model.vehicleName, 'VinFast VF9');
      expect(model.vehiclePlateNumber, '51H-99999');
      expect(model.stationName, 'Trạm Quận 7');
      expect(model.stationAddress, 'Nguyen Van Linh');
      expect(model.stationLatitude, 10.73);
      expect(model.stationLongitude, 106.71);
      expect(model.checkListFee, 100000.0);
      expect(model.reservationDeposit, 500000.0);
      expect(model.rentalDeposit, 3000000.0);
      expect(model.vehicleDamages.length, 1);
      expect(model.vehicleDamages.first.description, 'Vết trầy cửa sổ');
      expect(model.vehicleDamageFee, 500000.0);
      expect(model.vehicleDamageImages.length, 2);
      expect(model.refundEligible, isTrue);
    });
  });

  group('VehicleDamageItemModel & Entity', () {
    test('fromJson creates expected instance', () {
      final json = {'description': 'Vỡ gương', 'cost': 1200000};
      final item = VehicleDamageItemModel.fromJson(json);

      expect(item.description, 'Vỡ gương');
      expect(item.cost, 1200000.0);
      expect(item, isA<VehicleDamageItemEntity>());
    });
  });

  group('VehicleLogModel', () {
    test('fromJson parses repairItems and split string images correctly', () {
      final json = {
        'id': 12,
        'repairItems': [
          {'description': 'Lốp xẹp', 'cost': 200000},
        ],
        'totalCost': 200000,
        'images': 'img1.png|img2.png',
        'createdAt': '2026-10-01T15:00:00Z',
        'vehicleId': 5,
        'staffId': 3,
        'rentalId': 10,
      };

      final log = VehicleLogModel.fromJson(json);

      expect(log.id, 12);
      expect(log.repairItems.length, 1);
      expect(log.cost, 200000.0);
      expect(log.imgs, ['img1.png', 'img2.png']);
      expect(log.vehicleId, 5);
      expect(log.staffId, 3);
      expect(log.rentalId, 10);
      expect(log.createdAt, isNotNull);
    });
  });

  group('RentalChecklistModel', () {
    test('fromJson parses checklist fields with penaltyFee fallback', () {
      final json = {
        'id': 50,
        'type': 'CHECK_OUT',
        'currentBattery': 75.5,
        'penaltyFee': 150000,
        'img': 'https://car_check.png',
        'createdAt': '2026-10-01T12:00:00Z',
        'rentalId': 20,
        'staffEmail': 'staff@emotion.vn',
      };

      final checklist = RentalChecklistModel.fromJson(json);

      expect(checklist.id, 50);
      expect(checklist.type, 'CHECK_OUT');
      expect(checklist.currentBattery, 75.5);
      expect(checklist.fee, 150000.0);
      expect(checklist.img, 'https://car_check.png');
      expect(checklist.rentalId, 20);
      expect(checklist.staffEmail, 'staff@emotion.vn');
      expect(checklist.createdAt, isNotNull);
    });
  });
}
