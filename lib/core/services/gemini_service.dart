import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../../features/analysis/domain/ats_analysis_result.dart';
import 'gemini_http_client.dart';

/// Resume analysis via the official Gemini Flutter SDK.
///
/// See https://ai.google.dev/gemini-api/docs/models
class GeminiService {
  GeminiService({http.Client? httpClient})
      : _httpClient = httpClient ?? GeminiHttpClient.shared;

  static const _logName = 'ATSify.Gemini';
  static const _maxAttempts = 3;

  /// Gemini 1.5 was retired from the Google AI API (May 2025+).
  /// See https://ai.google.dev/gemini-api/docs/models
  static const _modelIds = [
    'gemini-2.5-flash-lite',
    'gemini-2.0-flash-lite',
    'gemini-flash-latest',
  ];

  final http.Client _httpClient;

  bool get isConfigured => AppConfig.hasGeminiApiKey;

  Future<AtsAnalysisResult> analyzeResume(String resumeText) async {
    if (!isConfigured) {
      _log('No API key — using local fallback analysis.');
      return _fallbackAnalysis(resumeText);
    }

    final prompt = _buildPrompt(resumeText);
    _log('Resume text length: ${resumeText.length} chars');

    Object? lastError;
    StackTrace? lastStack;

    for (final modelId in _modelIds) {
      try {
        final result = await _generateWithRetries(modelId, prompt);
        return result;
      } catch (error, stackTrace) {
        lastError = error;
        lastStack = stackTrace;
        if (_isModelUnavailable(error)) {
          _log('Model $modelId unavailable: $error');
          continue;
        }
        _log('Gemini API error ($modelId): $error', level: 1000);
        break;
      }
    }

    if (lastError != null) {
      _log('All models failed. Last error: $lastError', level: 1000);
      developer.log(
        'Stack trace',
        name: _logName,
        error: lastError,
        stackTrace: lastStack,
      );
      await _logAvailableModels();
    }
    _log('Using fallback analysis after error.');
    return _fallbackAnalysis(resumeText);
  }

  Future<AtsAnalysisResult> _generateWithRetries(
    String modelId,
    String prompt,
  ) async {
    Object? lastError;
    StackTrace? lastStack;

    for (var attempt = 1; attempt <= _maxAttempts; attempt++) {
      if (attempt > 1) {
        final delayMs = 400 * attempt;
        _log('Retry $attempt/$_maxAttempts for $modelId in ${delayMs}ms...');
        await Future<void>.delayed(Duration(milliseconds: delayMs));
      } else {
        _log('Sending request to Gemini ($modelId) via SDK...');
      }

      try {
        final model = GenerativeModel(
          model: modelId,
          apiKey: AppConfig.geminiApiKey,
          httpClient: _httpClient,
          generationConfig: GenerationConfig(
            temperature: 0.8,
            responseMimeType: 'application/json',
          ),
        );

        final response = await model.generateContent([Content.text(prompt)]);

        final text = response.text;
        if (text == null || text.trim().isEmpty) {
          throw StateError('Empty response from $modelId');
        }

        _log('Success with $modelId');
        _log('--- Gemini response text ---');
        _log(text);

        final result = AtsAnalysisResult.fromJsonString(text);
        _log('Parsed ATS score: ${result.atsScore} | Level: ${result.roastLevel}');
        _log(
          'Parsed JSON:\n${const JsonEncoder.withIndent('  ').convert(result.toMap())}',
        );
        return result;
      } catch (error, stackTrace) {
        lastError = error;
        lastStack = stackTrace;
        if (_isModelUnavailable(error)) rethrow;
        if (_isTransientNetworkError(error) && attempt < _maxAttempts) {
          _log('Transient network error (attempt $attempt): $error');
          continue;
        }
        rethrow;
      }
    }

    Error.throwWithStackTrace(lastError!, lastStack!);
  }

  static String _buildPrompt(String resumeText) => '''
You are a brutally honest ATS recruiter for a viral app called ATSify.

Analyze this resume and return JSON ONLY (no markdown) with this shape:
{
  "ats_score": number,
  "roast_level": string,
  "strengths": [string],
  "weaknesses": [string],
  "missing_keywords": [string],
  "roasts": [string],
  "suggestions": [string]
}

Rules:
- ats_score is 1-100
- roast_level should be spicy food themed (e.g. "Medium Rare", "Well Done", "Charcoal")
- roasts must be funny recruiter-style one-liners (2-4 items)
- suggestions must be actionable (3-5 items)

Resume:
$resumeText
''';

