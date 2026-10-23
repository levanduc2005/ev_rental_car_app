import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/features/profile/data/models/rental_detail_model.dart';
import 'package:rental_car/features/profile/data/models/rental_item_model.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';

void main() {
  group('RentalDetailEntity', () {
    test('status getters and computed fields return correct values', () {
      final ongoing = RentalDetailEntity(
        id: 1,
        status: 'ONGOING',
        vehicleName: 'VF8',
        rentalDepositAmount: 3000000,
        reservationDepositAmount: 500000,
        endTime: DateTime.now().subtract(const Duration(minutes: 10)),
      );

      expect(ongoing.isOngoing, isTrue);
      expect(ongoing.totalDeposit, 3500000);
      expect(ongoing.isOverdueTime, isTrue);

      const confirm = RentalDetailEntity(
        id: 2,
        status: 'CONFIRM',
        vehicleName: 'VF8',
      );
      expect(confirm.isConfirm, isTrue);

      const deposited = RentalDetailEntity(
        id: 3,
        status: 'DEPOSITED',
        vehicleName: 'VF8',
      );
      expect(deposited.isDeposited, isTrue);

      const pendingFee = RentalDetailEntity(
        id: 4,
        status: 'PENDING_FEE',
        vehicleName: 'VF8',
      );
      expect(pendingFee.isPendingFee, isTrue);

      const checking = RentalDetailEntity(
        id: 5,
        status: 'CHECKING',
        vehicleName: 'VF8',
      );
      expect(checking.isChecking, isTrue);

      const overdue = RentalDetailEntity(
        id: 6,
        status: 'OVERDUE',
        vehicleName: 'VF8',
      );
      expect(overdue.isOverdue, isTrue);

      const completed = RentalDetailEntity(
        id: 7,
        status: 'COMPLETED',
        vehicleName: 'VF8',
      );
      expect(completed.isCompleted, isTrue);

      const cancelled = RentalDetailEntity(
        id: 8,
        status: 'CANCELLED',
        vehicleName: 'VF8',
      );
      expect(cancelled.isCancelled, isTrue);
    });

    test('canStartCheckIn calculates correctly', () {
      const explicit = RentalDetailEntity(
        id: 1,
        status: 'ONGOING',
        vehicleName: 'VF8',
        canCheckIn: true,
      );
      expect(explicit.canStartCheckIn, isTrue);

      final now = DateTime.now();
      final soon = RentalDetailEntity(
        id: 2,
        status: 'CONFIRM',
        vehicleName: 'VF8',
        startTime: now.add(const Duration(minutes: 15)),
      );
      expect(soon.canStartCheckIn, isTrue);

      final tooEarly = RentalDetailEntity(
        id: 3,
        status: 'CONFIRM',
        vehicleName: 'VF8',
        startTime: now.add(const Duration(hours: 2)),
      );
      expect(tooEarly.canStartCheckIn, isFalse);

      const cancelled = RentalDetailEntity(
        id: 4,
        status: 'CANCELLED',
        vehicleName: 'VF8',
      );
      expect(cancelled.canStartCheckIn, isFalse);
    });
  });

  group('RentalDetailModel', () {
    test('fromJson and toEntity parse comprehensive backend structure', () {
      final json = {
        'id': 10,
        'status': 'ONGOING',
        'startTime': '2026-10-01T08:00:00Z',
        'endTime': '2026-10-01T16:00:00Z',
        'rentFee': 800000,
        'discountPoint': 10,
        'createdAt': '2026-10-01T07:30:00Z',
        'vehicle': {
          'id': 5,
          'name': 'VinFast VF8 Eco',
          'plateNumber': '51K-55555',
          'batteryCapacity': 87.7,
          'currentBattery': 92.0,
          'seatCapacity': 5,
          'pricePerHour': 100000,
          'pricePerDay': 1500000,
          'images': [
            {'url': 'https://car1.png', 'main': true},
          ],
          'station': {
            'name': 'Trạm Quận 1',
            'address': 'Nguyen Hue',
            'latitude': 10.77,
            'longitude': 106.70,
          },
        },
        'rentalDeposit': {'amount': 3000000, 'status': 'PAID'},
        'reservationDeposit': {'amount': 500000, 'status': 'PAID'},
        'rentalCheckLists': [
          {'id': 1, 'type': 'CHECK_IN', 'currentBattery': 95.0},
          {'id': 2, 'type': 'CHECK_OUT', 'currentBattery': 50.0},
        ],
        'vehicleLog': {
          'cost': 400000,
          'repairItems': [
            {'description': 'Vết xước cản trước', 'cost': 400000},
          ],
          'imgs': ['https://dmg.png'],
        },
        'staff': {'id': 9, 'name': 'Tran Staff', 'phone': '0987654321'},
        'reservation': {'id': 99, 'code': 'RES-99'},
        'userEmail': 'renter@test.com',
        'canCheckIn': true,
      };

      final model = RentalDetailModel.fromJson(json);

      expect(model.id, 10);
      expect(model.vehicleId, 5);
      expect(model.staffId, 9);
      expect(model.status, 'ONGOING');
      expect(model.vehicleName, 'VinFast VF8 Eco');
      expect(model.vehiclePlateNumber, '51K-55555');
      expect(model.vehicleImage, 'https://car1.png');
      expect(model.batteryCapacity, 87.7);
      expect(model.currentBattery, 92.0);
      expect(model.seatCapacity, 5);
      expect(model.pricePerHour, 100000.0);
      expect(model.pricePerDay, 1500000.0);
      expect(model.stationName, 'Trạm Quận 1');
      expect(model.stationAddress, 'Nguyen Hue');
      expect(model.rentalDepositAmount, 3000000.0);
      expect(model.reservationDepositAmount, 500000.0);
      expect(model.checkInChecklist, isNotNull);
      expect(model.checkOutChecklist, isNotNull);
      expect(model.vehicleDamages.length, 1);
      expect(model.vehicleDamageCost, 400000.0);
      expect(model.vehicleDamageImages, ['https://dmg.png']);
      expect(model.staffName, 'Tran Staff');
      expect(model.reservationId, 99);
      expect(model.canCheckIn, isTrue);

      final entity = model.toEntity();
      expect(entity.id, 10);
      expect(entity.vehicleName, 'VinFast VF8 Eco');
    });

    test('fromJson handles fallback direct vehicleDamages list', () {
      final json = {
        'id': 20,
        'status': 'COMPLETED',
        'vehicleDamages': [
          {'description': 'Vỡ đèn sau', 'cost': 800000},
        ],
      };

      final model = RentalDetailModel.fromJson(json);
      expect(model.vehicleDamages.length, 1);
      expect(model.vehicleDamageCost, 800000.0);
    });
  });

  group('RentalItemModel', () {
    test('fromJson and toEntity parse correctly', () {
      final json = {
        'id': 100,
        'vehicleName': 'VinFast VF5 Plus',
        'vehicleImage': 'https://vf5.png',
        'stationName': 'Trạm Q1',
        'status': 'COMPLETED',
        'createdAt': '2026-10-01T12:00:00Z',
        'paymentUrl': 'https://pay.vn',
      };

      final model = RentalItemModel.fromJson(json);

      expect(model.id, 100);
      expect(model.vehicleName, 'VinFast VF5 Plus');
      expect(model.status, 'COMPLETED');

      final entity = model.toEntity();
      expect(entity.id, 100);
      expect(entity.vehicleName, 'VinFast VF5 Plus');
      expect(entity.paymentUrl, 'https://pay.vn');
      expect(entity.createdAt, isNotNull);
    });
  });
}
