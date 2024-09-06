enum SocialConnection {
  apple,
  github,
  google,
}

extension PassageSocialConnectionExtension on SocialConnection {
  String get value {
    switch (this) {
      case SocialConnection.apple:
        return 'apple';
      case SocialConnection.github:
        return 'github';
      case SocialConnection.google:
        return 'google';
      default:
        throw Exception('Unknown PassageSocialConnection value');
    }
  }
}
