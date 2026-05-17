import 'dart:convert';

class AtsAnalysisResult {
  const AtsAnalysisResult({
    required this.atsScore,
    required this.roastLevel,
    required this.strengths,
    required this.weaknesses,
    required this.missingKeywords,
    required this.roasts,
    required this.suggestions,
  });

  final int atsScore;
  final String roastLevel;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> missingKeywords;
  final List<String> roasts;
  final List<String> suggestions;

  Map<String, dynamic> toMap() => {
        'ats_score': atsScore,
        'roast_level': roastLevel,
        'strengths': strengths,
        'weaknesses': weaknesses,
        'missing_keywords': missingKeywords,
        'roasts': roasts,
        'suggestions': suggestions,
      };

  factory AtsAnalysisResult.fromMap(Map<String, dynamic> map) {
    return AtsAnalysisResult(
      atsScore: (map['ats_score'] as num?)?.toInt() ?? 0,
      roastLevel: map['roast_level'] as String? ?? 'Medium Rare',
      strengths: _stringList(map['strengths']),
      weaknesses: _stringList(map['weaknesses']),
      missingKeywords: _stringList(map['missing_keywords']),
      roasts: _stringList(map['roasts']),
      suggestions: _stringList(map['suggestions']),
    );
  }

  factory AtsAnalysisResult.fromJsonString(String raw) {
    final cleaned = raw
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();
    final decoded = jsonDecode(cleaned);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Gemini response was not a JSON object.');
    }
    return AtsAnalysisResult.fromMap(decoded);
  }

  static List<String> _stringList(dynamic value) {
    if (value is! List) return const [];
    return value.map((item) => item.toString()).toList();
  }
}
