import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../core/storage/hive_service.dart';
import '../../analysis/domain/ats_analysis_result.dart';
import '../domain/roast_record.dart';

class RoastRepository {
  RoastRepository({required HiveService hiveService}) : _hiveService = hiveService;

  final HiveService _hiveService;

  Future<List<RoastRecord>> fetchRoasts() async {
    final raw = _hiveService.appBox.get(HiveKeys.roasts);
    if (raw is! List) return [];

    return raw
        .whereType<Map>()
        .map((entry) => RoastRecord.fromMap(Map<dynamic, dynamic>.from(entry)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<RoastRecord?> getRoastById(String id) async {
    final roasts = await fetchRoasts();
    for (final roast in roasts) {
      if (roast.id == id) return roast;
    }
    return null;
  }

  Future<RoastRecord> saveAnalysis({
    required String fileName,
    required String filePath,
    required AtsAnalysisResult analysis,
    required int analysisDurationMs,
  }) async {
    final roast = RoastRecord.fromAnalysis(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fileName: fileName,
      filePath: filePath,
      analysis: analysis,
      createdAt: DateTime.now(),
      analysisDurationMs: analysisDurationMs,
    );

    final roasts = await fetchRoasts();
    roasts.insert(0, roast);
    await _saveRoasts(roasts);
    return roast;
  }

  Future<String> persistResumeFile({
    required String sourcePath,
    required String fileName,
  }) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final resumesDir = Directory(p.join(documentsDir.path, 'resumes'));
    if (!await resumesDir.exists()) {
      await resumesDir.create(recursive: true);
    }

    final safeName = p.basename(fileName);
    final destination = File(
      p.join(
        resumesDir.path,
        '${DateTime.now().millisecondsSinceEpoch}_$safeName',
      ),
    );

    await File(sourcePath).copy(destination.path);
    return destination.path;
  }

  Future<void> toggleSaved(String id) async {
    final roasts = await fetchRoasts();
    final index = roasts.indexWhere((roast) => roast.id == id);
    if (index == -1) return;

    roasts[index] = roasts[index].copyWith(isSaved: !roasts[index].isSaved);
    await _saveRoasts(roasts);
  }

  Future<void> clearAll() async {
    await _hiveService.appBox.delete(HiveKeys.roasts);
  }

  Future<void> _saveRoasts(List<RoastRecord> roasts) async {
    final sorted = List<RoastRecord>.from(roasts)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    await _hiveService.appBox.put(
      HiveKeys.roasts,
      sorted.map((roast) => roast.toMap()).toList(),
    );
  }
}
