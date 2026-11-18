import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talanta/app/routes.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/auth/application/phone_sign_in_controller.dart';
import 'package:talanta/features/auth/domain/country.dart';
import 'package:talanta/features/auth/presentation/country_picker_sheet.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

class PhoneScreen extends ConsumerStatefulWidget {
  const PhoneScreen({super.key});

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen> {
  final _phone = TextEditingController();
  Country _country = Country.cameroon;
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final pending = ref.read(phoneSignInProvider);
    if (pending != null) {
      _country = pending.country;
      _phone.text = pending.typedPhone;
    }
    _phone.addListener(() => setState(() => _error = null));
  }

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  bool get _looksComplete =>
      _phone.text.replaceAll(RegExp(r'\D'), '').length >= 7;

  Future<void> _pickCountry() async {
    final picked = await showCountryPicker(context, selected: _country);
    if (picked != null && mounted) setState(() => _country = picked);
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    if (!_looksComplete) {
      setState(
        () => _error = _phone.text.trim().isEmpty
            ? l10n.phoneErrorEmpty
            : l10n.phoneErrorInvalid,
      );
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(phoneSignInProvider.notifier)
          .requestCode(country: _country, phone: _phone.text.trim());
      if (mounted) unawaited(context.push(Routes.otp));
    } on ApiFailure catch (failure) {
      if (!mounted) return;
      final message = failure is ProblemFailure
          ? failure.fieldMessage('phone') ?? failure.message(l10n)
          : failure.message(l10n);
      setState(() => _error = message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    return OnboardingScaffold(
      step: 1,
      title: l10n.phoneTitle,
      subtitle: l10n.phoneSubtitle,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TalantaTextField(
            key: const ValueKey('phone-field'),
            label: l10n.phoneFieldLabel,
            controller: _phone,
            hint: _country.example,
            error: _error,
            autofocus: true,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.telephoneNumber],
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d\s+\-()]')),
            ],
            maxLength: 20,
            prefix: _CountryButton(
              country: _country,
              onTap: _busy ? null : _pickCountry,
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: TalantaSpacing.x4),
          Text(
            l10n.phoneLegal,
            style: context.text.bodySmall?.copyWith(color: palette.textMuted),
          ),
        ],
      ),
      footer: TalantaButton(
        key: const ValueKey('send-code'),
        label: l10n.phoneSendCode,
        busy: _busy,
        onPressed: _submit,
      ),
    );
  }
}

class _CountryButton extends StatelessWidget {
  const _CountryButton({required this.country, required this.onTap});

  final Country country;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label:
          '${country.displayName(Localizations.localeOf(context).languageCode)} '
          '${country.dialCode}',
      child: InkWell(
        key: const ValueKey('country-button'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(TalantaRadii.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: TalantaSpacing.x3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(country.flag, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: TalantaSpacing.x2),
              Text(country.dialCode, style: context.text.bodyLarge),
              Icon(
                Icons.expand_more_rounded,
                size: 20,
                color: context.palette.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
