// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Talanta';

  @override
  String get splashTagline => 'Là où vit le talent africain';

  @override
  String get continueLabel => 'Continuer';

  @override
  String get retry => 'Réessayer';

  @override
  String get skipForNow => 'Plus tard';

  @override
  String get back => 'Retour';

  @override
  String get phoneTitle => 'Quel est ton numéro ?';

  @override
  String get phoneSubtitle =>
      'On t\'envoie un code par SMS pour te connecter. Aucun mot de passe à retenir.';

  @override
  String get phoneFieldLabel => 'Numéro de téléphone';

  @override
  String get phoneFieldHint => '6 71 23 45 67';

  @override
  String get phoneCountryPickerTitle => 'Choisis ton pays';

  @override
  String get phoneLegal =>
      'En continuant, tu acceptes les Conditions d\'utilisation et la Politique de confidentialité de Talanta.';

  @override
  String get phoneSendCode => 'Recevoir un code';

  @override
  String get phoneErrorInvalid => 'Vérifie le numéro et réessaie.';

  @override
  String get phoneErrorEmpty => 'Entre ton numéro de téléphone.';

  @override
  String get phoneErrorCountryUnsupported =>
      'Talanta n\'est pas encore disponible dans ce pays. On y travaille.';

  @override
  String get otpTitle => 'Entre ton code';

  @override
  String otpSubtitle(String phone) {
    return 'On a envoyé un code à 6 chiffres au $phone';
  }

  @override
  String otpResendIn(int seconds) {
    return 'Renvoyer le code dans $seconds s';
  }

  @override
  String get otpResend => 'Renvoyer le code';

  @override
  String get otpChangeNumber => 'Utiliser un autre numéro';

  @override
  String get otpSent => 'Un nouveau code arrive.';

  @override
  String get otpErrorInvalid => 'Ce code n\'est pas le bon. Vérifie encore.';

  @override
  String get otpErrorExpired => 'Ce code a expiré. Demandes-en un nouveau.';

  @override
  String get otpErrorTooManyAttempts =>
      'Trop d\'essais. Demande un nouveau code pour continuer.';

  @override
  String get otpErrorResendTooSoon =>
      'Laisse au dernier code le temps d\'arriver.';

  @override
  String get otpErrorRateLimited =>
      'Trop de codes demandés. Fais une pause et réessaie plus tard.';

  @override
  String get otpVerify => 'Valider';

  @override
  String get talentsTitle => 'Qu\'est-ce que tu fais ?';

  @override
  String talentsSubtitle(int max) {
    return 'Choisis-en jusqu\'à $max. Ton premier choix devient ton talent principal. Tu pourras les changer à tout moment.';
  }

  @override
  String talentsSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count choisis',
      one: '1 choisi',
      zero: 'Choisis-en au moins un',
    );
    return '$_temp0';
  }

  @override
  String get talentsMain => 'Principal';

  @override
  String get talentsLoadFailed => 'Impossible de charger la liste des talents.';

  @override
  String get talentMusic => 'Musique';

  @override
  String get talentDance => 'Danse';

  @override
  String get talentActing => 'Théâtre';

  @override
  String get talentComedy => 'Humour';

  @override
  String get talentArt => 'Arts visuels';

  @override
  String get talentCrafts => 'Artisanat';

  @override
  String get talentFashion => 'Mode';

  @override
  String get talentSpokenWord => 'Slam et poésie';

  @override
  String get talentFilm => 'Cinéma';

  @override
  String get talentPhotography => 'Photographie';

  @override
  String get talentWriting => 'Écriture';

  @override
  String get talentFood => 'Cuisine';

  @override
  String get profileTitle => 'Fais-le à ton image';

  @override
  String get profileSubtitle =>
      'C\'est comme ça qu\'on te trouvera sur Talanta.';

  @override
  String get profileAddPhoto => 'Ajouter une photo';

  @override
  String get profileChangePhoto => 'Changer de photo';

  @override
  String get profileNameLabel => 'Ton nom';

  @override
  String get profileNameHint => 'Ton nom complet';

  @override
  String get profileUsernameLabel => 'Nom d\'utilisateur';

  @override
  String get profileUsernameHint => 'tonnom';

  @override
  String get profileUsernameHelp =>
      'Lettres, chiffres et tirets bas. De 3 à 24 caractères.';

  @override
  String profileUsernameAvailable(String username) {
    return '@$username est disponible';
  }

  @override
  String get profileUsernameTaken => 'Quelqu\'un l\'a déjà pris.';

  @override
  String get profileUsernameReserved => 'Ce nom est réservé.';

  @override
  String get profileCityLabel => 'Ville';

  @override
  String get profileDobLabel => 'Date de naissance';

  @override
  String get profileDobHint => 'Choisis ta date de naissance';

  @override
  String get profileDobHelp =>
      'Pour protéger les plus jeunes. Jamais affichée sur ton profil.';

  @override
  String get profileErrorDob => 'Entre ta date de naissance.';

  @override
  String get profileErrorTooYoung =>
      'Talanta n\'est pas encore ouvert à ton âge. On a hâte de voir ton talent quand tu seras plus grand.';

  @override
  String get profileFinish => 'Terminer';

  @override
  String get profileErrorNameLength =>
      'Ton nom doit faire entre 2 et 50 caractères.';

  @override
  String get profileErrorNameEmpty => 'Entre ton nom.';

  @override
  String get profileErrorUsernameEmpty => 'Choisis un nom d\'utilisateur.';

  @override
  String get profileErrorUsernameFormat =>
      'Utilise de 3 à 24 lettres, chiffres ou tirets bas.';

  @override
  String get profileErrorCity => 'Dis-nous dans quelle ville tu crées.';

  @override
  String homeWelcome(String name) {
    return 'Bienvenue, $name';
  }

  @override
  String get homeComingSoon =>
      'Ton fil arrive bientôt. La phase 1 apporte les vidéos, les défis et la découverte.';

  @override
  String get homeSignOut => 'Se déconnecter';

  @override
  String get errorOffline =>
      'Tu es hors ligne. Vérifie ta connexion et réessaie.';

  @override
  String get errorTimeout =>
      'C\'est trop long. Vérifie ta connexion et réessaie.';

  @override
  String get errorServer =>
      'Un problème est survenu de notre côté. Réessaie dans un instant.';

  @override
  String get errorUnknown => 'Un problème est survenu. Réessaie.';

  @override
  String get errorSessionEnded => 'Ta session a pris fin. Reconnecte-toi.';

  @override
  String get navCalls => 'Offres';

  @override
  String get navDiscover => 'Découvrir';

  @override
  String get navActivity => 'Activité';

  @override
  String get navProfile => 'Profil';

  @override
  String get cancel => 'Annuler';

  @override
  String get timeJustNow => 'à l\'instant';

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
    return '$count j';
  }

  @override
  String get callsTitle => 'Offres';

  @override
  String get callsSubtitle =>
      'Contrats, castings et auditions près de chez toi.';

  @override
  String get callsAll => 'Tout';

  @override
  String get callsFeatured => 'À la une';

  @override
  String get callsSponsored => 'Sponsorisé';

  @override
  String get callsLatest => 'Dernières offres';

  @override
  String get callsEmpty => 'Pas encore d\'offre ici';

  @override
  String get callsEmptyBody =>
      'De nouvelles offres arrivent chaque semaine. Reviens bientôt, ou publie la tienne.';

  @override
  String get callsPost => 'Publier une offre';

  @override
  String callsApplicants(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count candidatures',
      one: '1 candidature',
      zero: 'Aucune candidature',
    );
    return '$_temp0';
  }

  @override
  String get callsUnpaid => 'Bénévole';

  @override
  String get callsNegotiable => 'Rémunération à discuter';

  @override
  String callsCloses(String date) {
    return 'Clôture le $date';
  }

  @override
  String get callsClosed => 'Clôturée';

  @override
  String get callAbout => 'Le projet';

  @override
  String get callPostedBy => 'Publiée par';

  @override
  String get callSafety =>
      'Talanta ne te demandera jamais de payer pour postuler. Si quelqu\'un te demande de l\'argent, signale-le.';

  @override
  String get callApply => 'Postuler';

  @override
  String get callYourApplication => 'Ta candidature';

  @override
  String callViewApplicants(int count) {
    return 'Voir les candidatures ($count)';
  }

  @override
  String get callClose => 'Clôturer l\'offre';

  @override
  String get callCloseConfirm =>
      'Arrêter de recevoir des candidatures ? Tu ne pourras pas la rouvrir.';

  @override
  String get callReport => 'Signaler l\'offre';

  @override
  String get callIsClosed => 'Cette offre est clôturée.';

  @override
  String get statusSubmitted => 'Envoyée';

  @override
  String get statusShortlisted => 'Présélection';

  @override
  String get statusDeclined => 'Non retenue';

  @override
  String get statusHired => 'Retenu·e';

  @override
  String get applyTitle => 'Postuler à cette offre';

  @override
  String get applyMessageLabel => 'Ton message';

  @override
  String get applyMessageHint =>
      'Pourquoi c\'est pour toi, et tes disponibilités.';

  @override
  String get applyAttach => 'Joins un extrait de ton travail';

  @override
  String get applyNoPortfolio =>
      'Ajoute du travail à ton profil pour le montrer ici.';

  @override
  String get applyNone => 'Sans pièce jointe';

  @override
  String get applySend => 'Envoyer ma candidature';

  @override
  String get applySent => 'Candidature envoyée. Bonne chance !';

  @override
  String get applyMessageTooShort => 'Écris au moins 10 caractères.';

  @override
  String get postTitle => 'Publication';

  @override
  String get postSubtitle =>
      'Décris le projet clairement. Les vraies offres attirent les vrais talents.';

  @override
  String get postTitleLabel => 'Titre';

  @override
  String get postTitleHint => 'Chanteuse pour un mariage à Douala';

  @override
  String get postTalentLabel => 'Talent recherché';

  @override
  String get postCityLabel => 'Ville';

  @override
  String get postDescriptionLabel => 'Décris le projet';

  @override
  String get postDescriptionHint =>
      'Date, lieu, ce que tu cherches et ce que tu fournis.';

  @override
  String get postPayLabel => 'Rémunération';

  @override
  String get postPaid => 'Payé';

  @override
  String get postNegotiable => 'À discuter';

  @override
  String get postUnpaid => 'Bénévole';

  @override
  String get postAmountLabel => 'Montant (FCFA)';

  @override
  String get postDeadlineLabel => 'Date de clôture (facultatif)';

  @override
  String get postDeadlineHint => 'Choisis une date';

  @override
  String get postSubmit => 'Publier';

  @override
  String get postPublished => 'Ton offre est en ligne.';

  @override
  String get postErrorTitle => 'Utilise de 5 à 100 caractères.';

  @override
  String get postErrorDescription => 'Écris au moins 20 caractères.';

  @override
  String get postErrorAmount => 'Indique le montant que tu paieras.';

  @override
  String get postErrorTalent => 'Choisis un talent.';

  @override
  String get applicantsTitle => 'Candidatures';

  @override
  String get applicantsEmpty => 'Pas encore de candidature';

  @override
  String get applicantsEmptyBody =>
      'Les candidatures apparaissent ici dès leur arrivée.';

  @override
  String get actionShortlist => 'Présélectionner';

  @override
  String get actionDecline => 'Refuser';

  @override
  String get actionHire => 'Retenir';

  @override
  String get viewWork => 'Voir le travail';

  @override
  String get myCallsTitle => 'Mes offres';

  @override
  String get myCallsEmpty => 'Tu n\'as pas encore publié d\'offre.';

  @override
  String get discoverTitle => 'Découvrir';

  @override
  String get discoverSearchHint => 'Rechercher des créateurs';

  @override
  String get discoverCreators => 'Créateurs';

  @override
  String get discoverFollowing => 'Abonnements';

  @override
  String get discoverEmpty => 'Personne ne correspond';

  @override
  String get followingEmpty =>
      'Suis des créateurs pour voir leur nouveau travail ici.';

  @override
  String followersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count abonnés',
      one: '1 abonné',
      zero: '0 abonné',
    );
    return '$_temp0';
  }

  @override
  String followingCount(int count) {
    return '$count abonnements';
  }

  @override
  String worksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count œuvres',
      one: '1 œuvre',
      zero: '0 œuvre',
    );
    return '$_temp0';
  }

  @override
  String get follow => 'Suivre';

  @override
  String get followingButton => 'Abonné·e';

  @override
  String get verified => 'Vérifié';

  @override
  String get portfolioTitle => 'Portfolio';

  @override
  String get portfolioEmpty => 'Pas encore de travail.';

  @override
  String get portfolioEmptyMine =>
      'Ajoute des liens vers ton meilleur travail sur YouTube, TikTok, Audiomack et plus.';

  @override
  String get portfolioAdd => 'Ajouter';

  @override
  String get portfolioTitleLabel => 'Titre';

  @override
  String get portfolioTitleHint => 'Live à l\'Institut Français';

  @override
  String get portfolioLinkLabel => 'Lien';

  @override
  String get portfolioLinkHelp =>
      'Colle le lien depuis YouTube, TikTok, Instagram, Audiomack ou Boomplay.';

  @override
  String get portfolioSave => 'Ajouter au portfolio';

  @override
  String get portfolioAdded => 'Ajouté à ton portfolio.';

  @override
  String get portfolioRemoveConfirm => 'Retirer cette œuvre de ton portfolio ?';

  @override
  String get remove => 'Retirer';

  @override
  String get portfolioErrorTitle => 'Donne-lui un titre de 2 à 80 caractères.';

  @override
  String get reportUser => 'Signaler cette personne';

  @override
  String get reportTitle => 'Quel est le problème ?';

  @override
  String get reasonScam => 'Arnaque ou demande d\'argent';

  @override
  String get reasonHarassment => 'Harcèlement';

  @override
  String get reasonInappropriate => 'Contenu inapproprié';

  @override
  String get reasonSpam => 'Spam';

  @override
  String get reasonUnderage => 'Implique un mineur';

  @override
  String get reasonOther => 'Autre chose';

  @override
  String get reportThanks => 'Merci. Notre équipe va vérifier.';

  @override
  String get profileMenuCalls => 'Mes offres';

  @override
  String get profileMenuEdit => 'Modifier le profil';

  @override
  String get profileMenuTalents => 'Modifier mes talents';

  @override
  String get profileMenuDelete => 'Supprimer mon compte';

  @override
  String get deleteTitle => 'Supprimer ton compte ?';

  @override
  String get deleteBody =>
      'Ton profil, ton portfolio et tes offres seront supprimés et tu seras déconnecté·e partout. C’est définitif.';

  @override
  String get deleteConfirm => 'Supprimer';

  @override
  String get activityTitle => 'Activité';

  @override
  String get activityNotifications => 'Notifications';

  @override
  String get activityApplications => 'Mes candidatures';

  @override
  String get activityEmpty => 'Rien de nouveau';

  @override
  String get activityEmptyBody =>
      'Candidatures, décisions et nouveaux abonnés apparaissent ici.';

  @override
  String get applicationsEmpty => 'Tu n\'as encore postulé à aucune offre';

  @override
  String get applicationsEmptyBody =>
      'Trouve une offre qui te correspond et postule en une minute.';

  @override
  String get browseCalls => 'Voir les offres';

  @override
  String get someone => 'Quelqu\'un';

  @override
  String notifApplicationReceived(String name, String title) {
    return '$name a postulé à « $title »';
  }

  @override
  String notifShortlisted(String title) {
    return 'Tu es présélectionné·e pour « $title »';
  }

  @override
  String notifHired(String title) {
    return 'Tu es retenu·e : « $title »';
  }

  @override
  String notifDeclined(String title) {
    return '« $title » : pas retenu·e cette fois';
  }

  @override
  String notifUpdate(String title) {
    return 'Du nouveau sur « $title »';
  }

  @override
  String notifNewFollower(String name) {
    return '$name te suit';
  }

  @override
  String get errorAdultsOnly => 'Les offres sont réservées aux 18 ans et plus.';

  @override
  String get errorProfileRequired => 'Termine d\'abord ton profil.';

  @override
  String get errorAlreadyApplied => 'Tu as déjà postulé.';

  @override
  String get errorCallClosed => 'Cette offre est clôturée.';

  @override
  String get errorLimitReached => 'Tu as atteint la limite.';

  @override
  String get errorLinkNotAllowed =>
      'Colle un lien complet commençant par https://';

  @override
  String get errorLinkFailed => 'Impossible d\'ouvrir ce lien.';

  @override
  String get errorRateLimited =>
      'Tu l\'as beaucoup fait aujourd\'hui. Réessaie plus tard.';

  @override
  String get errorNotFound => 'Ce n\'est plus disponible.';

  @override
  String get errorCannotApplyOwn => 'Tu as publié cette offre.';

  @override
  String get portfolioTalentLabel => 'Quel talent montre-t-il ? (facultatif)';

  @override
  String get navHome => 'Accueil';

  @override
  String get navReels => 'Reels';

  @override
  String get openMyProfile => 'Mon profil';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonClose => 'Fermer';

  @override
  String get errorGeneric => 'Un souci est survenu. Réessaie.';

  @override
  String get createTitle => 'Créer';

  @override
  String get createPhoto => 'Photo';

  @override
  String get createPhotoHint => 'Jusqu\'à 10 photos';

  @override
  String get createReel => 'Reel';

  @override
  String get createReelHint => 'Une courte vidéo verticale';

  @override
  String get createText => 'Écrire';

  @override
  String get createTextHint => 'Partage une nouvelle ou une idée';

  @override
  String get createCall => 'Appel à talents';

  @override
  String get createCallHint => 'Recrute pour un travail payé';

  @override
  String get composeTitle => 'Nouvelle publication';

  @override
  String get composeReelTitle => 'Nouveau reel';

  @override
  String get composePost => 'Publier';

  @override
  String get composeHint => 'Quoi de neuf dans ton art ?';

  @override
  String get composeCaptionHint => 'Écris une légende… #makossa @ami';

  @override
  String get composePhotos => 'Photos';

  @override
  String composePhotosCount(int count, int max) {
    return '$count/$max photos';
  }

  @override
  String get composeCamera => 'Appareil';

  @override
  String get composeVideo => 'Vidéo';

  @override
  String get composeRecord => 'Filmer';

  @override
  String get composeAsReel => 'Afficher aussi dans Reels';

  @override
  String get composeAsReelHint =>
      'Idéal pour les vidéos verticales de moins de 3 minutes';

  @override
  String get composeOneVideo =>
      'Une publication contient une vidéo, ou jusqu\'à 10 photos. Retire d\'abord la vidéo.';

  @override
  String get composeVideoTooBig =>
      'Cette vidéo dépasse 60 Mo. Coupe-la ou filme-en une plus courte.';

  @override
  String get composePosted => 'Publié. Tout le monde peut le voir.';

  @override
  String get feedForYou => 'Pour toi';

  @override
  String get feedFollowing => 'Abonnements';

  @override
  String feedComposePrompt(String name) {
    return 'Quoi de neuf, $name ?';
  }

  @override
  String get feedEmpty => 'Rien pour l\'instant';

  @override
  String get feedEmptyBody =>
      'Sois le premier à montrer ton talent au Cameroun.';

  @override
  String get feedPostFirst => 'Publier quelque chose';

  @override
  String get feedFollowingEmpty =>
      'Abonne-toi à des créateurs pour remplir ce fil';

  @override
  String get feedFollowingEmptyBody =>
      'Leurs photos, vidéos et nouvelles apparaîtront ici.';

  @override
  String get feedFindCreators => 'Trouver des créateurs';

  @override
  String get feedEnd => 'Tu as tout vu';

  @override
  String get feedPaidWork => 'Travail payé cette semaine';

  @override
  String get feedSeeAll => 'Tout voir';

  @override
  String get postLike => 'J\'aime';

  @override
  String get postUnlike => 'Je n\'aime plus';

  @override
  String get postComment => 'Commenter';

  @override
  String get postShare => 'Partager';

  @override
  String get postMore => 'Plus';

  @override
  String get postMoreText => 'plus';

  @override
  String postViewComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Voir les $count commentaires',
      one: 'Voir 1 commentaire',
    );
    return '$_temp0';
  }

  @override
  String get postDelete => 'Supprimer';

  @override
  String get postDeleteTitle => 'Supprimer cette publication ?';

  @override
  String get postDeleteBody =>
      'Elle disparaîtra de ton profil et de tous les fils. Impossible de revenir en arrière.';

  @override
  String get postDeleted => 'Publication supprimée';

  @override
  String get postReport => 'Signaler';

  @override
  String get commentsTitle => 'Commentaires';

  @override
  String get commentsEmpty =>
      'Pas encore de commentaires. Lance la discussion.';

  @override
  String get commentsMore => 'Plus de commentaires';

  @override
  String get commentHint => 'Ajoute un commentaire bienveillant…';

  @override
  String get commentSend => 'Envoyer';

  @override
  String get commentDelete => 'Supprimer le commentaire';

  @override
  String get commentReport => 'Signaler le commentaire';

  @override
  String get commentAuthorBadge => 'Auteur';

  @override
  String get videoPlay => 'Lire la vidéo';

  @override
  String get videoRetry => 'Réessayer';

  @override
  String get videoMute => 'Couper le son';

  @override
  String get videoUnmute => 'Activer le son';

  @override
  String get reelsEmptyTitle => 'Ta scène est prête';

  @override
  String get reelsEmptyBody =>
      'Publie une courte vidéo verticale de ton talent. Danse, chante, fais rire.';

  @override
  String get reelsEmptyAction => 'Publier un reel';

  @override
  String get profileShare => 'Partager le profil';

  @override
  String get profileStatPosts => 'Publications';

  @override
  String get profileStatFollowers => 'Abonnés';

  @override
  String get profileStatFollowing => 'Abonnements';

  @override
  String get profileStatWork => 'Œuvres';

  @override
  String get profileTabPosts => 'Publications';

  @override
  String get profileTabWork => 'Œuvres';

  @override
  String get profileNewPost => 'Publier';

  @override
  String get profileNoPosts => 'Aucune publication';

  @override
  String get profileNoPostsMine => 'Partage ta première publication';

  @override
  String get profileNoPostsMineBody =>
      'Les photos et vidéos de ton travail aident les organisateurs à te choisir.';

  @override
  String get profilePhotoFailed =>
      'Ton profil est enregistré, mais la photo n\'est pas passée. Ajoute-la depuis Modifier le profil.';

  @override
  String get portfolioIntro =>
      'Œuvres sur YouTube, TikTok, Audiomack et ailleurs.';

  @override
  String get portfolioIntroMine =>
      'Ajoute tes meilleures œuvres sur YouTube, TikTok ou Audiomack. Les organisateurs regardent ici en premier.';

  @override
  String get editSave => 'Enregistrer';

  @override
  String get editSaved => 'Profil mis à jour';

  @override
  String get editBioLabel => 'Bio';

  @override
  String get editBioHint => 'Ce que tu fais, et pour quoi on peut te réserver';

  @override
  String get editBioTooLong => 'Garde ta bio sous 280 caractères.';

  @override
  String get editPictureGallery => 'Choisir dans la galerie';

  @override
  String get editPictureCamera => 'Prendre une photo';

  @override
  String get editPictureRemove => 'Retirer la photo';

  @override
  String get editPictureSaved => 'Photo de profil mise à jour';

  @override
  String get editTalents => 'Talents';

  @override
  String get editChange => 'Modifier';

  @override
  String get editPrimary => 'principal';

  @override
  String get editBirthdayFixed =>
      'Ta date de naissance est fixée ; seul le support peut la changer. Cela protège les plus jeunes.';

  @override
  String get editDiscardTitle => 'Abandonner les modifications ?';

  @override
  String get editDiscardBody => 'Tes modifications ne sont pas enregistrées.';

  @override
  String get editKeepEditing => 'Continuer';

  @override
  String get editDiscard => 'Abandonner';

  @override
  String get settingsAccount => 'Compte';

  @override
  String get settingsSafety => 'Sécurité';

  @override
  String get settingsApp => 'Application';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageValue => 'Langue du téléphone';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get safetyTitle => 'Rester en sécurité';

  @override
  String get safetyTipPay =>
      'Ne paie jamais pour postuler. Les vrais organisateurs te paient, pas l\'inverse.';

  @override
  String get safetyTipMeet =>
      'Rencontre les nouveaux clients dans des lieux publics, et dis à quelqu’un où tu vas.';

  @override
  String get safetyTipMinors =>
      'Moins de 18 ans ? Viens avec un parent ou tuteur à toute audition ou mission.';

  @override
  String get safetyTipReport =>
      'Quelque chose cloche ? Signale-le. Notre équipe lit chaque signalement.';

  @override
  String notifPostLiked(String name) {
    return '$name a aimé ta publication';
  }

  @override
  String notifPostCommented(String name, String text) {
    return '$name a commenté : $text';
  }
}
