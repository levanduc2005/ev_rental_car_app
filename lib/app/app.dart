import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/app/router/app_router.dart';
import 'package:rental_car/core/config/app_config.dart';
import 'package:rental_car/core/theme/app_theme.dart';
import 'package:rental_car/l10n/l10n.dart';

/// The root application widget.
///
/// Wires up routing, theming and localization. Kept deliberately thin — all
/// real work lives in features and providers.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      // Localized title (shown in the OS task switcher). Falls back to the
      // flavor name before the first frame resolves localizations.
      locale: const Locale('vi'),
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: !AppConfig.isProd,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
