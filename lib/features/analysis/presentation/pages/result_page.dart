import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/di/injection.dart';
import '../../../home/data/roast_repository.dart';
import '../../../home/domain/roast_record.dart';
import '../../../onboarding/presentation/widgets/ember_background.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({
    required this.roastId,
    super.key,
  });

  final String roastId;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  RoastRecord? _roast;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final roast = await getIt<RoastRepository>().getRoastById(widget.roastId);
    if (!mounted) return;
    setState(() {
      _roast = roast;
      _loading = false;
    });
  }

  Future<void> _toggleSaved() async {
    await getIt<RoastRepository>().toggleSaved(widget.roastId);
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_roast?.isSaved == true ? 'Result saved' : 'Removed from saved'),
      ),
    );
  }

  void _share() {
    final roast = _roast;
    if (roast == null) return;
    final topRoast = roast.roasts.isNotEmpty ? roast.roasts.first : 'Got roasted on ATSify';
    Share.share(
      'I scored ${roast.score}/100 on ATSify 🔥\n'
      'Roast level: ${roast.roastLevel}\n'
      '$topRoast',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Color(0xFFFF8C00))),
      );
    }

    final roast = _roast;
    if (roast == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text('Result not found', style: GoogleFonts.inter(color: Colors.white)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text('Your Roast', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: EmberBackground()),
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              _ScoreCircle(score: roast.score).animate().scale(
                    begin: const Offset(0.85, 0.85),
                    duration: 500.ms,
                    curve: Curves.easeOutBack,
                  ),
              const SizedBox(height: 20),
              _RoastMeter(level: roast.roastLevel, spice: roast.spiceLevel),
              const SizedBox(height: 24),
              _SectionCard(
                title: 'Strengths',
                icon: Icons.check_circle_outline,
                items: roast.strengths,
                accent: const Color(0xFF66BB6A),
              ),
              const SizedBox(height: 14),
              _SectionCard(
                title: 'Weaknesses',
                icon: Icons.warning_amber_rounded,
                items: roast.weaknesses,
                accent: const Color(0xFFFF8C00),
              ),
              const SizedBox(height: 14),
              _RoastCards(roasts: roast.roasts),
              const SizedBox(height: 14),
              _KeywordChips(keywords: roast.missingKeywords),
              const SizedBox(height: 14),
              _SectionCard(
                title: 'Suggestions',
                icon: Icons.lightbulb_outline,
                items: roast.suggestions,
                accent: const Color(0xFF42A5F5),
              ),
              const SizedBox(height: 24),
              _ActionButtons(
                isSaved: roast.isSaved,
                onSave: _toggleSaved,
                onShare: _share,
                onDone: () => context.go('/'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreCircle extends StatelessWidget {
  const _ScoreCircle({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 180,
        height: 180,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 180,
              height: 180,
              child: CircularProgressIndicator(
                value: score / 100,
                strokeWidth: 12,
                backgroundColor: const Color(0xFF2A2A2A),
                color: const Color(0xFFFF8C00),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$score',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 52,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                Text(
                  '/100',
                  style: GoogleFonts.inter(color: const Color(0xFF888888), fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoastMeter extends StatelessWidget {
  const _RoastMeter({required this.level, required this.spice});

  final String level;
  final int spice;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: Column(
        children: [
          Text('Roast Meter', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            '${'🌶️' * spice} $level',
            style: GoogleFonts.inter(color: const Color(0xFFFFB74D), fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.items,
    required this.accent,
  });

  final String title;
  final IconData icon;
  final List<String> items;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accent, size: 20),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(color: accent, fontSize: 16)),
                  Expanded(
                    child: Text(item, style: GoogleFonts.inter(color: const Color(0xFFE0E0E0), height: 1.35)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoastCards extends StatelessWidget {
  const _RoastCards({required this.roasts});

  final List<String> roasts;

  @override
  Widget build(BuildContext context) {
    if (roasts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Roast Cards', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: roasts.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return Container(
                width: 260,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2A1A10), Color(0xFF1A1A1A)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFF8C00).withValues(alpha: 0.4)),
                ),
                child: Text(
                  roasts[index],
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 15, height: 1.35),
                ),
              ).animate().fadeIn(delay: (120 * index).ms).slideX(begin: 0.1, end: 0);
            },
          ),
        ),
      ],
    );
  }
}

class _KeywordChips extends StatelessWidget {
  const _KeywordChips({required this.keywords});

  final List<String> keywords;

  @override
  Widget build(BuildContext context) {
    if (keywords.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Missing Keywords', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: keywords
                .map(
                  (keyword) => Chip(
                    label: Text(keyword),
                    backgroundColor: const Color(0xFF2A2A2A),
                    labelStyle: GoogleFonts.inter(color: const Color(0xFFFFB74D)),
                    side: const BorderSide(color: Color(0xFF444444)),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.isSaved,
    required this.onSave,
    required this.onShare,
    required this.onDone,
  });

  final bool isSaved;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: onDone,
          icon: const Icon(Icons.auto_fix_high_rounded),
          label: const Text('Improve Resume'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFFF8C00),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: onShare,
          icon: const Icon(Icons.ios_share_rounded),
          label: const Text('Share Score'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Color(0xFF555555)),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: onSave,
          icon: Icon(isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded),
          label: Text(isSaved ? 'Saved' : 'Save Result'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Color(0xFF555555)),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ],
    );
  }
}
