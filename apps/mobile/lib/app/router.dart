import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talanta/app/routes.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta/features/auth/presentation/otp_screen.dart';
import 'package:talanta/features/auth/presentation/phone_screen.dart';
import 'package:talanta/features/auth/presentation/splash_screen.dart';
import 'package:talanta/features/home/presentation/home_screen.dart';
import 'package:talanta/features/onboarding/presentation/create_profile_screen.dart';
import 'package:talanta/features/onboarding/presentation/talents_screen.dart';
import 'package:talanta_api/talanta_api.dart';

/// Where the session says the person should be. Navigation never has to
/// know about onboarding order; it only follows this.
String? redirectFor(SessionState session, String location) {
  switch (session) {
    case SessionUnknown() || SessionUnreachable():
      return location == Routes.splash ? null : Routes.splash;
    case SignedOut():
      final onSignIn = location == Routes.phone || location == Routes.otp;
      return onSignIn ? null : Routes.phone;
    case SignedIn(:final me):
      final target = switch (me.onboardingStep) {
        OnboardingStep.talents => Routes.talents,
        OnboardingStep.profile => Routes.profile,
        OnboardingStep.done || OnboardingStep.$unknown => Routes.home,
      };
      // Finished people may still revisit the onboarding screens to edit.
      final editing =
          me.onboardingStep == OnboardingStep.done &&
          (location == Routes.talents || location == Routes.profile);
      if (editing || location == target) return null;
      // Finished talents may go on to profile, but never skip ahead.
      if (me.onboardingStep == OnboardingStep.profile &&
          location == Routes.talents) {
        return null;
      }
      return target;
  }
}

/// Bridges Riverpod state into a [Listenable] for go_router.
class _SessionListenable extends ChangeNotifier {
  _SessionListenable(Ref ref) {
    ref.listen<SessionState>(sessionProvider, (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final listenable = _SessionListenable(ref);
  ref.onDispose(listenable.dispose);

  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: listenable,
    redirect: (context, state) =>
        redirectFor(ref.read(sessionProvider), state.matchedLocation),
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: Routes.phone, builder: (_, _) => const PhoneScreen()),
      GoRoute(path: Routes.otp, builder: (_, _) => const OtpScreen()),
      GoRoute(path: Routes.talents, builder: (_, _) => const TalentsScreen()),
      GoRoute(
        path: Routes.profile,
        builder: (_, _) => const CreateProfileScreen(),
      ),
      GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen()),
    ],
  );
});
