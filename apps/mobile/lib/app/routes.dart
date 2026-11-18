abstract final class Routes {
  static const splash = '/';
  static const phone = '/sign-in';
  static const otp = '/sign-in/code';
  static const talents = '/onboarding/talents';
  static const profile = '/onboarding/profile';

  // Tabs.
  static const calls = '/calls';
  static const discover = '/discover';
  static const activity = '/activity';
  static const me = '/me';

  /// Where people land once onboarding is done.
  static const home = calls;

  // Screens pushed over the tabs.
  static const postCall = '/post-call';
  static const myCalls = '/my-calls';
  static String call(String id) => '/calls/$id';
  static String applicants(String id) => '/calls/$id/applicants';
  static String creator(String username) => '/creators/$username';
}
