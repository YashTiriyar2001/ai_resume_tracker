import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Hey $userName 🔥, ready to get ATSified? ✨',
            style: HomeTheme.greetingStyle,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
            decoration: BoxDecoration(
              color: HomeTheme.surface.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: HomeTheme.border),
              boxShadow: [
                BoxShadow(
                  color: HomeTheme.accent.withValues(alpha: 0.12),
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
                const Text(
                  'UPLOAD YOUR RESUME',
                  style: TextStyle(
                    color: HomeTheme.headline,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'PDF, DOCX, TXT, or photo • Tap or drag & drop',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: HomeTheme.body,
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
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: HomeTheme.accent.withValues(alpha: 0.35),
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
              gradient: HomeTheme.primaryButton,
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Center(
              child: Text(
                'START ROASTING →',
                style: TextStyle(
                  color: Colors.black,
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
