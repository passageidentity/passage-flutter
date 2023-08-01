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
    
    func oneTimePasscodeActivate(arguments: Any?, result: @escaping FlutterResult) {
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
    
    func magicLinkActivate(arguments: Any?, result: @escaping FlutterResult) {
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
    
    // MARK: - Token Methods
        
    func getAuthToken(result: @escaping FlutterResult) {
        let token = passage.tokenStore.authToken
        result(token)
    }
    
    func isAuthTokenValid(arguments: Any?, result: @escaping FlutterResult) {
        guard let authToken = (arguments as? [String: String])?["authToken"] else {
            let error = FlutterError(
                code: PassageFlutterError.INVALID_ARGUMENT.rawValue,
                message: "Invalid auth token.",
                details: nil
            )
            result(error)
            return
        }
        let isValid = !PassageTokenUtils.isTokenExpired(token: authToken)
        result(isValid)
    }
    
    func refreshAuthToken(result: @escaping FlutterResult) {
        Task {
            do {
                let authResult = try await passage.refresh()
                result(authResult.authToken)
            } catch {
                let error = FlutterError(
                    code: PassageFlutterError.TOKEN_ERROR.rawValue,
                    message: error.localizedDescription,
                    details: nil
                )
                result(error)
            }
        }
    }
    
    // MARK: - App Methods
        
    func getAppInfo(result: @escaping FlutterResult) {
        Task {
            do {
                guard let appInfo = try await PassageAuth.appInfo() else {
                    let error = FlutterError(
                        code: PassageFlutterError.APP_INFO_ERROR.rawValue,
                        message: "Error getting app info.",
                        details: nil
                    )
                    result(error)
                    return
                }
                result(appInfo.toJsonString())
            } catch {
                let error = FlutterError(
                    code: PassageFlutterError.APP_INFO_ERROR.rawValue,
                    message: error.localizedDescription,
                    details: nil
                )
                result(error)
            }
        }
    }
    
    // MARK: - User Methods
    
    func getCurrentUser(result: @escaping FlutterResult) {
        Task {
            do {
                let user = try await passage.getCurrentUser()
                result(user?.toJsonString())
            } catch {
                result(nil)
            }
        }
    }
    
    func signOut(result: @escaping FlutterResult) {
        Task {
            try? await passage.signOut()
            result(nil)
        }
    }
    
    func addPasskey(arguments: Any?, result: @escaping FlutterResult) {
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
                let device = try await passage.addDevice()
                result(device.toJsonString())
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
    
    func deletePasskey(arguments: Any?, result: @escaping FlutterResult) {
        guard let deviceId = (arguments as? [String: String])?["passkeyId"] else {
            let error = FlutterError(
                code: PassageFlutterError.INVALID_ARGUMENT.rawValue,
                message: "Invalid device id",
                details: nil
            )
            return
        }
        Task {
            do {
                try await passage.revokeDevice(deviceId: deviceId)
                result(nil)
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
    
    func editPasskeyName(arguments: Any?, result: @escaping FlutterResult) {
        guard let passkeyId = (arguments as? [String: String])?["passkeyId"] else {
            let error = FlutterError(
                code: PassageFlutterError.INVALID_ARGUMENT.rawValue,
                message: "Invalid device id",
                details: nil
            )
            return
        }
        guard let newPasskeyName = (arguments as? [String: String])?["newPasskeyName"] else {
            let error = FlutterError(
                code: PassageFlutterError.INVALID_ARGUMENT.rawValue,
                message: "Invalid passkey name",
                details: nil
            )
            return
        }
        Task {
            do {
                guard let deviceInfo = try await passage
                    .editDevice(deviceId: passkeyId, friendlyName: newPasskeyName)
                else {
                    let error = FlutterError(
                        code: PassageFlutterError.PASSKEY_ERROR.rawValue,
                        message: "Error editing passkey name.",
                        details: nil
                    )
                    result(error)
                    return
                }
                result(deviceInfo.toJsonString())
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
    
    func changeEmail(arguments: Any?, result: @escaping FlutterResult) {
        guard let newEmail = (arguments as? [String: String])?["newEmail"] else {
            let error = FlutterError(
                code: PassageFlutterError.INVALID_ARGUMENT.rawValue,
                message: "Invalid email",
                details: nil
            )
            return
        }
        Task {
            do {
                let magicLink = try await passage.changeEmail(newEmail: newEmail)
                result(magicLink?.id)
            } catch PassageAPIError.unauthorized(let unauthorizedError) {
                let error = FlutterError(
                    code: PassageFlutterError.USER_UNAUTHORIZED.rawValue,
                    message: "\(unauthorizedError)",
                    details: nil
                )
                result(error)
            } catch {
                let error = FlutterError(
                    code: PassageFlutterError.CHANGE_EMAIL_ERROR.rawValue,
                    message: error.localizedDescription,
                    details: nil
                )
                result(error)
            }
        }
    }
    
    func changePhone(arguments: Any?, result: @escaping FlutterResult) {
        guard let newPhone = (arguments as? [String: String])?["newPhone"] else {
            let error = FlutterError(
                code: PassageFlutterError.INVALID_ARGUMENT.rawValue,
                message: "Invalid phone number",
                details: nil
            )
            return
        }
        Task {
            do {
                let magicLink = try await passage.changePhone(newPhone: newPhone)
                result(magicLink?.id)
            } catch PassageAPIError.unauthorized(let unauthorizedError) {
                let error = FlutterError(
                    code: PassageFlutterError.USER_UNAUTHORIZED.rawValue,
                    message: "\(unauthorizedError)",
                    details: nil
                )
                result(error)
            } catch {
                let error = FlutterError(
                    code: PassageFlutterError.CHANGE_PHONE_ERROR.rawValue,
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
