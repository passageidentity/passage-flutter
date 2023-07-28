import Flutter
import UIKit

public class PassageFlutterPlugin: NSObject, FlutterPlugin {
    
    private let passageFlutter = PassageFlutter()
    
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
        case "register":
            passageFlutter.register(arguments: call.arguments, result: result)
        case "login":
            passageFlutter.login(result: result)
        case "newRegisterOneTimePasscode":
            passageFlutter.newRegisterOneTimePasscode(arguments: call.arguments, result: result)
        case "newLoginOneTimePasscode":
            passageFlutter.newLoginOneTimePasscode(arguments: call.arguments, result: result)
        case "activateOneTimePasscode":
            passageFlutter.activateOneTimePasscode(arguments: call.arguments, result: result)
        case "newRegisterMagicLink":
            passageFlutter.newRegisterMagicLink(arguments: call.arguments, result: result)
        case "newLoginMagicLink":
            passageFlutter.newLoginMagicLink(arguments: call.arguments, result: result)
        case "activateMagicLink":
            passageFlutter.activateMagicLink(arguments: call.arguments, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
}
