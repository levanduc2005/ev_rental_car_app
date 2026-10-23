import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/features/booking/data/models/booking_fee_model.dart';
import 'package:rental_car/features/booking/data/models/create_reservation_request_model.dart';
import 'package:rental_car/features/booking/data/models/payos_payment_info_model.dart';
import 'package:rental_car/features/booking/data/models/reservation_model.dart';
import 'package:rental_car/features/booking/data/models/vehicle_booking_summary_model.dart';

void main() {
  group('BookingFeeModel & FeeItemModel', () {
    test('fromList parses fee types and calculates total if missing', () {
      final list = [
        {
          'description': 'Phí đặt xe',
          'feeType': 'BOOKING_FEE',
          'value': 400000,
        },
        {
          'description': 'Tiền thế chấp',
          'feeType': 'DEPOSIT',
          'value': 2000000,
        },
        {'description': 'Giữ chỗ', 'feeType': 'HOLD_CAR', 'value': 500000},
      ];

      final model = BookingFeeModel.fromList(list);

      expect(model.bookingFee, 400000);
      expect(model.depositFee, 2000000);
      expect(model.holdCarFee, 500000);
      expect(model.totalAmount, 2400000);
      expect(model.items.length, 3);

      final entity = model.toEntity();
      expect(entity.bookingFee, 400000);
      expect(entity.items.length, 3);
      expect(entity.items.first.description, 'Phí đặt xe');
    });

    test('fromList extracts explicit TOTAL_AMOUNT', () {
      final list = [
        {
          'description': 'Phí đặt xe',
          'feeType': 'BOOKING_FEE',
          'value': 400000,
        },
        {
          'description': 'Tổng cộng',
          'feeType': 'TOTAL_AMOUNT',
          'value': 500000,
        },
      ];

      final model = BookingFeeModel.fromList(list);
      expect(model.totalAmount, 500000);
    });
  });

  group('CreateReservationRequestModel', () {
    test('toJson produces correct map structure', () {
      final start = DateTime(2026, 10, 1, 8, 30);
      final end = DateTime(2026, 10, 1, 16, 30);

      final model = CreateReservationRequestModel(
        userEmail: 'renter@test.com',
        vehicleId: 10,
        stationId: 2,
        startTime: start,
        endTime: end,
        isInstant: true,
      );

      final json = model.toJson();

      expect(json['userEmail'], 'renter@test.com');
      expect(json['vehicleId'], 10);
      expect(json['stationId'], 2);
      expect(json['startTime'], '2026-10-01T08:30:00');
      expect(json['endTime'], '2026-10-01T16:30:00');
      expect(json['paymentMethod'], 'PAYOS');
      expect(json['isInstant'], isTrue);
    });
  });

  group('PayOSPaymentInfoModel', () {
    test('fromJson and toEntity parse payload correctly', () {
      final json = {
        'orderCode': 'ORD-999',
        'amount': 500000,
        'description': 'Hold car fee',
        'accountNumber': '0123456789',
        'accountName': 'E-MOTION CORP',
        'bin': '970422',
        'bankName': 'MBBank',
        'qrCode': 'https://qr.vietqr.io/image.png',
        'checkoutUrl': 'https://checkout.payos.vn/123',
        'expiresAt': '2026-10-01T10:00:00Z',
      };

      final model = PayOSPaymentInfoModel.fromJson(json);

      expect(model.orderCode, 'ORD-999');
      expect(model.amount, 500000.0);
      expect(model.description, 'Hold car fee');
      expect(model.accountNumber, '0123456789');
      expect(model.accountName, 'E-MOTION CORP');
      expect(model.bin, '970422');
      expect(model.bankName, 'MBBank');
      expect(model.qrCodeUrl, 'https://qr.vietqr.io/image.png');
      expect(model.checkoutUrl, 'https://checkout.payos.vn/123');
      expect(model.expiresAt, isNotNull);

      final entity = model.toEntity();
      expect(entity.orderCode, 'ORD-999');
      expect(entity.amount, 500000.0);
    });

    test(
      'fromJson generates fallback VietQR image URL when qrCode is not an http link',
      () {
        final json = {
          'orderCode': 'ORD-888',
          'amount': 300000,
          'accountNumber': '987654321',
          'accountName': 'E-MOTION',
          'expiredAt': 1760000000,
        };

        final model = PayOSPaymentInfoModel.fromJson(json);
        expect(
          model.qrCodeUrl,
          contains('https://img.vietqr.io/image/970422-987654321'),
        );
        expect(model.expiresAt, isNotNull);
      },
    );
  });

  group('VehicleBookingSummaryModel', () {
    test('fromJson and toEntity parse vehicle correctly', () {
      final json = {
        'id': 1,
        'name': 'VinFast VF8 Plus',
        'plateNumber': '51K-12345',
        'images': [
          {'url': 'https://image.com/vf8.png'},
        ],
        'batteryLevel': 85,
        'station': {'id': 10, 'name': 'Trạm Quận 1', 'address': '123 Le Loi'},
        'vehiclePriceDto': {
          'rentalRate_4Hours': 400000,
          'rentalRate_8Hours': 700000,
          'rentalRate_12Hours': 1000000,
          'rentalRate_24Hours': 1500000,
        },
        'depositFee': 3000000,
        'holdFee': 5000,
        'seats': 5,
        'status': 'AVAILABLE',
      };

      final model = VehicleBookingSummaryModel.fromJson(json);

      expect(model.id, 1);
      expect(model.name, 'VinFast VF8 Plus');
      expect(model.plateNumber, '51K-12345');
      expect(model.imageUrl, 'https://image.com/vf8.png');
      expect(model.batteryPercentage, 85);
      expect(model.stationId, 10);
      expect(model.stationName, 'Trạm Quận 1');
      expect(model.stationAddress, '123 Le Loi');
      expect(model.price4h, 400000);
      expect(model.price8h, 700000);
      expect(model.price12h, 1000000);
      expect(model.price24h, 1500000);
      expect(model.depositFee, 3000000.0);
      expect(model.seats, 5);

      final entity = model.toEntity();
      expect(entity.id, 1);
      expect(entity.name, 'VinFast VF8 Plus');
      expect(entity.pricePer4Hours, 400000);
    });

    test('fromJson handles brand/model fallback and string image', () {
      final json = {
        'id': 2,
        'brand': 'VinFast',
        'model': 'VF3',
        'images': ['https://image.com/vf3.png'],
        'stationId': 5,
        'stationName': 'Trạm Q7',
      };

      final model = VehicleBookingSummaryModel.fromJson(json);
      expect(model.name, 'VinFast VF3');
      expect(model.imageUrl, 'https://image.com/vf3.png');
      expect(model.stationId, 5);
    });
  });

  group('ReservationModel', () {
    test('fromJson parses nested reservation response wrapper', () {
      final json = {
        'reservation': {
          'id': 101,
          'code': 'RES-101',
          'status': 'PENDING',
          'createdAt': '2026-10-01T08:00:00Z',
          'startTime': '2026-10-01T10:00:00Z',
          'endTime': '2026-10-01T18:00:00Z',
        },
        'vnpayUrl': 'https://pay.vn',
        'payos': {
          'orderCode': 'ORD-101',
          'amount': 500000,
          'accountNumber': '123',
          'accountName': 'EMOTION',
        },
        'deposit': {'amount': 500000},
      };

      final model = ReservationModel.fromJson(json);

      expect(model.id, 101);
      expect(model.code, 'RES-101');
      expect(model.status, 'PENDING');
      expect(model.paymentUrl, 'https://pay.vn');
      expect(model.paymentInfo?.orderCode, 'ORD-101');
      expect(model.depositAmount, 500000.0);

      final entity = model.toEntity();
      expect(entity.id, 101);
      expect(entity.code, 'RES-101');
      expect(entity.isPending, isTrue);
    });

    test('fromJson parses flat reservation with station and user', () {
      final json = {
        'id': 202,
        'code': 'RES-202',
        'status': 'CONFIRMED',
        'station': {
          'id': 7,
          'name': 'Trạm Thủ Đức',
          'address': 'Khu Công Nghệ Cao',
        },
        'user': {'email': 'driver@test.com'},
        'vehicleName': 'VF6 Base',
        'vehicleImage': 'https://image.com/vf6.png',
        'totalRentAmount': 800000,
      };

      final model = ReservationModel.fromJson(json);

      expect(model.id, 202);
      expect(model.stationId, 7);
      expect(model.stationName, 'Trạm Thủ Đức');
      expect(model.userEmail, 'driver@test.com');
      expect(model.vehicleName, 'VF6 Base');
      expect(model.totalRentAmount, 800000.0);

      final entity = model.toEntity();
      expect(entity.id, 202);
      expect(entity.vehicleName, 'VF6 Base');
      expect(entity.vehicleImageUrl, 'https://image.com/vf6.png');
      expect(entity.pickupLocation, 'Khu Công Nghệ Cao');

      final copied = model.copyWith(status: 'COMPLETED');
      expect(copied.status, 'COMPLETED');
    });
  });
}
