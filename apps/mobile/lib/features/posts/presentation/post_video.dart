import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talanta/core/media/media.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_tokens/talanta_tokens.dart';
import 'package:video_player/video_player.dart';

/// Makes players. Tests replace it, since real playback needs a device.
final videoControllerFactoryProvider =
    Provider<VideoPlayerController Function(String url)>(
      (ref) =>
          (url) => VideoPlayerController.networkUrl(
            Uri.parse(resolveMediaUrl(url)),
            videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
          ),
    );

/// A video in the feed. Nothing downloads until it is tapped, which keeps
/// scrolling cheap on mobile data.
class FeedVideo extends ConsumerStatefulWidget {
  const FeedVideo({required this.url, super.key, this.onDoubleTap});

  final String url;
  final VoidCallback? onDoubleTap;

  @override
  ConsumerState<FeedVideo> createState() => _FeedVideoState();
}

class _FeedVideoState extends ConsumerState<FeedVideo> {
  VideoPlayerController? _controller;
  bool _starting = false;
  bool _failed = false;
  bool _muted = false;

  @override
  void dispose() {
    unawaited(_controller?.dispose());
    super.dispose();
  }

  Future<void> _toggle() async {
    final controller = _controller;
    if (controller != null) {
      if (controller.value.isPlaying) {
        await controller.pause();
      } else {
        await controller.play();
      }
      if (mounted) setState(() {});
      return;
    }
    setState(() {
      _starting = true;
      _failed = false;
    });
    final created = ref.read(videoControllerFactoryProvider)(widget.url);
    try {
      await created.initialize();
      await created.setLooping(true);
      await created.play();
      if (!mounted) {
        await created.dispose();
        return;
      }
      setState(() {
        _controller = created;
        _starting = false;
      });
    } on Object {
      await created.dispose();
      if (mounted) {
        setState(() {
          _starting = false;
          _failed = true;
        });
      }
    }
  }

  Future<void> _toggleMute() async {
    final controller = _controller;
    if (controller == null) return;
    _muted = !_muted;
    await controller.setVolume(_muted ? 0 : 1);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = _controller;
    final ready = controller != null && controller.value.isInitialized;
    // Feed videos sit between square and 4:5; taller ones are cropped.
    final aspect = ready
        ? controller.value.aspectRatio.clamp(0.8, 1.91)
        : 4 / 5;

    return GestureDetector(
      onTap: _toggle,
      onDoubleTap: widget.onDoubleTap,
      child: AspectRatio(
        aspectRatio: aspect,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (ready)
              ClipRect(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller.value.size.width,
                    height: controller.value.size.height,
                    child: VideoPlayer(controller),
                  ),
                ),
              )
            else
              const _VideoPoster(),
            if (!ready || !controller.value.isPlaying)
              Center(
                child: _starting
                    ? const SizedBox.square(
                        dimension: 36,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      )
                    : _RoundButton(
                        icon: _failed
                            ? Icons.refresh_rounded
                            : Icons.play_arrow_rounded,
                        label: _failed ? l10n.videoRetry : l10n.videoPlay,
                        size: 58,
                      ),
              ),
            if (ready) ...[
              Positioned(
                right: TalantaSpacing.x3,
                bottom: TalantaSpacing.x3,
                child: GestureDetector(
                  onTap: _toggleMute,
                  child: _RoundButton(
                    icon: _muted
                        ? Icons.volume_off_rounded
                        : Icons.volume_up_rounded,
                    label: _muted ? l10n.videoUnmute : l10n.videoMute,
                    size: 32,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: VideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                  padding: EdgeInsets.zero,
                  colors: const VideoProgressColors(
                    playedColor: TalantaBrand.primary,
                    bufferedColor: Color(0x55FFFFFF),
                    backgroundColor: Color(0x22FFFFFF),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A full-screen reel. Plays while it is the page in view, loops, and
/// pauses on tap.
class ReelVideo extends ConsumerStatefulWidget {
  const ReelVideo({
    required this.url,
    required this.active,
    super.key,
    this.onDoubleTap,
  });

  final String url;
  final bool active;
  final VoidCallback? onDoubleTap;

  @override
  ConsumerState<ReelVideo> createState() => _ReelVideoState();
}

class _ReelVideoState extends ConsumerState<ReelVideo> {
  VideoPlayerController? _controller;
  bool _failed = false;
  bool _pausedByTap = false;

  @override
  void initState() {
    super.initState();
    if (widget.active) unawaited(_start());
  }

  @override
  void didUpdateWidget(ReelVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active == oldWidget.active) return;
    if (widget.active) {
      _pausedByTap = false;
      if (_controller == null) {
        unawaited(_start());
      } else {
        unawaited(_controller!.play());
      }
    } else {
      unawaited(_controller?.pause());
    }
  }

  @override
  void dispose() {
    unawaited(_controller?.dispose());
    super.dispose();
  }

  Future<void> _start() async {
    final created = ref.read(videoControllerFactoryProvider)(widget.url);
    try {
      await created.initialize();
      await created.setLooping(true);
      if (!mounted) {
        await created.dispose();
        return;
      }
      if (widget.active) await created.play();
      setState(() {
        _controller = created;
        _failed = false;
      });
    } on Object {
      await created.dispose();
      if (mounted) setState(() => _failed = true);
    }
  }

  Future<void> _toggle() async {
    final controller = _controller;
    if (controller == null) {
      if (_failed) await _start();
      return;
    }
    if (controller.value.isPlaying) {
      await controller.pause();
      _pausedByTap = true;
    } else {
      await controller.play();
      _pausedByTap = false;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = _controller;
    final ready = controller != null && controller.value.isInitialized;
    return GestureDetector(
      onTap: _toggle,
      onDoubleTap: widget.onDoubleTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (ready)
            FittedBox(
              fit: BoxFit.cover,
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: VideoPlayer(controller),
              ),
            )
          else
            const _VideoPoster(),
          if (!ready && !_failed)
            const Center(
              child: SizedBox.square(
                dimension: 36,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            ),
          if (_failed)
            Center(
              child: _RoundButton(
                icon: Icons.refresh_rounded,
                label: l10n.videoRetry,
                size: 58,
              ),
            ),
          if (ready && _pausedByTap)
            Center(
              child: _RoundButton(
                icon: Icons.play_arrow_rounded,
                label: l10n.videoPlay,
                size: 64,
              ),
            ),
          if (ready)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: VideoProgressIndicator(
                controller,
                allowScrubbing: true,
                padding: EdgeInsets.zero,
                colors: const VideoProgressColors(
                  playedColor: TalantaBrand.primary,
                  bufferedColor: Color(0x44FFFFFF),
                  backgroundColor: Color(0x22FFFFFF),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Shown until a video's first frame arrives.
class _VideoPoster extends StatelessWidget {
  const _VideoPoster();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: 1.1,
          colors: [
            TalantaBrand.secondary.withValues(alpha: 0.55),
            context.palette.background,
          ],
        ),
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.label,
    required this.size,
  });

  final IconData icon;
  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0x66000000),
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.6),
      ),
    );
  }
}
