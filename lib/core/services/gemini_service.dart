import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../../features/analysis/domain/ats_analysis_result.dart';

/// Calls the Gemini REST API (replaces deprecated `google_generative_ai` 0.4.7).
class GeminiService {
  static const _logName = 'ATSify.Gemini';
  static const _model = 'gemini-2.0-flash';
  static const _baseUrl = 'https://generativelanguage.googleapis.com/v1beta';

  final http.Client _client;

  GeminiService({http.Client? client}) : _client = client ?? http.Client();

  bool get isConfigured => AppConfig.hasGeminiApiKey;

  Future<AtsAnalysisResult> analyzeResume(String resumeText) async {
    if (!isConfigured) {
      _log('No API key — using local fallback analysis.');
      return _fallbackAnalysis(resumeText);
    }

    final prompt = '''
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

    _log('Sending request to Gemini ($_model) via REST API...');
    _log('Resume text length: ${resumeText.length} chars');

    try {
      final uri = Uri.parse(
        '$_baseUrl/models/$_model:generateContent?key=${AppConfig.geminiApiKey}',
      );

      final response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.8,
            'responseMimeType': 'application/json',
          },
        }),
      );

      _log('HTTP status: ${response.statusCode}');
      _log('--- Gemini raw response body ---');
      _log(response.body);
      _log('--- end response body ---');

      if (response.statusCode != 200) {
        throw StateError(
          'Gemini API ${response.statusCode}: ${response.body}',
        );
      }

      final text = _extractResponseText(response.body);
      if (text == null || text.trim().isEmpty) {
        _log('Empty response — using fallback.');
        return _fallbackAnalysis(resumeText);
      }

      _log('--- Gemini extracted text ---');
      _log(text);

      final result = AtsAnalysisResult.fromJsonString(text);
      _log('Parsed ATS score: ${result.atsScore} | Level: ${result.roastLevel}');
      _log(
        'Parsed JSON:\n${const JsonEncoder.withIndent('  ').convert(result.toMap())}',
      );
      return result;
    } catch (error, stackTrace) {
      _log('Gemini API error: $error', level: 1000);
      developer.log(
        'Stack trace',
        name: _logName,
        error: error,
        stackTrace: stackTrace,
      );
      _log('Using fallback analysis after error.');
      return _fallbackAnalysis(resumeText);
    }
  }

  String? _extractResponseText(String responseBody) {
    final decoded = jsonDecode(responseBody);
    if (decoded is! Map<String, dynamic>) return null;

    final candidates = decoded['candidates'];
    if (candidates is! List || candidates.isEmpty) return null;

    final first = candidates.first;
    if (first is! Map<String, dynamic>) return null;

    final content = first['content'];
    if (content is! Map<String, dynamic>) return null;

    final parts = content['parts'];
    if (parts is! List || parts.isEmpty) return null;

    final part = parts.first;
    if (part is! Map<String, dynamic>) return null;

    return part['text'] as String?;
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
