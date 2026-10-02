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

  /// Google OAuth Web Client ID (Server Client ID).
  static const String googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue:
        '14848507995-qc19oj7m5b55qlbtlklej355rf0fnmpk.apps.googleusercontent.com',
  );

  /// Cloudinary Cloud Name.
  static const String cloudinaryCloudName = String.fromEnvironment(
    'CLOUDINARY_CLOUD_NAME',
    defaultValue: 'dxa6upoxl',
  );

  /// Cloudinary Upload Preset (unsigned).
  static const String cloudinaryUploadPreset = String.fromEnvironment(
    'CLOUDINARY_UPLOAD_PRESET',
    defaultValue: 'emotion_mobile_preset',
  );

  /// Human-readable app name shown in the UI.
  static String get appName => switch (flavor) {
    Flavor.prod => 'E-Motion',
    Flavor.staging => 'E-Motion (Staging)',
    Flavor.dev => 'E-Motion (Dev)',
  };

  static bool get isProd => flavor == Flavor.prod;
}
