import 'dart:async';

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
import 'package:talanta/features/onboarding/application/onboarding_controller.dart';
import 'package:talanta/features/onboarding/domain/talent_icons.dart';
import 'package:talanta/features/posts/presentation/composer_screen.dart';
import 'package:talanta/features/profile/application/profile_actions.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_api/talanta_api.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

final _usernamePattern = RegExp(r'^[a-z0-9_]{3,24}$');

/// Change my picture, name, username, bio and city.
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _bio = TextEditingController();
  final _city = TextEditingController();

  String? _nameError;
  String? _usernameError;
  String? _bioError;
  String? _cityError;
  UsernameStatus? _usernameStatus;
  Timer? _usernameDebounce;
  bool _saving = false;
  bool _pictureBusy = false;
  double _pictureProgress = 0;
  late final ProfileSnapshot _original;

  @override
  void initState() {
    super.initState();
    final session = ref.read(sessionProvider);
    final profile = session is SignedIn ? session.me.profile : null;
    _original = ProfileSnapshot(
      name: profile?.displayName ?? '',
      username: profile?.username ?? '',
      bio: profile?.bio ?? '',
      city: profile?.city ?? '',
    );
    _name.text = _original.name;
    _username.text = _original.username;
    _bio.text = _original.bio;
    _city.text = _original.city;
    _name.addListener(() => setState(() => _nameError = null));
    _bio.addListener(() => setState(() => _bioError = null));
    _city.addListener(() => setState(() => _cityError = null));
    _username.addListener(_onUsernameChanged);
  }

  @override
  void dispose() {
    _usernameDebounce?.cancel();
    _name.dispose();
    _username.dispose();
    _bio.dispose();
    _city.dispose();
    super.dispose();
  }

  ProfileSnapshot get _current => ProfileSnapshot(
    name: _name.text.trim(),
    username: _username.text.trim(),
    bio: _bio.text.trim(),
    city: _city.text.trim(),
  );

  bool get _changed => _current != _original;

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
    if (lower == _original.username || !_usernamePattern.hasMatch(lower)) {
      return;
    }
    _usernameDebounce = Timer(const Duration(milliseconds: 450), () async {
      try {
        final status = await ref
            .read(onboardingControllerProvider)
            .checkUsername(lower);
        if (mounted && _username.text == lower) {
          setState(() => _usernameStatus = status);
        }
      } on ApiFailure {
        // Saving reports a clash; the live hint is a courtesy.
      }
    });
  }

  bool _validate(AppLocalizations l10n) {
    final c = _current;
    setState(() {
      _nameError = c.name.isEmpty
          ? l10n.profileErrorNameEmpty
          : c.name.length < 2 || c.name.length > 50
          ? l10n.profileErrorNameLength
          : null;
      _usernameError = c.username.isEmpty
          ? l10n.profileErrorUsernameEmpty
          : _usernamePattern.hasMatch(c.username)
          ? null
          : l10n.profileErrorUsernameFormat;
      _cityError = c.city.length < 2 ? l10n.profileErrorCity : null;
      _bioError = c.bio.length > 280 ? l10n.editBioTooLong : null;
    });
    return _nameError == null &&
        _usernameError == null &&
        _cityError == null &&
        _bioError == null;
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!_changed) {
      context.pop();
      return;
    }
    if (!_validate(l10n)) return;
    setState(() => _saving = true);
    try {
      final c = _current;
      await ref
          .read(profileActionsProvider)
          .save(
            displayName: c.name,
            username: c.username,
            city: c.city,
            bio: c.bio,
          );
      unawaited(HapticFeedback.mediumImpact());
      if (!mounted) return;
      TalantaSnack.show(context, l10n.editSaved);
      context.pop();
    } on ProblemFailure catch (failure) {
      if (!mounted) return;
      switch (failure.code) {
        case ErrorCode.usernameTaken || ErrorCode.usernameReserved:
          setState(() => _usernameError = failure.message(l10n));
        case ErrorCode.validationFailed:
          setState(() {
            _nameError = failure.fieldMessage('displayName');
            _usernameError = failure.fieldMessage('username');
            _cityError = failure.fieldMessage('city');
            _bioError = failure.fieldMessage('bio');
          });
        case _:
          TalantaSnack.show(context, failure.message(l10n), error: true);
      }
    } on ApiFailure catch (failure) {
      if (mounted) {
        TalantaSnack.show(context, failure.message(l10n), error: true);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _changePicture() async {
    final l10n = AppLocalizations.of(context);
    final session = ref.read(sessionProvider);
    final hasPicture =
        session is SignedIn && session.me.profile?.avatarUrl != null;
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              key: const ValueKey('picture-gallery'),
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.editPictureGallery),
              onTap: () => Navigator.pop(sheet, 'gallery'),
            ),
            ListTile(
              key: const ValueKey('picture-camera'),
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.editPictureCamera),
              onTap: () => Navigator.pop(sheet, 'camera'),
            ),
            if (hasPicture)
              ListTile(
                key: const ValueKey('picture-remove'),
                leading: Icon(
                  Icons.delete_outline_rounded,
                  color: context.palette.danger,
                ),
                title: Text(
                  l10n.editPictureRemove,
                  style: TextStyle(color: context.palette.danger),
                ),
                onTap: () => Navigator.pop(sheet, 'remove'),
              ),
          ],
        ),
      ),
    );
    if (choice == null || !mounted) return;

    final actions = ref.read(profileActionsProvider);
    try {
      if (choice == 'remove') {
        setState(() => _pictureBusy = true);
        await actions.removePicture();
      } else {
        final file = await ref
            .read(imagePickerProvider)
            .pickImage(
              source: choice == 'camera'
                  ? ImageSource.camera
                  : ImageSource.gallery,
              maxWidth: 1600,
              maxHeight: 1600,
              imageQuality: 90,
              preferredCameraDevice: CameraDevice.front,
            );
        if (file == null || !mounted) return;
        setState(() {
          _pictureBusy = true;
          _pictureProgress = 0;
        });
        await actions.setPicture(
          file.path,
          onProgress: (value) {
            if (mounted) setState(() => _pictureProgress = value);
          },
        );
        if (mounted) TalantaSnack.show(context, l10n.editPictureSaved);
      }
    } on ApiFailure catch (failure) {
      if (mounted) {
        TalantaSnack.show(context, failure.message(l10n), error: true);
      }
    } finally {
      if (mounted) setState(() => _pictureBusy = false);
    }
  }

  Future<bool> _confirmDiscard() async {
    if (!_changed) return true;
    final l10n = AppLocalizations.of(context);
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(l10n.editDiscardTitle),
        content: Text(l10n.editDiscardBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: Text(l10n.editKeepEditing),
          ),
          TextButton(
            key: const ValueKey('discard-changes'),
            onPressed: () => Navigator.pop(dialog, true),
            child: Text(l10n.editDiscard),
          ),
        ],
      ),
    );
    return discard ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final session = ref.watch(sessionProvider);
    final me = session is SignedIn ? session.me : null;
    final profile = me?.profile;

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

    return PopScope(
      canPop: !_changed || _saving,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        if (await _confirmDiscard()) navigator.pop();
      },
      child: Scaffold(
        key: const ValueKey('edit-profile-screen'),
        appBar: AppBar(
          leading: IconButton(
            tooltip: l10n.commonClose,
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          centerTitle: true,
          title: Text(l10n.profileMenuEdit),
          actions: [
            TextButton(
              key: const ValueKey('save-profile'),
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.editSave),
            ),
            const SizedBox(width: TalantaSpacing.x2),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(
            TalantaSpacing.x4,
            TalantaSpacing.x2,
            TalantaSpacing.x4,
            TalantaSpacing.x10,
          ),
          children: [
            Center(
              child: GestureDetector(
                key: const ValueKey('change-picture'),
                onTap: _pictureBusy ? null : _changePicture,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        TalantaAvatar(
                          name: profile?.displayName ?? '',
                          imageUrl: profile?.avatarUrl,
                          size: 104,
                        ),
                        if (_pictureBusy)
                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0x88000000),
                              ),
                              padding: const EdgeInsets.all(34),
                              child: CircularProgressIndicator(
                                value:
                                    _pictureProgress > 0 && _pictureProgress < 1
                                    ? _pictureProgress
                                    : null,
                                strokeWidth: 3,
                              ),
                            ),
                          ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: TalantaBrand.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: palette.background,
                                width: 3,
                              ),
                            ),
                            child: Icon(
                              Icons.photo_camera_rounded,
                              size: 18,
                              color: palette.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TalantaSpacing.x2),
                    Text(
                      profile?.avatarUrl == null
                          ? l10n.profileAddPhoto
                          : l10n.profileChangePhoto,
                      style: context.text.labelMedium?.copyWith(
                        color: TalantaBrand.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: TalantaSpacing.x6),
            TalantaTextField(
              key: const ValueKey('name-field'),
              label: l10n.profileNameLabel,
              controller: _name,
              error: _nameError,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              maxLength: 50,
            ),
            const SizedBox(height: TalantaSpacing.x4),
            TalantaTextField(
              key: const ValueKey('username-field'),
              label: l10n.profileUsernameLabel,
              controller: _username,
              helper: usernameHelper,
              error: usernameError,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_]')),
              ],
              maxLength: 24,
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
              key: const ValueKey('bio-field'),
              label: l10n.editBioLabel,
              controller: _bio,
              hint: l10n.editBioHint,
              error: _bioError,
              textCapitalization: TextCapitalization.sentences,
              minLines: 3,
              maxLines: 6,
              maxLength: 280,
              showCounter: true,
            ),
            const SizedBox(height: TalantaSpacing.x4),
            TalantaTextField(
              key: const ValueKey('city-field'),
              label: l10n.profileCityLabel,
              controller: _city,
              error: _cityError,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              maxLength: 80,
            ),
            const SizedBox(height: TalantaSpacing.x6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.editTalents,
                    style: context.text.titleMedium,
                  ),
                ),
                TextButton(
                  key: const ValueKey('edit-talents'),
                  onPressed: () => unawaited(context.push(Routes.talents)),
                  child: Text(l10n.editChange),
                ),
              ],
            ),
            Wrap(
              spacing: TalantaSpacing.x2,
              runSpacing: TalantaSpacing.x2,
              children: [
                for (final t in me?.talents ?? const <UserTalent>[])
                  TalantaTag(
                    label:
                        TalentNames.of(l10n, t.slug, t.name) +
                        (t.isPrimary ? ' · ${l10n.editPrimary}' : ''),
                    icon: TalentIcons.of(t.icon),
                    color: t.isPrimary ? TalantaBrand.primary : null,
                  ),
              ],
            ),
            if (me?.dateOfBirth != null) ...[
              const SizedBox(height: TalantaSpacing.x6),
              Text(
                l10n.editBirthdayFixed,
                style: context.text.bodySmall?.copyWith(
                  color: palette.textMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The editable fields, to tell whether anything changed.
@immutable
class ProfileSnapshot {
  const ProfileSnapshot({
    required this.name,
    required this.username,
    required this.bio,
    required this.city,
  });

  final String name;
  final String username;
  final String bio;
  final String city;

  @override
  bool operator ==(Object other) =>
      other is ProfileSnapshot &&
      other.name == name &&
      other.username == username &&
      other.bio == bio &&
      other.city == city;

  @override
  int get hashCode => Object.hash(name, username, bio, city);
}
