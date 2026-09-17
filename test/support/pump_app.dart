import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:rental_car/l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps [widget] wrapped in the minimum shell a screen needs: a
/// [ProviderScope] (with optional [overrides]) and a localized [MaterialApp].
///
/// Keeps individual widget tests focused on behavior instead of boilerplate.
extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget, {List<Override> overrides = const []}) {
    return pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: widget,
        ),
      ),
    );
  }
}
