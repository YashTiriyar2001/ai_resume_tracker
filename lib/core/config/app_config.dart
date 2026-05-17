import 'secrets.dart';

abstract final class AppConfig {
  /// Priority: `--dart-define=GEMINI_API_KEY=...` then [Secrets.geminiApiKey].
  static const geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: Secrets.geminiApiKey,
  );

  static bool get hasGeminiApiKey =>
      geminiApiKey.isNotEmpty && geminiApiKey != 'YOUR_GEMINI_API_KEY_HERE';
}
