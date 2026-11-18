import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talanta/core/media/media.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// A person's picture, or their initials on a colour picked from the name
/// so each person looks the same everywhere.
class TalantaAvatar extends ConsumerWidget {
  const TalantaAvatar({
    required this.name,
    super.key,
    this.imageUrl,
    this.size = 44,
    this.verified = false,
    this.ring = false,
  });

  final String name;
  final String? imageUrl;
  final double size;
  final bool verified;

  /// An orange ring, for people with something new to see.
  final bool ring;

  static const _tones = [
    Color(0xFF6C2BD9),
    Color(0xFFA0521D),
    Color(0xFF1F7A63),
    Color(0xFF9B2C5E),
    Color(0xFF2E5AAC),
    Color(0xFFB4561F),
  ];

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final letters = parts.take(2).map((p) => p.characters.first.toUpperCase());
    return letters.isEmpty ? '?' : letters.join();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tone = _tones[name.hashCode.abs() % _tones.length];
    final initials = Container(
      alignment: Alignment.center,
      color: tone,
      child: Text(
        _initials,
        style: context.text.titleSmall?.copyWith(
          color: const Color(0xFFF7F5FA),
          fontSize: size * 0.36,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    final url = imageUrl;
    Widget face = ClipOval(
      child: SizedBox.square(
        dimension: size,
        child: url == null
            ? initials
            : Image(
                image: ref.watch(networkImageProvider)(url),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => initials,
                frameBuilder: (_, child, frame, wasSynchronous) =>
                    frame == null && !wasSynchronous ? initials : child,
              ),
      ),
    );
    if (ring) {
      face = Container(
        padding: const EdgeInsets.all(2.5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: TalantaBrand.primary,
        ),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.palette.background,
          ),
          child: face,
        ),
      );
    }

    return Semantics(
      label: name,
      image: true,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          face,
          if (verified)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                padding: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  color: context.palette.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.verified_rounded,
                  size: (size * 0.34).clamp(12, 22),
                  color: TalantaBrand.gold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
