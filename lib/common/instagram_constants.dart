class InstagramConstant {
  static InstagramConstant? _instance;
  static InstagramConstant get instance {
    _instance ??= InstagramConstant._init();
    return _instance!;
  }

  InstagramConstant._init();

  static const String clientID = '5875517492562804';
  //  '637427618040954' ; // meta account of account of sreejith
  static const String appSecret = 'b69e7d85c52deea30a0998f9ce9c11a9';

  // '098c1ab0293eac3b6c622aa7daebc0f3'  ; // meta account of account of sreejith
  static const String redirectUri =
      'https://www.privacypolicies.com/live/57b0ebdd-4444-4b3f-863f-945b0e997532';
  static const String scope = 'user_profile,user_media';
  static const String responseType = 'code';
  final String url =
      'https://api.instagram.com/oauth/authorize?client_id=$clientID&redirect_uri=$redirectUri&scope=user_profile,user_media&response_type=$responseType';

  static const String instaBase = 'https://graph.instagram.com/';
  static const String instaAuthBase = 'https://api.instagram.com/';
}
