package id.passage.passage_flutter

import id.passage.android.model.AuthResult

internal fun AuthResult.convertToMap(): HashMap<String, Any> {
    val authResultHashMap:  HashMap<String, Any> = hashMapOf(
        "auth_token" to authToken,
        "redirect_url" to redirectUrl
    )
    refreshToken?.let { authResultHashMap["refresh_token"] = it }
    refreshTokenExpiration?.let { authResultHashMap["refresh_token_expiration"] = it }
    return authResultHashMap
}