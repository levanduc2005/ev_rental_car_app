import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/features/active_trip/data/models/extend_rental_preview_model.dart';
import 'package:rental_car/features/active_trip/data/models/extend_rental_result_model.dart';
import 'package:rental_car/features/active_trip/data/models/vehicle_schedule_model.dart';

void main() {
  group('VehicleScheduleModel', () {
    test('fromJson & toEntity map correctly', () {
      final json = {
        'startTime': '2026-10-25T10:00:00Z',
        'endTime': '2026-10-25T14:00:00Z',
      };

      final model = VehicleScheduleModel.fromJson(json);
      final entity = model.toEntity();

      expect(model.startTime, DateTime.parse('2026-10-25T10:00:00Z'));
      expect(model.endTime, DateTime.parse('2026-10-25T14:00:00Z'));
      expect(entity.startTime, model.startTime);
      expect(entity.endTime, model.endTime);
    });
  });

  group('ExtendRentalResultModel', () {
    test('fromJson & toEntity map correctly with all fields', () {
      final json = {
        'url': 'https://pay.payos.vn/web/123456',
        'qrCode': 'https://img.vietqr.io/image/970422-123456-compact2.png',
      };

      final model = ExtendRentalResultModel.fromJson(json);
      final entity = model.toEntity();

      expect(model.url, 'https://pay.payos.vn/web/123456');
      expect(
        model.qrCode,
        'https://img.vietqr.io/image/970422-123456-compact2.png',
      );
      expect(entity.url, model.url);
      expect(entity.qrCode, model.qrCode);
    });

    test('fromJson handles null values with defaults', () {
      final json = <String, dynamic>{};

      final model = ExtendRentalResultModel.fromJson(json);

      expect(model.url, '');
      expect(model.qrCode, isNull);
    });
  });

  group('ExtendRentalPreviewModel', () {
    test('fromJson & toEntity map correctly with all fields', () {
      final json = {
        'additionalFee': 100000.0,
        'newRentFee': 1000000.0,
        'currentRentFee': 900000.0,
        'additionalHours': 1,
        'newReturnTime': '2026-10-25T19:00:00Z',
      };

      final model = ExtendRentalPreviewModel.fromJson(json);
      final entity = model.toEntity();

      expect(model.additionalFee, 100000.0);
      expect(model.newRentFee, 1000000.0);
      expect(model.currentRentFee, 900000.0);
      expect(model.additionalHours, 1);
      expect(entity.additionalFee, model.additionalFee);
      expect(entity.newRentFee, model.newRentFee);
      expect(entity.currentRentFee, model.currentRentFee);
      expect(entity.additionalHours, model.additionalHours);
      expect(entity.newReturnTime, model.newReturnTime);
    });

    test('fromJson handles empty json with defaults', () {
      final json = <String, dynamic>{};

      final model = ExtendRentalPreviewModel.fromJson(json);

      expect(model.additionalFee, 0.0);
      expect(model.newRentFee, 0.0);
      expect(model.currentRentFee, 0.0);
      expect(model.additionalHours, 0);
      expect(model.newReturnTime, isNotNull);
    });
  });
}
