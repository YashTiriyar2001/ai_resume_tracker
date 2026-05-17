import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/roast_record.dart';
import '../theme/home_theme.dart';

class HomeRecentRoastsSection extends StatelessWidget {
  const HomeRecentRoastsSection({
    required this.roasts,
    super.key,
  });

  final List<RoastRecord> roasts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text('Recent Roasts', style: HomeTheme.sectionTitleStyle),
                const Spacer(),
                if (roasts.isNotEmpty)
                  Text(
                    '${roasts.length} shown',
                    style: HomeTheme.linkStyle.copyWith(fontSize: 13),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (roasts.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'No roasts yet. Tap START ROASTING to upload your first resume.',
                style: TextStyle(
                  color: HomeTheme.body,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            )
          else
            SizedBox(
              height: 148,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: roasts.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return _RecentRoastCard(roast: roasts[index]);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _RecentRoastCard extends StatelessWidget {
  const _RecentRoastCard({required this.roast});

  final RoastRecord roast;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/result/${roast.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 168,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: HomeTheme.surfaceElevated,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: HomeTheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 16,
                    color: HomeTheme.muted.withValues(alpha: 0.9),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      roast.timeAgoLabel,
                      style: const TextStyle(
                        color: HomeTheme.muted,
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  roast.fileName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: HomeTheme.headline,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '🔥 ${roast.roastLevel}',
                style: const TextStyle(color: HomeTheme.body, fontSize: 11),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
