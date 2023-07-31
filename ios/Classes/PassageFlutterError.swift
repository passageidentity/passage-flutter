import Foundation

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
}
