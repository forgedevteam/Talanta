import 'package:flutter/material.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// Shared frame for the onboarding screens: optional back button, a step
/// indicator, a display headline, a short subtitle, the body and a pinned
/// footer that stays above the keyboard.
class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    required this.title,
    required this.body,
    super.key,
    this.subtitle,
    this.footer,
    this.step,
    this.totalSteps = 4,
    this.onBack,
    this.scrollable = true,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final Widget? footer;
  final int? step;
  final int totalSteps;
  final VoidCallback? onBack;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (step != null) ...[
          _StepIndicator(step: step!, total: totalSteps),
          const SizedBox(height: TalantaSpacing.x6),
        ],
        Text(title, style: context.text.headlineLarge),
        if (subtitle != null) ...[
          const SizedBox(height: TalantaSpacing.x3),
          Text(
            subtitle!,
            style: context.text.bodyLarge?.copyWith(color: palette.textMuted),
          ),
        ],
        const SizedBox(height: TalantaSpacing.x8),
      ],
    );

    const padding = EdgeInsets.symmetric(horizontal: TalantaSpacing.x5);

    return Scaffold(
      appBar: AppBar(
        leading: onBack == null
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: onBack,
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: scrollable
                  ? SingleChildScrollView(
                      padding: padding,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [header, body],
                      ),
                    )
                  : Padding(
                      padding: padding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          header,
                          Expanded(child: body),
                        ],
                      ),
                    ),
            ),
            if (footer != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  TalantaSpacing.x5,
                  TalantaSpacing.x3,
                  TalantaSpacing.x5,
                  TalantaSpacing.x4,
                ),
                child: footer,
              ),
          ],
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.step, required this.total});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Semantics(
      label: 'Step $step of $total',
      child: Row(
        children: [
          for (var i = 1; i <= total; i++) ...[
            Expanded(
              child: AnimatedContainer(
                duration: TalantaDurations.base,
                height: 4,
                decoration: BoxDecoration(
                  color: i <= step ? TalantaBrand.primary : palette.outline,
                  borderRadius: BorderRadius.circular(TalantaRadii.pill),
                ),
              ),
            ),
            if (i < total) const SizedBox(width: TalantaSpacing.x2),
          ],
        ],
      ),
    );
  }
}
