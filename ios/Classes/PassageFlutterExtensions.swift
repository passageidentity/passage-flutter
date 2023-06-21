import Passage

internal extension AuthResult {
    func convertToDictionary() -> [String: Any] {
        var authResultDict: [String : Any] = [
            "auth_token": authToken,
            "redirect_url": redirectURL
        ]
        if let refreshToken = refreshToken {
            authResultDict["refresh_token"] = refreshToken
        }
        if let refreshTokenExpiration = refreshTokenExpiration {
            authResultDict["refresh_token_expiration"] = refreshTokenExpiration
        }
        return authResultDict
    }
}
