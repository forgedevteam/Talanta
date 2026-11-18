// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Talanta';

  @override
  String get splashTagline => 'Where Africa\'s talent lives';

  @override
  String get continueLabel => 'Continue';

  @override
  String get retry => 'Try again';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get back => 'Back';

  @override
  String get phoneTitle => 'What\'s your number?';

  @override
  String get phoneSubtitle =>
      'We\'ll text you a code to sign in. No passwords to remember.';

  @override
  String get phoneFieldLabel => 'Phone number';

  @override
  String get phoneFieldHint => '0803 123 4567';

  @override
  String get phoneCountryPickerTitle => 'Choose your country';

  @override
  String get phoneLegal =>
      'By continuing you agree to the Talanta Terms and Privacy Policy.';

  @override
  String get phoneSendCode => 'Send me a code';

  @override
  String get phoneErrorInvalid => 'Check the number and try again.';

  @override
  String get phoneErrorEmpty => 'Enter your phone number.';

  @override
  String get phoneErrorCountryUnsupported =>
      'Talanta isn\'t in that country yet. We\'re working on it.';

  @override
  String get otpTitle => 'Enter your code';

  @override
  String otpSubtitle(String phone) {
    return 'We sent a 6-digit code to $phone';
  }

  @override
  String otpResendIn(int seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get otpResend => 'Resend code';

  @override
  String get otpChangeNumber => 'Use a different number';

  @override
  String get otpSent => 'A fresh code is on its way.';

  @override
  String get otpErrorInvalid => 'That code isn\'t right. Have another look.';

  @override
  String get otpErrorExpired => 'That code has expired. Request a new one.';

  @override
  String get otpErrorTooManyAttempts =>
      'Too many tries. Request a new code to continue.';

  @override
  String get otpErrorResendTooSoon => 'Give the last code a moment to arrive.';

  @override
  String get otpErrorRateLimited =>
      'Too many codes requested. Take a break and try again later.';

  @override
  String get otpVerify => 'Verify';

  @override
  String get talentsTitle => 'What do you do?';

  @override
  String talentsSubtitle(int max) {
    return 'Pick up to $max. Your first pick becomes your main talent. You can change these any time.';
  }

  @override
  String talentsSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count picked',
      one: '1 picked',
      zero: 'Pick at least one',
    );
    return '$_temp0';
  }

  @override
  String get talentsMain => 'Main';

  @override
  String get talentsLoadFailed => 'We couldn\'t load the talents list.';

  @override
  String get talentMusic => 'Music';

  @override
  String get talentDance => 'Dance';

  @override
  String get talentActing => 'Acting';

  @override
  String get talentComedy => 'Comedy';

  @override
  String get talentArt => 'Art';

  @override
  String get talentCrafts => 'Crafts';

  @override
  String get talentFashion => 'Fashion';

  @override
  String get talentSpokenWord => 'Spoken word';

  @override
  String get talentFilm => 'Film';

  @override
  String get talentPhotography => 'Photography';

  @override
  String get talentWriting => 'Writing';

  @override
  String get talentFood => 'Food';

  @override
  String get profileTitle => 'Make it yours';

  @override
  String get profileSubtitle => 'This is how people will find you on Talanta.';

  @override
  String get profileAddPhoto => 'Add photo';

  @override
  String get profileChangePhoto => 'Change photo';

  @override
  String get profilePhotoLater =>
      'Photo uploads land with the next release. Your pick stays on this phone until then.';

  @override
  String get profileNameLabel => 'Your name';

  @override
  String get profileNameHint => 'Your full name';

  @override
  String get profileUsernameLabel => 'Username';

  @override
  String get profileUsernameHint => 'yourname';

  @override
  String get profileUsernameHelp =>
      'Letters, numbers and underscores. 3 to 24 characters.';

  @override
  String profileUsernameAvailable(String username) {
    return '@$username is available';
  }

  @override
  String get profileUsernameTaken => 'Someone already has that one.';

  @override
  String get profileUsernameReserved => 'That name is reserved.';

  @override
  String get profileCityLabel => 'City';

  @override
  String get profileDobLabel => 'Date of birth';

  @override
  String get profileDobHint => 'Choose your date of birth';

  @override
  String get profileDobHelp =>
      'Keeps younger members safe. Never shown on your profile.';

  @override
  String get profileErrorDob => 'Enter your date of birth.';

  @override
  String get profileErrorTooYoung =>
      'Talanta isn\'t open to your age yet. We can\'t wait to see your talent when you\'re older.';

  @override
  String get profileFinish => 'Finish';

  @override
  String get profileErrorNameLength =>
      'Your name should be 2 to 50 characters.';

  @override
  String get profileErrorNameEmpty => 'Enter your name.';

  @override
  String get profileErrorUsernameEmpty => 'Choose a username.';

  @override
  String get profileErrorUsernameFormat =>
      'Use 3 to 24 letters, numbers or underscores.';

  @override
  String get profileErrorCity => 'Tell us the city you create from.';

  @override
  String homeWelcome(String name) {
    return 'Welcome, $name';
  }

  @override
  String get homeComingSoon =>
      'Your feed is on its way. Phase 1 brings video, challenges and discovery.';

  @override
  String get homeSignOut => 'Sign out';

  @override
  String get errorOffline =>
      'You\'re offline. Check your connection and try again.';

  @override
  String get errorTimeout =>
      'That took too long. Check your connection and try again.';

  @override
  String get errorServer =>
      'Something went wrong on our side. Try again in a moment.';

  @override
  String get errorUnknown => 'Something went wrong. Try again.';

  @override
  String get errorSessionEnded => 'Your session ended. Sign in again.';
}
