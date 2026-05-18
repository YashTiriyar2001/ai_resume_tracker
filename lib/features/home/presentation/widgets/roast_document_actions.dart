import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_palette.dart';
import '../../data/resume_document_service.dart';
import '../../domain/roast_record.dart';

Future<void> showRoastDocumentSheet(
  BuildContext context, {
  required RoastRecord roast,
}) {
  final colors = context.appPalette;

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.surfaceElevated,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      final sheetColors = sheetContext.appPalette;

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: sheetColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    roast.documentIcon,
                    color: sheetColors.accent,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          roast.fileName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: sheetColors.headline,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          roast.fileExtensionLabel,
                          style: TextStyle(
                            color: sheetColors.muted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _SheetAction(
                icon: Icons.open_in_new_rounded,
                label: 'Open resume',
                onTap: () => _runDocumentAction(
                  sheetContext,
                  () => getIt<ResumeDocumentService>().open(roast),
                ),
              ),
              const SizedBox(height: 8),
              _SheetAction(
                icon: Icons.ios_share_rounded,
                label: 'Share resume file',
                onTap: () => _runDocumentAction(
                  sheetContext,
                  () => getIt<ResumeDocumentService>().share(roast),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _runDocumentAction(
  BuildContext context,
  Future<void> Function() action,
) async {
  try {
    await action();
    if (context.mounted) Navigator.of(context).pop();
  } on ResumeDocumentException catch (error) {
    if (!context.mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.message),
        backgroundColor: const Color(0xFFB71C1C),
      ),
    );
  } catch (error) {
    if (!context.mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.toString()),
        backgroundColor: const Color(0xFFB71C1C),
      ),
    );
  }
}

class _SheetAction extends StatelessWidget {
  const _SheetAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: colors.accent, size: 22),
              const SizedBox(width: 14),
              Text(
                label,
                style: TextStyle(
                  color: colors.headline,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoastDocumentIconButton extends StatelessWidget {
  const RoastDocumentIconButton({
    required this.roast,
    super.key,
  });

  final RoastRecord roast;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Resume file',
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      onPressed: () => showRoastDocumentSheet(context, roast: roast),
      icon: Icon(
        roast.documentIcon,
        size: 20,
        color: context.appPalette.accent.withValues(alpha: 0.95),
      ),
    );
  }
}
