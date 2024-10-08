package id.passage.passage_flutter

internal enum class PassageFlutterError {
    INVALID_ARGUMENT,
    PASSKEY_ERROR,
    USER_CANCELLED,
    USER_UNAUTHORIZED,
    USER_NOT_FOUND,
    USER_INACTIVE,
    USER_REQUEST,
    USER_SERVER_ERROR,
    METADATA_APP_NOT_FOUND,
    METADATA_INVALID,
    METADATA_FORBIDDEN,
    METADATA_SERVER_ERROR,
    OTP_ERROR,
    MAGIC_LINK_ERROR,
    TOKEN_ERROR,
    APP_INFO_ERROR,
    CHANGE_EMAIL_ERROR,
    CHANGE_PHONE_ERROR,
    IDENTIFIER_EXISTS_ERROR,
    OTP_ACTIVATION_EXCEEDED_ATTEMPTS,
    SOCIAL_AUTH_ERROR,
    START_HOSTED_AUTH_ERROR,
    LOGOUT_HOSTED_AUTH_ERROR,
    FINISH_HOSTED_AUTH_ERROR
}
