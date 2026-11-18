import 'package:flutter/material.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// Initials on a colour picked from the name, so each person looks the same
/// everywhere. Stands in for photos until uploads arrive.
class TalantaAvatar extends StatelessWidget {
  const TalantaAvatar({
    required this.name,
    super.key,
    this.size = 44,
    this.verified = false,
  });

  final String name;
  final double size;
  final bool verified;

  static const _tones = [
    TalantaBrand.primary,
    TalantaBrand.secondary,
    Color(0xFF1F9E8A),
    Color(0xFFC2410C),
    Color(0xFF2563EB),
    Color(0xFFB4236B),
  ];

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final letters = parts.take(2).map((p) => p.characters.first.toUpperCase());
    return letters.isEmpty ? '?' : letters.join();
  }

  @override
  Widget build(BuildContext context) {
    final tone = _tones[name.hashCode.abs() % _tones.length];
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tone.withValues(alpha: 0.22),
              border: Border.all(color: tone.withValues(alpha: 0.6)),
            ),
            child: Text(
              _initials,
              style: context.text.titleSmall?.copyWith(
                color: context.palette.text,
                fontSize: size * 0.36,
              ),
            ),
          ),
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
                  size: size * 0.34,
                  color: TalantaBrand.gold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
