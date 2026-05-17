import 'package:hive_flutter/hive_flutter.dart';

import '../constants/storage_keys.dart';

class HiveService {
  Box<dynamic>? _appBox;

  Box<dynamic> get appBox {
    final box = _appBox;
    if (box == null || !box.isOpen) {
      throw StateError('HiveService is not initialized. Call init() first.');
    }
    return box;
  }

  Future<void> init() async {
    await Hive.initFlutter();
    await _openAppBox();
  }

  /// Use in tests where [Hive.initFlutter] / path_provider is unavailable.
  Future<void> initAtPath(String directoryPath) async {
    Hive.init(directoryPath);
    await _openAppBox();
  }

  Future<void> _openAppBox() async {
    _appBox = await Hive.openBox<dynamic>(HiveBoxNames.app);
  }

  String? readDisplayName() {
    final value = appBox.get(HiveKeys.displayName);
    return value is String ? value : null;
  }

  Future<void> writeDisplayName(String name) async {
    await appBox.put(HiveKeys.displayName, name);
  }

  Future<void> clearDisplayName() async {
    await appBox.delete(HiveKeys.displayName);
  }

  Future<void> close() async {
    await _appBox?.close();
    _appBox = null;
  }
}
