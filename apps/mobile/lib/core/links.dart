import 'package:flutter/widgets.dart';
import 'package:talanta/core/widgets/talanta_snack.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens a portfolio or sponsor link in the app that owns it (YouTube,
/// TikTok...) or the browser. Only https links ever leave the app.
Future<void> openExternalLink(BuildContext context, String link) async {
  final uri = Uri.tryParse(link);
  final l10n = AppLocalizations.of(context);
  if (uri == null || uri.scheme != 'https') {
    TalantaSnack.show(context, l10n.errorLinkNotAllowed, error: true);
    return;
  }
  final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!opened && context.mounted) {
    TalantaSnack.show(context, l10n.errorLinkFailed, error: true);
  }
}
