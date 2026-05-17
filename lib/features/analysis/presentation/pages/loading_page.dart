import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/di/injection.dart';
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text('ATSify', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: EmberBackground()),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Roasting your resume',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 8),
                Text(
                  widget.request.fileName,
                  style: GoogleFonts.inter(color: const Color(0xFFB3B3B3), fontSize: 14),
                ),
                const Spacer(),
                if (_error != null) ...[
                  Text(
                    _error!,
                    style: GoogleFonts.inter(color: const Color(0xFFFF8A80), fontSize: 14),
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
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 28),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      value: _progress,
                      backgroundColor: const Color(0xFF2A2A2A),
                      color: const Color(0xFFFF8C00),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${(_progress * 100).round()}%',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(color: const Color(0xFF888888)),
                  ),
                ],
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
