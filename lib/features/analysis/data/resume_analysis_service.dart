import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../../core/services/gemini_service.dart';
import '../../../core/services/resume_text_extractor.dart';
import '../../home/data/roast_repository.dart';
import '../../home/domain/roast_record.dart';

class ResumeAnalysisService {
  ResumeAnalysisService({
    required ResumeTextExtractor textExtractor,
    required GeminiService geminiService,
    required RoastRepository roastRepository,
  })  : _textExtractor = textExtractor,
        _geminiService = geminiService,
        _roastRepository = roastRepository;

  final ResumeTextExtractor _textExtractor;
  final GeminiService _geminiService;
  final RoastRepository _roastRepository;

  Future<RoastRecord> analyzeAndSave({
    required String sourcePath,
    required String fileName,
  }) async {
    final stopwatch = Stopwatch()..start();
    final persistedPath = await _roastRepository.persistResumeFile(
      sourcePath: sourcePath,
      fileName: fileName,
    );

    final extractedText = await _textExtractor.extract(File(persistedPath));
    if (kDebugMode) {
      developer.log(
        'Extracted ${extractedText.length} chars from $fileName',
        name: 'ATSify.Analysis',
      );
      debugPrint(
        '[ATSify.Analysis] Text preview: '
        '${extractedText.substring(0, extractedText.length.clamp(0, 200))}...',
      );
    }

    final analysis = await _geminiService.analyzeResume(extractedText);
    stopwatch.stop();

    return _roastRepository.saveAnalysis(
      fileName: fileName,
      filePath: persistedPath,
      mimeType: RoastRepository.mimeTypeForFileName(fileName),
      analysis: analysis,
      analysisDurationMs: stopwatch.elapsedMilliseconds,
    );
  }
}
