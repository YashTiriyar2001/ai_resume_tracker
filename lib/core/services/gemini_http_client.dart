import 'dart:io' show Platform;

import 'package:cronet_http/cronet_http.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Platform HTTP client for Gemini API calls.
///
/// Android emulators often fail Dart's [HttpClient] TLS with
/// `SSLV3_ALERT_BAD_RECORD_MAC`. Cronet uses Chromium's stack and avoids that.
abstract final class GeminiHttpClient {
  static http.Client? _instance;

  static http.Client get shared => _instance ??= _create();

  static http.Client _create() {
    if (!kIsWeb && Platform.isAndroid) {
      final engine = CronetEngine.build(
        cacheMode: CacheMode.memory,
        cacheMaxSize: 2 * 1024 * 1024,
        userAgent: 'ATSify/1.0',
      );
      return CronetClient.fromCronetEngine(engine, closeEngine: true);
    }
    return http.Client();
  }
}
