enum PassageSocialConnection {
  apple,
  github,
  google,
}

extension PassageSocialConnectionExtension on PassageSocialConnection {
  String get value {
    switch (this) {
      case PassageSocialConnection.apple:
        return 'apple';
      case PassageSocialConnection.github:
        return 'github';
      case PassageSocialConnection.google:
        return 'google';
      default:
        throw Exception('Unknown PassageSocialConnection value');
    }
  }
}
