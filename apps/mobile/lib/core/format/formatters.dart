import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';

/// Money and time, written the way people in the launch markets write them.
abstract final class Formatters {
  static String _locale(BuildContext context) =>
      Localizations.localeOf(context).toLanguageTag();

  /// "150 000 FCFA" for XAF; "₦50,000" style elsewhere.
  static String money(BuildContext context, num amount, String currency) {
    final locale = _locale(context);
    if (currency == 'XAF' || currency == 'XOF') {
      final digits = NumberFormat.decimalPattern(locale).format(amount);
      return '$digits FCFA';
    }
    return NumberFormat.simpleCurrency(
      locale: locale,
      name: currency,
      decimalDigits: 0,
    ).format(amount);
  }

  /// "14 déc." or "Dec 14".
  static String shortDate(BuildContext context, DateTime date) =>
      DateFormat.MMMd(_locale(context)).format(date);

  /// A `YYYY-MM-DD` calendar date from the API.
  static String calendarDate(BuildContext context, String isoDate) {
    final parsed = DateTime.tryParse(isoDate);
    return parsed == null ? isoDate : shortDate(context, parsed);
  }

  /// "now", "5 min", "3 h", "2 d", then a date.
  static String ago(BuildContext context, DateTime moment, DateTime now) {
    final l10n = AppLocalizations.of(context);
    final elapsed = now.difference(moment);
    if (elapsed.inMinutes < 1) return l10n.timeJustNow;
    if (elapsed.inHours < 1) return l10n.timeMinutes(elapsed.inMinutes);
    if (elapsed.inDays < 1) return l10n.timeHours(elapsed.inHours);
    if (elapsed.inDays < 7) return l10n.timeDays(elapsed.inDays);
    return shortDate(context, moment.toLocal());
  }
}
