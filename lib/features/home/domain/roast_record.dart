import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../../analysis/domain/ats_analysis_result.dart';

class RoastRecord extends Equatable {
  const RoastRecord({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.score,
    required this.createdAt,
    required this.roastLevel,
    required this.strengths,
    required this.weaknesses,
    required this.missingKeywords,
    required this.roasts,
    required this.suggestions,
    this.mimeType,
    this.analysisDurationMs,
    this.isSaved = false,
  });

  final String id;
  final String fileName;
  final String filePath;
  final String? mimeType;
  final int score;
  final DateTime createdAt;
  final String roastLevel;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> missingKeywords;
  final List<String> roasts;
  final List<String> suggestions;
  final int? analysisDurationMs;
  final bool isSaved;

  factory RoastRecord.fromAnalysis({
    required String id,
    required String fileName,
    required String filePath,
    required AtsAnalysisResult analysis,
    required DateTime createdAt,
    int? analysisDurationMs,
    String? mimeType,
    bool isSaved = false,
  }) {
    return RoastRecord(
      id: id,
      fileName: fileName,
      filePath: filePath,
      mimeType: mimeType,
      score: analysis.atsScore,
      createdAt: createdAt,
      roastLevel: analysis.roastLevel,
      strengths: analysis.strengths,
      weaknesses: analysis.weaknesses,
      missingKeywords: analysis.missingKeywords,
      roasts: analysis.roasts,
      suggestions: analysis.suggestions,
      analysisDurationMs: analysisDurationMs,
      isSaved: isSaved,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'fileName': fileName,
        'filePath': filePath,
        if (mimeType != null) 'mimeType': mimeType,
        'score': score,
        'createdAt': createdAt.toIso8601String(),
        'roastLevel': roastLevel,
        'strengths': strengths,
        'weaknesses': weaknesses,
        'missingKeywords': missingKeywords,
        'roasts': roasts,
        'suggestions': suggestions,
        'analysisDurationMs': analysisDurationMs,
        'isSaved': isSaved,
      };

  factory RoastRecord.fromMap(Map<dynamic, dynamic> map) {
    return RoastRecord(
      id: map['id'] as String,
      fileName: map['fileName'] as String,
      filePath: map['filePath'] as String,
      mimeType: map['mimeType'] as String?,
      score: (map['score'] as num).toInt(),
      createdAt: DateTime.parse(map['createdAt'] as String),
      roastLevel: map['roastLevel'] as String? ?? 'Medium Rare',
      strengths: _readStringList(map['strengths']),
      weaknesses: _readStringList(map['weaknesses']),
      missingKeywords: _readStringList(map['missingKeywords']),
      roasts: _readStringList(map['roasts']),
      suggestions: _readStringList(map['suggestions']),
      analysisDurationMs: (map['analysisDurationMs'] as num?)?.toInt(),
      isSaved: map['isSaved'] as bool? ?? false,
    );
  }

  RoastRecord copyWith({
    bool? isSaved,
  }) {
    return RoastRecord(
      id: id,
      fileName: fileName,
      filePath: filePath,
      mimeType: mimeType,
      score: score,
      createdAt: createdAt,
      roastLevel: roastLevel,
      strengths: strengths,
      weaknesses: weaknesses,
      missingKeywords: missingKeywords,
      roasts: roasts,
      suggestions: suggestions,
      analysisDurationMs: analysisDurationMs,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  String get fileExtension => p.extension(fileName).toLowerCase();

  String get fileExtensionLabel {
    final ext = fileExtension.replaceFirst('.', '').toUpperCase();
    return ext.isEmpty ? 'Document' : ext;
  }

  IconData get documentIcon {
    return switch (fileExtension) {
      '.pdf' => Icons.picture_as_pdf_outlined,
      '.doc' || '.docx' => Icons.article_outlined,
      '.txt' => Icons.text_snippet_outlined,
      '.jpg' || '.jpeg' || '.png' => Icons.image_outlined,
      _ => Icons.description_outlined,
    };
  }

  static List<String> _readStringList(dynamic value) {
    if (value is! List) return const [];
    return value.map((item) => item.toString()).toList();
  }

  Color get scoreColor {
    if (score >= 90) return const Color(0xFF43A047);
    if (score >= 80) return const Color(0xFFFF8C00);
    return const Color(0xFFE53935);
  }

  String get timeAgoLabel {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${diff.inDays ~/ 7} weeks ago';
    return '${diff.inDays ~/ 30} months ago';
  }

  String get formattedAnalysisTime {
    final ms = analysisDurationMs;
    if (ms == null) return '—';
    if (ms < 1000) return '${ms}ms';
    return '${(ms / 1000).toStringAsFixed(1)}s';
  }

  int get spiceLevel {
    final level = roastLevel.toLowerCase();
    if (level.contains('charcoal') || level.contains('burnt')) return 3;
    if (level.contains('medium') || level.contains('rare')) return 2;
    return 1;
  }

  @override
  List<Object?> get props => [
        id,
        fileName,
        filePath,
        mimeType,
        score,
        createdAt,
        roastLevel,
        strengths,
        weaknesses,
        missingKeywords,
        roasts,
        suggestions,
        analysisDurationMs,
        isSaved,
      ];
}

abstract final class RoastStats {
  static int averageScore(List<RoastRecord> roasts) {
    if (roasts.isEmpty) return 0;
    final total = roasts.fold<int>(0, (sum, roast) => sum + roast.score);
    return (total / roasts.length).round();
  }

  static int streakDays(List<RoastRecord> roasts) {
    if (roasts.isEmpty) return 0;

    final days = roasts
        .map(
          (roast) => DateTime(
            roast.createdAt.year,
            roast.createdAt.month,
            roast.createdAt.day,
          ),
        )
        .toSet();

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final yesterday = todayDate.subtract(const Duration(days: 1));

    if (!days.contains(todayDate) && !days.contains(yesterday)) {
      return 0;
    }

    var cursor = days.contains(todayDate) ? todayDate : yesterday;
    var streak = 0;
    while (days.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  static int? fastestAnalysisMs(List<RoastRecord> roasts) {
    final durations = roasts
        .map((roast) => roast.analysisDurationMs)
        .whereType<int>()
        .toList();
    if (durations.isEmpty) return null;
    return durations.reduce((a, b) => a < b ? a : b);
  }
}
