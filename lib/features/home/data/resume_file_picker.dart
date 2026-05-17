import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart' as p;

class ResumePickResult {
  const ResumePickResult({
    required this.path,
    required this.fileName,
  });

  final String path;
  final String fileName;
}

abstract final class ResumeFilePicker {
  static const _allowedExtensions = {
    '.pdf',
    '.doc',
    '.docx',
    '.txt',
    '.jpg',
    '.jpeg',
    '.png',
  };

  static const _documentGroup = XTypeGroup(
    label: 'Documents',
    extensions: ['pdf', 'doc', 'docx', 'txt'],
    mimeTypes: [
      'application/pdf',
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'text/plain',
    ],
  );

  static const _imageGroup = XTypeGroup(
    label: 'Photos',
    extensions: ['jpg', 'jpeg', 'png'],
    mimeTypes: ['image/jpeg', 'image/png'],
  );

  static Future<ResumePickResult?> pickResume() async {
    final file = await openFile(
      acceptedTypeGroups: const [_documentGroup, _imageGroup],
    );
    if (file == null) return null;

    final fileName = file.name;
    final extension = p.extension(fileName).toLowerCase();
    if (!_allowedExtensions.contains(extension)) {
      throw UnsupportedError(
        'Unsupported file type. Use PDF, DOCX, TXT, or a photo.',
      );
    }

    final path = file.path;
    if (path.isEmpty) {
      throw StateError('Could not access the selected file.');
    }

    return ResumePickResult(path: path, fileName: fileName);
  }
}
