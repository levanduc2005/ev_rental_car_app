import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:rental_car/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:rental_car/features/auth/data/datasources/google_auth_service.dart';
import 'package:rental_car/features/auth/data/models/auth_tokens_model.dart';
import 'package:rental_car/features/auth/data/models/user_model.dart';
import 'package:rental_car/features/auth/data/repositories/auth_repository_impl.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockGoogleAuthService extends Mock implements GoogleAuthService {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

void main() {
  late MockAuthRemoteDataSource remoteDataSource;
  late MockAuthLocalDataSource localDataSource;
  late MockGoogleAuthService googleAuthService;
  late AuthRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const UserModel(email: 'fallback@test.com'));
  });

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    localDataSource = MockAuthLocalDataSource();
    googleAuthService = MockGoogleAuthService();
    repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      googleAuthService: googleAuthService,
    );
  });

  group('AuthRepositoryImpl', () {
    test('completeProfile saves and returns UserEntity on success', () async {
      const userModel = UserModel(email: 'user@test.com', fullName: 'New User');

      when(
        () => remoteDataSource.completeProfile(fullName: 'New User'),
      ).thenAnswer((_) async => userModel);
      when(() => localDataSource.saveUser(any())).thenAnswer((_) async {});

      final result = await repository.completeProfile(fullName: 'New User');

      expect(result.isOk, isTrue);
      result.when(
        ok: (entity) => expect(entity.fullName, 'New User'),
        err: (_) => fail('Expected ok'),
      );
      verify(() => localDataSource.saveUser(userModel)).called(1);
    });

    test('getCurrentUser returns cached user if present', () async {
      const cached = UserModel(email: 'cached@test.com', fullName: 'Cached');
      when(() => localDataSource.getUser()).thenAnswer((_) async => cached);

      final result = await repository.getCurrentUser();

      expect(result.isOk, isTrue);
      result.when(
        ok: (user) => expect(user?.email, 'cached@test.com'),
        err: (_) => fail('Expected ok'),
      );
      verifyNever(() => localDataSource.getAccessToken());
    });

    test(
      'getCurrentUser returns null when no user and no token cached',
      () async {
        when(() => localDataSource.getUser()).thenAnswer((_) async => null);
        when(
          () => localDataSource.getAccessToken(),
        ).thenAnswer((_) async => null);

        final result = await repository.getCurrentUser();

        expect(result.isOk, isTrue);
        result.when(
          ok: (user) => expect(user, isNull),
          err: (_) => fail('Expected ok'),
        );
      },
    );

    test('logout clears local tokens, user and signs out google', () async {
      when(() => remoteDataSource.logout()).thenAnswer((_) async {});
      when(() => googleAuthService.signOut()).thenAnswer((_) async {});
      when(() => localDataSource.clearTokens()).thenAnswer((_) async {});
      when(() => localDataSource.clearUser()).thenAnswer((_) async {});

      final result = await repository.logout();

      expect(result.isOk, isTrue);
      verify(() => googleAuthService.signOut()).called(1);
      verify(() => localDataSource.clearTokens()).called(1);
      verify(() => localDataSource.clearUser()).called(1);
    });

    test('refreshToken fails when old refresh token is missing', () async {
      when(
        () => localDataSource.getRefreshToken(),
      ).thenAnswer((_) async => null);

      final result = await repository.refreshToken();

      expect(result.isErr, isTrue);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (f) => expect(f, isA<ServerFailure>()),
      );
    });

    test('refreshToken succeeds and saves tokens', () async {
      const tokens = AuthTokensModel(
        accessToken: 'new-acc',
        refreshToken: 'new-ref',
      );

      when(
        () => localDataSource.getRefreshToken(),
      ).thenAnswer((_) async => 'old-ref');
      when(
        () => remoteDataSource.refreshToken(refreshToken: 'old-ref'),
      ).thenAnswer((_) async => tokens);
      when(
        () => localDataSource.saveTokens(
          accessToken: 'new-acc',
          refreshToken: 'new-ref',
        ),
      ).thenAnswer((_) async {});

      final result = await repository.refreshToken();

      expect(result.isOk, isTrue);
      result.when(
        ok: (t) => expect(t.accessToken, 'new-acc'),
        err: (_) => fail('Expected ok'),
      );
    });

    test('sendOtp delegates to remoteDataSource', () async {
      when(
        () => remoteDataSource.sendOtp(email: 'a@b.com'),
      ).thenAnswer((_) async {});

      final result = await repository.sendOtp(email: 'a@b.com');

      expect(result.isOk, isTrue);
      verify(() => remoteDataSource.sendOtp(email: 'a@b.com')).called(1);
    });

    test('verifyOtp saves tokens and fetches user successfully', () async {
      const tokens = AuthTokensModel(accessToken: 'acc', refreshToken: 'ref');
      const user = UserModel(email: 'a@b.com', fullName: 'User A');

      when(
        () => remoteDataSource.verifyOtp(email: 'a@b.com', otp: '123456'),
      ).thenAnswer((_) async => tokens);
      when(
        () =>
            localDataSource.saveTokens(accessToken: 'acc', refreshToken: 'ref'),
      ).thenAnswer((_) async {});
      when(
        () => remoteDataSource.getCurrentUser(),
      ).thenAnswer((_) async => user);
      when(() => localDataSource.saveUser(any())).thenAnswer((_) async {});

      final result = await repository.verifyOtp(
        email: 'a@b.com',
        otp: '123456',
      );

      expect(result.isOk, isTrue);
      result.when(
        ok: (u) => expect(u.email, 'a@b.com'),
        err: (_) => fail('Expected ok'),
      );
    });

    test(
      'setProfileSetupSkipped and isProfileSetupSkipped delegate to localDataSource',
      () async {
        when(
          () => localDataSource.setProfileSetupSkipped('a@b.com'),
        ).thenAnswer((_) async {});
        when(
          () => localDataSource.isProfileSetupSkipped('a@b.com'),
        ).thenAnswer((_) async => true);

        final res1 = await repository.setProfileSetupSkipped('a@b.com');
        expect(res1.isOk, isTrue);

        final res2 = await repository.isProfileSetupSkipped('a@b.com');
        expect(res2.isOk, isTrue);
        expect(res2.valueOrNull, isTrue);
      },
    );

    test('signInWithGoogle returns failure when cancelled', () async {
      when(() => googleAuthService.signIn()).thenAnswer((_) async => null);

      final result = await repository.signInWithGoogle();

      expect(result.isErr, isTrue);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (f) => expect(f, isA<ServerFailure>()),
      );
    });

    test(
      'signInWithGoogle returns failure when idToken is null or empty',
      () async {
        final auth = MockGoogleSignInAuthentication();
        when(() => auth.idToken).thenReturn('');
        when(() => googleAuthService.signIn()).thenAnswer((_) async => auth);

        final result = await repository.signInWithGoogle();

        expect(result.isErr, isTrue);
        result.when(
          ok: (_) => fail('Expected err'),
          err: (f) => expect(f, isA<ServerFailure>()),
        );
      },
    );

    test(
      'signInWithGoogle completes login and stores tokens on success',
      () async {
        final auth = MockGoogleSignInAuthentication();
        when(() => auth.idToken).thenReturn('valid-google-id-token');
        when(() => googleAuthService.signIn()).thenAnswer((_) async => auth);

        const tokens = AuthTokensModel(
          accessToken: 'g-acc',
          refreshToken: 'g-ref',
        );
        const user = UserModel(
          email: 'google@test.com',
          fullName: 'Google User',
        );

        when(
          () => remoteDataSource.loginWithGoogle(
            idToken: 'valid-google-id-token',
          ),
        ).thenAnswer((_) async => tokens);
        when(
          () => localDataSource.saveTokens(
            accessToken: 'g-acc',
            refreshToken: 'g-ref',
          ),
        ).thenAnswer((_) async {});
        when(
          () => remoteDataSource.getCurrentUser(),
        ).thenAnswer((_) async => user);
        when(() => localDataSource.saveUser(any())).thenAnswer((_) async {});

        final result = await repository.signInWithGoogle();

        expect(result.isOk, isTrue);
        result.when(
          ok: (u) => expect(u.email, 'google@test.com'),
          err: (_) => fail('Expected ok'),
        );
      },
    );

    test(
      'default constructor creates repository with default GoogleAuthService',
      () {
        final repo = AuthRepositoryImpl(
          remoteDataSource: remoteDataSource,
          localDataSource: localDataSource,
        );
        expect(repo, isNotNull);
      },
    );

    test(
      'getCurrentUser fetches remote user when token exists, and falls back to JWT claims on error',
      () async {
        const validJwt =
            'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqd3RAdGVzdC5jb20iLCJlbWFpbCI6Imp3dEB0ZXN0LmNvbSIsInJvbGUiOiJST0xFX1VTRVIiLCJleHAiOjk5OTk5OTk5OTl9.signature';

        // 1. Success remote user with tokenRole enrichment
        when(() => localDataSource.getUser()).thenAnswer((_) async => null);
        when(
          () => localDataSource.getAccessToken(),
        ).thenAnswer((_) async => validJwt);
        when(() => remoteDataSource.getCurrentUser()).thenAnswer(
          (_) async => const UserModel(email: 'jwt@test.com', role: ''),
        );
        when(() => localDataSource.saveUser(any())).thenAnswer((_) async {});

        final res1 = await repository.getCurrentUser();
        expect(res1.isOk, isTrue);
        expect(res1.valueOrNull?.role, 'ROLE_USER');

        // 2. Remote throws -> falls back to JWT claims
        when(
          () => remoteDataSource.getCurrentUser(),
        ).thenThrow(Exception('offline'));

        final res2 = await repository.getCurrentUser();
        expect(res2.isOk, isTrue);
        expect(res2.valueOrNull?.email, 'jwt@test.com');
      },
    );

    test(
      'verifyOtp and signInWithGoogle fallback to JWT user when getCurrentUser throws',
      () async {
        const validJwt =
            'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqd3RAdGVzdC5jb20iLCJlbWFpbCI6Imp3dEB0ZXN0LmNvbSIsInJvbGUiOiJST0xFX1VTRVIiLCJleHAiOjk5OTk5OTk5OTl9.signature';
        const tokens = AuthTokensModel(
          accessToken: validJwt,
          refreshToken: 'ref',
        );

        when(
          () => remoteDataSource.verifyOtp(
            email: any(named: 'email'),
            otp: any(named: 'otp'),
          ),
        ).thenAnswer((_) async => tokens);
        when(
          () => localDataSource.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => remoteDataSource.getCurrentUser(),
        ).thenThrow(Exception('offline'));
        when(() => localDataSource.saveUser(any())).thenAnswer((_) async {});

        final verifyRes = await repository.verifyOtp(
          email: 'fallback@test.com',
          otp: '123456',
        );
        expect(verifyRes.isOk, isTrue);
        expect(verifyRes.valueOrNull?.email, 'jwt@test.com');

        final auth = MockGoogleSignInAuthentication();
        when(() => auth.idToken).thenReturn('valid-google-id-token');
        when(() => googleAuthService.signIn()).thenAnswer((_) async => auth);
        when(
          () =>
              remoteDataSource.loginWithGoogle(idToken: any(named: 'idToken')),
        ).thenAnswer((_) async => tokens);

        final googleRes = await repository.signInWithGoogle();
        expect(googleRes.isOk, isTrue);
        expect(googleRes.valueOrNull?.email, 'jwt@test.com');
      },
    );
  });
}
