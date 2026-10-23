import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/network/api_handler.dart';

void main() {
  group('guardApiCall', () {
    test('returns result on successful call', () async {
      final result = await guardApiCall(() async => 'success');
      expect(result, 'success');
    });

    test('throws NetworkException on connectionTimeout DioException', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      expect(
        () => guardApiCall(() async => throw dioException),
        throwsA(isA<NetworkException>()),
      );
    });

    test('throws NetworkException on sendTimeout DioException', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.sendTimeout,
      );

      expect(
        () => guardApiCall(() async => throw dioException),
        throwsA(isA<NetworkException>()),
      );
    });

    test('throws NetworkException on receiveTimeout DioException', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.receiveTimeout,
      );

      expect(
        () => guardApiCall(() async => throw dioException),
        throwsA(isA<NetworkException>()),
      );
    });

    test('throws NetworkException on connectionError DioException', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionError,
      );

      expect(
        () => guardApiCall(() async => throw dioException),
        throwsA(isA<NetworkException>()),
      );
    });

    test(
      'throws ServerException with message from response data map',
      () async {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
            data: {'message': 'Custom error message'},
          ),
        );

        expect(
          () => guardApiCall(() async => throw dioException),
          throwsA(
            isA<ServerException>()
                .having((e) => e.message, 'message', 'Custom error message')
                .having((e) => e.statusCode, 'statusCode', 400),
          ),
        );
      },
    );

    test(
      'throws ServerException with error key from response data map',
      () async {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 500,
            data: {'error': 'Fallback error'},
          ),
        );

        expect(
          () => guardApiCall(() async => throw dioException),
          throwsA(
            isA<ServerException>().having(
              (e) => e.message,
              'message',
              'Fallback error',
            ),
          ),
        );
      },
    );

    test(
      'throws ServerException with default message when response data is not map',
      () async {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 502,
            data: 'Bad Gateway',
          ),
        );

        expect(
          () => guardApiCall(() async => throw dioException),
          throwsA(
            isA<ServerException>().having(
              (e) => e.message,
              'message',
              'Đã có lỗi xảy ra từ máy chủ.',
            ),
          ),
        );
      },
    );

    test(
      'throws ServerException when response is null but dio exception message exists',
      () async {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          message: 'Unknown dio error',
        );

        expect(
          () => guardApiCall(() async => throw dioException),
          throwsA(
            isA<ServerException>().having(
              (e) => e.message,
              'message',
              'Unknown dio error',
            ),
          ),
        );
      },
    );

    test('rethrows known exceptions directly', () async {
      const serverException = ServerException(
        message: 'Already server exception',
      );
      expect(
        () => guardApiCall(() async => throw serverException),
        throwsA(same(serverException)),
      );

      const networkException = NetworkException('Already network exception');
      expect(
        () => guardApiCall(() async => throw networkException),
        throwsA(same(networkException)),
      );

      const parsingException = ParsingException('Already parsing exception');
      expect(
        () => guardApiCall(() async => throw parsingException),
        throwsA(same(parsingException)),
      );
    });

    test('wraps generic exceptions into ServerException', () async {
      expect(
        () => guardApiCall(() async => throw Exception('Generic failure')),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
