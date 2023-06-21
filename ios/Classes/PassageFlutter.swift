import Flutter
import Passage

internal class PassageFlutter {
    
    private let passage = PassageAuth()
    
    func register(arguments: Any?, result: @escaping FlutterResult) {
        guard let identifier = (arguments as? [String: String])?["identifier"] else {
            let error = FlutterError(
                code: PassageFlutterError.INVALID_ARGUMENT.rawValue,
                message: "Invalid identifier.",
                details: nil
            )
            return result(error)
        }
        Task {
            do {
                let authResult = try await passage.registerWithPasskey(identifier: identifier)
                result(authResult.convertToDictionary())
            } catch {
                let error = FlutterError(
                    code: PassageFlutterError.REGISTRATION_ERROR.rawValue,
                    message: error.localizedDescription,
                    details: nil
                )
                result(error)
            }
        }
    }
    
}
