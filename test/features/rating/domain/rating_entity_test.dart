import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/features/rating/domain/entities/rating_entity.dart';

void main() {
  group('RatingEntity', () {
    test('equality, hashCode and toString work as expected', () {
      const r1 = RatingEntity(
        id: 1,
        rentalId: 10,
        score: 5,
        comment: 'Tuyệt vời',
        userId: 2,
      );
      const r2 = RatingEntity(
        id: 1,
        rentalId: 10,
        score: 5,
        comment: 'Tuyệt vời',
        userId: 2,
      );
      const r3 = RatingEntity(
        id: 2,
        rentalId: 10,
        score: 4,
        comment: 'Khá tốt',
        userId: 3,
      );

      expect(r1, equals(r2));
      expect(r1.hashCode, equals(r2.hashCode));
      expect(r1 == r3, isFalse);
      expect(r1.toString(), contains('RatingEntity'));
    });
  });
}
