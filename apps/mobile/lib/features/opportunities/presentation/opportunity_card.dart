import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:talanta/core/format/formatters.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/talanta_card.dart';
import 'package:talanta/core/widgets/talanta_states.dart';
import 'package:talanta/features/onboarding/domain/talent_icons.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_api/talanta_api.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// Pay, as people will read it: an amount, "to discuss", or unpaid.
String compensationLabel(
  BuildContext context,
  CompensationType compensation,
  num? amount,
  String currency,
) {
  final l10n = AppLocalizations.of(context);
  return switch (compensation) {
    CompensationType.paid when amount != null => Formatters.money(
      context,
      amount,
      currency,
    ),
    CompensationType.unpaid => l10n.callsUnpaid,
    _ => l10n.callsNegotiable,
  };
}

/// One Open Call in a list.
class OpportunityCard extends StatelessWidget {
  const OpportunityCard({
    required this.opportunity,
    required this.onTap,
    super.key,
  });

  final OpportunitySummary opportunity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final o = opportunity;
    final talent = TalentNames.of(l10n, o.category.slug, o.category.name);
    final paid = o.compensation == CompensationType.paid;

    return TalantaCard(
      key: ValueKey('call-${o.id}'),
      onTap: onTap,
      borderColor: o.isFeatured
          ? TalantaBrand.gold.withValues(alpha: 0.6)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                TalentIcons.of(o.category.icon),
                size: 16,
                color: TalantaBrand.primary,
              ),
              const SizedBox(width: TalantaSpacing.x1),
              Expanded(
                child: Text(
                  '$talent · ${o.city}',
                  style: context.text.labelMedium?.copyWith(
                    color: palette.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (o.isFeatured)
                TalantaTag(
                  label: l10n.callsFeatured,
                  icon: Icons.star_rounded,
                  color: TalantaBrand.gold,
                  filled: true,
                ),
            ],
          ),
          const SizedBox(height: TalantaSpacing.x2),
          Text(
            o.title,
            style: context.text.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: TalantaSpacing.x3),
          Wrap(
            spacing: TalantaSpacing.x2,
            runSpacing: TalantaSpacing.x2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              TalantaTag(
                label: compensationLabel(
                  context,
                  o.compensation,
                  o.budgetAmount,
                  o.currency,
                ),
                icon: paid ? Icons.payments_rounded : null,
                color: paid ? palette.success : null,
              ),
              if (o.status != OpportunityStatus.open)
                TalantaTag(label: l10n.callsClosed, color: palette.danger)
              else if (o.deadline != null)
                TalantaTag(
                  label: l10n.callsCloses(
                    Formatters.calendarDate(context, o.deadline!),
                  ),
                  icon: Icons.schedule_rounded,
                ),
            ],
          ),
          const SizedBox(height: TalantaSpacing.x3),
          Row(
            children: [
              Expanded(
                child: Text(
                  o.poster?.displayName ?? '',
                  style: context.text.bodySmall?.copyWith(
                    color: palette.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (o.poster?.isVerified ?? false) ...[
                const Icon(
                  Icons.verified_rounded,
                  size: 14,
                  color: TalantaBrand.gold,
                ),
                const SizedBox(width: TalantaSpacing.x2),
              ],
              Flexible(
                child: Text(
                  '${l10n.callsApplicants(o.applicationsCount.toInt())} · '
                  '${Formatters.ago(context, o.createdAt, clock.now())}',
                  style: context.text.bodySmall?.copyWith(
                    color: palette.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A sponsored card, always labelled as such.
class PromotionCard extends StatelessWidget {
  const PromotionCard({
    required this.promotion,
    required this.onTap,
    super.key,
  });

  final Promotion promotion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    return TalantaCard(
      key: ValueKey('promotion-${promotion.id}'),
      raised: true,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${l10n.callsSponsored} · ${promotion.sponsorName}',
            style: context.text.labelSmall?.copyWith(color: palette.textMuted),
          ),
          const SizedBox(height: TalantaSpacing.x2),
          Text(promotion.title, style: context.text.titleMedium),
          const SizedBox(height: TalantaSpacing.x1),
          Text(
            promotion.body,
            style: context.text.bodyMedium?.copyWith(color: palette.textMuted),
          ),
          const SizedBox(height: TalantaSpacing.x3),
          Text(
            promotion.ctaLabel,
            style: context.text.labelLarge?.copyWith(
              color: TalantaBrand.primary,
            ),
          ),
        ],
      ),
    );
  }
}
