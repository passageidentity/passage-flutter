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
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
}
