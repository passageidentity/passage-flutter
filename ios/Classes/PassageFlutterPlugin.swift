import Flutter
import UIKit

public class PassageFlutterPlugin: NSObject, FlutterPlugin {
    
    private var passageFlutter: PassageFlutter?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "passage_flutter",
            binaryMessenger: registrar.messenger()
        )
        let instance = PassageFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if passageFlutter == nil {
            if
                call.method == "initialize",
                let appId = (call.arguments as? [String: String])?["appId"]
            {
                passageFlutter = PassageFlutter(appId: appId)
            }
            guard passageFlutter != nil else {
                result(FlutterError(code: "NOT_INITIALIZED", message: "PassageFlutter has not been initialized", details: nil))
                return
            }
        }
            switch call.method {
            case "initialize": ()
            case "registerWithPasskey":
                passageFlutter?.registerWithPasskey(arguments: call.arguments, result: result)
            case "loginWithPasskey":
                passageFlutter?.loginWithPasskey(arguments: call.arguments, result: result)
            case "deviceSupportsPasskeys":
                passageFlutter?.deviceSupportsPasskeys(result: result)
            case "newRegisterOneTimePasscode":
                passageFlutter?.newRegisterOneTimePasscode(arguments: call.arguments, result: result)
            case "newLoginOneTimePasscode":
                passageFlutter?.newLoginOneTimePasscode(arguments: call.arguments, result: result)
            case "oneTimePasscodeActivate":
                passageFlutter?.oneTimePasscodeActivate(arguments: call.arguments, result: result)
            case "newRegisterMagicLink":
                passageFlutter?.newRegisterMagicLink(arguments: call.arguments, result: result)
            case "newLoginMagicLink":
                passageFlutter?.newLoginMagicLink(arguments: call.arguments, result: result)
            case "magicLinkActivate":
                passageFlutter?.magicLinkActivate(arguments: call.arguments, result: result)
            case "getMagicLinkStatus":
                passageFlutter?.getMagicLinkStatus(arguments: call.arguments, result: result)
            case "authorizeWith":
                passageFlutter?.authorizeWith(arguments: call.arguments, result: result)
            case "getValidAuthToken":
                passageFlutter?.getValidAuthToken(result: result)
            case "isAuthTokenValid":
                passageFlutter?.isAuthTokenValid(arguments: call.arguments, result: result)
            case "refreshAuthToken":
                passageFlutter?.refreshAuthToken(result: result)
            case "getAppInfo":
                passageFlutter?.getAppInfo(result: result)
            case "getCurrentUser":
                passageFlutter?.getCurrentUser(result: result)
            case "signOut":
                passageFlutter?.signOut(result: result)
            case "addPasskey":
                passageFlutter?.addPasskey(arguments: call.arguments, result: result)
            case "deletePasskey":
                passageFlutter?.deletePasskey(arguments: call.arguments, result: result)
            case "editPasskeyName":
                passageFlutter?.editPasskeyName(arguments: call.arguments, result: result)
            case "changeEmail":
                passageFlutter?.changeEmail(arguments: call.arguments, result: result)
            case "changePhone":
                passageFlutter?.changePhone(arguments: call.arguments, result: result)
            case "identifierExists":
                passageFlutter?.identifierExists(arguments: call.arguments, result: result)
            case "hostedAuth":
                passageFlutter?.hostedAuth(result: result)
            case "socialConnections":
                passageFlutter?.socialConnections(result: result)
            case "deleteSocialConnection":
                passageFlutter?.deleteSocialConnection(arguments: call.arguments, result: result)
            case "metaData":
                passageFlutter?.metaData(result: result)
            case "updateMetaData":
                passageFlutter?.updateMetaData(arguments: call.arguments, result: result)
            case "createUser":
                passageFlutter?.createUser(arguments: call.arguments, result: result)
            case "passkeys":
                passageFlutter?.passkeys(result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
    }

