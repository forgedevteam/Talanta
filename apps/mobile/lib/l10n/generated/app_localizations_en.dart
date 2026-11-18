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

  @override
  String get navCalls => 'Open Calls';

  @override
  String get navDiscover => 'Discover';

  @override
  String get navActivity => 'Activity';

  @override
  String get navProfile => 'Profile';

  @override
  String get cancel => 'Cancel';

  @override
  String get timeJustNow => 'now';

  @override
  String timeMinutes(int count) {
    return '$count min';
  }

  @override
  String timeHours(int count) {
    return '$count h';
  }

  @override
  String timeDays(int count) {
    return '$count d';
  }

  @override
  String get callsTitle => 'Open Calls';

  @override
  String get callsSubtitle => 'Paid gigs, castings and auditions near you.';

  @override
  String get callsAll => 'All';

  @override
  String get callsFeatured => 'Featured';

  @override
  String get callsSponsored => 'Sponsored';

  @override
  String get callsLatest => 'Latest calls';

  @override
  String get callsEmpty => 'No calls here yet';

  @override
  String get callsEmptyBody =>
      'New calls arrive every week. Check back soon, or post your own.';

  @override
  String get callsPost => 'Post a call';

  @override
  String callsApplicants(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count applicants',
      one: '1 applicant',
      zero: 'No applicants yet',
    );
    return '$_temp0';
  }

  @override
  String get callsUnpaid => 'Unpaid';

  @override
  String get callsNegotiable => 'Pay to discuss';

  @override
  String callsCloses(String date) {
    return 'Closes $date';
  }

  @override
  String get callsClosed => 'Closed';

  @override
  String get callAbout => 'About the work';

  @override
  String get callPostedBy => 'Posted by';

  @override
  String get callSafety =>
      'Talanta never asks you to pay to apply. If anyone asks you for money, report them.';

  @override
  String get callApply => 'Apply';

  @override
  String get callYourApplication => 'Your application';

  @override
  String callViewApplicants(int count) {
    return 'See applicants ($count)';
  }

  @override
  String get callClose => 'Close this call';

  @override
  String get callCloseConfirm =>
      'Stop taking applications? You cannot reopen it.';

  @override
  String get callReport => 'Report this call';

  @override
  String get callIsClosed => 'This call is closed.';

  @override
  String get statusSubmitted => 'Sent';

  @override
  String get statusShortlisted => 'Shortlisted';

  @override
  String get statusDeclined => 'Not selected';

  @override
  String get statusHired => 'Hired';

  @override
  String get applyTitle => 'Apply to this call';

  @override
  String get applyMessageLabel => 'Your message';

  @override
  String get applyMessageHint =>
      'Why you\'re right for it, and when you\'re free.';

  @override
  String get applyAttach => 'Show a piece of your work';

  @override
  String get applyNoPortfolio => 'Add work to your profile to show it here.';

  @override
  String get applyNone => 'No attachment';

  @override
  String get applySend => 'Send application';

  @override
  String get applySent => 'Application sent. Good luck!';

  @override
  String get applyMessageTooShort => 'Write at least 10 characters.';

  @override
  String get postTitle => 'Post';

  @override
  String get postSubtitle =>
      'Describe the work clearly. Real calls get real talent.';

  @override
  String get postTitleLabel => 'Title';

  @override
  String get postTitleHint => 'Singer for a wedding in Douala';

  @override
  String get postTalentLabel => 'Talent you need';

  @override
  String get postCityLabel => 'City';

  @override
  String get postDescriptionLabel => 'Describe the work';

  @override
  String get postDescriptionHint =>
      'Date, place, what you need and what you provide.';

  @override
  String get postPayLabel => 'Pay';

  @override
  String get postPaid => 'Paid';

  @override
  String get postNegotiable => 'To discuss';

  @override
  String get postUnpaid => 'Unpaid';

  @override
  String get postAmountLabel => 'Amount (FCFA)';

  @override
  String get postDeadlineLabel => 'Closing date (optional)';

  @override
  String get postDeadlineHint => 'Choose a date';

  @override
  String get postSubmit => 'Publish';

  @override
  String get postPublished => 'Your call is live.';

  @override
  String get postErrorTitle => 'Use 5 to 100 characters.';

  @override
  String get postErrorDescription => 'Write at least 20 characters.';

  @override
  String get postErrorAmount => 'Enter the amount you\'ll pay.';

  @override
  String get postErrorTalent => 'Choose a talent.';

  @override
  String get applicantsTitle => 'Applicants';

  @override
  String get applicantsEmpty => 'No applications yet';

  @override
  String get applicantsEmptyBody =>
      'Applications appear here as soon as they arrive.';

  @override
  String get actionShortlist => 'Shortlist';

  @override
  String get actionDecline => 'Decline';

  @override
  String get actionHire => 'Hire';

  @override
  String get viewWork => 'View work';

  @override
  String get myCallsTitle => 'My calls';

  @override
  String get myCallsEmpty => 'You haven\'t posted a call yet.';

  @override
  String get discoverTitle => 'Discover';

  @override
  String get discoverSearchHint => 'Search creators';

  @override
  String get discoverCreators => 'Creators';

  @override
  String get discoverFollowing => 'Following';

  @override
  String get discoverEmpty => 'No one matches yet';

  @override
  String get followingEmpty => 'Follow creators to see their new work here.';

  @override
  String followersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count followers',
      one: '1 follower',
    );
    return '$_temp0';
  }

  @override
  String followingCount(int count) {
    return '$count following';
  }

  @override
  String worksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pieces',
      one: '1 piece',
    );
    return '$_temp0';
  }

  @override
  String get follow => 'Follow';

  @override
  String get followingButton => 'Following';

  @override
  String get verified => 'Verified';

  @override
  String get portfolioTitle => 'Portfolio';

  @override
  String get portfolioEmpty => 'No work yet.';

  @override
  String get portfolioEmptyMine =>
      'Add links to your best work on YouTube, TikTok, Audiomack and more.';

  @override
  String get portfolioAdd => 'Add work';

  @override
  String get portfolioTitleLabel => 'Title';

  @override
  String get portfolioTitleHint => 'Live at Institut Français';

  @override
  String get portfolioLinkLabel => 'Link';

  @override
  String get portfolioLinkHelp =>
      'Paste the link from YouTube, TikTok, Instagram, Audiomack or Boomplay.';

  @override
  String get portfolioSave => 'Add to portfolio';

  @override
  String get portfolioAdded => 'Added to your portfolio.';

  @override
  String get portfolioRemoveConfirm => 'Remove this piece from your portfolio?';

  @override
  String get remove => 'Remove';

  @override
  String get portfolioErrorTitle => 'Give it a title of 2 to 80 characters.';

  @override
  String get reportUser => 'Report this person';

  @override
  String get reportTitle => 'What\'s wrong?';

  @override
  String get reasonScam => 'Scam, or asks for money';

  @override
  String get reasonHarassment => 'Harassment';

  @override
  String get reasonInappropriate => 'Inappropriate content';

  @override
  String get reasonSpam => 'Spam';

  @override
  String get reasonUnderage => 'Involves a minor';

  @override
  String get reasonOther => 'Something else';

  @override
  String get reportThanks => 'Thanks. Our team will look into it.';

  @override
  String get profileMenuCalls => 'My calls';

  @override
  String get profileMenuEdit => 'Edit profile';

  @override
  String get profileMenuTalents => 'Edit talents';

  @override
  String get profileMenuDelete => 'Delete my account';

  @override
  String get deleteTitle => 'Delete your account?';

  @override
  String get deleteBody =>
      'Your profile, portfolio and calls are removed and you\'re signed out everywhere. This can\'t be undone.';

  @override
  String get deleteConfirm => 'Delete';

  @override
  String get activityTitle => 'Activity';

  @override
  String get activityNotifications => 'Notifications';

  @override
  String get activityApplications => 'My applications';

  @override
  String get activityEmpty => 'Nothing new yet';

  @override
  String get activityEmptyBody =>
      'Applications, decisions and new followers show up here.';

  @override
  String get applicationsEmpty => 'You haven\'t applied to a call yet';

  @override
  String get applicationsEmptyBody =>
      'Find a call that fits you and apply in a minute.';

  @override
  String get browseCalls => 'Browse calls';

  @override
  String get someone => 'Someone';

  @override
  String notifApplicationReceived(String name, String title) {
    return '$name applied to “$title”';
  }

  @override
  String notifShortlisted(String title) {
    return 'You\'re shortlisted for “$title”';
  }

  @override
  String notifHired(String title) {
    return 'You got the job: “$title”';
  }

  @override
  String notifDeclined(String title) {
    return '“$title”: not selected this time';
  }

  @override
  String notifUpdate(String title) {
    return 'Update on “$title”';
  }

  @override
  String notifNewFollower(String name) {
    return '$name started following you';
  }

  @override
  String get errorAdultsOnly => 'Open Calls are for people 18 and over.';

  @override
  String get errorProfileRequired => 'Finish your profile first.';

  @override
  String get errorAlreadyApplied => 'You\'ve already applied.';

  @override
  String get errorCallClosed => 'This call is closed.';

  @override
  String get errorLimitReached => 'You\'ve reached the limit.';

  @override
  String get errorLinkNotAllowed => 'Paste a full link starting with https://';

  @override
  String get errorLinkFailed => 'That link couldn\'t be opened.';

  @override
  String get errorRateLimited =>
      'You\'ve done that a lot today. Try again later.';

  @override
  String get errorNotFound => 'This is no longer available.';

  @override
  String get errorCannotApplyOwn => 'You posted this call.';

  @override
  String get portfolioTalentLabel => 'Which talent does it show? (optional)';

  @override
  String get navHome => 'Home';

  @override
  String get navReels => 'Reels';

  @override
  String get openMyProfile => 'My profile';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonClose => 'Close';

  @override
  String get errorGeneric => 'Something went wrong. Try again.';

  @override
  String get createTitle => 'Create';

  @override
  String get createPhoto => 'Photo';

  @override
  String get createPhotoHint => 'Up to 10 photos';

  @override
  String get createReel => 'Reel';

  @override
  String get createReelHint => 'A short vertical video';

  @override
  String get createText => 'Write';

  @override
  String get createTextHint => 'Share news or an idea';

  @override
  String get createCall => 'Open Call';

  @override
  String get createCallHint => 'Hire talent for paid work';

  @override
  String get composeTitle => 'New post';

  @override
  String get composeReelTitle => 'New reel';

  @override
  String get composePost => 'Post';

  @override
  String get composeHint => 'What\'s happening in your craft?';

  @override
  String get composeCaptionHint => 'Write a caption… #makossa @friend';

  @override
  String get composePhotos => 'Photos';

  @override
  String composePhotosCount(int count, int max) {
    return '$count/$max photos';
  }

  @override
  String get composeCamera => 'Camera';

  @override
  String get composeVideo => 'Video';

  @override
  String get composeRecord => 'Record';

  @override
  String get composeAsReel => 'Also show in Reels';

  @override
  String get composeAsReelHint => 'Best for vertical videos under 3 minutes';

  @override
  String get composeOneVideo =>
      'A post holds one video, or up to 10 photos. Remove the video first.';

  @override
  String get composeVideoTooBig =>
      'That video is over 60 MB. Trim it or record a shorter one.';

  @override
  String get composePosted => 'Posted. People can see it now.';

  @override
  String get feedForYou => 'For you';

  @override
  String get feedFollowing => 'Following';

  @override
  String get feedComposePrompt => 'Share your talent…';

  @override
  String get feedEmpty => 'Nothing here yet';

  @override
  String get feedEmptyBody =>
      'Be the first to share your talent with Cameroon.';

  @override
  String get feedPostFirst => 'Share something';

  @override
  String get feedFollowingEmpty => 'Follow creators to fill this feed';

  @override
  String get feedFollowingEmptyBody =>
      'Their photos, videos and news will show up here.';

  @override
  String get feedFindCreators => 'Find creators';

  @override
  String get feedEnd => 'You\'re all caught up';

  @override
  String get feedPaidWork => 'Paid work this week';

  @override
  String get feedSeeAll => 'See all';

  @override
  String get postLike => 'Like';

  @override
  String get postUnlike => 'Unlike';

  @override
  String get postComment => 'Comment';

  @override
  String get postShare => 'Share';

  @override
  String get postMore => 'More';

  @override
  String get postMoreText => 'more';

  @override
  String postViewComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'View all $count comments',
      one: 'View 1 comment',
    );
    return '$_temp0';
  }

  @override
  String get postDelete => 'Delete post';

  @override
  String get postDeleteTitle => 'Delete this post?';

  @override
  String get postDeleteBody =>
      'It will disappear from your profile and every feed. This cannot be undone.';

  @override
  String get postDeleted => 'Post deleted';

  @override
  String get postReport => 'Report post';

  @override
  String get commentsTitle => 'Comments';

  @override
  String get commentsEmpty => 'No comments yet. Start the conversation.';

  @override
  String get commentsMore => 'Load more comments';

  @override
  String get commentHint => 'Add a kind comment…';

  @override
  String get commentSend => 'Send';

  @override
  String get commentDelete => 'Delete comment';

  @override
  String get commentReport => 'Report comment';

  @override
  String get commentAuthorBadge => 'Author';

  @override
  String get videoPlay => 'Play video';

  @override
  String get videoRetry => 'Try again';

  @override
  String get videoMute => 'Mute';

  @override
  String get videoUnmute => 'Unmute';

  @override
  String get reelsEmptyTitle => 'Your stage is ready';

  @override
  String get reelsEmptyBody =>
      'Post a short vertical video of your talent. Dance, sing, make people laugh.';

  @override
  String get reelsEmptyAction => 'Post a reel';

  @override
  String get profileShare => 'Share profile';

  @override
  String get profileStatPosts => 'Posts';

  @override
  String get profileStatFollowers => 'Followers';

  @override
  String get profileStatFollowing => 'Following';

  @override
  String get profileStatWork => 'Work';

  @override
  String get profileTabPosts => 'Posts';

  @override
  String get profileTabWork => 'Work';

  @override
  String get profileNewPost => 'New post';

  @override
  String get profileNoPosts => 'No posts yet';

  @override
  String get profileNoPostsMine => 'Share your first post';

  @override
  String get profileNoPostsMineBody =>
      'Photos and videos of your work help organisers pick you.';

  @override
  String get profilePhotoFailed =>
      'Your profile is saved, but the photo didn\'t upload. Add it again from Edit profile.';

  @override
  String get portfolioIntro => 'Work on YouTube, TikTok, Audiomack and more.';

  @override
  String get portfolioIntroMine =>
      'Link your best work on YouTube, TikTok or Audiomack. Organisers check here first.';

  @override
  String get editSave => 'Save';

  @override
  String get editSaved => 'Profile updated';

  @override
  String get editBioLabel => 'Bio';

  @override
  String get editBioHint => 'What you do, and what people can book you for';

  @override
  String get editBioTooLong => 'Keep your bio under 280 characters.';

  @override
  String get editPictureGallery => 'Choose from gallery';

  @override
  String get editPictureCamera => 'Take a photo';

  @override
  String get editPictureRemove => 'Remove photo';

  @override
  String get editPictureSaved => 'Profile photo updated';

  @override
  String get editTalents => 'Talents';

  @override
  String get editChange => 'Change';

  @override
  String get editPrimary => 'main';

  @override
  String get editBirthdayFixed =>
      'Your date of birth is set and only support can change it. It keeps younger members protected.';

  @override
  String get editDiscardTitle => 'Discard changes?';

  @override
  String get editDiscardBody => 'Your changes haven\'t been saved.';

  @override
  String get editKeepEditing => 'Keep editing';

  @override
  String get editDiscard => 'Discard';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsSafety => 'Safety';

  @override
  String get settingsApp => 'App';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageValue => 'Your phone\'s language';

  @override
  String get settingsAbout => 'About';

  @override
  String get safetyTitle => 'Staying safe';

  @override
  String get safetyTipPay =>
      'Never pay to apply. Real organisers pay you, not the other way round.';

  @override
  String get safetyTipMeet =>
      'Meet new clients in public places, and tell someone where you are going.';

  @override
  String get safetyTipMinors =>
      'Under 18? Bring a parent or guardian to any audition or job.';

  @override
  String get safetyTipReport =>
      'Something feels wrong? Report it. Our team reads every report.';

  @override
  String notifPostLiked(String name) {
    return '$name liked your post';
  }

  @override
  String notifPostCommented(String name, String text) {
    return '$name commented: $text';
  }
}
