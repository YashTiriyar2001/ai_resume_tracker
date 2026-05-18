import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

enum HomeTab { home, history, settings }

class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final HomeTab selected;
  final ValueChanged<HomeTab> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final shadowColor = colors.isDark
        ? Colors.black.withValues(alpha: 0.4)
        : Colors.black.withValues(alpha: 0.08);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.navBar.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: colors.border),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isSelected: selected == HomeTab.home,
                onTap: () => onSelected(HomeTab.home),
              ),
              _NavItem(
                icon: Icons.history_rounded,
                label: 'History',
                isSelected: selected == HomeTab.history,
                onTap: () => onSelected(HomeTab.history),
              ),
              _NavItem(
                icon: Icons.settings_rounded,
                label: 'Settings',
                isSelected: selected == HomeTab.settings,
                onTap: () => onSelected(HomeTab.settings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final color = isSelected ? colors.accent : colors.muted;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 26),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
