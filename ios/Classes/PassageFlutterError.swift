import Flutter

internal enum PassageFlutterError: String {
    case PASSKEYS_NOT_SUPPORTED
    case INVALID_ARGUMENT
    case PASSKEY_ERROR
    case USER_CANCELLED
    case USER_UNAUTHORIZED
    case OTP_ERROR
    case MAGIC_LINK_ERROR
    case TOKEN_ERROR
    case APP_INFO_ERROR
    case CHANGE_EMAIL_ERROR
    case CHANGE_PHONE_ERROR
    
    var defaultMessage: String {
        switch self {
        case .INVALID_ARGUMENT: return "Invalid or missing argument"
        case .PASSKEYS_NOT_SUPPORTED: return "Passkeys only supported in iOS 16 and newer"
        case .USER_CANCELLED: return "User cancelled"
        case .APP_INFO_ERROR: return "Error getting app info"
        default: return ""
        }
    }
    
    var defaultFlutterError: FlutterError {
        return FlutterError(
            code: self.rawValue,
            message: defaultMessage,
            details: nil
        )
    }
}
