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
  String get profilePhotoLater =>
      'L\'envoi de photos arrive avec la prochaine version. D\'ici là, ta photo reste sur ce téléphone.';

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
}
