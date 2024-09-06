import 'passage_flutter_models/auth_result.dart';
import 'passage_flutter_platform/passage_flutter_platform_interface.dart';

class PassageHosted {
  
  /// Authentication Method for Hosted Apps
  ///
  /// If your Passage app is Hosted, use this method to register and log in your user. This method will open up a Passage login experience
  /// Throws:
  ///  `PassageError`
    
  Future<void> start() {
    return PassageFlutterPlatform.instance.hostedAuthStart();
  }
  
  /// Authentication Method for Hosted Apps
  /// ONLY FOR iOS
  /// If your Passage app is Hosted, use this method to register and log in your user. This method will open up a Passage login experience
  /// 
  /// Throws:
  ///  `PassageError`
    
  Future<AuthResult> startIOS() {
    return PassageFlutterPlatform.instance.hostedAuthIOS();
  }

  /// Finish Hosted Auth
  ///
  /// Finishes a Hosted login/sign up by exchanging the auth code for Passage tokens.
  /// Parameters:
  /// code: The code returned from app link redirect to your activity.
  /// clientSecret: You hosted app's client secret, found in Passage Console's OIDC Settings.
  /// state: The state returned from app link redirect to your activity.
  /// Throws:
  ///  `PassageError`

  Future<AuthResult> finish(String code, String state) {
    return PassageFlutterPlatform.instance.hostedAuthFinish(code, state);
  }
}
