import Flutter
import Passage
import AnyCodable

internal class PassageFlutter {
    
    private let passage: Passage
    
    internal init(appId: String) {
        passage = Passage(appId: appId)
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
                var passkeyCreationOptions: PasskeyCreationOptions? = nil
                if let optionsDictionary = (arguments as? [String: Any])?["options"] as? [String: String],
                   let authenticatorAttachmentString = optionsDictionary["authenticatorAttachment"],
                   let authenticatorAttachment = AuthenticatorAttachment(rawValue: authenticatorAttachmentString)
                {
                    passkeyCreationOptions = PasskeyCreationOptions(authenticatorAttachment: authenticatorAttachment)
                }
                let authResult = try await passage.passkey.register(identifier: identifier, options: passkeyCreationOptions)
                result(convertToJsonString(codable: authResult))
            } catch PassagePasskeyError.canceled {
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
                let authResult = try await passage.passkey.login(identifier: identifier)
                result(convertToJsonString(codable: authResult))
            } catch PassagePasskeyError.canceled {
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
        let language = (arguments as? [String: Any])?["language"] as? String
        Task {
            do {
                let otp = try await passage.oneTimePasscode.register(identifier: identifier, language: language)
                result(otp.otpId)
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
        let language = (arguments as? [String: Any])?["language"] as? String
        Task {
            do {
                let otp = try await passage.oneTimePasscode.login(identifier: identifier, language: language)
                result(otp.otpId)
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
                let authResult = try await passage.oneTimePasscode.activate(otp: otp, id: otpId)
                result(convertToJsonString(codable: authResult))
            } catch {
                var errorCode = PassageFlutterError.OTP_ERROR.rawValue
                if case OneTimePasscodeError.exceededAttempts = error {
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
        let language = (arguments as? [String: Any])?["language"] as? String
        Task {
            do {
                let ml = try await passage.magicLink.register(identifier: identifier, language: language)
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
        let language = (arguments as? [String: Any])?["language"] as? String
        Task {
            do {
                let ml = try await passage.magicLink.login(identifier: identifier, language: language)
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
                let authResult = try await passage.magicLink.activate(magicLink: userMagicLink)
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
                let authResult = try await passage.magicLink.status(id: magicLinkId)
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
                let authResult = try await passage.social.authorize(connection: safeConnection)
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
        
    internal func getValidAuthToken(result: @escaping FlutterResult) {
        Task {
            do {
                let token = try await passage.tokenStore.getValidAuthToken()
                result(token)
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
    
    internal func isAuthTokenValid(arguments: Any?, result: @escaping FlutterResult) {
        guard let authToken = (arguments as? [String: String])?["authToken"] else {
            let error = PassageFlutterError.INVALID_ARGUMENT.defaultFlutterError
            result(error)
            return
        }
        let isValid = passage.tokenStore.isAuthTokenValid()
        result(isValid)
    }
    
    internal func refreshAuthToken(result: @escaping FlutterResult) {
        Task {
            do {
                let authResult = try await passage.tokenStore.refreshTokens()
                result(convertToJsonString(codable: authResult))
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
                let appInfo = try await passage.app.info()
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
                let user = try await passage.currentUser.userInfo()
                result(convertToJsonString(codable: user))
            } catch {
                result(nil)
            }
        }
    }
    
    internal func signOut(result: @escaping FlutterResult) {
        Task {
            try? await passage.currentUser.logOut()
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
                let device = try await passage.currentUser.addPasskey()
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
                try await passage.currentUser.deletePasskey(passkeyId: deviceId)
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
                let deviceInfo = try await passage
                    .currentUser.editPasskey(passkeyId: passkeyId, newFriendlyName: newPasskeyName)
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
        let language = (arguments as? [String: Any])?["language"] as? String
        Task {
            do {
                let magicLink = try await passage.currentUser.changeEmail(newEmail: newEmail, language: language)
                result(magicLink.id)
            } catch let error as CurrentUserError {
                result(handleCurrentUserError(error))
            } catch {
                let flutterError = FlutterError(
                    code: "UNKNOWN_ERROR",
                    message: error.localizedDescription,
                    details: nil
                )
                result(flutterError)
            }
        }
    }
    
    internal func changePhone(arguments: Any?, result: @escaping FlutterResult) {
        guard let newPhone = (arguments as? [String: String])?["newPhone"] else {
            let error = PassageFlutterError.INVALID_ARGUMENT.defaultFlutterError
            result(error)
            return
        }
        let language = (arguments as? [String: Any])?["language"] as? String
        Task {
            do {
                let magicLink = try await passage.currentUser.changePhone(newPhone: newPhone, language: language)
                result(magicLink.id)
            } catch let error as CurrentUserError {
                result(handleCurrentUserError(error))
            } catch {
                let flutterError = FlutterError(
                    code: "UNKNOWN_ERROR",
                    message: error.localizedDescription,
                    details: nil
                )
                result(flutterError)
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
            let user = try? await passage.app.userExists(identifier: identifier)
            result(convertToJsonString(codable: user))
        }
    }

    internal func hostedAuth(result: @escaping FlutterResult) {
        Task {
            do {
                let authResult = try await passage.hosted.authorize()
                result(convertToJsonString(codable: authResult))
            } catch {
                let error = FlutterError(
                    code: PassageFlutterError.START_HOSTED_AUTH_ERROR.rawValue,
                    message: error.localizedDescription,
                    details: nil
                )
                result(error)
            }
        }
    }
    
    internal func passkeys(result: @escaping FlutterResult) {
        Task {
            do {
                let passkeys = try await passage.currentUser.passkeys()
                result(convertToJsonString(codable: passkeys))
            } catch let error as CurrentUserError {
                result(handleCurrentUserError(error))
            } catch {
                result(PassageFlutterError.PASSKEYS_ERROR.defaultFlutterError)
            }
        }
    }

    internal func socialConnections(result: @escaping FlutterResult) {
        Task {
            do {
                let socialConnections = try await passage.currentUser.socialConnections()
                result(convertToJsonString(codable: socialConnections))
            } catch let error as CurrentUserError {
                result(handleCurrentUserError(error))
            } catch {
                result(PassageFlutterError.SOCIAL_CONNECTIONS_ERROR.defaultFlutterError)
            }
        }
    }

    internal func deleteSocialConnection(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? [String: Any],
              let socialConnectionTypeString = args["socialConnectionType"] as? String,
              let socialConnectionType = SocialConnection(rawValue: socialConnectionTypeString) else {
            result(PassageFlutterError.INVALID_ARGUMENT.defaultFlutterError)
            return
        }
        Task {
            do {
                try await passage.currentUser.deleteSocialConnection(socialConnectionType: socialConnectionType)
                result(nil)
            } catch let error as CurrentUserError {
                result(handleCurrentUserError(error))
            } catch {
                result(PassageFlutterError.DELETE_SOCIAL_CONNECTION_ERROR.defaultFlutterError)
            }
        }
    }

    internal func metaData(result: @escaping FlutterResult) {
        Task {
            do {
                let metaData = try await passage.currentUser.metadata()
                result(convertToJsonString(codable: metaData))
            } catch let error as CurrentUserError {
                result(handleCurrentUserError(error))
            } catch {
                result(PassageFlutterError.METADATA_ERROR.defaultFlutterError)
            }
        }
    }

    internal func updateMetaData(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? [String: Any],
              let userMetadata = args["userMetadata"] as? [String: Any] else {
            result(PassageFlutterError.INVALID_ARGUMENT.defaultFlutterError)
            return
        }
        Task {
            do {
                let anyCodableMetadata = AnyCodable(userMetadata)
                let updatedMetaData = try await passage.currentUser.updateMetadata(newMetaData: anyCodableMetadata)
                result(convertToJsonString(codable: updatedMetaData))
            } catch let error as CurrentUserError {
                result(handleCurrentUserError(error))
            } catch {
                result(PassageFlutterError.METADATA_UPDATE_ERROR.defaultFlutterError)
            }
        }
    }

    internal func createUser(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? [String: Any],
              let identifier = args["identifier"] as? String else {
            result(PassageFlutterError.INVALID_ARGUMENT.defaultFlutterError)
            return
        }
        let userMetadata = args["userMetadata"] as? [String: Any]
        Task {
            do {
                let user = try await passage.app.createUser(identifier: identifier, userMetadata: userMetadata.map { AnyCodable($0) })
                result(convertToJsonString(codable: user))
            } catch {
                result(PassageFlutterError.CREATE_USER_ERROR.defaultFlutterError)
            }
        }
    }

    func handleCurrentUserError(_ error: CurrentUserError) -> FlutterError {
        switch error {
        case .authorizationFailed(let message):
            return PassageFlutterError.USER_UNAUTHORIZED.defaultFlutterError
        case .canceled(let message):
            return PassageFlutterError.USER_CANCELLED.defaultFlutterError
        case .invalidRequest(let message):
            return PassageFlutterError.INVALID_ARGUMENT.defaultFlutterError
        case .unauthorized(let message):
            return PassageFlutterError.USER_UNAUTHORIZED.defaultFlutterError
        case .unspecified(let message):
            return PassageFlutterError.PASSKEY_ERROR.defaultFlutterError
        case .userNotActive(let message):
            return PassageFlutterError.USER_INACTIVE.defaultFlutterError
        case .userNotFound(let message):
            return PassageFlutterError.USER_NOT_FOUND.defaultFlutterError
        default:
            return PassageFlutterError.PASSKEY_ERROR.defaultFlutterError
        }
    }
    
}

extension PassageFlutter {
    
    private func getIdentifier(from arguments: Any?) -> (String?, FlutterError?) {
        guard let identifier = (arguments as? [String: Any])?["identifier"] as? String else {
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
