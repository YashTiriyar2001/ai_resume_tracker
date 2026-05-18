import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../analysis/domain/analysis_request.dart';
import '../../../onboarding/presentation/widgets/ember_background.dart';
import '../../../settings/presentation/pages/settings_tab.dart';
import '../../data/resume_file_picker.dart';
import '../../domain/roast_record.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/home_bottom_nav_bar.dart';
import '../widgets/home_recent_roasts_section.dart';
import '../widgets/home_stats_section.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/home_upload_section.dart';
import '../widgets/roast_document_actions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeTab _selectedTab = HomeTab.home;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const HomeStarted());
  }

  Future<void> _startRoasting() async {
    try {
      final picked = await ResumeFilePicker.pickResume();
      if (picked == null || !mounted) return;

      await context.push(
        '/analyze',
        extra: AnalysisRequest(
          sourcePath: picked.path,
          fileName: picked.fileName,
        ),
      );

      if (!mounted) return;
      context.read<HomeBloc>().add(const HomeRoastsRefreshed());
    } on UnsupportedError catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Unsupported file'),
          backgroundColor: const Color(0xFFB71C1C),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: const Color(0xFFB71C1C),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          const Positioned.fill(child: EmberBackground()),
          SafeArea(
            child: Column(
              children: [
                const HomeTopBar(),
                Expanded(
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state.status == HomeStatus.loading &&
                          state.roasts.isEmpty) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: colors.accent,
                          ),
                        );
                      }

                      return switch (_selectedTab) {
                        HomeTab.home => _HomeTabBody(
                            state: state,
                            onStartRoasting: _startRoasting,
                          ),
                        HomeTab.history => _HistoryTab(roasts: state.roasts),
                        HomeTab.settings => const SettingsTab(),
                      };
                    },
                  ),
                ),
                HomeBottomNavBar(
                  selected: _selectedTab,
                  onSelected: (tab) => setState(() => _selectedTab = tab),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeTabBody extends StatelessWidget {
  const _HomeTabBody({
    required this.state,
    required this.onStartRoasting,
  });

  final HomeState state;
  final VoidCallback onStartRoasting;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeUploadSection(
            userName: state.greetingName,
            onStartRoasting: onStartRoasting,
          ),
          HomeStatsSection(
            totalRoasts: state.totalRoasts,
            averageScore: state.averageScore,
            fastestAnalysisLabel: state.fastestAnalysisLabel,
          ),
          HomeRecentRoastsSection(roasts: state.recentRoasts),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({required this.roasts});

  final List<RoastRecord> roasts;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;

    if (roasts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'No roasts yet. Upload a resume from Home.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.body,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      itemCount: roasts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final roast = roasts[index];
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.push('/result/${roast.id}'),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          roast.fileName,
                          style: TextStyle(
                            color: colors.headline,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ATS Score: ${roast.score} • 🔥 ${roast.roastLevel}',
                          style: TextStyle(
                            color: colors.muted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          roast.timeAgoLabel,
                          style: TextStyle(
                            color: colors.muted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RoastDocumentIconButton(roast: roast),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: roast.scoreColor.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: roast.scoreColor.withValues(alpha: 0.45),
                          ),
                        ),
                        child: Text(
                          '${roast.score}/100',
                          style: TextStyle(
                            color: roast.scoreColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
