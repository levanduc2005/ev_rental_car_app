import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/features/auth/data/datasources/google_auth_service.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

void main() {
  late MockGoogleSignIn mockGoogleSignIn;
  late MockGoogleSignInAccount mockAccount;
  late MockGoogleSignInAuthentication mockAuth;
  late GoogleAuthServiceImpl service;

  setUp(() {
    mockGoogleSignIn = MockGoogleSignIn();
    mockAccount = MockGoogleSignInAccount();
    mockAuth = MockGoogleSignInAuthentication();
    service = GoogleAuthServiceImpl(googleSignIn: mockGoogleSignIn);
  });

  group('GoogleAuthServiceImpl', () {
    test('instantiates with default constructor without throwing', () {
      final defaultService = GoogleAuthServiceImpl();
      expect(defaultService, isNotNull);
    });

    test('signIn handles already signed in user and returns auth', () async {
      when(() => mockGoogleSignIn.isSignedIn()).thenAnswer((_) async => true);
      when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => null);
      when(
        () => mockGoogleSignIn.signIn(),
      ).thenAnswer((_) async => mockAccount);
      when(() => mockAccount.authentication).thenAnswer((_) async => mockAuth);

      final result = await service.signIn();

      expect(result, equals(mockAuth));
      verify(() => mockGoogleSignIn.signOut()).called(1);
      verify(() => mockGoogleSignIn.signIn()).called(1);
    });

    test('signIn returns null when account is null', () async {
      when(() => mockGoogleSignIn.isSignedIn()).thenAnswer((_) async => false);
      when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

      final result = await service.signIn();

      expect(result, isNull);
      verifyNever(() => mockGoogleSignIn.signOut());
    });

    test('signOut swallows errors gracefully', () async {
      when(
        () => mockGoogleSignIn.signOut(),
      ).thenThrow(Exception('sign out error'));
      when(
        () => mockGoogleSignIn.disconnect(),
      ).thenThrow(Exception('disconnect error'));

      await expectLater(service.signOut(), completes);
      verify(() => mockGoogleSignIn.signOut()).called(1);
      verify(() => mockGoogleSignIn.disconnect()).called(1);
    });

    test('signOut calls signOut and disconnect on success', () async {
      when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => null);
      when(() => mockGoogleSignIn.disconnect()).thenAnswer((_) async => null);

      await service.signOut();
      verify(() => mockGoogleSignIn.signOut()).called(1);
      verify(() => mockGoogleSignIn.disconnect()).called(1);
    });
  });
}
