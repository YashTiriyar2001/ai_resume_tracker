import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/di/injection.dart';
import '../../../app/cubit/app_cubit.dart';
import '../../../home/data/roast_repository.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/bloc/home_event.dart';
import '../../../home/presentation/theme/home_theme.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<AppCubit>().state.themeMode;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Text('Settings', style: GoogleFonts.poppins(color: HomeTheme.headline, fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 20),
        _SettingsTile(
          icon: Icons.dark_mode_outlined,
          title: 'Dark mode',
          subtitle: _themeLabel(themeMode),
          trailing: Switch.adaptive(
            value: themeMode == ThemeMode.dark,
            activeThumbColor: HomeTheme.accent,
            onChanged: (enabled) {
              context.read<AppCubit>().setThemeMode(
                    enabled ? ThemeMode.dark : ThemeMode.light,
                  );
            },
          ),
        ),
        _SettingsTile(
          icon: Icons.key_outlined,
          title: 'Gemini API',
          subtitle: AppConfig.hasGeminiApiKey
              ? 'gemini-2.0-flash (REST API)'
              : 'Using local fallback analysis',
        ),
        _SettingsTile(
          icon: Icons.delete_outline,
          title: 'Clear history',
          subtitle: 'Remove all saved roasts',
          onTap: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: HomeTheme.surface,
                title: const Text('Clear history?', style: TextStyle(color: HomeTheme.headline)),
                content: const Text(
                  'This deletes all roast results from this device.',
                  style: TextStyle(color: HomeTheme.body),
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                  TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Clear')),
                ],
              ),
            );
            if (confirmed != true || !context.mounted) return;
            await getIt<RoastRepository>().clearAll();
            if (!context.mounted) return;
            context.read<HomeBloc>().add(const HomeStarted());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('History cleared')),
            );
          },
        ),
        _SettingsTile(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy policy',
          subtitle: 'Resumes stay on your device',
        ),
        _SettingsTile(
          icon: Icons.star_outline,
          title: 'Rate app',
          subtitle: 'Spread the roast',
        ),
        _SettingsTile(
          icon: Icons.info_outline,
          title: 'About ATSify',
          subtitle: 'Your resume deserves honesty.',
        ),
      ],
    );
  }

  String _themeLabel(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.dark => 'On',
      ThemeMode.light => 'Off',
      ThemeMode.system => 'System',
    };
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: HomeTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HomeTheme.border),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: HomeTheme.accent),
        title: Text(title, style: GoogleFonts.inter(color: HomeTheme.headline, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: GoogleFonts.inter(color: HomeTheme.muted, fontSize: 12)),
        trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right, color: HomeTheme.muted) : null),
      ),
    );
  }
}
