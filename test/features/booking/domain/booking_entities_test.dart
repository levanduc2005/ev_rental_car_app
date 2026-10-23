import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/features/booking/domain/entities/booking_fee_entity.dart';
import 'package:rental_car/features/booking/domain/entities/payos_payment_info_entity.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/booking/domain/entities/vehicle_booking_summary.dart';

void main() {
  group('BookingFeeEntity & FeeItemEntity', () {
    test('calculates paymentUponPickup correctly when positive', () {
      const entity = BookingFeeEntity(
        bookingFee: 1000000,
        depositFee: 3000000,
        holdCarFee: 500000,
        totalAmount: 4000000,
        items: [
          FeeItemEntity(
            description: 'Phí thuê',
            feeType: 'RENTAL',
            value: 1000000,
          ),
        ],
      );

      expect(entity.paymentUponPickup, 3500000);
      expect(entity.rentalFee, 1000000);
      expect(entity.bookingCost, 1000000);
      expect(entity.collateralFee, 3000000);
      expect(entity.holdDepositFee, 500000);
      expect(entity.totalCost, 4000000);
      expect(entity.items.length, 1);
      expect(entity.items.first.feeType, 'RENTAL');
    });

    test('paymentUponPickup returns 0 when holdCarFee exceeds sum', () {
      const entity = BookingFeeEntity(
        bookingFee: 100000,
        depositFee: 100000,
        holdCarFee: 500000,
        totalAmount: 200000,
      );

      expect(entity.paymentUponPickup, 0);
    });
  });

  group('VehicleBookingSummary', () {
    test('default getters and values evaluate correctly', () {
      const vehicle = VehicleBookingSummary(
        id: 1,
        name: 'VinFast VF8',
        price4h: 400000,
        price8h: 700000,
        price12h: 1000000,
        price24h: 1500000,
        holdFee: 10000,
        batteryPercentage: 90,
        status: 'AVAILABLE',
      );

      expect(vehicle.location, 'Trạm xe e-Motion');
      expect(vehicle.seats, 4);
      expect(vehicle.transmission, 'Số tự động');
      expect(vehicle.fuelType, 'Điện');
      expect(vehicle.batteryCapacity, 0);
      expect(vehicle.holdDepositFee, 10000);
      expect(vehicle.pricePer4Hours, 400000);
      expect(vehicle.pricePer8Hours, 700000);
      expect(vehicle.pricePer12Hours, 1000000);
      expect(vehicle.pricePerDay, 1500000);
      expect(vehicle.batteryLevel, 90);
      expect(vehicle.isAvailable, isTrue);
    });

    test('isAvailable recognizes various formats and flags non-available', () {
      const v1 = VehicleBookingSummary(id: 1, name: 'VF3', status: 'SẴN SÀNG');
      expect(v1.isAvailable, isTrue);

      const v2 = VehicleBookingSummary(id: 2, name: 'VF5', status: 'SAN SANG');
      expect(v2.isAvailable, isTrue);

      const v3 = VehicleBookingSummary(id: 3, name: 'VF6', status: 'RENTED');
      expect(v3.isAvailable, isFalse);

      const v4 = VehicleBookingSummary(id: 4, name: 'VF7');
      expect(v4.isAvailable, isTrue);
    });

    test('copyWith updates specified fields', () {
      const vehicle = VehicleBookingSummary(
        id: 1,
        name: 'VF8',
        price4h: 400000,
      );

      final updated = vehicle.copyWith(
        name: 'VF9',
        price4h: 600000,
        stationName: 'Trạm Landmark 81',
      );

      expect(updated.name, 'VF9');
      expect(updated.price4h, 600000);
      expect(updated.stationName, 'Trạm Landmark 81');
      expect(updated.id, 1);
    });
  });

  group('ReservationEntity', () {
    test('status getters evaluate correctly', () {
      const pending = ReservationEntity(
        id: 1,
        code: 'RES-01',
        status: 'PENDING',
      );
      expect(pending.isPending, isTrue);
      expect(pending.canCancel, isTrue);

      const waiting = ReservationEntity(
        id: 2,
        code: 'RES-02',
        status: 'WAITING_PAYMENT',
      );
      expect(waiting.isPending, isTrue);

      const confirmed = ReservationEntity(
        id: 3,
        code: 'RES-03',
        status: 'CONFIRMED',
      );
      expect(confirmed.isConfirmed, isTrue);
      expect(confirmed.canCancel, isTrue);

      const active = ReservationEntity(id: 4, code: 'RES-04', status: 'ACTIVE');
      expect(active.isActive, isTrue);
      expect(active.canCancel, isFalse);

      const inProgress = ReservationEntity(
        id: 5,
        code: 'RES-05',
        status: 'IN_PROGRESS',
      );
      expect(inProgress.isActive, isTrue);

      const cancelled = ReservationEntity(
        id: 6,
        code: 'RES-06',
        status: 'CANCELLED',
      );
      expect(cancelled.isCancelled, isTrue);

      const completed = ReservationEntity(
        id: 7,
        code: 'RES-07',
        status: 'COMPLETED',
      );
      expect(completed.isCompleted, isTrue);

      const failed = ReservationEntity(id: 8, code: 'RES-08', status: 'FAILED');
      expect(failed.isFailed, isTrue);

      const overdue = ReservationEntity(
        id: 9,
        code: 'RES-09',
        status: 'OVERDUE',
      );
      expect(overdue.isOverdue, isTrue);
    });

    test('isExpiredHold and holdRemainingSeconds calculate accurately', () {
      final now = DateTime.now();
      final recent = ReservationEntity(
        id: 1,
        code: 'RES-01',
        status: 'PENDING',
        createdAt: now.subtract(const Duration(minutes: 5)),
      );
      expect(recent.isExpiredHold, isFalse);
      expect(recent.holdRemainingSeconds, greaterThan(0));

      final expired = ReservationEntity(
        id: 2,
        code: 'RES-02',
        status: 'PENDING',
        createdAt: now.subtract(const Duration(minutes: 20)),
      );
      expect(expired.isExpiredHold, isTrue);
      expect(expired.holdRemainingSeconds, 0);

      const nonPending = ReservationEntity(
        id: 3,
        code: 'RES-03',
        status: 'CONFIRMED',
      );
      expect(nonPending.isExpiredHold, isFalse);
      expect(nonPending.holdRemainingSeconds, 15 * 60);
    });

    test('canStartCheckIn logic tests window before startTime', () {
      final now = DateTime.now();
      final soon = ReservationEntity(
        id: 1,
        code: 'RES-01',
        status: 'CONFIRMED',
        startTime: now.add(const Duration(minutes: 15)),
      );
      expect(soon.canStartCheckIn, isTrue);

      final tooEarly = ReservationEntity(
        id: 2,
        code: 'RES-02',
        status: 'CONFIRMED',
        startTime: now.add(const Duration(hours: 2)),
      );
      expect(tooEarly.canStartCheckIn, isFalse);

      final unconfirmed = ReservationEntity(
        id: 3,
        code: 'RES-03',
        status: 'PENDING',
        startTime: now,
      );
      expect(unconfirmed.canStartCheckIn, isFalse);
    });

    test('isEligibleForRefund checks 5 days threshold', () {
      final now = DateTime.now();
      final refundable = ReservationEntity(
        id: 1,
        code: 'RES-01',
        status: 'CONFIRMED',
        startTime: now.add(const Duration(days: 6)),
      );
      expect(refundable.isEligibleForRefund, isTrue);

      final nonRefundable = ReservationEntity(
        id: 2,
        code: 'RES-02',
        status: 'CONFIRMED',
        startTime: now.add(const Duration(days: 3)),
      );
      expect(nonRefundable.isEligibleForRefund, isFalse);
    });

    test('totalAmount calculates fallback from vehicle pricing tiers', () {
      final start = DateTime(2026, 10, 1, 8);
      final end4h = DateTime(2026, 10, 1, 12);
      final end8h = DateTime(2026, 10, 1, 16);
      final end12h = DateTime(2026, 10, 1, 20);
      final end24h = DateTime(2026, 10, 2, 8);

      const vehicle = VehicleBookingSummary(
        id: 1,
        name: 'VF8',
        price4h: 400000,
        price8h: 700000,
        price12h: 1000000,
        price24h: 1500000,
      );

      final res4h = ReservationEntity(
        id: 1,
        code: 'R1',
        status: 'PENDING',
        startTime: start,
        endTime: end4h,
        vehicle: vehicle,
      );
      expect(res4h.totalAmount, 400000);

      final res8h = res4h.copyWith(endTime: end8h);
      expect(res8h.totalAmount, 700000);

      final res12h = res4h.copyWith(endTime: end12h);
      expect(res12h.totalAmount, 1000000);

      final res24h = res4h.copyWith(endTime: end24h);
      expect(res24h.totalAmount, 1500000);

      final explicitTotal = res4h.copyWith(totalRentAmount: 999000);
      expect(explicitTotal.totalAmount, 999000);
    });

    test('depositFee, collateralFee, pickupLocation fallbacks', () {
      const payos = PayOSPaymentInfoEntity(
        orderCode: 'ORD-1',
        amount: 500000,
        description: 'Deposit',
        accountNumber: '123',
        accountName: 'EMOTION',
        qrCodeUrl: 'https://qr.png',
      );

      const resWithPayos = ReservationEntity(
        id: 1,
        code: 'R1',
        status: 'PENDING',
        paymentInfo: payos,
        stationAddress: '123 Nguyen Hue',
      );

      expect(resWithPayos.depositFee, 500000);
      expect(resWithPayos.pickupLocation, '123 Nguyen Hue');
      expect(resWithPayos.returnLocation, '123 Nguyen Hue');
      expect(resWithPayos.paymentMethod, 'PayOS (VietQR)');

      const resWithStationName = ReservationEntity(
        id: 2,
        code: 'R2',
        status: 'PENDING',
        stationName: 'Trạm Vincom',
      );
      expect(resWithStationName.pickupLocation, 'Trạm Vincom');

      const resWithStationId = ReservationEntity(
        id: 3,
        code: 'R3',
        status: 'PENDING',
        stationId: 5,
      );
      expect(resWithStationId.pickupLocation, 'Trạm #5');

      const resDefault = ReservationEntity(
        id: 4,
        code: 'R4',
        status: 'PENDING',
      );
      expect(resDefault.pickupLocation, 'Trạm nhận xe e-Motion');
      expect(resDefault.collateralFee, 3000000);
    });
  });
}
