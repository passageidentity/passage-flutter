import 'models/meta_data.dart';
import 'passage_flutter_models/public_user_info.dart';
import 'passage_flutter_models/passage_app_info.dart';
import 'passage_flutter_platform/passage_flutter_platform_interface.dart';

class PassageApp {

  /// Gets information about an app.
  ///
  /// Returns:
  ///  A `Future<PassageAppInfo>` object containing app information, authentication policy, etc.
  ///
  /// Throws:
  ///  `PassageError`
  Future<PassageAppInfo> info() {
    return PassageFlutterPlatform.instance.getAppInfo();
  }

  /// Checks if the provided identifier exists for the application. 
  /// This method can be used to determine whether to register or log in a user.
  /// 
  /// It also checks if the app supports the provided identifier type 
  /// (e.g., it will throw an error if a phone number is supplied to an app 
  /// that only supports emails as an identifier).
  /// 
  /// Returns:
  ///  A `Future<PublicUserInfo>` object containing user information if the identifier exists
  Future<PublicUserInfo> userExists(String identifier) {
    return PassageFlutterPlatform.instance.identifierExists(identifier);
  }

  /// Creates a new user with the provided identifier and optional metadata. 
  /// This method should be used to register a new user.
  /// 
  /// The `identifier` is required to uniquely identify the user (e.g., email or phone number).
  /// The `userMetadata` can be used to provide additional information about the user.
  /// 
  /// Returns:
  ///  A `Future<PublicUserInfo>` object containing the created user's information
  /// 
  /// Parameters:
  /// - `identifier`: The identifier for the new user (e.g., email or phone number).
  /// - `userMetadata`: Optional metadata associated with the user.
  Future<PublicUserInfo>? createUser(String identifier, Metadata? userMetadata) {
    // TODO: implement updateMetadata - After updating the code with new Android, JS, and iOS code 
    return null;
  }
}
