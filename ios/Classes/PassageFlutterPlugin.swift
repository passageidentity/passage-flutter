import Flutter
import Passage
import UIKit

public class PassageFlutterPlugin: NSObject, FlutterPlugin {
    
    let passage = PassageAuth()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "passage_flutter",
            binaryMessenger: registrar.messenger()
        )
        let instance = PassageFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "register":
            guard let identifier = (call.arguments as? [String: String])?["identifier"] else {
                let error = FlutterError(
                    code: "INVALID_ARGS",
                    message: "Invalid identifier",
                    details: nil
                )
                return result(error)
            }
            Task {
                do {
                    let authResult = try await passage.loginWithPasskey()
                    let authResultDict = [
                        "auth_token": authResult.auth_token,
                        "refresh_token": authResult.refresh_token,
                        "redirect_url": authResult.redirect_url
                    ]
                    result(authResultDict)
                } catch {
                    // TODO: Error code strategy
                    let error = FlutterError(
                        code: "UNKNOWN",
                        message: error.localizedDescription,
                        details: nil
                    )
                    result(error)
                }
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
