import 'dart:io';

import 'package:ai_resume_tracker/app/app.dart';
import 'package:ai_resume_tracker/core/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory hiveTestDir;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    hiveTestDir = await Directory.systemTemp.createTemp('ai_resume_tracker_test');
    await configureDependencies(hiveDirectoryPath: hiveTestDir.path);
  });

  tearDownAll(() async {
    if (hiveTestDir.existsSync()) {
      await hiveTestDir.delete(recursive: true);
    }
  });

  testWidgets('App shows onboarding on first launch', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.text('Welcome to ATSify 🔥'), findsOneWidget);
    expect(find.text('Tired of your resume getting ghosted?'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });
}
