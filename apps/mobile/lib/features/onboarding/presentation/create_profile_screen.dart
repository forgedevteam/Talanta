import 'dart:async';
import 'dart:io';

import 'package:clock/clock.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talanta/app/routes.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta/features/auth/domain/country.dart';
import 'package:talanta/features/onboarding/application/onboarding_controller.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_api/talanta_api.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

final _usernamePattern = RegExp(r'^[a-z0-9_]{3,24}$');

class CreateProfileScreen extends ConsumerStatefulWidget {
  const CreateProfileScreen({super.key, this.imagePicker});

  /// Injected in tests; the real picker needs a platform.
  final ImagePicker? imagePicker;

  @override
  ConsumerState<CreateProfileScreen> createState() =>
      _CreateProfileScreenState();
}

class _CreateProfileScreenState extends ConsumerState<CreateProfileScreen> {
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _city = TextEditingController();

  String? _nameError;
  String? _usernameError;
  String? _cityError;
  String? _dobError;
  DateTime? _dateOfBirth;

  /// The server fixes the date of birth once set, so only ask when it is missing.
  bool _needsDateOfBirth = true;

  /// A city from the person's own country, so the example feels familiar.
  String _cityHint = Country.cameroon.exampleCity;
  UsernameStatus? _usernameStatus;
  Timer? _usernameDebounce;
  XFile? _photo;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final session = ref.read(sessionProvider);
    if (session is SignedIn) {
      _needsDateOfBirth = session.me.dateOfBirth == null;
      _cityHint = Country.fromCode(session.me.country).exampleCity;
    }
    if (session is SignedIn && session.me.profile != null) {
      final profile = session.me.profile!;
      _name.text = profile.displayName;
      _username.text = profile.username;
      _city.text = profile.city ?? '';
    }
    _name.addListener(() => setState(() => _nameError = null));
    _city.addListener(() => setState(() => _cityError = null));
    _username.addListener(_onUsernameChanged);
  }

  @override
  void dispose() {
    _usernameDebounce?.cancel();
    _name.dispose();
    _username.dispose();
    _city.dispose();
    super.dispose();
  }

  void _onUsernameChanged() {
    final value = _username.text;
    final lower = value.toLowerCase();
    if (value != lower) {
      _username.value = _username.value.copyWith(
        text: lower,
        selection: TextSelection.collapsed(offset: lower.length),
      );
      return;
    }
    setState(() {
      _usernameError = null;
      _usernameStatus = null;
    });
    _usernameDebounce?.cancel();
    if (!_usernamePattern.hasMatch(lower)) return;
    _usernameDebounce = Timer(
      const Duration(milliseconds: 450),
      () => _checkUsername(lower),
    );
  }

  Future<void> _checkUsername(String username) async {
    try {
      final status = await ref
          .read(onboardingControllerProvider)
          .checkUsername(username);
      if (mounted && _username.text == username) {
        setState(() => _usernameStatus = status);
      }
    } on ApiFailure {
      // The save will report a clash; the live hint is only a courtesy.
    }
  }

  Future<void> _pickPhoto() async {
    final picker = widget.imagePicker ?? ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (file != null && mounted) {
      setState(() => _photo = file);
      TalantaSnack.show(
        context,
        AppLocalizations.of(context).profilePhotoLater,
      );
    }
  }

  Future<void> _pickDateOfBirth() async {
    final today = clock.now();
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _dateOfBirth ?? DateTime(today.year - 18, today.month, today.day),
      firstDate: DateTime(today.year - 120),
      lastDate: today,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDatePickerMode: DatePickerMode.year,
      helpText: AppLocalizations.of(context).profileDobLabel,
    );
    if (picked != null && mounted) {
      setState(() {
        _dateOfBirth = picked;
        _dobError = null;
      });
    }
  }

  bool _validate(AppLocalizations l10n) {
    final name = _name.text.trim();
    final username = _username.text.trim();
    final city = _city.text.trim();
    setState(() {
      _nameError = name.isEmpty
          ? l10n.profileErrorNameEmpty
          : name.length < 2 || name.length > 50
          ? l10n.profileErrorNameLength
          : null;
      _usernameError = username.isEmpty
          ? l10n.profileErrorUsernameEmpty
          : _usernamePattern.hasMatch(username)
          ? null
          : l10n.profileErrorUsernameFormat;
      _cityError = city.length < 2 ? l10n.profileErrorCity : null;
      _dobError = _needsDateOfBirth && _dateOfBirth == null
          ? l10n.profileErrorDob
          : null;
    });
    return _nameError == null &&
        _usernameError == null &&
        _cityError == null &&
        _dobError == null;
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!_validate(l10n)) return;
    setState(() => _busy = true);
    try {
      await ref
          .read(onboardingControllerProvider)
          .saveProfile(
            displayName: _name.text.trim(),
            username: _username.text.trim(),
            city: _city.text.trim(),
            dateOfBirth: _needsDateOfBirth ? _dateOfBirth : null,
          );
      unawaited(HapticFeedback.mediumImpact());
      if (!mounted) return;
      // Opened from the Profile tab to edit: go back there.
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(Routes.home);
      }
    } on ApiFailure catch (failure) {
      if (!mounted) return;
      if (failure is ProblemFailure) {
        final code = failure.code;
        if (code == ErrorCode.usernameTaken ||
            code == ErrorCode.usernameReserved) {
          setState(() => _usernameError = failure.message(l10n));
          return;
        }
        if (code == ErrorCode.validationFailed) {
          setState(() {
            _nameError = failure.fieldMessage('displayName');
            _usernameError = failure.fieldMessage('username');
            _cityError = failure.fieldMessage('city');
            _dobError = failure.fieldMessage('dateOfBirth');
          });
          return;
        }
        if (code == ErrorCode.ageBelowMinimum) {
          setState(() => _dobError = failure.message(l10n));
          return;
        }
      }
      TalantaSnack.show(context, failure.message(l10n), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    final usernameHelper = switch (_usernameStatus) {
      UsernameStatus.available => l10n.profileUsernameAvailable(_username.text),
      UsernameStatus.taken => l10n.profileUsernameTaken,
      UsernameStatus.reserved => l10n.profileUsernameReserved,
      _ => l10n.profileUsernameHelp,
    };
    final usernameError =
        _usernameError ??
        (_usernameStatus == UsernameStatus.taken ||
                _usernameStatus == UsernameStatus.reserved
            ? usernameHelper
            : null);

    return OnboardingScaffold(
      step: 4,
      title: l10n.profileTitle,
      subtitle: l10n.profileSubtitle,
      body: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: _AvatarPicker(
                photo: _photo,
                label: _photo == null
                    ? l10n.profileAddPhoto
                    : l10n.profileChangePhoto,
                onTap: _busy ? null : _pickPhoto,
              ),
            ),
            const SizedBox(height: TalantaSpacing.x8),
            TalantaTextField(
              key: const ValueKey('name-field'),
              label: l10n.profileNameLabel,
              controller: _name,
              hint: l10n.profileNameHint,
              error: _nameError,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              maxLength: 50,
            ),
            const SizedBox(height: TalantaSpacing.x4),
            TalantaTextField(
              key: const ValueKey('username-field'),
              label: l10n.profileUsernameLabel,
              controller: _username,
              hint: l10n.profileUsernameHint,
              helper: usernameHelper,
              error: usernameError,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newUsername],
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_]')),
              ],
              maxLength: 24,
              // Sized like a text indent, centred on the input line.
              prefix: SizedBox(
                width: TalantaSpacing.x10,
                child: Center(
                  child: Text(
                    '@',
                    style: context.text.bodyLarge?.copyWith(
                      color: palette.textMuted,
                    ),
                  ),
                ),
              ),
              suffix: _usernameStatus == UsernameStatus.available
                  ? Icon(Icons.check_circle_rounded, color: palette.success)
                  : null,
            ),
            const SizedBox(height: TalantaSpacing.x4),
            TalantaTextField(
              key: const ValueKey('city-field'),
              label: l10n.profileCityLabel,
              controller: _city,
              hint: _cityHint,
              error: _cityError,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.addressCity],
              maxLength: 80,
              onSubmitted: (_) => _save(),
            ),
            if (_needsDateOfBirth) ...[
              const SizedBox(height: TalantaSpacing.x4),
              TalantaDateField(
                key: const ValueKey('dob-field'),
                label: l10n.profileDobLabel,
                value: _dateOfBirth,
                hint: l10n.profileDobHint,
                helper: l10n.profileDobHelp,
                error: _dobError,
                onTap: _busy ? null : _pickDateOfBirth,
              ),
            ],
          ],
        ),
      ),
      footer: TalantaButton(
        key: const ValueKey('finish-profile'),
        label: l10n.profileFinish,
        busy: _busy,
        onPressed: _save,
      ),
    );
  }
}

class _AvatarPicker extends StatelessWidget {
  const _AvatarPicker({
    required this.photo,
    required this.label,
    required this.onTap,
  });

  final XFile? photo;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        key: const ValueKey('avatar-picker'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(TalantaRadii.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.surfaceRaised,
                border: Border.all(color: palette.outline),
                image: photo == null
                    ? null
                    : DecorationImage(
                        image: FileImage(File(photo!.path)),
                        fit: BoxFit.cover,
                      ),
              ),
              child: photo == null
                  ? Icon(
                      Icons.add_a_photo_outlined,
                      color: palette.textMuted,
                      size: 28,
                    )
                  : null,
            ),
            const SizedBox(height: TalantaSpacing.x2),
            Text(
              label,
              style: context.text.labelMedium?.copyWith(
                color: TalantaBrand.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
