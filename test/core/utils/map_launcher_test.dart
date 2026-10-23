import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:rental_car/core/utils/map_launcher.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class MockUrlLauncherPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class FakeLaunchOptions extends Fake implements LaunchOptions {}

void main() {
  late MockUrlLauncherPlatform mockPlatform;

  setUpAll(() {
    registerFallbackValue(FakeLaunchOptions());
  });

  setUp(() {
    mockPlatform = MockUrlLauncherPlatform();
    UrlLauncherPlatform.instance = mockPlatform;
  });

  group('MapLauncher', () {
    testWidgets('launches GPS coordinates when lat/lng are provided', (
      tester,
    ) async {
      when(
        () => mockPlatform.launchUrl(any(), any()),
      ).thenAnswer((_) async => true);

      late BuildContext buildContext;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) {
                buildContext = ctx;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      await MapLauncher.openDirections(
        context: buildContext,
        latitude: 10.7769,
        longitude: 106.7009,
        stationName: 'Trạm Landmark 81',
        stationAddress: '720A Dien Bien Phu',
      );

      final captured = verify(
        () => mockPlatform.launchUrl(captureAny(), any()),
      ).captured;

      expect(captured.first, contains('destination=10.7769,106.7009'));
    });

    testWidgets('launches query address when lat/lng are 0 or null', (
      tester,
    ) async {
      when(
        () => mockPlatform.launchUrl(any(), any()),
      ).thenAnswer((_) async => true);

      late BuildContext buildContext;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) {
                buildContext = ctx;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      await MapLauncher.openDirections(
        context: buildContext,
        latitude: 0.0,
        longitude: 0.0,
        stationName: 'Trạm Vincom',
        stationAddress: 'Dong Khoi',
      );

      final captured = verify(
        () => mockPlatform.launchUrl(captureAny(), any()),
      ).captured;

      expect(
        captured.first,
        contains('destination=Tr%E1%BA%A1m%20Vincom%2C%20Dong%20Khoi'),
      );
    });

    testWidgets('shows snackbar when launchUrl fails or throws', (
      tester,
    ) async {
      when(
        () => mockPlatform.launchUrl(any(), any()),
      ).thenAnswer((_) async => false);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () => MapLauncher.openDirections(
                  context: ctx,
                  stationAddress: 'Ho Chi Minh',
                ),
                child: const Text('Open Map'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Map'));
      await tester.pumpAndSettle();

      expect(find.text('Không thể mở ứng dụng Bản đồ.'), findsOneWidget);
    });
  });
}
