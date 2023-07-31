import Flutter
import Passage

internal class PassageFlutter {
    
    private let passage = PassageAuth()
    
    func register(arguments: Any?, result: @escaping FlutterResult) {
        guard #available(iOS 16.0, *) else {
            let error = FlutterError(
                code: PassageFlutterError.PASSKEYS_NOT_SUPPORTED.rawValue,
                message: "Only supported in iOS 16 and above",
                details: nil
            )
            result(error)
            return
        }
        let (identifier, error) = getIdentifier(from: arguments)
        guard let identifier else {
            result(error)
            return
        }
        Task {
            do {
                let authResult = try await passage.registerWithPasskey(identifier: identifier)
                result(authResult.toJsonString())
            } catch PassageASAuthorizationError.canceled {
                let error = FlutterError(
                    code: PassageFlutterError.USER_CANCELLED.rawValue,
                    message: "User cancelled",
                    details: nil
                )
                result(error)
            } catch {
                let error = FlutterError(
                    code: PassageFlutterError.PASSKEY_ERROR.rawValue,
                    message: error.localizedDescription,
                    details: nil
                )
                result(error)
            }
        }
    }
    
    func login(result: @escaping FlutterResult) {
        guard #available(iOS 16.0, *) else {
            let error = FlutterError(
                code: PassageFlutterError.PASSKEYS_NOT_SUPPORTED.rawValue,
                message: "Only supported in iOS 16 and above",
                details: nil
            )
            result(error)
            return
        }
        Task {
            do {
                let authResult = try await passage.loginWithPasskey()
                result(authResult.toJsonString())
            } catch PassageASAuthorizationError.canceled {
                let error = FlutterError(
                    code: PassageFlutterError.USER_CANCELLED.rawValue,
                    message: "User cancelled",
                    details: nil
                )
                result(error)
            } catch {
                let error = FlutterError(
                    code: PassageFlutterError.PASSKEY_ERROR.rawValue,
                    message: error.localizedDescription,
                    details: nil
                )
                result(error)
            }
        }
    }
    
    func newRegisterOneTimePasscode(arguments: Any?, result: @escaping FlutterResult) {
        let (identifier, error) = getIdentifier(from: arguments)
        guard let identifier else {
            result(error)
            return
        }
        Task {
            do {
                let otp = try await PassageAuth.newRegisterOneTimePasscode(identifier: identifier)
                result(otp.id)
            } catch {
                let error = FlutterError(
                    code: PassageFlutterError.OTP_ERROR.rawValue,
                    message: error.localizedDescription,
                    details: nil
                )
                result(error)
            }
        }
    }
    
    func newLoginOneTimePasscode(arguments: Any?, result: @escaping FlutterResult) {
        let (identifier, error) = getIdentifier(from: arguments)
        guard let identifier else {
            result(error)
            return
        }
        Task {
            do {
                let otp = try await PassageAuth.newLoginOneTimePasscode(identifier: identifier)
                result(otp.id)
            } catch {
                let error = FlutterError(
                    code: PassageFlutterError.OTP_ERROR.rawValue,
                    message: error.localizedDescription,
                    details: nil
                )
                result(error)
            }
        }
    }
    
    func activateOneTimePasscode(arguments: Any?, result: @escaping FlutterResult) {
        guard let otp = (arguments as? [String: String])?["otp"],
              let otpId = (arguments as? [String: String])?["otpId"]
        else {
            let error = FlutterError(
                code: PassageFlutterError.INVALID_ARGUMENT.rawValue,
                message: "invalid arguments",
                details: nil
            )
            return
        }
        Task {
            do {
                let authResult = try await PassageAuth.oneTimePasscodeActivate(otp: otp, otpId: otpId)
                result(authResult.toJsonString())
            } catch {
                let error = FlutterError(
                    code: PassageFlutterError.OTP_ERROR.rawValue,
                    message: error.localizedDescription,
                    details: nil
                )
                result(error)
            }
        }
    }
    
    func newRegisterMagicLink(arguments: Any?, result: @escaping FlutterResult) {
        let (identifier, error) = getIdentifier(from: arguments)
        guard let identifier else {
            result(error)
            return
        }
        Task {
            do {
                let ml = try await PassageAuth.newRegisterMagicLink(identifier: identifier)
                result(ml.id)
            } catch {
                let error = FlutterError(
                    code: PassageFlutterError.MAGIC_LINK_ERROR.rawValue,
                    message: error.localizedDescription,
                    details: nil
                )
                result(error)
            }
        }
    }
    
    func newLoginMagicLink(arguments: Any?, result: @escaping FlutterResult) {
        let (identifier, error) = getIdentifier(from: arguments)
        guard let identifier else {
            result(error)
            return
        }
        Task {
            do {
                let ml = try await PassageAuth.newLoginMagicLink(identifier: identifier)
                result(ml.id)
            } catch {
                let error = FlutterError(
                    code: PassageFlutterError.MAGIC_LINK_ERROR.rawValue,
                    message: error.localizedDescription,
                    details: nil
                )
                result(error)
            }
        }
    }
    
    func activateMagicLink(arguments: Any?, result: @escaping FlutterResult) {
        guard let userMagicLink = (arguments as? [String: String])?["userMagicLink"] else {
            let error = FlutterError(
                code: PassageFlutterError.INVALID_ARGUMENT.rawValue,
                message: "invalid argument",
                details: nil
            )
            return
        }
        Task {
            do {
                let authResult = try await PassageAuth.magicLinkActivate(userMagicLink: userMagicLink)
                result(authResult.toJsonString())
            } catch {
                let error = FlutterError(
                    code: PassageFlutterError.MAGIC_LINK_ERROR.rawValue,
                    message: error.localizedDescription,
                    details: nil
                )
                result(error)
            }
        }
    }
    
    func getMagicLinkStatus(arguments: Any?, result: @escaping FlutterResult) {
        guard let magicLinkId = (arguments as? [String: String])?["magicLinkId"] else {
            let error = FlutterError(
                code: PassageFlutterError.INVALID_ARGUMENT.rawValue,
                message: "invalid argument",
                details: nil
            )
            return
        }
        Task {
            do {
                let authResult = try await passage.getMagicLinkStatus(id: magicLinkId)
                result(authResult.toJsonString())
            } catch {
                let error = FlutterError(
                    code: PassageFlutterError.MAGIC_LINK_ERROR.rawValue,
                    message: error.localizedDescription,
                    details: nil
                )
                result(error)
            }
        }
    }
    
}

extension PassageFlutter {
    
    private func getIdentifier(from arguments: Any?) -> (String?, FlutterError?) {
        guard let identifier = (arguments as? [String: String])?["identifier"] else {
            let error = FlutterError(
                code: PassageFlutterError.INVALID_ARGUMENT.rawValue,
                message: "Invalid identifier.",
                details: nil
            )
            return (nil, error)
        }
        return (identifier, nil)
    }
    
}
