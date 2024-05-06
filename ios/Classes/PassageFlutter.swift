import Flutter
import Passage

internal class PassageFlutter {
    
    private let passage: PassageAuth
    
    internal init() {
        passage = PassageAuth()
    }
    
    internal init(appId: String) {
        passage = PassageAuth(appId: appId)
    }
    
    internal func registerWithPasskey(arguments: Any?, result: @escaping FlutterResult) {
        guard #available(iOS 16.0, *) else {
            let error = PassageFlutterError.PASSKEYS_NOT_SUPPORTED.defaultFlutterError
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
                result(convertToJsonString(codable: authResult))
            } catch PassageASAuthorizationError.canceled {
                let error = PassageFlutterError.USER_CANCELLED.defaultFlutterError
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
    
    internal func loginWithPasskey(arguments: Any?, result: @escaping FlutterResult) {
        guard #available(iOS 16.0, *) else {
            let error = PassageFlutterError.PASSKEYS_NOT_SUPPORTED.defaultFlutterError
            result(error)
            return
        }
        let (identifier, _) = getIdentifier(from: arguments)
        Task {
            do {
                let authResult = try await passage.loginWithPasskey(identifier: identifier)
                result(convertToJsonString(codable: authResult))
            } catch PassageASAuthorizationError.canceled {
                let error = PassageFlutterError.USER_CANCELLED.defaultFlutterError
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
    
    internal func deviceSupportsPasskeys(result: @escaping FlutterResult) {
        if #available(iOS 16.0, *) {
            result(true)
        } else {
            result(false)
        }
    }
    
    internal func newRegisterOneTimePasscode(arguments: Any?, result: @escaping FlutterResult) {
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
    
    internal func newLoginOneTimePasscode(arguments: Any?, result: @escaping FlutterResult) {
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
    
    internal func oneTimePasscodeActivate(arguments: Any?, result: @escaping FlutterResult) {
        guard let otp = (arguments as? [String: String])?["otp"],
              let otpId = (arguments as? [String: String])?["otpId"]
        else {
            let error = PassageFlutterError.INVALID_ARGUMENT.defaultFlutterError
            result(error)
            return
        }
        Task {
            do {
                let authResult = try await passage.oneTimePasscodeActivate(otp: otp, otpId: otpId)
                result(convertToJsonString(codable: authResult))
            } catch {
                var errorCode = PassageFlutterError.OTP_ERROR.rawValue
                if case PassageOTPError.exceededAttempts = error {
                    errorCode = PassageFlutterError.OTP_ACTIVATION_EXCEEDED_ATTEMPTS.rawValue
                }
                let error = FlutterError(
                    code: errorCode,
                    message: error.localizedDescription,
                    details: nil
                )
                result(error)
            }
        }
    }
    
    internal func newRegisterMagicLink(arguments: Any?, result: @escaping FlutterResult) {
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
    
    internal func newLoginMagicLink(arguments: Any?, result: @escaping FlutterResult) {
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
    
    internal func magicLinkActivate(arguments: Any?, result: @escaping FlutterResult) {
        guard let userMagicLink = (arguments as? [String: String])?["magicLink"] else {
            let error = PassageFlutterError.INVALID_ARGUMENT.defaultFlutterError
            result(error)
            return
        }
        Task {
            do {
                let authResult = try await passage.magicLinkActivate(userMagicLink: userMagicLink)
                result(convertToJsonString(codable: authResult))
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
    
    internal func getMagicLinkStatus(arguments: Any?, result: @escaping FlutterResult) {
        guard let magicLinkId = (arguments as? [String: String])?["magicLinkId"] else {
            let error = PassageFlutterError.INVALID_ARGUMENT.defaultFlutterError
            result(error)
            return
        }
        Task {
            do {
                let authResult = try await passage.getMagicLinkStatus(id: magicLinkId)
                result(convertToJsonString(codable: authResult))
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
    
    // MARK: - Social Methods
    internal func authorizeWith(arguments: Any?, result: @escaping FlutterResult) {
        guard let connection = (arguments as? [String: String])?["connection"] else {
            let error = PassageFlutterError.INVALID_ARGUMENT.defaultFlutterError
            result(error)
            return
        }
        Task {
            do {
                guard let safeConnection = PassageSocialConnection(rawValue: connection) else {
                    let error = FlutterError(
                        code: PassageFlutterError.SOCIAL_AUTH_ERROR.rawValue,
                        message: "Invalid connection.",
                        details: nil
                    )
                    result(error)
                    return
                }
                guard let window = await UIApplication.shared.delegate?.window ?? nil else {
                    let error = FlutterError(
                        code: PassageFlutterError.SOCIAL_AUTH_ERROR.rawValue,
                        message: "Could not access app window.",
                        details: nil
                    )
                    result(error)
                    return
                }
                let authResult = try await passage.authorize(with: safeConnection, in: window)
                result(convertToJsonString(codable: authResult))
            } catch {
                let error = FlutterError(
                    code: PassageFlutterError.SOCIAL_AUTH_ERROR.rawValue,
                    message: error.localizedDescription,
                    details: nil
                )
                result(error)
            }
        }
    }
    
    // MARK: - Token Methods
        
    internal func getAuthToken(result: @escaping FlutterResult) {
        let token = passage.tokenStore.authToken
        result(token)
    }
    
    internal func isAuthTokenValid(arguments: Any?, result: @escaping FlutterResult) {
        guard let authToken = (arguments as? [String: String])?["authToken"] else {
            let error = PassageFlutterError.INVALID_ARGUMENT.defaultFlutterError
            result(error)
            return
        }
        let isValid = !PassageTokenUtils.isTokenExpired(token: authToken)
        result(isValid)
    }
    
    internal func refreshAuthToken(result: @escaping FlutterResult) {
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
        
    internal func getAppInfo(result: @escaping FlutterResult) {
        Task {
            do {
                guard let appInfo = try await PassageAuth.appInfo() else {
                    let error = PassageFlutterError.APP_INFO_ERROR.defaultFlutterError
                    result(error)
                    return
                }
                result(convertToJsonString(codable: appInfo))
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
    
    internal func getCurrentUser(result: @escaping FlutterResult) {
        Task {
            do {
                let user = try await passage.getCurrentUser()
                result(convertToJsonString(codable: user))
            } catch {
                result(nil)
            }
        }
    }
    
    internal func signOut(result: @escaping FlutterResult) {
        Task {
            try? await passage.signOut()
            result(nil)
        }
    }
    
    internal func addPasskey(arguments: Any?, result: @escaping FlutterResult) {
        guard #available(iOS 16.0, *) else {
            let error = PassageFlutterError.PASSKEYS_NOT_SUPPORTED.defaultFlutterError
            result(error)
            return
        }
        Task {
            do {
                let device = try await passage.addDevice()
                result(convertToJsonString(codable: device))
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
    
    internal func deletePasskey(arguments: Any?, result: @escaping FlutterResult) {
        guard let deviceId = (arguments as? [String: String])?["passkeyId"] else {
            let error = PassageFlutterError.INVALID_ARGUMENT.defaultFlutterError
            result(error)
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
    
    internal func editPasskeyName(arguments: Any?, result: @escaping FlutterResult) {
        guard
            let passkeyId = (arguments as? [String: String])?["passkeyId"],
            let newPasskeyName = (arguments as? [String: String])?["newPasskeyName"]
        else {
            let error = PassageFlutterError.INVALID_ARGUMENT.defaultFlutterError
            result(error)
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
                result(convertToJsonString(codable: deviceInfo))
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
    
    internal func changeEmail(arguments: Any?, result: @escaping FlutterResult) {
        guard let newEmail = (arguments as? [String: String])?["newEmail"] else {
            let error = PassageFlutterError.INVALID_ARGUMENT.defaultFlutterError
            result(error)
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
    
    internal func changePhone(arguments: Any?, result: @escaping FlutterResult) {
        guard let newPhone = (arguments as? [String: String])?["newPhone"] else {
            let error = PassageFlutterError.INVALID_ARGUMENT.defaultFlutterError
            result(error)
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
    
    internal func identifierExists(arguments: Any?, result: @escaping FlutterResult) {
        let (identifier, error) = getIdentifier(from: arguments)
        guard let identifier else {
            result(error)
            return
        }
        Task {
            let user = try? await PassageAuth.getUser(identifier: identifier)
            result(convertToJsonString(codable: user))
        }
    }
    
}

extension PassageFlutter {
    
    private func getIdentifier(from arguments: Any?) -> (String?, FlutterError?) {
        guard let identifier = (arguments as? [String: String])?["identifier"] else {
            let error = PassageFlutterError.INVALID_ARGUMENT.defaultFlutterError
            return (nil, error)
        }
        return (identifier, nil)
    }
    
    private func convertToJsonString(codable: Codable?) -> String? {
        let encoder = JSONEncoder()
        guard let codable,
              let jsonData = try? encoder.encode(codable),
              let jsonString = String(data: jsonData, encoding: .utf8)
        else {
            return nil
        }
        return jsonString
    }
    
}
