import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

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

  /// No description provided for @phoneErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number.'**
  String get phoneErrorEmpty;

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

  /// No description provided for @talentMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get talentMusic;

  /// No description provided for @talentDance.
  ///
  /// In en, this message translates to:
  /// **'Dance'**
  String get talentDance;

  /// No description provided for @talentActing.
  ///
  /// In en, this message translates to:
  /// **'Acting'**
  String get talentActing;

  /// No description provided for @talentComedy.
  ///
  /// In en, this message translates to:
  /// **'Comedy'**
  String get talentComedy;

  /// No description provided for @talentArt.
  ///
  /// In en, this message translates to:
  /// **'Art'**
  String get talentArt;

  /// No description provided for @talentCrafts.
  ///
  /// In en, this message translates to:
  /// **'Crafts'**
  String get talentCrafts;

  /// No description provided for @talentFashion.
  ///
  /// In en, this message translates to:
  /// **'Fashion'**
  String get talentFashion;

  /// No description provided for @talentSpokenWord.
  ///
  /// In en, this message translates to:
  /// **'Spoken word'**
  String get talentSpokenWord;

  /// No description provided for @talentFilm.
  ///
  /// In en, this message translates to:
  /// **'Film'**
  String get talentFilm;

  /// No description provided for @talentPhotography.
  ///
  /// In en, this message translates to:
  /// **'Photography'**
  String get talentPhotography;

  /// No description provided for @talentWriting.
  ///
  /// In en, this message translates to:
  /// **'Writing'**
  String get talentWriting;

  /// No description provided for @talentFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get talentFood;

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

  /// No description provided for @profileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get profileNameLabel;

  /// No description provided for @profileNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your full name'**
  String get profileNameHint;

  /// No description provided for @profileUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get profileUsernameLabel;

  /// No description provided for @profileUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'yourname'**
  String get profileUsernameHint;

  /// No description provided for @profileUsernameHelp.
  ///
  /// In en, this message translates to:
  /// **'Letters, numbers and underscores. 3 to 24 characters.'**
  String get profileUsernameHelp;

  /// No description provided for @profileUsernameAvailable.
  ///
  /// In en, this message translates to:
  /// **'@{username} is available'**
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

  /// No description provided for @profileDobLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get profileDobLabel;

  /// No description provided for @profileDobHint.
  ///
  /// In en, this message translates to:
  /// **'Choose your date of birth'**
  String get profileDobHint;

  /// No description provided for @profileDobHelp.
  ///
  /// In en, this message translates to:
  /// **'Keeps younger members safe. Never shown on your profile.'**
  String get profileDobHelp;

  /// No description provided for @profileErrorDob.
  ///
  /// In en, this message translates to:
  /// **'Enter your date of birth.'**
  String get profileErrorDob;

  /// No description provided for @profileErrorTooYoung.
  ///
  /// In en, this message translates to:
  /// **'Talanta isn\'t open to your age yet. We can\'t wait to see your talent when you\'re older.'**
  String get profileErrorTooYoung;

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

  /// No description provided for @profileErrorNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter your name.'**
  String get profileErrorNameEmpty;

  /// No description provided for @profileErrorUsernameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Choose a username.'**
  String get profileErrorUsernameEmpty;

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

  /// No description provided for @navCalls.
  ///
  /// In en, this message translates to:
  /// **'Open Calls'**
  String get navCalls;

  /// No description provided for @navDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get navDiscover;

  /// No description provided for @navActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get navActivity;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get timeJustNow;

  /// No description provided for @timeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String timeMinutes(int count);

  /// No description provided for @timeHours.
  ///
  /// In en, this message translates to:
  /// **'{count} h'**
  String timeHours(int count);

  /// No description provided for @timeDays.
  ///
  /// In en, this message translates to:
  /// **'{count} d'**
  String timeDays(int count);

  /// No description provided for @callsTitle.
  ///
  /// In en, this message translates to:
  /// **'Open Calls'**
  String get callsTitle;

  /// No description provided for @callsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Paid gigs, castings and auditions near you.'**
  String get callsSubtitle;

  /// No description provided for @callsAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get callsAll;

  /// No description provided for @callsFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get callsFeatured;

  /// No description provided for @callsSponsored.
  ///
  /// In en, this message translates to:
  /// **'Sponsored'**
  String get callsSponsored;

  /// No description provided for @callsLatest.
  ///
  /// In en, this message translates to:
  /// **'Latest calls'**
  String get callsLatest;

  /// No description provided for @callsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No calls here yet'**
  String get callsEmpty;

  /// No description provided for @callsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'New calls arrive every week. Check back soon, or post your own.'**
  String get callsEmptyBody;

  /// No description provided for @callsPost.
  ///
  /// In en, this message translates to:
  /// **'Post a call'**
  String get callsPost;

  /// No description provided for @callsApplicants.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No applicants yet} =1{1 applicant} other{{count} applicants}}'**
  String callsApplicants(int count);

  /// No description provided for @callsUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get callsUnpaid;

  /// No description provided for @callsNegotiable.
  ///
  /// In en, this message translates to:
  /// **'Pay to discuss'**
  String get callsNegotiable;

  /// No description provided for @callsCloses.
  ///
  /// In en, this message translates to:
  /// **'Closes {date}'**
  String callsCloses(String date);

  /// No description provided for @callsClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get callsClosed;

  /// No description provided for @callAbout.
  ///
  /// In en, this message translates to:
  /// **'About the work'**
  String get callAbout;

  /// No description provided for @callPostedBy.
  ///
  /// In en, this message translates to:
  /// **'Posted by'**
  String get callPostedBy;

  /// No description provided for @callSafety.
  ///
  /// In en, this message translates to:
  /// **'Talanta never asks you to pay to apply. If anyone asks you for money, report them.'**
  String get callSafety;

  /// No description provided for @callApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get callApply;

  /// No description provided for @callYourApplication.
  ///
  /// In en, this message translates to:
  /// **'Your application'**
  String get callYourApplication;

  /// No description provided for @callViewApplicants.
  ///
  /// In en, this message translates to:
  /// **'See applicants ({count})'**
  String callViewApplicants(int count);

  /// No description provided for @callClose.
  ///
  /// In en, this message translates to:
  /// **'Close this call'**
  String get callClose;

  /// No description provided for @callCloseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Stop taking applications? You cannot reopen it.'**
  String get callCloseConfirm;

  /// No description provided for @callReport.
  ///
  /// In en, this message translates to:
  /// **'Report this call'**
  String get callReport;

  /// No description provided for @callIsClosed.
  ///
  /// In en, this message translates to:
  /// **'This call is closed.'**
  String get callIsClosed;

  /// No description provided for @statusSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get statusSubmitted;

  /// No description provided for @statusShortlisted.
  ///
  /// In en, this message translates to:
  /// **'Shortlisted'**
  String get statusShortlisted;

  /// No description provided for @statusDeclined.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get statusDeclined;

  /// No description provided for @statusHired.
  ///
  /// In en, this message translates to:
  /// **'Hired'**
  String get statusHired;

  /// No description provided for @applyTitle.
  ///
  /// In en, this message translates to:
  /// **'Apply to this call'**
  String get applyTitle;

  /// No description provided for @applyMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get applyMessageLabel;

  /// No description provided for @applyMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Why you\'re right for it, and when you\'re free.'**
  String get applyMessageHint;

  /// No description provided for @applyAttach.
  ///
  /// In en, this message translates to:
  /// **'Show a piece of your work'**
  String get applyAttach;

  /// No description provided for @applyNoPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Add work to your profile to show it here.'**
  String get applyNoPortfolio;

  /// No description provided for @applyNone.
  ///
  /// In en, this message translates to:
  /// **'No attachment'**
  String get applyNone;

  /// No description provided for @applySend.
  ///
  /// In en, this message translates to:
  /// **'Send application'**
  String get applySend;

  /// No description provided for @applySent.
  ///
  /// In en, this message translates to:
  /// **'Application sent. Good luck!'**
  String get applySent;

  /// No description provided for @applyMessageTooShort.
  ///
  /// In en, this message translates to:
  /// **'Write at least 10 characters.'**
  String get applyMessageTooShort;

  /// No description provided for @postTitle.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get postTitle;

  /// No description provided for @postSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Describe the work clearly. Real calls get real talent.'**
  String get postSubtitle;

  /// No description provided for @postTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get postTitleLabel;

  /// No description provided for @postTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Singer for a wedding in Douala'**
  String get postTitleHint;

  /// No description provided for @postTalentLabel.
  ///
  /// In en, this message translates to:
  /// **'Talent you need'**
  String get postTalentLabel;

  /// No description provided for @postCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get postCityLabel;

  /// No description provided for @postDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Describe the work'**
  String get postDescriptionLabel;

  /// No description provided for @postDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Date, place, what you need and what you provide.'**
  String get postDescriptionHint;

  /// No description provided for @postPayLabel.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get postPayLabel;

  /// No description provided for @postPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get postPaid;

  /// No description provided for @postNegotiable.
  ///
  /// In en, this message translates to:
  /// **'To discuss'**
  String get postNegotiable;

  /// No description provided for @postUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get postUnpaid;

  /// No description provided for @postAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount (FCFA)'**
  String get postAmountLabel;

  /// No description provided for @postDeadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Closing date (optional)'**
  String get postDeadlineLabel;

  /// No description provided for @postDeadlineHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a date'**
  String get postDeadlineHint;

  /// No description provided for @postSubmit.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get postSubmit;

  /// No description provided for @postPublished.
  ///
  /// In en, this message translates to:
  /// **'Your call is live.'**
  String get postPublished;

  /// No description provided for @postErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Use 5 to 100 characters.'**
  String get postErrorTitle;

  /// No description provided for @postErrorDescription.
  ///
  /// In en, this message translates to:
  /// **'Write at least 20 characters.'**
  String get postErrorDescription;

  /// No description provided for @postErrorAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount you\'ll pay.'**
  String get postErrorAmount;

  /// No description provided for @postErrorTalent.
  ///
  /// In en, this message translates to:
  /// **'Choose a talent.'**
  String get postErrorTalent;

  /// No description provided for @applicantsTitle.
  ///
  /// In en, this message translates to:
  /// **'Applicants'**
  String get applicantsTitle;

  /// No description provided for @applicantsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No applications yet'**
  String get applicantsEmpty;

  /// No description provided for @applicantsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Applications appear here as soon as they arrive.'**
  String get applicantsEmptyBody;

  /// No description provided for @actionShortlist.
  ///
  /// In en, this message translates to:
  /// **'Shortlist'**
  String get actionShortlist;

  /// No description provided for @actionDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get actionDecline;

  /// No description provided for @actionHire.
  ///
  /// In en, this message translates to:
  /// **'Hire'**
  String get actionHire;

  /// No description provided for @viewWork.
  ///
  /// In en, this message translates to:
  /// **'View work'**
  String get viewWork;

  /// No description provided for @myCallsTitle.
  ///
  /// In en, this message translates to:
  /// **'My calls'**
  String get myCallsTitle;

  /// No description provided for @myCallsEmpty.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t posted a call yet.'**
  String get myCallsEmpty;

  /// No description provided for @discoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discoverTitle;

  /// No description provided for @discoverSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search creators'**
  String get discoverSearchHint;

  /// No description provided for @discoverCreators.
  ///
  /// In en, this message translates to:
  /// **'Creators'**
  String get discoverCreators;

  /// No description provided for @discoverFollowing.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get discoverFollowing;

  /// No description provided for @discoverEmpty.
  ///
  /// In en, this message translates to:
  /// **'No one matches yet'**
  String get discoverEmpty;

  /// No description provided for @followingEmpty.
  ///
  /// In en, this message translates to:
  /// **'Follow creators to see their new work here.'**
  String get followingEmpty;

  /// No description provided for @followersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 follower} other{{count} followers}}'**
  String followersCount(int count);

  /// No description provided for @followingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} following'**
  String followingCount(int count);

  /// No description provided for @worksCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 piece} other{{count} pieces}}'**
  String worksCount(int count);

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @followingButton.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get followingButton;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @portfolioTitle.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get portfolioTitle;

  /// No description provided for @portfolioEmpty.
  ///
  /// In en, this message translates to:
  /// **'No work yet.'**
  String get portfolioEmpty;

  /// No description provided for @portfolioEmptyMine.
  ///
  /// In en, this message translates to:
  /// **'Add links to your best work on YouTube, TikTok, Audiomack and more.'**
  String get portfolioEmptyMine;

  /// No description provided for @portfolioAdd.
  ///
  /// In en, this message translates to:
  /// **'Add work'**
  String get portfolioAdd;

  /// No description provided for @portfolioTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get portfolioTitleLabel;

  /// No description provided for @portfolioTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Live at Institut Français'**
  String get portfolioTitleHint;

  /// No description provided for @portfolioLinkLabel.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get portfolioLinkLabel;

  /// No description provided for @portfolioLinkHelp.
  ///
  /// In en, this message translates to:
  /// **'Paste the link from YouTube, TikTok, Instagram, Audiomack or Boomplay.'**
  String get portfolioLinkHelp;

  /// No description provided for @portfolioSave.
  ///
  /// In en, this message translates to:
  /// **'Add to portfolio'**
  String get portfolioSave;

  /// No description provided for @portfolioAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to your portfolio.'**
  String get portfolioAdded;

  /// No description provided for @portfolioRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove this piece from your portfolio?'**
  String get portfolioRemoveConfirm;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @portfolioErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Give it a title of 2 to 80 characters.'**
  String get portfolioErrorTitle;

  /// No description provided for @reportUser.
  ///
  /// In en, this message translates to:
  /// **'Report this person'**
  String get reportUser;

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s wrong?'**
  String get reportTitle;

  /// No description provided for @reasonScam.
  ///
  /// In en, this message translates to:
  /// **'Scam, or asks for money'**
  String get reasonScam;

  /// No description provided for @reasonHarassment.
  ///
  /// In en, this message translates to:
  /// **'Harassment'**
  String get reasonHarassment;

  /// No description provided for @reasonInappropriate.
  ///
  /// In en, this message translates to:
  /// **'Inappropriate content'**
  String get reasonInappropriate;

  /// No description provided for @reasonSpam.
  ///
  /// In en, this message translates to:
  /// **'Spam'**
  String get reasonSpam;

  /// No description provided for @reasonUnderage.
  ///
  /// In en, this message translates to:
  /// **'Involves a minor'**
  String get reasonUnderage;

  /// No description provided for @reasonOther.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get reasonOther;

  /// No description provided for @reportThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks. Our team will look into it.'**
  String get reportThanks;

  /// No description provided for @profileMenuCalls.
  ///
  /// In en, this message translates to:
  /// **'My calls'**
  String get profileMenuCalls;

  /// No description provided for @profileMenuEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileMenuEdit;

  /// No description provided for @profileMenuTalents.
  ///
  /// In en, this message translates to:
  /// **'Edit talents'**
  String get profileMenuTalents;

  /// No description provided for @profileMenuDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get profileMenuDelete;

  /// No description provided for @deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get deleteTitle;

  /// No description provided for @deleteBody.
  ///
  /// In en, this message translates to:
  /// **'Your profile, portfolio and calls are removed and you\'re signed out everywhere. This can\'t be undone.'**
  String get deleteBody;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteConfirm;

  /// No description provided for @activityTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activityTitle;

  /// No description provided for @activityNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get activityNotifications;

  /// No description provided for @activityApplications.
  ///
  /// In en, this message translates to:
  /// **'My applications'**
  String get activityApplications;

  /// No description provided for @activityEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing new yet'**
  String get activityEmpty;

  /// No description provided for @activityEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Applications, decisions and new followers show up here.'**
  String get activityEmptyBody;

  /// No description provided for @applicationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t applied to a call yet'**
  String get applicationsEmpty;

  /// No description provided for @applicationsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Find a call that fits you and apply in a minute.'**
  String get applicationsEmptyBody;

  /// No description provided for @browseCalls.
  ///
  /// In en, this message translates to:
  /// **'Browse calls'**
  String get browseCalls;

  /// No description provided for @someone.
  ///
  /// In en, this message translates to:
  /// **'Someone'**
  String get someone;

  /// No description provided for @notifApplicationReceived.
  ///
  /// In en, this message translates to:
  /// **'{name} applied to “{title}”'**
  String notifApplicationReceived(String name, String title);

  /// No description provided for @notifShortlisted.
  ///
  /// In en, this message translates to:
  /// **'You\'re shortlisted for “{title}”'**
  String notifShortlisted(String title);

  /// No description provided for @notifHired.
  ///
  /// In en, this message translates to:
  /// **'You got the job: “{title}”'**
  String notifHired(String title);

  /// No description provided for @notifDeclined.
  ///
  /// In en, this message translates to:
  /// **'“{title}”: not selected this time'**
  String notifDeclined(String title);

  /// No description provided for @notifUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update on “{title}”'**
  String notifUpdate(String title);

  /// No description provided for @notifNewFollower.
  ///
  /// In en, this message translates to:
  /// **'{name} started following you'**
  String notifNewFollower(String name);

  /// No description provided for @errorAdultsOnly.
  ///
  /// In en, this message translates to:
  /// **'Open Calls are for people 18 and over.'**
  String get errorAdultsOnly;

  /// No description provided for @errorProfileRequired.
  ///
  /// In en, this message translates to:
  /// **'Finish your profile first.'**
  String get errorProfileRequired;

  /// No description provided for @errorAlreadyApplied.
  ///
  /// In en, this message translates to:
  /// **'You\'ve already applied.'**
  String get errorAlreadyApplied;

  /// No description provided for @errorCallClosed.
  ///
  /// In en, this message translates to:
  /// **'This call is closed.'**
  String get errorCallClosed;

  /// No description provided for @errorLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the limit.'**
  String get errorLimitReached;

  /// No description provided for @errorLinkNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Paste a full link starting with https://'**
  String get errorLinkNotAllowed;

  /// No description provided for @errorLinkFailed.
  ///
  /// In en, this message translates to:
  /// **'That link couldn\'t be opened.'**
  String get errorLinkFailed;

  /// No description provided for @errorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'You\'ve done that a lot today. Try again later.'**
  String get errorRateLimited;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'This is no longer available.'**
  String get errorNotFound;

  /// No description provided for @errorCannotApplyOwn.
  ///
  /// In en, this message translates to:
  /// **'You posted this call.'**
  String get errorCannotApplyOwn;

  /// No description provided for @portfolioTalentLabel.
  ///
  /// In en, this message translates to:
  /// **'Which talent does it show? (optional)'**
  String get portfolioTalentLabel;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navReels.
  ///
  /// In en, this message translates to:
  /// **'Reels'**
  String get navReels;

  /// No description provided for @openMyProfile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get openMyProfile;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get errorGeneric;

  /// No description provided for @createTitle.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createTitle;

  /// No description provided for @createPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get createPhoto;

  /// No description provided for @createPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Up to 10 photos'**
  String get createPhotoHint;

  /// No description provided for @createReel.
  ///
  /// In en, this message translates to:
  /// **'Reel'**
  String get createReel;

  /// No description provided for @createReelHint.
  ///
  /// In en, this message translates to:
  /// **'A short vertical video'**
  String get createReelHint;

  /// No description provided for @createText.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get createText;

  /// No description provided for @createTextHint.
  ///
  /// In en, this message translates to:
  /// **'Share news or an idea'**
  String get createTextHint;

  /// No description provided for @createCall.
  ///
  /// In en, this message translates to:
  /// **'Open Call'**
  String get createCall;

  /// No description provided for @createCallHint.
  ///
  /// In en, this message translates to:
  /// **'Hire talent for paid work'**
  String get createCallHint;

  /// No description provided for @composeTitle.
  ///
  /// In en, this message translates to:
  /// **'New post'**
  String get composeTitle;

  /// No description provided for @composeReelTitle.
  ///
  /// In en, this message translates to:
  /// **'New reel'**
  String get composeReelTitle;

  /// No description provided for @composePost.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get composePost;

  /// No description provided for @composeHint.
  ///
  /// In en, this message translates to:
  /// **'What\'s happening in your craft?'**
  String get composeHint;

  /// No description provided for @composeCaptionHint.
  ///
  /// In en, this message translates to:
  /// **'Write a caption… #makossa @friend'**
  String get composeCaptionHint;

  /// No description provided for @composePhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get composePhotos;

  /// No description provided for @composePhotosCount.
  ///
  /// In en, this message translates to:
  /// **'{count}/{max} photos'**
  String composePhotosCount(int count, int max);

  /// No description provided for @composeCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get composeCamera;

  /// No description provided for @composeVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get composeVideo;

  /// No description provided for @composeRecord.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get composeRecord;

  /// No description provided for @composeAsReel.
  ///
  /// In en, this message translates to:
  /// **'Also show in Reels'**
  String get composeAsReel;

  /// No description provided for @composeAsReelHint.
  ///
  /// In en, this message translates to:
  /// **'Best for vertical videos under 3 minutes'**
  String get composeAsReelHint;

  /// No description provided for @composeOneVideo.
  ///
  /// In en, this message translates to:
  /// **'A post holds one video, or up to 10 photos. Remove the video first.'**
  String get composeOneVideo;

  /// No description provided for @composeVideoTooBig.
  ///
  /// In en, this message translates to:
  /// **'That video is over 60 MB. Trim it or record a shorter one.'**
  String get composeVideoTooBig;

  /// No description provided for @composePosted.
  ///
  /// In en, this message translates to:
  /// **'Posted. People can see it now.'**
  String get composePosted;

  /// No description provided for @feedForYou.
  ///
  /// In en, this message translates to:
  /// **'For you'**
  String get feedForYou;

  /// No description provided for @feedFollowing.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get feedFollowing;

  /// No description provided for @feedComposePrompt.
  ///
  /// In en, this message translates to:
  /// **'What\'s new, {name}?'**
  String feedComposePrompt(String name);

  /// No description provided for @feedEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get feedEmpty;

  /// No description provided for @feedEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Be the first to share your talent with Cameroon.'**
  String get feedEmptyBody;

  /// No description provided for @feedPostFirst.
  ///
  /// In en, this message translates to:
  /// **'Share something'**
  String get feedPostFirst;

  /// No description provided for @feedFollowingEmpty.
  ///
  /// In en, this message translates to:
  /// **'Follow creators to fill this feed'**
  String get feedFollowingEmpty;

  /// No description provided for @feedFollowingEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Their photos, videos and news will show up here.'**
  String get feedFollowingEmptyBody;

  /// No description provided for @feedFindCreators.
  ///
  /// In en, this message translates to:
  /// **'Find creators'**
  String get feedFindCreators;

  /// No description provided for @feedEnd.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up'**
  String get feedEnd;

  /// No description provided for @feedPaidWork.
  ///
  /// In en, this message translates to:
  /// **'Paid work this week'**
  String get feedPaidWork;

  /// No description provided for @feedSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get feedSeeAll;

  /// No description provided for @postLike.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get postLike;

  /// No description provided for @postUnlike.
  ///
  /// In en, this message translates to:
  /// **'Unlike'**
  String get postUnlike;

  /// No description provided for @postComment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get postComment;

  /// No description provided for @postShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get postShare;

  /// No description provided for @postMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get postMore;

  /// No description provided for @postMoreText.
  ///
  /// In en, this message translates to:
  /// **'more'**
  String get postMoreText;

  /// No description provided for @postViewComments.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{View 1 comment} other{View all {count} comments}}'**
  String postViewComments(int count);

  /// No description provided for @postDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete post'**
  String get postDelete;

  /// No description provided for @postDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this post?'**
  String get postDeleteTitle;

  /// No description provided for @postDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'It will disappear from your profile and every feed. This cannot be undone.'**
  String get postDeleteBody;

  /// No description provided for @postDeleted.
  ///
  /// In en, this message translates to:
  /// **'Post deleted'**
  String get postDeleted;

  /// No description provided for @postReport.
  ///
  /// In en, this message translates to:
  /// **'Report post'**
  String get postReport;

  /// No description provided for @commentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get commentsTitle;

  /// No description provided for @commentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No comments yet. Start the conversation.'**
  String get commentsEmpty;

  /// No description provided for @commentsMore.
  ///
  /// In en, this message translates to:
  /// **'Load more comments'**
  String get commentsMore;

  /// No description provided for @commentHint.
  ///
  /// In en, this message translates to:
  /// **'Add a kind comment…'**
  String get commentHint;

  /// No description provided for @commentSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get commentSend;

  /// No description provided for @commentDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete comment'**
  String get commentDelete;

  /// No description provided for @commentReport.
  ///
  /// In en, this message translates to:
  /// **'Report comment'**
  String get commentReport;

  /// No description provided for @commentAuthorBadge.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get commentAuthorBadge;

  /// No description provided for @videoPlay.
  ///
  /// In en, this message translates to:
  /// **'Play video'**
  String get videoPlay;

  /// No description provided for @videoRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get videoRetry;

  /// No description provided for @videoMute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get videoMute;

  /// No description provided for @videoUnmute.
  ///
  /// In en, this message translates to:
  /// **'Unmute'**
  String get videoUnmute;

  /// No description provided for @reelsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your stage is ready'**
  String get reelsEmptyTitle;

  /// No description provided for @reelsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Post a short vertical video of your talent. Dance, sing, make people laugh.'**
  String get reelsEmptyBody;

  /// No description provided for @reelsEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Post a reel'**
  String get reelsEmptyAction;

  /// No description provided for @profileShare.
  ///
  /// In en, this message translates to:
  /// **'Share profile'**
  String get profileShare;

  /// No description provided for @profileStatPosts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get profileStatPosts;

  /// No description provided for @profileStatFollowers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get profileStatFollowers;

  /// No description provided for @profileStatFollowing.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get profileStatFollowing;

  /// No description provided for @profileStatWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get profileStatWork;

  /// No description provided for @profileTabPosts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get profileTabPosts;

  /// No description provided for @profileTabWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get profileTabWork;

  /// No description provided for @profileNewPost.
  ///
  /// In en, this message translates to:
  /// **'New post'**
  String get profileNewPost;

  /// No description provided for @profileNoPosts.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get profileNoPosts;

  /// No description provided for @profileNoPostsMine.
  ///
  /// In en, this message translates to:
  /// **'Share your first post'**
  String get profileNoPostsMine;

  /// No description provided for @profileNoPostsMineBody.
  ///
  /// In en, this message translates to:
  /// **'Photos and videos of your work help organisers pick you.'**
  String get profileNoPostsMineBody;

  /// No description provided for @profilePhotoFailed.
  ///
  /// In en, this message translates to:
  /// **'Your profile is saved, but the photo didn\'t upload. Add it again from Edit profile.'**
  String get profilePhotoFailed;

  /// No description provided for @portfolioIntro.
  ///
  /// In en, this message translates to:
  /// **'Work on YouTube, TikTok, Audiomack and more.'**
  String get portfolioIntro;

  /// No description provided for @portfolioIntroMine.
  ///
  /// In en, this message translates to:
  /// **'Link your best work on YouTube, TikTok or Audiomack. Organisers check here first.'**
  String get portfolioIntroMine;

  /// No description provided for @editSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get editSave;

  /// No description provided for @editSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get editSaved;

  /// No description provided for @editBioLabel.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get editBioLabel;

  /// No description provided for @editBioHint.
  ///
  /// In en, this message translates to:
  /// **'What you do, and what people can book you for'**
  String get editBioHint;

  /// No description provided for @editBioTooLong.
  ///
  /// In en, this message translates to:
  /// **'Keep your bio under 280 characters.'**
  String get editBioTooLong;

  /// No description provided for @editPictureGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get editPictureGallery;

  /// No description provided for @editPictureCamera.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get editPictureCamera;

  /// No description provided for @editPictureRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get editPictureRemove;

  /// No description provided for @editPictureSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated'**
  String get editPictureSaved;

  /// No description provided for @editTalents.
  ///
  /// In en, this message translates to:
  /// **'Talents'**
  String get editTalents;

  /// No description provided for @editChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get editChange;

  /// No description provided for @editPrimary.
  ///
  /// In en, this message translates to:
  /// **'main'**
  String get editPrimary;

  /// No description provided for @editBirthdayFixed.
  ///
  /// In en, this message translates to:
  /// **'Your date of birth is set and only support can change it. It keeps younger members protected.'**
  String get editBirthdayFixed;

  /// No description provided for @editDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get editDiscardTitle;

  /// No description provided for @editDiscardBody.
  ///
  /// In en, this message translates to:
  /// **'Your changes haven\'t been saved.'**
  String get editDiscardBody;

  /// No description provided for @editKeepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get editKeepEditing;

  /// No description provided for @editDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get editDiscard;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsSafety.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get settingsSafety;

  /// No description provided for @settingsApp.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get settingsApp;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageValue.
  ///
  /// In en, this message translates to:
  /// **'Your phone\'s language'**
  String get settingsLanguageValue;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @safetyTitle.
  ///
  /// In en, this message translates to:
  /// **'Staying safe'**
  String get safetyTitle;

  /// No description provided for @safetyTipPay.
  ///
  /// In en, this message translates to:
  /// **'Never pay to apply. Real organisers pay you, not the other way round.'**
  String get safetyTipPay;

  /// No description provided for @safetyTipMeet.
  ///
  /// In en, this message translates to:
  /// **'Meet new clients in public places, and tell someone where you are going.'**
  String get safetyTipMeet;

  /// No description provided for @safetyTipMinors.
  ///
  /// In en, this message translates to:
  /// **'Under 18? Bring a parent or guardian to any audition or job.'**
  String get safetyTipMinors;

  /// No description provided for @safetyTipReport.
  ///
  /// In en, this message translates to:
  /// **'Something feels wrong? Report it. Our team reads every report.'**
  String get safetyTipReport;

  /// No description provided for @notifPostLiked.
  ///
  /// In en, this message translates to:
  /// **'{name} liked your post'**
  String notifPostLiked(String name);

  /// No description provided for @notifPostCommented.
  ///
  /// In en, this message translates to:
  /// **'{name} commented: {text}'**
  String notifPostCommented(String name, String text);
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
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
