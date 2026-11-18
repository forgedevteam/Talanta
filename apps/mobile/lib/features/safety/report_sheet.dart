import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/opportunities/application/talanta_actions.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_api/talanta_api.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// Lets anyone report a person, a call or a piece of work in two taps.
Future<void> showReportSheet(
  BuildContext context, {
  required ReportTarget target,
  required String targetId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _ReportSheet(target: target, targetId: targetId),
  );
}

class _ReportSheet extends ConsumerStatefulWidget {
  const _ReportSheet({required this.target, required this.targetId});

  final ReportTarget target;
  final String targetId;

  @override
  ConsumerState<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends ConsumerState<_ReportSheet> {
  bool _busy = false;

  Future<void> _send(ReportReason reason) async {
    final l10n = AppLocalizations.of(context);
    final messenger = Navigator.of(context);
    setState(() => _busy = true);
    try {
      await ref
          .read(talantaActionsProvider)
          .report(widget.target, widget.targetId, reason);
      if (!mounted) return;
      messenger.pop();
      TalantaSnack.show(context, l10n.reportThanks);
    } on ApiFailure catch (failure) {
      if (mounted) {
        TalantaSnack.show(context, failure.message(l10n), error: true);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reasons = <(ReportReason, String, IconData)>[
      (ReportReason.scam, l10n.reasonScam, Icons.money_off_rounded),
      (
        ReportReason.harassment,
        l10n.reasonHarassment,
        Icons.front_hand_rounded,
      ),
      (
        ReportReason.inappropriate,
        l10n.reasonInappropriate,
        Icons.visibility_off_rounded,
      ),
      (ReportReason.underage, l10n.reasonUnderage, Icons.child_care_rounded),
      (ReportReason.spam, l10n.reasonSpam, Icons.report_gmailerrorred_rounded),
      (ReportReason.other, l10n.reasonOther, Icons.more_horiz_rounded),
    ];
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              TalantaSpacing.x5,
              TalantaSpacing.x2,
              TalantaSpacing.x5,
              TalantaSpacing.x3,
            ),
            child: Text(l10n.reportTitle, style: context.text.headlineSmall),
          ),
          for (final (reason, label, icon) in reasons)
            ListTile(
              key: ValueKey('report-${reason.name}'),
              leading: Icon(icon),
              title: Text(label),
              enabled: !_busy,
              onTap: () => _send(reason),
            ),
          const SizedBox(height: TalantaSpacing.x2),
        ],
      ),
    );
  }
}