  static bool _isModelUnavailable(Object error) {
    final message = error.toString().toLowerCase();
    return message.contains('not found') ||
        message.contains('not supported for generatecontent');
  }

  Future<void> _logAvailableModels() async {
    if (!kDebugMode || !isConfigured) return;
    try {
      final uri = Uri.https(
        'generativelanguage.googleapis.com',
        '/v1beta/models',
        {'key': AppConfig.geminiApiKey},
      );
      final response = await _httpClient.get(uri);
      if (response.statusCode != 200) {
        _log('ListModels HTTP ${response.statusCode}');
        return;
      }
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final models = decoded['models'] as List<dynamic>? ?? [];
      _log('Models available for your API key (${models.length}):');
      for (final entry in models) {
        if (entry is! Map<String, dynamic>) continue;
        final name = entry['name'] as String? ?? '?';
        final methods = entry['supportedGenerationMethods'] as List<dynamic>?;
        if (methods?.contains('generateContent') ?? false) {
          _log('  $name');
        }
      }
    } catch (error) {
      _log('Could not list models: $error');
    }
  }

  static bool _isTransientNetworkError(Object error) {
    final message = error.toString().toUpperCase();
    return message.contains('BAD_RECORD_MAC') ||
        message.contains('SSL') ||
        message.contains('HANDSHAKE') ||
        message.contains('CONNECTION RESET') ||
        message.contains('SOCKETEXCEPTION') ||
        message.contains('CLIENTEXCEPTION');
  }

  AtsAnalysisResult _fallbackAnalysis(String resumeText) {
    _log('Running local fallback analyzer.');
    final words = resumeText.split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    final wordCount = words.length;
    final hasMetrics = RegExp(r'\d+%|\$\d+|\d+\+').hasMatch(resumeText);
    final hasSkills = RegExp(
      r'\b(flutter|dart|python|java|aws|docker|kubernetes|sql|api)\b',
      caseSensitive: false,
    ).hasMatch(resumeText);

    var score = 52 + (wordCount ~/ 12);
    if (hasMetrics) score += 8;
    if (hasSkills) score += 10;
    score = score.clamp(45, 94);

    final roastLevel = switch (score) {
      >= 85 => 'Well Done',
      >= 70 => 'Medium Rare',
      >= 55 => 'Rare',
      _ => 'Charcoal',
    };

    final random = Random(resumeText.hashCode);
    final roastPool = [
      'Your resume objective sounds like a horoscope.',
      'Recruiters skipped this faster than YouTube ads.',
      'Buzzword density is higher than your actual achievements.',
      'This reads like a job description cosplaying as a resume.',
    ]..shuffle(random);

    final result = AtsAnalysisResult(
      atsScore: score,
      roastLevel: roastLevel,
      strengths: [
        if (wordCount > 180) 'Decent amount of experience detail',
        if (hasSkills) 'Relevant technical keywords detected',
        'Clear section structure',
      ],
      weaknesses: [
        if (!hasMetrics) 'Few measurable achievements',
        'Some bullets feel generic',
        if (wordCount < 220) 'Resume may be too thin for senior roles',
      ],
      missingKeywords: [
        if (!resumeText.toLowerCase().contains('docker')) 'Docker',
        if (!resumeText.toLowerCase().contains('aws')) 'AWS',
        if (!resumeText.toLowerCase().contains('api')) 'REST API',
      ],
      roasts: roastPool.take(3).toList(),
      suggestions: [
        'Quantify impact with numbers and percentages',
        'Tailor keywords to each job description',
        'Replace generic objectives with a sharp summary',
        'Keep bullets outcome-focused: action + metric + result',
      ],
    );

    _log('Fallback result: ${result.atsScore}/100 (${result.roastLevel})');
    return result;
  }

  static void _log(String message, {int level = 800}) {
    if (!kDebugMode) return;
    developer.log(message, name: _logName, level: level);
    debugPrint('[$_logName] $message');
  }
}
