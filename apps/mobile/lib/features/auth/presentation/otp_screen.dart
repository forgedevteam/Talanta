import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talanta/app/routes.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/auth/application/phone_sign_in_controller.dart';
import 'package:talanta/features/auth/presentation/otp_input.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _code = TextEditingController();
  Timer? _ticker;
  int _secondsToResend = 0;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _code.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _ticker?.cancel();
    _tick();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final pending = ref.read(phoneSignInProvider);
    final remaining = pending == null
        ? 0
        : (pending.resendAt.difference(clock.now()).inMilliseconds / 1000)
              .ceil()
              .clamp(0, 600);
    if (remaining != _secondsToResend && mounted) {
      setState(() => _secondsToResend = remaining);
    }
    if (remaining == 0) _ticker?.cancel();
  }

  Future<void> _verify(String code) async {
    if (_busy) return;
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(phoneSignInProvider.notifier).verifyCode(code);
      unawaited(HapticFeedback.mediumImpact());
      // The router moves on once the session changes.
    } on ApiFailure catch (failure) {
      if (!mounted) return;
      unawaited(HapticFeedback.heavyImpact());
      _code.clear();
      setState(() => _error = failure.message(l10n));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resend() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(phoneSignInProvider.notifier).resendCode();
      _code.clear();
      _startCountdown();
      if (mounted) TalantaSnack.show(context, l10n.otpSent);
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
    final pending = ref.watch(phoneSignInProvider);
    final canResend = _secondsToResend == 0 && !_busy;

    return OnboardingScaffold(
      step: 2,
      title: l10n.otpTitle,
      subtitle: l10n.otpSubtitle(
        // Non-breaking spaces keep the number on one line.
        (pending?.displayPhone ?? '').replaceAll(' ', ' '),
      ),
      onBack: () => context.pop(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OtpInput(
            controller: _code,
            enabled: !_busy,
            hasError: _error != null,
            onCompleted: _verify,
          ),
          AnimatedSize(
            duration: TalantaDurations.fast,
            alignment: Alignment.topLeft,
            child: _error == null
                ? const SizedBox(width: double.infinity)
                : Padding(
                    padding: const EdgeInsets.only(top: TalantaSpacing.x3),
                    child: Text(
                      _error!,
                      key: const ValueKey('otp-error'),
                      style: context.text.bodyMedium?.copyWith(
                        color: palette.danger,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: TalantaSpacing.x6),
          Wrap(
            spacing: TalantaSpacing.x2,
            runSpacing: TalantaSpacing.x1,
            children: [
              TalantaButton(
                key: const ValueKey('resend-code'),
                label: canResend
                    ? l10n.otpResend
                    : l10n.otpResendIn(_secondsToResend),
                variant: TalantaButtonVariant.ghost,
                expand: false,
                onPressed: canResend ? _resend : null,
              ),
              TalantaButton(
                key: const ValueKey('change-number'),
                label: l10n.otpChangeNumber,
                variant: TalantaButtonVariant.ghost,
                expand: false,
                onPressed: _busy ? null : () => context.go(Routes.phone),
              ),
            ],
          ),
        ],
      ),
      footer: TalantaButton(
        key: const ValueKey('verify-code'),
        label: l10n.otpVerify,
        busy: _busy,
        onPressed: _code.text.length == 6 ? () => _verify(_code.text) : null,
      ),
    );
  }
}
