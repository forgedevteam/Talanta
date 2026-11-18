import 'package:flutter/material.dart';

/// Maps the API's icon keys to glyphs. Placeholders until the illustrated set
/// arrives; unknown keys get a star so a new category never breaks the grid.
abstract final class TalentIcons {
  static const Map<String, IconData> _icons = {
    'music': Icons.music_note_rounded,
    'dance': Icons.directions_run_rounded,
    'acting': Icons.theater_comedy_rounded,
    'comedy': Icons.sentiment_very_satisfied_rounded,
    'art': Icons.palette_rounded,
    'crafts': Icons.handyman_rounded,
    'fashion': Icons.checkroom_rounded,
    'spoken-word': Icons.record_voice_over_rounded,
    'film': Icons.movie_creation_rounded,
    'photography': Icons.photo_camera_rounded,
    'writing': Icons.edit_note_rounded,
    'food': Icons.restaurant_rounded,
  };

  static IconData of(String key) => _icons[key] ?? Icons.star_rounded;
}
