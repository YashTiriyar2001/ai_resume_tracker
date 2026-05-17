import 'dart:io';

import 'package:docx_to_text/docx_to_text.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path/path.dart' as p;
import 'package:syncfusion_flutter_pdf/pdf.dart';

abstract final class ResumeFileLimits {
  static const pdfDocxBytes = 10 * 1024 * 1024;
  static const txtBytes = 2 * 1024 * 1024;
  static const imageBytes = 5 * 1024 * 1024;
}

class ResumeTextExtractor {
  Future<String> extract(File file) async {
    final extension = p.extension(file.path).toLowerCase();
    await _enforceSizeLimit(file, extension);

    final text = switch (extension) {
      '.pdf' => await _extractPdf(file),
      '.doc' || '.docx' => await _extractDocx(file),
      '.txt' => await _extractTxt(file),
      '.jpg' || '.jpeg' || '.png' => await _extractImage(file.path),
      _ => throw UnsupportedError(
          'Unsupported file type. Use PDF, DOCX, TXT, or an image.',
        ),
    };

    final cleaned = cleanResumeText(text);
    if (cleaned.length < 40) {
      throw StateError(
        'Could not extract enough resume text. Try a clearer PDF or DOCX.',
      );
    }
    return cleaned;
  }

  static String cleanResumeText(String text) {
    var output = text.replaceAll(RegExp(r'[ \t]+'), ' ');
    output = output.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    return output.trim();
  }

  Future<void> _enforceSizeLimit(File file, String extension) async {
    final length = await file.length();
    final maxBytes = switch (extension) {
      '.pdf' || '.doc' || '.docx' => ResumeFileLimits.pdfDocxBytes,
      '.txt' => ResumeFileLimits.txtBytes,
      '.jpg' || '.jpeg' || '.png' => ResumeFileLimits.imageBytes,
      _ => ResumeFileLimits.pdfDocxBytes,
    };

    if (length > maxBytes) {
      throw StateError(
        'File is too large. Max size is ${maxBytes ~/ (1024 * 1024)} MB for this type.',
      );
    }
  }

  Future<String> _extractPdf(File file) async {
    final bytes = await file.readAsBytes();
    final document = PdfDocument(inputBytes: bytes);
    try {
      return PdfTextExtractor(document).extractText();
    } finally {
      document.dispose();
    }
  }

  Future<String> _extractDocx(File file) async {
    final bytes = await file.readAsBytes();
    return docxToText(bytes);
  }

  Future<String> _extractTxt(File file) async {
    return file.readAsString();
  }

  Future<String> _extractImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final recognizer = TextRecognizer();
    try {
      final recognizedText = await recognizer.processImage(inputImage);
      return recognizedText.text;
    } finally {
      await recognizer.close();
    }
  }
}
