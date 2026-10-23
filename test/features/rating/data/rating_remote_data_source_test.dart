import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/features/rating/data/datasources/rating_remote_data_source.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late RatingRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = RatingRemoteDataSourceImpl(dio: mockDio);
  });

  group('RatingRemoteDataSourceImpl', () {
    test('submitRating returns RatingModel on success', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>(
          '/ratings',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/ratings'),
          data: {
            'data': {
              'id': 1,
              'rentalId': 10,
              'score': 5,
              'comment': 'Good service',
            },
          },
          statusCode: 200,
        ),
      );

      final result = await dataSource.submitRating(
        rentalId: 10,
        score: 5,
        comment: 'Good service',
      );

      expect(result.id, 1);
      expect(result.score, 5);
      expect(result.comment, 'Good service');
    });

    test('getAllRatings returns list on success', () async {
      when(() => mockDio.get<Map<String, dynamic>>('/ratings')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/ratings'),
          data: {
            'data': [
              {'id': 1, 'score': 4},
            ],
          },
          statusCode: 200,
        ),
      );

      final result = await dataSource.getAllRatings();

      expect(result.length, 1);
      expect(result.first.score, 4);
    });

    test('getRatingById returns model on success', () async {
      when(() => mockDio.get<Map<String, dynamic>>('/ratings/1')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/ratings/1'),
          data: {
            'data': {'id': 1, 'score': 5},
          },
          statusCode: 200,
        ),
      );

      final result = await dataSource.getRatingById(1);

      expect(result.id, 1);
      expect(result.score, 5);
    });

    test('getRatingById throws ParsingException when data is null', () async {
      when(() => mockDio.get<Map<String, dynamic>>('/ratings/1')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/ratings/1'),
          data: {'data': null},
          statusCode: 200,
        ),
      );

      expect(
        () => dataSource.getRatingById(1),
        throwsA(isA<ParsingException>()),
      );
    });
  });
}
