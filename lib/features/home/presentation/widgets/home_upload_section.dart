import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../theme/home_theme.dart';

abstract final class HomeAssets {
  static const uploadHero = 'assets/home/home_upload_hero.png';
}

class HomeUploadSection extends StatelessWidget {
  const HomeUploadSection({
    required this.userName,
    required this.onStartRoasting,
    super.key,
  });

  final String userName;
  final VoidCallback onStartRoasting;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Hey $userName 🔥, ready to get ATSified? ✨',
            style: HomeTheme.greetingStyle(context),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: colors.border),
              boxShadow: [
                BoxShadow(
                  color: colors.accent.withValues(alpha: 0.12),
                  blurRadius: 32,
                  spreadRadius: -4,
                ),
              ],
            ),
            child: Column(
              children: [
                Image.asset(
                  HomeAssets.uploadHero,
                  height: 160,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 16),
                Text(
                  'UPLOAD YOUR RESUME',
                  style: TextStyle(
                    color: colors.headline,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'PDF, DOCX, TXT, or photo • Tap or drag & drop',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.body,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                _StartRoastingButton(onPressed: onStartRoasting),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StartRoastingButton extends StatelessWidget {
  const _StartRoastingButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: colors.accent.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(32),
          child: Ink(
            height: 56,
            decoration: BoxDecoration(
              gradient: colors.primaryButton,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Center(
              child: Text(
                'START ROASTING →',
                style: TextStyle(
                  color: colors.onAccentButton,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
