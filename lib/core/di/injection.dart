import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/analysis/data/resume_analysis_service.dart';
import '../../features/app/cubit/app_cubit.dart';
import '../../features/home/data/resume_document_service.dart';
import '../../features/home/data/roast_repository.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../services/gemini_service.dart';
import '../services/resume_text_extractor.dart';
import '../storage/hive_service.dart';
import '../storage/preferences_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies({String? hiveDirectoryPath}) async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerSingleton<PreferencesService>(PreferencesService(prefs));

  final hiveService = HiveService();
  if (hiveDirectoryPath != null) {
    await hiveService.initAtPath(hiveDirectoryPath);
  } else {
    await hiveService.init();
  }
  getIt.registerSingleton<HiveService>(hiveService);

  getIt.registerLazySingleton<ResumeTextExtractor>(ResumeTextExtractor.new);
  getIt.registerLazySingleton<GeminiService>(GeminiService.new);
  getIt.registerLazySingleton<ResumeDocumentService>(ResumeDocumentService.new);

  getIt.registerLazySingleton<RoastRepository>(
    () => RoastRepository(hiveService: getIt<HiveService>()),
  );

  getIt.registerLazySingleton<ResumeAnalysisService>(
    () => ResumeAnalysisService(
      textExtractor: getIt<ResumeTextExtractor>(),
      geminiService: getIt<GeminiService>(),
      roastRepository: getIt<RoastRepository>(),
    ),
  );

  getIt.registerFactory<AppCubit>(
    () => AppCubit(preferences: getIt<PreferencesService>()),
  );

  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(
      hiveService: getIt<HiveService>(),
      roastRepository: getIt<RoastRepository>(),
    ),
  );
}
