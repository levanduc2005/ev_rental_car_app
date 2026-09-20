/// Compile-time application configuration.
///
/// Values are injected at build time via `--dart-define` (or
/// `--dart-define-from-file`) so that no secrets are hardcoded in source.
///
/// Run with an environment file:
/// ```sh
/// flutter run --dart-define-from-file=config/dev.json
/// ```
///
/// See `config/dev.example.json` for the expected keys.
enum Flavor { dev, staging, prod }

abstract final class AppConfig {
  /// The current build flavor. Defaults to [Flavor.dev].
  static Flavor get flavor =>
      switch (const String.fromEnvironment('FLAVOR', defaultValue: 'dev')) {
        'prod' => Flavor.prod,
        'staging' => Flavor.staging,
        _ => Flavor.dev,
      };

  /// Base URL for the REST API.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080/api',
  );

  /// Network timeout in milliseconds.
  static const int apiTimeoutMs = int.fromEnvironment(
    'API_TIMEOUT_MS',
    defaultValue: 15000,
  );

  /// Whether verbose network/logging is enabled.
  static const bool enableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: true,
  );

  /// Human-readable app name shown in the UI.
  static String get appName => switch (flavor) {
    Flavor.prod => 'Flutter Template',
    Flavor.staging => 'Flutter Template (Staging)',
    Flavor.dev => 'Flutter Template (Dev)',
  };

  static bool get isProd => flavor == Flavor.prod;
}
