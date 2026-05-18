import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class HomeStatsSection extends StatelessWidget {
  const HomeStatsSection({
    required this.totalRoasts,
    required this.averageScore,
    required this.fastestAnalysisLabel,
    super.key,
  });

  final int totalRoasts;
  final int? averageScore;
  final String fastestAnalysisLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final avgLabel = averageScore == null ? '—' : '$averageScore/100';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: colors.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: _StatItem(
                label: 'Total Roasts',
                value: '$totalRoasts ✨',
              ),
            ),
            _StatDivider(color: colors.border),
            Expanded(
              child: _StatItem(
                label: 'Avg ATS Score',
                value: avgLabel,
              ),
            ),
            _StatDivider(color: colors.border),
            Expanded(
              child: _StatItem(
                label: 'Fastest Analysis',
                value: fastestAnalysisLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: color,
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;

    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colors.muted,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colors.statValue,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
