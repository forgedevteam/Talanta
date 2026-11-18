abstract final class Routes {
  static const splash = '/';
  static const phone = '/sign-in';
  static const otp = '/sign-in/code';
  static const talents = '/onboarding/talents';
  static const profile = '/onboarding/profile';

  // Tabs.
  static const home = '/home';
  static const reels = '/reels';
  static const calls = '/calls';
  static const discover = '/discover';

  // Screens pushed over the tabs.
  static const activity = '/activity';
  static const me = '/me';
  static const settings = '/settings';
  static const editProfile = '/settings/profile';
  static const compose = '/compose';
  static const postCall = '/post-call';
  static const myCalls = '/my-calls';
  static String post(String id) => '/posts/$id';
  static String call(String id) => '/calls/$id';
  static String applicants(String id) => '/calls/$id/applicants';
  static String creator(String username) => '/creators/$username';
}
