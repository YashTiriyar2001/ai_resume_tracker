import 'dart:io';

import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';

import '../domain/roast_record.dart';

class ResumeDocumentException implements Exception {
  ResumeDocumentException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ResumeDocumentService {
  Future<bool> exists(RoastRecord roast) => File(roast.filePath).exists();

  Future<void> open(RoastRecord roast) async {
    final file = File(roast.filePath);
    if (!await file.exists()) {
      throw ResumeDocumentException(
        'Resume file is missing. Re-upload to analyze again.',
      );
    }

    final result = await OpenFilex.open(file.path);
    if (result.type != ResultType.done) {
      throw ResumeDocumentException(
        result.message.isEmpty ? 'Could not open resume file.' : result.message,
      );
    }
  }

  Future<void> share(RoastRecord roast) async {
    final file = File(roast.filePath);
    if (!await file.exists()) {
      throw ResumeDocumentException(
        'Resume file is missing. Re-upload to analyze again.',
      );
    }

    await Share.shareXFiles(
      [XFile(file.path, name: roast.fileName, mimeType: roast.mimeType)],
      subject: roast.fileName,
    );
  }
}
