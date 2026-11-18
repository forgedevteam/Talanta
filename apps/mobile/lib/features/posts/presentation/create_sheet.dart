import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talanta/app/routes.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// What the composer opens ready to make.
enum ComposeMode { photo, video, reel, text }

/// The sheet behind the + button.
Future<void> showCreateSheet(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  void open(String location) {
    Navigator.of(context).pop();
    unawaited(context.push(location));
  }

  String compose(ComposeMode mode) => '${Routes.compose}?mode=${mode.name}';

  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          TalantaSpacing.x4,
          0,
          TalantaSpacing.x4,
          TalantaSpacing.x4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.createTitle, style: context.text.headlineSmall),
            const SizedBox(height: TalantaSpacing.x4),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: TalantaSpacing.x3,
              crossAxisSpacing: TalantaSpacing.x3,
              childAspectRatio: 1.45,
              children: [
                _Option(
                  key: const ValueKey('create-photo'),
                  icon: Icons.photo_library_rounded,
                  tone: TalantaBrand.primary,
                  title: l10n.createPhoto,
                  hint: l10n.createPhotoHint,
                  onTap: () => open(compose(ComposeMode.photo)),
                ),
                _Option(
                  key: const ValueKey('create-reel'),
                  icon: Icons.smart_display_rounded,
                  tone: TalantaBrand.secondary,
                  title: l10n.createReel,
                  hint: l10n.createReelHint,
                  onTap: () => open(compose(ComposeMode.reel)),
                ),
                _Option(
                  key: const ValueKey('create-text'),
                  icon: Icons.edit_note_rounded,
                  tone: const Color(0xFF1F9E8A),
                  title: l10n.createText,
                  hint: l10n.createTextHint,
                  onTap: () => open(compose(ComposeMode.text)),
                ),
                _Option(
                  key: const ValueKey('create-call'),
                  icon: Icons.work_rounded,
                  tone: TalantaBrand.gold,
                  title: l10n.createCall,
                  hint: l10n.createCallHint,
                  onTap: () => open(Routes.postCall),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _Option extends StatelessWidget {
  const _Option({
    required this.icon,
    required this.tone,
    required this.title,
    required this.hint,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final Color tone;
  final String title;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Material(
      color: palette.surfaceRaised,
      borderRadius: BorderRadius.circular(TalantaRadii.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TalantaRadii.md),
        child: Padding(
          padding: const EdgeInsets.all(TalantaSpacing.x3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: tone.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: tone, size: 21),
              ),
              const Spacer(),
              Text(title, style: context.text.titleSmall),
              Text(
                hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.bodySmall?.copyWith(
                  color: palette.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
