import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Talanta'**
  String get appName;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Where Africa\'s talent lives'**
  String get splashTagline;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @phoneTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your number?'**
  String get phoneTitle;

  /// No description provided for @phoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll text you a code to sign in. No passwords to remember.'**
  String get phoneSubtitle;

  /// No description provided for @phoneFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneFieldLabel;

  /// No description provided for @phoneFieldHint.
  ///
  /// In en, this message translates to:
  /// **'0803 123 4567'**
  String get phoneFieldHint;

  /// No description provided for @phoneCountryPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your country'**
  String get phoneCountryPickerTitle;

  /// No description provided for @phoneLegal.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to the Talanta Terms and Privacy Policy.'**
  String get phoneLegal;

  /// No description provided for @phoneSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send me a code'**
  String get phoneSendCode;

  /// No description provided for @phoneErrorInvalid.
  ///
  /// In en, this message translates to:
  /// **'Check the number and try again.'**
  String get phoneErrorInvalid;

  /// No description provided for @phoneErrorCountryUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Talanta isn\'t in that country yet. We\'re working on it.'**
  String get phoneErrorCountryUnsupported;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your code'**
  String get otpTitle;

  /// No description provided for @otpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {phone}'**
  String otpSubtitle(String phone);

  /// No description provided for @otpResendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String otpResendIn(int seconds);

  /// No description provided for @otpResend.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get otpResend;

  /// No description provided for @otpChangeNumber.
  ///
  /// In en, this message translates to:
  /// **'Use a different number'**
  String get otpChangeNumber;

  /// No description provided for @otpSent.
  ///
  /// In en, this message translates to:
  /// **'A fresh code is on its way.'**
  String get otpSent;

  /// No description provided for @otpErrorInvalid.
  ///
  /// In en, this message translates to:
  /// **'That code isn\'t right. Have another look.'**
  String get otpErrorInvalid;

  /// No description provided for @otpErrorExpired.
  ///
  /// In en, this message translates to:
  /// **'That code has expired. Request a new one.'**
  String get otpErrorExpired;

  /// No description provided for @otpErrorTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many tries. Request a new code to continue.'**
  String get otpErrorTooManyAttempts;

  /// No description provided for @otpErrorResendTooSoon.
  ///
  /// In en, this message translates to:
  /// **'Give the last code a moment to arrive.'**
  String get otpErrorResendTooSoon;

  /// No description provided for @otpErrorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many codes requested. Take a break and try again later.'**
  String get otpErrorRateLimited;

  /// No description provided for @otpVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get otpVerify;

  /// No description provided for @talentsTitle.
  ///
  /// In en, this message translates to:
  /// **'What do you do?'**
  String get talentsTitle;

  /// No description provided for @talentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick up to {max}. Your first pick becomes your main talent. You can change these any time.'**
  String talentsSubtitle(int max);

  /// No description provided for @talentsSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Pick at least one} =1{1 picked} other{{count} picked}}'**
  String talentsSelectedCount(int count);

  /// No description provided for @talentsMain.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get talentsMain;

  /// No description provided for @talentsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load the talents list.'**
  String get talentsLoadFailed;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Make it yours'**
  String get profileTitle;

  /// No description provided for @profileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This is how people will find you on Talanta.'**
  String get profileSubtitle;

  /// No description provided for @profileAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get profileAddPhoto;

  /// No description provided for @profileChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get profileChangePhoto;

  /// No description provided for @profilePhotoLater.
  ///
  /// In en, this message translates to:
  /// **'Photo uploads land with the next release. Your pick stays on this phone until then.'**
  String get profilePhotoLater;

  /// No description provided for @profileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get profileNameLabel;

  /// No description provided for @profileNameHint.
  ///
  /// In en, this message translates to:
  /// **'Amara Okafor'**
  String get profileNameHint;

  /// No description provided for @profileUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get profileUsernameLabel;

  /// No description provided for @profileUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'amara_sings'**
  String get profileUsernameHint;

  /// No description provided for @profileUsernameHelp.
  ///
  /// In en, this message translates to:
  /// **'Letters, numbers and underscores. 3 to 24 characters.'**
  String get profileUsernameHelp;

  /// No description provided for @profileUsernameAvailable.
  ///
  /// In en, this message translates to:
  /// **'@{username} is yours'**
  String profileUsernameAvailable(String username);

  /// No description provided for @profileUsernameTaken.
  ///
  /// In en, this message translates to:
  /// **'Someone already has that one.'**
  String get profileUsernameTaken;

  /// No description provided for @profileUsernameReserved.
  ///
  /// In en, this message translates to:
  /// **'That name is reserved.'**
  String get profileUsernameReserved;

  /// No description provided for @profileCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get profileCityLabel;

  /// No description provided for @profileCityHint.
  ///
  /// In en, this message translates to:
  /// **'Lagos'**
  String get profileCityHint;

  /// No description provided for @profileFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get profileFinish;

  /// No description provided for @profileErrorNameLength.
  ///
  /// In en, this message translates to:
  /// **'Your name should be 2 to 50 characters.'**
  String get profileErrorNameLength;

  /// No description provided for @profileErrorUsernameFormat.
  ///
  /// In en, this message translates to:
  /// **'Use 3 to 24 letters, numbers or underscores.'**
  String get profileErrorUsernameFormat;

  /// No description provided for @profileErrorCity.
  ///
  /// In en, this message translates to:
  /// **'Tell us the city you create from.'**
  String get profileErrorCity;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String homeWelcome(String name);

  /// No description provided for @homeComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Your feed is on its way. Phase 1 brings video, challenges and discovery.'**
  String get homeComingSoon;

  /// No description provided for @homeSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get homeSignOut;

  /// No description provided for @errorOffline.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Check your connection and try again.'**
  String get errorOffline;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'That took too long. Check your connection and try again.'**
  String get errorTimeout;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our side. Try again in a moment.'**
  String get errorServer;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get errorUnknown;

  /// No description provided for @errorSessionEnded.
  ///
  /// In en, this message translates to:
  /// **'Your session ended. Sign in again.'**
  String get errorSessionEnded;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
