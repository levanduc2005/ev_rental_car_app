import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/app/app.dart';
import 'package:rental_car/core/providers/core_providers.dart';
import 'package:rental_car/core/storage/key_value_store.dart';
import 'package:rental_car/core/storage/secure_store.dart';
import 'package:rental_car/features/auth/presentation/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeSecureStore implements SecureStore {
  final Map<String, String> _data = {};

  @override
  Future<String?> read(String key) async => _data[key];

  @override
  Future<void> write(String key, String value) async {
    _data[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _data.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _data.clear();
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('boots to login screen when unauthenticated', (tester) async {
    final prefs = await SharedPreferencesStore.create();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          keyValueStoreProvider.overrideWithValue(prefs),
          secureStoreProvider.overrideWithValue(_FakeSecureStore()),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });
}
