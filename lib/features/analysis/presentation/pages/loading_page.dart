import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/bloc/home_event.dart';
import '../../../onboarding/presentation/widgets/ember_background.dart';
import '../../data/resume_analysis_service.dart';
import '../../domain/analysis_request.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({
    required this.request,
    super.key,
  });

  final AnalysisRequest request;

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  static const _scanGif = 'assets/scan_files.gif';

  static const _thoughts = [
    'Scanning buzzwords...',
    'Detecting weak achievements...',
    'Counting unnecessary objectives...',
    'Measuring recruiter patience...',
    'Cross-checking ATS keywords...',
    'Roasting bullet points...',
  ];

  int _thoughtIndex = 0;
  double _progress = 0.08;
  Timer? _thoughtTimer;
  String? _error;

  @override
  void initState() {
    super.initState();
    _thoughtTimer = Timer.periodic(const Duration(milliseconds: 1400), (_) {
      if (!mounted) return;
      setState(() => _thoughtIndex = (_thoughtIndex + 1) % _thoughts.length);
    });
    _runAnalysis();
  }

  @override
  void dispose() {
    _thoughtTimer?.cancel();
    super.dispose();
  }

  Future<void> _runAnalysis() async {
    final service = getIt<ResumeAnalysisService>();
    try {
      for (var step = 0; step < 4; step++) {
        if (!mounted) return;
        setState(() => _progress = 0.15 + (step * 0.18));
        await Future<void>.delayed(const Duration(milliseconds: 450));
      }

      final roast = await service.analyzeAndSave(
        sourcePath: widget.request.sourcePath,
        fileName: widget.request.fileName,
      );

      if (!mounted) return;
      context.read<HomeBloc>().add(const HomeRoastsRefreshed());
      setState(() => _progress = 1);
      await Future<void>.delayed(const Duration(milliseconds: 350));
      if (!mounted) return;
      context.go('/result/${roast.id}');
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _progress = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    const errorColor = Color(0xFFFF8A80);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: colors.headline,
        title: Text(
          'ATSify',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: EmberBackground()),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Roasting your resume',
                  style: GoogleFonts.poppins(
                    color: colors.headline,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 8),
                Text(
                  widget.request.fileName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: colors.body,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: _error == null
                        ? _ScanningAnimation()
                        : Icon(
                            Icons.error_outline_rounded,
                            size: 72,
                            color: errorColor.withValues(alpha: 0.9),
                          ),
                  ),
                ),
                if (_error != null) ...[
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: errorColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.pop(),
                    child: const Text('Go back'),
                  ),
                ] else ...[
                  Text(
                    _thoughts[_thoughtIndex],
                    key: ValueKey(_thoughtIndex),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: colors.headline,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      value: _progress,
                      backgroundColor: colors.progressTrack,
                      color: colors.accent,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${(_progress * 100).round()}%',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(color: colors.muted),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanningAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final gifSize = size.width.clamp(260.0, 360.0);

    return Image.asset(
      _LoadingPageState._scanGif,
      width: gifSize,
      height: gifSize,
      fit: BoxFit.contain,
      gaplessPlayback: true,
      filterQuality: FilterQuality.medium,
    )
        .animate()
        .fadeIn(duration: 450.ms)
        .scale(
          begin: const Offset(0.92, 0.92),
          end: const Offset(1, 1),
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        );
  }
}
