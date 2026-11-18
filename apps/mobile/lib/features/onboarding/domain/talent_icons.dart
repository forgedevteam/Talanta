import 'package:flutter/material.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';

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

/// Category names in the app's language, keyed by the stable slug. A slug the
/// app does not know yet falls back to the name the server sent.
abstract final class TalentNames {
  static String of(AppLocalizations l10n, String slug, String fallback) =>
      switch (slug) {
        'music' => l10n.talentMusic,
        'dance' => l10n.talentDance,
        'acting' => l10n.talentActing,
        'comedy' => l10n.talentComedy,
        'art' => l10n.talentArt,
        'crafts' => l10n.talentCrafts,
        'fashion' => l10n.talentFashion,
        'spoken-word' => l10n.talentSpokenWord,
        'film' => l10n.talentFilm,
        'photography' => l10n.talentPhotography,
        'writing' => l10n.talentWriting,
        'food' => l10n.talentFood,
        _ => fallback,
      };
}
