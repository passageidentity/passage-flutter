import 'passage_flutter_models/auth_result.dart';
import 'passage_flutter_models/passage_social_connection.dart';
import 'passage_flutter_platform/passage_flutter_platform_interface.dart';

class PassageSocial {
  /// Initiates the authorization process using a third-party social provider (Android Only).
  /// 
  /// This method opens the social provider's authentication interface. 
  /// The behavior may vary based on the platform and the underlying implementation.
  ///
  /// - [connection]: The social connection to use for login (e.g., Google, Apple).
  /// 
  /// Returns a `Future<void>` that completes when the authorization process is initiated.
  /// Throws:
  ///  `PassageError`
  Future<void> authorize(SocialConnection connection) {
    return PassageFlutterPlatform.instance.authorizeWith(connection);
  }

  /// Completes the social authentication process using the provided authorization code (Android Only).
  /// 
  /// After receiving the authorization code from the social provider, 
  /// this method exchanges it for authentication credentials.
  ///
  /// - [code]: The authorization code received from the social provider.
  /// 
  /// Returns a `Future<AuthResult>` containing the authentication result.
  /// Throws:
  ///  `PassageError`
  Future<AuthResult> finish(String code) {
    return PassageFlutterPlatform.instance.finishSocialAuthentication(code);
  }

  /// Initiates the authorization process for iOS-specific social providers(IOS Only).
  /// 
  /// This method is specific to iOS and allows for platform-specific behavior 
  /// when authorizing with social providers.
  ///
  /// - [connection]: The social connection to use for login (e.g., Google, Apple).
  /// 
  /// Returns a `Future<AuthResult>` containing the authentication result.
  /// Throws:
  ///  `PassageError`
  Future<AuthResult> authorizeIOS(SocialConnection connection) {
    return PassageFlutterPlatform.instance.authorizeIOSWith(connection);
  }
}
