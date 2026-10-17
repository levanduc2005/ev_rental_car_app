import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/features/rating/data/models/rating_model.dart';

void main() {
  group('RatingModel', () {
    test('fromJson and toEntity parse backend response correctly', () {
      final json = <String, dynamic>{
        'id': 101,
        'rentalId': 55,
        'score': 4,
        'comment': 'Xe chạy tốt, dịch vụ nhanh',
        'userId': 12,
        'createdAt': '2026-10-10T14:30:00Z',
      };

      final model = RatingModel.fromJson(json);

      expect(model.id, 101);
      expect(model.rentalId, 55);
      expect(model.score, 4);
      expect(model.comment, 'Xe chạy tốt, dịch vụ nhanh');
      expect(model.userId, 12);
      expect(model.createdAt, '2026-10-10T14:30:00Z');

      final entity = model.toEntity();
      expect(entity.id, 101);
      expect(entity.rentalId, 55);
      expect(entity.score, 4);
      expect(entity.comment, 'Xe chạy tốt, dịch vụ nhanh');
      expect(entity.userId, 12);
      expect(entity.createdAt, DateTime.parse('2026-10-10T14:30:00Z'));
    });

    test('toJson creates expected Map', () {
      const model = RatingModel(
        id: 7,
        rentalId: 20,
        score: 5,
        comment: 'Hoàn hảo',
        userId: 3,
      );

      final json = model.toJson();
      expect(json['id'], 7);
      expect(json['rentalId'], 20);
      expect(json['score'], 5);
      expect(json['comment'], 'Hoàn hảo');
      expect(json['userId'], 3);
    });
  });
}
