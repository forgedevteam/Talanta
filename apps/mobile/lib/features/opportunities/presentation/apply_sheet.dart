import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta/features/discover/application/discover_providers.dart';
import 'package:talanta/features/opportunities/application/talanta_actions.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_api/talanta_api.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

Future<void> showApplySheet(BuildContext context, String opportunityId) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: _ApplySheet(opportunityId: opportunityId),
    ),
  );
}

class _ApplySheet extends ConsumerStatefulWidget {
  const _ApplySheet({required this.opportunityId});

  final String opportunityId;

  @override
  ConsumerState<_ApplySheet> createState() => _ApplySheetState();
}

class _ApplySheetState extends ConsumerState<_ApplySheet> {
  final _message = TextEditingController();
  String? _pieceId;
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context);
    if (_message.text.trim().length < 10) {
      setState(() => _error = l10n.applyMessageTooShort);
      return;
    }
    final navigator = Navigator.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(talantaActionsProvider)
          .apply(
            widget.opportunityId,
            message: _message.text.trim(),
            portfolioItemId: _pieceId,
          );
      if (!mounted) return;
      navigator.pop();
      TalantaSnack.show(context, l10n.applySent);
    } on ApiFailure catch (failure) {
      if (mounted) setState(() => _error = failure.message(l10n));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final session = ref.watch(sessionProvider);
    final username = session is SignedIn ? session.me.profile?.username : null;
    final portfolio = username == null
        ? const <PortfolioItem>[]
        : (ref.watch(creatorProvider(username)).value?.portfolio ??
              const <PortfolioItem>[]);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          TalantaSpacing.x5,
          TalantaSpacing.x2,
          TalantaSpacing.x5,
          TalantaSpacing.x4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.applyTitle, style: context.text.headlineSmall),
            const SizedBox(height: TalantaSpacing.x4),
            TalantaTextField(
              key: const ValueKey('apply-message'),
              label: l10n.applyMessageLabel,
              hint: l10n.applyMessageHint,
              controller: _message,
              error: _error,
              maxLength: 1000,
              minLines: 4,
              maxLines: 8,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: TalantaSpacing.x4),
            Text(
              l10n.applyAttach,
              style: context.text.labelMedium?.copyWith(
                color: palette.textMuted,
              ),
            ),
            const SizedBox(height: TalantaSpacing.x2),
            if (portfolio.isEmpty)
              Text(
                l10n.applyNoPortfolio,
                style: context.text.bodySmall?.copyWith(
                  color: palette.textMuted,
                ),
              )
            else
              Wrap(
                spacing: TalantaSpacing.x2,
                runSpacing: TalantaSpacing.x2,
                children: [
                  TalantaChip(
                    label: l10n.applyNone,
                    selected: _pieceId == null,
                    onTap: () => setState(() => _pieceId = null),
                  ),
                  for (final piece in portfolio)
                    TalantaChip(
                      key: ValueKey('attach-${piece.id}'),
                      label: piece.title,
                      icon: Icons.play_circle_outline_rounded,
                      selected: _pieceId == piece.id,
                      onTap: () => setState(() => _pieceId = piece.id),
                    ),
                ],
              ),
            const SizedBox(height: TalantaSpacing.x5),
            TalantaButton(
              key: const ValueKey('send-application'),
              label: l10n.applySend,
              busy: _busy,
              onPressed: _send,
            ),
          ],
        ),
      ),
    );
  }
}
