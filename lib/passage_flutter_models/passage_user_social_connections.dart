import 'dart:convert';

class UserSocialConnections {
  final AppleSocialConnection? apple;
  final GithubSocialConnection? github;
  final GoogleSocialConnection? google;

  UserSocialConnections({
    this.apple,
    this.github,
    this.google,
  });

  UserSocialConnections.fromMap(Map<String, dynamic> map)
      : apple = map['apple'] != null
          ? AppleSocialConnection.fromMap(map['apple'])
          : null,
        github = map['github'] != null
          ? GithubSocialConnection.fromMap(map['github'])
          : null,
        google = map['google'] != null
          ? GoogleSocialConnection.fromMap(map['google'])
          : null;

  factory UserSocialConnections.fromJson(String jsonString) {
    return UserSocialConnections.fromMap(jsonDecode(jsonString));
  }

  Map<String, dynamic> toMap() {
    return {
      'apple': apple?.toMap(),
      'github': github?.toMap(),
      'google': google?.toMap(),
    };
  }
}

class AppleSocialConnection {
  final String providerId;
  final String createdAt;
  final String lastLoginAt;
  final String providerIdentifier;

  AppleSocialConnection({
    required this.providerId,
    required this.createdAt,
    required this.lastLoginAt,
    required this.providerIdentifier,
  });

  AppleSocialConnection.fromMap(Map<String, dynamic> map)
      : providerId = map['providerId'],
        createdAt = map['createdAt'],
        lastLoginAt = map['lastLoginAt'],
        providerIdentifier = map['providerIdentifier'];

  Map<String, dynamic> toMap() {
    return {
      'providerId': providerId,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
      'providerIdentifier': providerIdentifier,
    };
  }
}

class GithubSocialConnection {
  final String providerId;
  final String? createdAt;
  final String? lastLoginAt;
  final String providerIdentifier;

  GithubSocialConnection({
    required this.providerId,
    this.createdAt,
    this.lastLoginAt,
    required this.providerIdentifier,
  });

  GithubSocialConnection.fromMap(Map<String, dynamic> map)
      : providerId = map['providerId'],
        createdAt = map['createdAt'] is String ? map['createdAt'] : null,
        lastLoginAt = map['lastLoginAt'] is String ? map['lastLoginAt'] : null,
        providerIdentifier = map['providerIdentifier'];

  Map<String, dynamic> toMap() {
    return {
      'providerId': providerId,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
      'providerIdentifier': providerIdentifier,
    };
  }
}

class GoogleSocialConnection {
  final String providerId;
  final String? createdAt;
  final String? lastLoginAt;
  final String providerIdentifier;

  GoogleSocialConnection({
    required this.providerId,
    this.createdAt,
    this.lastLoginAt,
    required this.providerIdentifier,
  });

  GoogleSocialConnection.fromMap(Map<String, dynamic> map)
      : providerId = map['providerId'],
        createdAt = map['createdAt'] is String ? map['createdAt'] : null,
        lastLoginAt = map['lastLoginAt'] is String ? map['lastLoginAt'] : null,
        providerIdentifier = map['providerIdentifier'];

  Map<String, dynamic> toMap() {
    return {
      'providerId': providerId,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
      'providerIdentifier': providerIdentifier,
    };
  }
}
