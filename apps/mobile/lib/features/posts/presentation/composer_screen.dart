import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talanta/core/network/api_failure.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/core/widgets/widgets.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta/features/posts/application/post_actions.dart';
import 'package:talanta/features/posts/presentation/create_sheet.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_tokens/talanta_tokens.dart';
import 'package:video_player/video_player.dart';

/// The photo and video picker. Tests replace it.
final imagePickerProvider = Provider<ImagePicker>((ref) => ImagePicker());

const _maxPhotos = 10;
const _maxVideo = Duration(minutes: 3);

/// Write something, add photos or a video, and post.
class ComposerScreen extends ConsumerStatefulWidget {
  const ComposerScreen({required this.mode, super.key});

  final ComposeMode mode;

  @override
  ConsumerState<ComposerScreen> createState() => _ComposerScreenState();
}

class _ComposerScreenState extends ConsumerState<ComposerScreen> {
  final _text = TextEditingController();
  final List<PickedMedia> _media = [];
  bool _isReel = false;
  bool _busy = false;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _isReel = widget.mode == ComposeMode.reel;
    _text.addListener(() => setState(() {}));
    // Opening "Photo" or "Reel" goes straight to the phone's gallery.
    if (widget.mode == ComposeMode.photo) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _pickPhotos());
    } else if (widget.mode == ComposeMode.reel) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _pickVideo(ImageSource.gallery),
      );
    }
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  bool get _hasVideo => _media.any((m) => m.isVideo);
  bool get _canPost =>
      !_busy && (_text.text.trim().isNotEmpty || _media.isNotEmpty);

  Future<void> _pickPhotos() async {
    if (_hasVideo) return _replaceWarning();
    final room = _maxPhotos - _media.length;
    if (room <= 0) return;
    final picker = ref.read(imagePickerProvider);
    final files = await picker.pickMultiImage(
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 88,
      limit: room > 1 ? room : null,
    );
    if (!mounted || files.isEmpty) return;
    setState(() {
      _media.addAll(
        files.take(room).map((f) => PickedMedia(path: f.path, isVideo: false)),
      );
    });
  }

  Future<void> _takePhoto() async {
    if (_hasVideo) return _replaceWarning();
    if (_media.length >= _maxPhotos) return;
    final file = await ref
        .read(imagePickerProvider)
        .pickImage(
          source: ImageSource.camera,
          maxWidth: 2048,
          maxHeight: 2048,
          imageQuality: 88,
        );
    if (file != null && mounted) {
      setState(() => _media.add(PickedMedia(path: file.path, isVideo: false)));
    }
  }

  Future<void> _pickVideo(ImageSource source) async {
    final file = await ref
        .read(imagePickerProvider)
        .pickVideo(source: source, maxDuration: _maxVideo);
    if (file == null || !mounted) return;
    final bytes = await File(file.path).length();
    if (!mounted) return;
    if (bytes > 60 * 1024 * 1024) {
      TalantaSnack.show(
        context,
        AppLocalizations.of(context).composeVideoTooBig,
        error: true,
      );
      return;
    }
    setState(() {
      _media
        ..clear()
        ..add(PickedMedia(path: file.path, isVideo: true));
    });
  }

  void _replaceWarning() {
    TalantaSnack.show(
      context,
      AppLocalizations.of(context).composeOneVideo,
      error: true,
    );
  }

  Future<void> _post() async {
    if (!_canPost) return;
    final l10n = AppLocalizations.of(context);
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _progress = 0;
    });
    try {
      await ref
          .read(postActionsProvider)
          .publish(
            body: _text.text,
            media: List.of(_media),
            isReel: _hasVideo && _isReel,
            onProgress: (value) {
              if (mounted) setState(() => _progress = value);
            },
          );
      unawaited(HapticFeedback.mediumImpact());
      if (!mounted) return;
      TalantaSnack.show(context, l10n.composePosted);
      context.pop();
    } on ApiFailure catch (failure) {
      if (mounted) {
        TalantaSnack.show(context, failure.message(l10n), error: true);
      }
    } on Object {
      if (mounted) TalantaSnack.show(context, l10n.errorGeneric, error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final session = ref.watch(sessionProvider);
    final profile = session is SignedIn ? session.me.profile : null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: l10n.commonClose,
          onPressed: _busy ? null : () => context.pop(),
          icon: const Icon(Icons.close_rounded),
        ),
        title: Text(
          widget.mode == ComposeMode.reel
              ? l10n.composeReelTitle
              : l10n.composeTitle,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: TalantaSpacing.x3),
            child: Center(
              child: SizedBox(
                height: 38,
                child: FilledButton(
                  key: const ValueKey('publish-post'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(80, 38),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                  ),
                  onPressed: _canPost ? _post : null,
                  child: Text(l10n.composePost),
                ),
              ),
            ),
          ),
        ],
        bottom: _busy
            ? PreferredSize(
                preferredSize: const Size.fromHeight(3),
                child: LinearProgressIndicator(
                  value: _progress > 0 && _progress < 1 ? _progress : null,
                  minHeight: 3,
                ),
              )
            : null,
      ),
      body: AbsorbPointer(
        absorbing: _busy,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(TalantaSpacing.x4),
                children: [
                  Row(
                    children: [
                      TalantaAvatar(
                        name: profile?.displayName ?? '',
                        imageUrl: profile?.avatarUrl,
                        size: 40,
                      ),
                      const SizedBox(width: TalantaSpacing.x3),
                      Expanded(
                        child: Text(
                          profile?.displayName ?? '',
                          style: context.text.titleSmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TalantaSpacing.x3),
                  TextField(
                    key: const ValueKey('compose-text'),
                    controller: _text,
                    autofocus: widget.mode == ComposeMode.text,
                    minLines: 3,
                    maxLines: null,
                    maxLength: 2200,
                    textCapitalization: TextCapitalization.sentences,
                    style: context.text.bodyLarge,
                    decoration: InputDecoration(
                      hintText: _media.isEmpty
                          ? l10n.composeHint
                          : l10n.composeCaptionHint,
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  if (_media.isNotEmpty) ...[
                    const SizedBox(height: TalantaSpacing.x3),
                    if (_hasVideo)
                      _VideoPreview(
                        path: _media.first.path,
                        onRemove: () => setState(_media.clear),
                      )
                    else
                      _PhotoStrip(
                        media: _media,
                        onRemove: (index) =>
                            setState(() => _media.removeAt(index)),
                        // The first photo is the one people see first.
                        onReorder: (from, to) => setState(() {
                          final item = _media.removeAt(from);
                          _media.insert(to > from ? to - 1 : to, item);
                        }),
                      ),
                  ],
                  if (_hasVideo) ...[
                    const SizedBox(height: TalantaSpacing.x3),
                    Container(
                      decoration: BoxDecoration(
                        color: palette.surface,
                        borderRadius: BorderRadius.circular(TalantaRadii.md),
                        border: Border.all(color: palette.outline),
                      ),
                      child: SwitchListTile(
                        key: const ValueKey('reel-switch'),
                        value: _isReel,
                        onChanged: (value) => setState(() => _isReel = value),
                        activeThumbColor: TalantaBrand.primary,
                        title: Text(
                          l10n.composeAsReel,
                          style: context.text.titleSmall,
                        ),
                        subtitle: Text(
                          l10n.composeAsReelHint,
                          style: context.text.bodySmall?.copyWith(
                            color: palette.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            _Toolbar(
              onPhotos: _pickPhotos,
              onCamera: _takePhoto,
              onVideo: () => _pickVideo(ImageSource.gallery),
              onRecord: () => _pickVideo(ImageSource.camera),
              photoCount: _hasVideo ? 0 : _media.length,
            ),
          ],
        ),
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.onPhotos,
    required this.onCamera,
    required this.onVideo,
    required this.onRecord,
    required this.photoCount,
  });

  final VoidCallback onPhotos;
  final VoidCallback onCamera;
  final VoidCallback onVideo;
  final VoidCallback onRecord;
  final int photoCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    Widget tool(
      Key key,
      IconData icon,
      String label,
      Color tone,
      VoidCallback onTap,
    ) => Expanded(
      child: InkWell(
        key: key,
        onTap: onTap,
        borderRadius: BorderRadius.circular(TalantaRadii.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: TalantaSpacing.x2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: tone),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.labelSmall?.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(top: BorderSide(color: palette.outline)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TalantaSpacing.x2,
            vertical: TalantaSpacing.x1,
          ),
          child: Row(
            children: [
              tool(
                const ValueKey('add-photos'),
                Icons.photo_library_rounded,
                photoCount > 0
                    ? l10n.composePhotosCount(photoCount, _maxPhotos)
                    : l10n.composePhotos,
                TalantaBrand.primary,
                onPhotos,
              ),
              tool(
                const ValueKey('take-photo'),
                Icons.photo_camera_rounded,
                l10n.composeCamera,
                TalantaBrand.gold,
                onCamera,
              ),
              tool(
                const ValueKey('add-video'),
                Icons.video_library_rounded,
                l10n.composeVideo,
                const Color(0xFF8B5CF6),
                onVideo,
              ),
              tool(
                const ValueKey('record-video'),
                Icons.videocam_rounded,
                l10n.composeRecord,
                palette.danger,
                onRecord,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoStrip extends StatelessWidget {
  const _PhotoStrip({
    required this.media,
    required this.onRemove,
    required this.onReorder,
  });

  final List<PickedMedia> media;
  final void Function(int index) onRemove;
  final void Function(int from, int to) onReorder;

  @override
  Widget build(BuildContext context) {
    if (media.length == 1) {
      return _Removable(
        onRemove: () => onRemove(0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(TalantaRadii.lg),
          child: Image.file(File(media.first.path), fit: BoxFit.cover),
        ),
      );
    }
    return SizedBox(
      height: 220,
      child: ReorderableListView.builder(
        scrollDirection: Axis.horizontal,
        buildDefaultDragHandles: false,
        itemCount: media.length,
        onReorder: onReorder,
        itemBuilder: (context, index) => ReorderableDelayedDragStartListener(
          key: ValueKey(media[index].path),
          index: index,
          child: Padding(
            padding: const EdgeInsets.only(right: TalantaSpacing.x2),
            child: _Removable(
              onRemove: () => onRemove(index),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(TalantaRadii.md),
                child: Image.file(
                  File(media[index].path),
                  width: 165,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Removable extends StatelessWidget {
  const _Removable({required this.child, required this.onRemove});

  final Widget child;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          top: 6,
          right: 6,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xAA000000),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The chosen video, playing silently so the person can check it.
class _VideoPreview extends StatefulWidget {
  const _VideoPreview({required this.path, required this.onRemove});

  final String path;
  final VoidCallback onRemove;

  @override
  State<_VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<_VideoPreview> {
  late final VideoPlayerController _controller = VideoPlayerController.file(
    File(widget.path),
  );
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    unawaited(_start());
  }

  Future<void> _start() async {
    try {
      await _controller.initialize();
      await _controller.setVolume(0);
      await _controller.setLooping(true);
      await _controller.play();
      if (mounted) setState(() => _ready = true);
    } on Object {
      // A preview that cannot play still lets the person post.
    }
  }

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return _Removable(
      onRemove: widget.onRemove,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(TalantaRadii.lg),
        child: SizedBox(
          height: 340,
          width: double.infinity,
          child: _ready
              ? FittedBox(
                  fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                )
              : ColoredBox(
                  color: palette.surfaceRaised,
                  child: Icon(
                    Icons.movie_rounded,
                    color: palette.textMuted,
                    size: 40,
                  ),
                ),
        ),
      ),
    );
  }
}
