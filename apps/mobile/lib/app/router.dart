import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talanta/app/home_shell.dart';
import 'package:talanta/app/routes.dart';
import 'package:talanta/features/activity/presentation/activity_screen.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta/features/auth/presentation/otp_screen.dart';
import 'package:talanta/features/auth/presentation/phone_screen.dart';
import 'package:talanta/features/auth/presentation/splash_screen.dart';
import 'package:talanta/features/discover/presentation/creator_profile_view.dart';
import 'package:talanta/features/discover/presentation/discover_screen.dart';
import 'package:talanta/features/onboarding/presentation/create_profile_screen.dart';
import 'package:talanta/features/onboarding/presentation/talents_screen.dart';
import 'package:talanta/features/opportunities/presentation/applicants_screen.dart';
import 'package:talanta/features/opportunities/presentation/my_opportunities_screen.dart';
import 'package:talanta/features/opportunities/presentation/opportunities_screen.dart';
import 'package:talanta/features/opportunities/presentation/opportunity_detail_screen.dart';
import 'package:talanta/features/opportunities/presentation/post_opportunity_screen.dart';
import 'package:talanta/features/profile/presentation/my_profile_screen.dart';
import 'package:talanta_api/talanta_api.dart';

/// Where the session says the person should be. Navigation never has to
/// know about onboarding order; it only follows this.
String? redirectFor(SessionState session, String location) {
  final signingIn = location == Routes.phone || location == Routes.otp;
  switch (session) {
    case SessionUnknown() || SessionUnreachable():
      return location == Routes.splash ? null : Routes.splash;
    case SignedOut():
      return signingIn ? null : Routes.phone;
    case SignedIn(:final me):
      switch (me.onboardingStep) {
        case OnboardingStep.talents:
          return location == Routes.talents ? null : Routes.talents;
        case OnboardingStep.profile:
          // Going back to change talents is fine; skipping ahead is not.
          return location == Routes.profile || location == Routes.talents
              ? null
              : Routes.profile;
        case OnboardingStep.done || OnboardingStep.$unknown:
          // Everything is open, including the onboarding screens for editing.
          return location == Routes.splash || signingIn ? Routes.home : null;
      }
  }
}

/// Bridges Riverpod state into a [Listenable] for go_router.
class _SessionListenable extends ChangeNotifier {
  _SessionListenable(Ref ref) {
    ref.listen<SessionState>(sessionProvider, (_, _) => notifyListeners());
  }
}

final _rootKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final listenable = _SessionListenable(ref);
  ref.onDispose(listenable.dispose);

  return GoRouter(
    navigatorKey: _rootKey,
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
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => HomeShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.calls,
                builder: (_, _) => const OpportunitiesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.discover,
                builder: (_, _) => const DiscoverScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.activity,
                builder: (_, _) => const ActivityScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.me,
                builder: (_, _) => const MyProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      // Full-screen pages over the tabs.
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: Routes.postCall,
        builder: (_, _) => const PostOpportunityScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: Routes.myCalls,
        builder: (_, _) => const MyOpportunitiesScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/calls/:id',
        builder: (_, state) =>
            OpportunityDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/calls/:id/applicants',
        builder: (_, state) =>
            ApplicantsScreen(opportunityId: state.pathParameters['id']!),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/creators/:username',
        builder: (_, state) =>
            CreatorProfileScreen(username: state.pathParameters['username']!),
      ),
    ],
  );
});
