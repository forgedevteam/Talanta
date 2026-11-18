/// Build-time settings. Override with `--dart-define=API_BASE_URL=...`.
///
/// On an Android emulator the host machine is `10.0.2.2`; on a phone over
/// USB run `adb reverse tcp:3000 tcp:3000` and keep the default.
abstract final class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 20);
}
