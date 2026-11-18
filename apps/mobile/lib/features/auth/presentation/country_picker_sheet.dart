import 'package:flutter/material.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta/features/auth/domain/country.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// Picks one of the launch countries. Returns null when dismissed.
Future<Country?> showCountryPicker(
  BuildContext context, {
  required Country selected,
}) {
  return showModalBottomSheet<Country>(
    context: context,
    builder: (context) => _CountryPickerSheet(selected: selected),
  );
}

class _CountryPickerSheet extends StatelessWidget {
  const _CountryPickerSheet({required this.selected});

  final Country selected;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              TalantaSpacing.x5,
              TalantaSpacing.x2,
              TalantaSpacing.x5,
              TalantaSpacing.x3,
            ),
            child: Text(
              AppLocalizations.of(context).phoneCountryPickerTitle,
              style: context.text.headlineSmall,
            ),
          ),
          for (final country in Country.values)
            ListTile(
              key: ValueKey('country-${country.code}'),
              leading: Text(country.flag, style: const TextStyle(fontSize: 26)),
              title: Text(country.name),
              subtitle: Text(
                country.dialCode,
                style: TextStyle(color: palette.textMuted),
              ),
              trailing: country == selected
                  ? const Icon(Icons.check_rounded, color: TalantaBrand.primary)
                  : null,
              selected: country == selected,
              onTap: () => Navigator.of(context).pop(country),
            ),
          const SizedBox(height: TalantaSpacing.x2),
        ],
      ),
    );
  }
}
