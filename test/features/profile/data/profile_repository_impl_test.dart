import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:rental_car/features/profile/data/models/kyc_document_model.dart';
import 'package:rental_car/features/profile/data/models/user_profile_model.dart';
import 'package:rental_car/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:rental_car/features/profile/domain/entities/kyc_document_entity.dart';

class MockProfileRemoteDataSource extends Mock
    implements ProfileRemoteDataSource {}

void main() {
  late MockProfileRemoteDataSource mockRemoteDataSource;
  late ProfileRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockProfileRemoteDataSource();
    repository = ProfileRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('ProfileRepositoryImpl', () {
    test('getProfile returns UserProfileEntity when successful', () async {
      const model = UserProfileModel(
        email: 'test@example.com',
        fullName: 'Test User',
        point: 200,
      );

      when(
        () => mockRemoteDataSource.getProfile(),
      ).thenAnswer((_) async => model);

      final result = await repository.getProfile();

      expect(result.isOk, isTrue);
      expect(result.valueOrNull?.email, 'test@example.com');
      expect(result.valueOrNull?.point, 200);
      verify(() => mockRemoteDataSource.getProfile()).called(1);
    });

    test('getProfile returns ServerFailure on ServerException', () async {
      when(() => mockRemoteDataSource.getProfile()).thenThrow(
        const ServerException(statusCode: 500, message: 'Lỗi hệ thống'),
      );

      final result = await repository.getProfile();

      expect(result.isErr, isTrue);
      expect(result.failureOrNull, isA<ServerFailure>());
      expect(result.failureOrNull?.message, 'Lỗi hệ thống');
    });

    test('uploadKycDocument uploads image and document successfully', () async {
      when(
        () => mockRemoteDataSource.uploadImage(any()),
      ).thenAnswer((_) async => 'https://cloudinary.com/uploaded.jpg');

      const docModel = KycDocumentModel(
        id: 10,
        imgUrl: 'https://cloudinary.com/uploaded.jpg',
        type: 'LICENSE',
        number: '123456789',
      );

      when(
        () => mockRemoteDataSource.uploadDocument(
          imgUrl: any(named: 'imgUrl'),
          type: any(named: 'type'),
          number: any(named: 'number'),
          email: any(named: 'email'),
        ),
      ).thenAnswer((_) async => docModel);

      final result = await repository.uploadKycDocument(
        imagePath: '/path/to/img.jpg',
        type: DocumentType.license,
        number: '123456789',
        licenseClass: 'B2',
        email: 'test@example.com',
      );

      expect(result.isOk, isTrue);
      expect(result.valueOrNull?.number, '123456789');
      expect(result.valueOrNull?.licenseClass, 'B2');
      verify(
        () => mockRemoteDataSource.uploadImage('/path/to/img.jpg'),
      ).called(1);
    });
  });
}
