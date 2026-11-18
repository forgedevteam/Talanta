import 'package:flutter_test/flutter_test.dart';
import 'package:talanta/app/router.dart';
import 'package:talanta/app/routes.dart';
import 'package:talanta/features/auth/application/session_controller.dart';
import 'package:talanta_api/talanta_api.dart';

Me meAt(OnboardingStep step) => Me(
  id: 'u1',
  phone: '+2348031234567',
  country: 'NG',
  language: 'en',
  role: UserRole.member,
  dateOfBirth: null,
  isMinor: null,
  profile: null,
  talents: const [],
  onboardingStep: step,
);

void main() {
  group('redirectFor', () {
    test('holds everyone on the splash while the session is unknown', () {
      expect(redirectFor(const SessionUnknown(), Routes.splash), isNull);
      expect(redirectFor(const SessionUnknown(), Routes.home), Routes.splash);
    });

    test(
      'sends signed-out people to sign in and lets them reach the code screen',
      () {
        expect(redirectFor(const SignedOut(), Routes.splash), Routes.phone);
        expect(redirectFor(const SignedOut(), Routes.home), Routes.phone);
        expect(redirectFor(const SignedOut(), Routes.phone), isNull);
        expect(redirectFor(const SignedOut(), Routes.otp), isNull);
      },
    );

    test('sends signed-in people to their next onboarding step', () {
      expect(
        redirectFor(SignedIn(meAt(OnboardingStep.talents)), Routes.phone),
        Routes.talents,
      );
      expect(
        redirectFor(SignedIn(meAt(OnboardingStep.talents)), Routes.home),
        Routes.talents,
      );
      expect(
        redirectFor(SignedIn(meAt(OnboardingStep.profile)), Routes.home),
        Routes.profile,
      );
      expect(
        redirectFor(SignedIn(meAt(OnboardingStep.done)), Routes.splash),
        Routes.home,
      );
    });

    test('never lets anyone skip ahead, but allows going back to talents', () {
      expect(
        redirectFor(SignedIn(meAt(OnboardingStep.talents)), Routes.profile),
        Routes.talents,
      );
      expect(
        redirectFor(SignedIn(meAt(OnboardingStep.profile)), Routes.talents),
        isNull,
      );
    });

    test('lets finished people revisit onboarding screens to edit', () {
      expect(
        redirectFor(SignedIn(meAt(OnboardingStep.done)), Routes.talents),
        isNull,
      );
      expect(
        redirectFor(SignedIn(meAt(OnboardingStep.done)), Routes.profile),
        isNull,
      );
      expect(
        redirectFor(SignedIn(meAt(OnboardingStep.done)), Routes.phone),
        Routes.home,
      );
    });
  });
}
