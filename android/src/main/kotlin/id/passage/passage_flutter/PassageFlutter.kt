package id.passage.passage_flutter

import android.app.Activity
import android.os.Build
import com.google.gson.FieldNamingPolicy
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import id.passage.android.Passage
import id.passage.android.exceptions.AppInfoException
import id.passage.android.exceptions.GetMetadataAppNotFoundException
import id.passage.android.exceptions.GetMetadataForbiddenException
import id.passage.android.exceptions.GetMetadataInvalidException
import id.passage.android.exceptions.LoginWithPasskeyCancellationException
import id.passage.android.exceptions.OneTimePasscodeActivateExceededAttemptsException
import id.passage.android.exceptions.PassageUserInactiveUserException
import id.passage.android.exceptions.PassageUserNotFoundException
import id.passage.android.exceptions.PassageUserRequestException
import id.passage.android.exceptions.PassageUserUnauthorizedException
import id.passage.android.exceptions.RegisterWithPasskeyCancellationException
import id.passage.android.model.AuthenticatorAttachment
import id.passage.android.utils.Metadata
import id.passage.android.utils.Passkey
import id.passage.android.utils.PasskeyCreationOptions
import id.passage.android.utils.SocialConnection
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

internal class PassageFlutter(private val activity: Activity, appId: String) {

    private val passage: Passage = Passage(activity, appId)

    internal companion object {
        internal fun invalidArgumentError(result: MethodChannel.Result) {
            result.error(
                PassageFlutterError.INVALID_ARGUMENT.name, "Invalid or missing argument", null
            )
        }
    }

    // region PASSKEY METHODS

    internal fun registerWithPasskey(call: MethodCall, result: MethodChannel.Result) {
        val identifier = call.argument<String>("identifier") ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                var options: PasskeyCreationOptions? = null
                call.argument<Map<String, String>>("options")?.let { map ->
                    map["authenticatorAttachment"]?.let { authAttachmentString ->
                        AuthenticatorAttachment.decode(authAttachmentString)
                            ?.let { authenticatorAttachment ->
                                options = PasskeyCreationOptions(authenticatorAttachment)
                            }
                    }
                }
                val authResult = passage.passkey.register(identifier, options)
                val jsonString = Gson().toJson(authResult)
                result.success(jsonString)
            } catch (e: Exception) {
                val error = when (e) {
                    is RegisterWithPasskeyCancellationException -> {
                        PassageFlutterError.USER_CANCELLED
                    }

                    else -> PassageFlutterError.PASSKEY_ERROR
                }
                result.error(error.name, e.message, e.toString())
            }
        }
    }

    internal fun loginWithPasskey(call: MethodCall, result: MethodChannel.Result) {
        val identifier = call.argument<String>("identifier")
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val authResult = passage.passkey.login(identifier)
                val jsonString = Gson().toJson(authResult)
                result.success(jsonString)
            } catch (e: Exception) {
                val error = when (e) {
                    is LoginWithPasskeyCancellationException -> {
                        PassageFlutterError.USER_CANCELLED
                    }

                    else -> PassageFlutterError.PASSKEY_ERROR
                }
                result.error(error.name, e.message, e.toString())
            }
        }
    }

    fun deviceSupportsPasskeys(result: MethodChannel.Result) {
        val supportsPasskeys = Build.VERSION.SDK_INT > 27
        result.success(supportsPasskeys)
    }

    // endregion

    // region OTP METHODS

    fun newRegisterOneTimePasscode(call: MethodCall, result: MethodChannel.Result) {
        val identifier = call.argument<String>("identifier") ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val otpId = passage.oneTimePasscode.register(identifier).otpId
                result.success(otpId)
            } catch (e: Exception) {
                result.error(PassageFlutterError.OTP_ERROR.name, e.message, e.toString())
            }
        }
    }

    fun newLoginOneTimePasscode(call: MethodCall, result: MethodChannel.Result) {
        val identifier = call.argument<String>("identifier") ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val otpId = passage.oneTimePasscode.login(identifier).otpId
                result.success(otpId)
            } catch (e: Exception) {
                result.error(PassageFlutterError.OTP_ERROR.name, e.message, e.toString())
            }
        }
    }

    fun oneTimePasscodeActivate(call: MethodCall, result: MethodChannel.Result) {
        val otp = call.argument<String>("otp") ?: return invalidArgumentError(result)
        val otpId = call.argument<String>("otpId") ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val authResult = passage.oneTimePasscode.activate(otp, otpId)
                val jsonString = Gson().toJson(authResult)
                result.success(jsonString)
            } catch (e: OneTimePasscodeActivateExceededAttemptsException) {
                result.error(
                    PassageFlutterError.OTP_ACTIVATION_EXCEEDED_ATTEMPTS.name,
                    e.message,
                    e.toString()
                )
            } catch (e: Exception) {
                result.error(PassageFlutterError.OTP_ERROR.name, e.message, e.toString())
            }
        }
    }

    // endregion

    // region MAGIC LINK METHODS

    fun newRegisterMagicLink(call: MethodCall, result: MethodChannel.Result) {
        val identifier = call.argument<String>("identifier") ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val magicLinkId = passage.magicLink.register(identifier).id
                result.success(magicLinkId)
            } catch (e: Exception) {
                result.error(PassageFlutterError.MAGIC_LINK_ERROR.name, e.message, e.toString())
            }
        }
    }

    fun newLoginMagicLink(call: MethodCall, result: MethodChannel.Result) {
        val identifier = call.argument<String>("identifier") ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val magicLinkId = passage.magicLink.login(identifier).id
                result.success(magicLinkId)
            } catch (e: Exception) {
                result.error(PassageFlutterError.MAGIC_LINK_ERROR.name, e.message, e.toString())
            }
        }
    }

    fun magicLinkActivate(call: MethodCall, result: MethodChannel.Result) {
        val magicLink = call.argument<String>("magicLink") ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val authResult = passage.magicLink.activate(magicLink)
                val jsonString = Gson().toJson(authResult)
                result.success(jsonString)
            } catch (e: Exception) {
                result.error(PassageFlutterError.MAGIC_LINK_ERROR.name, e.message, e.toString())
            }
        }
    }

    fun getMagicLinkStatus(call: MethodCall, result: MethodChannel.Result) {
        val magicLinkId =
            call.argument<String>("magicLinkId") ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val authResult = passage.magicLink.status(magicLinkId)
                val jsonString = Gson().toJson(authResult)
                result.success(jsonString)
            } catch (e: Exception) {
                result.error(PassageFlutterError.MAGIC_LINK_ERROR.name, e.message, e.toString())
            }
        }
    }

    // endregion

    // region SOCIAL METHODS
    fun authorizeWith(call: MethodCall, result: MethodChannel.Result) {
        val connection = call.argument<String>("connection") ?: return invalidArgumentError(result)
        val validConnection =
            SocialConnection.values().firstOrNull { it.value == connection } ?: return result.error(
                PassageFlutterError.SOCIAL_AUTH_ERROR.name, "Invalid connection type", null
            )
        passage.social.authorize(validConnection)
        result.success(null)
    }

    fun finishSocialAuthentication(call: MethodCall, result: MethodChannel.Result) {
        val authCode = call.argument<String>("code") ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val authResult = passage.social.finish(authCode)
                val jsonString = Gson().toJson(authResult)
                result.success(jsonString)
            } catch (e: Exception) {
                result.error(PassageFlutterError.SOCIAL_AUTH_ERROR.name, e.message, e.toString())
            }
        }
    }

    // endregion

    // region TOKEN METHODS
    fun getValidAuthToken(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val newToken = passage.tokenStore.getValidAuthToken()
                result.success(newToken)
            } catch (e: Exception) {
                result.error(PassageFlutterError.TOKEN_ERROR.name, e.message, e.toString())
            }
        }
    }

    fun isAuthTokenValid(call: MethodCall, result: MethodChannel.Result) {
        val authToken = call.argument<String>("authToken") ?: return invalidArgumentError(result)
        val isValid = passage.tokenStore.isAuthTokenValid(authToken)
        result.success(isValid)
    }

    fun refreshAuthToken(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val refreshToken = passage.tokenStore.refreshToken ?: ""
                val authResult = passage.tokenStore.refreshAuthToken(refreshToken)
                val jsonString = Gson().toJson(authResult)
                result.success(jsonString)
            } catch (e: Exception) {
                result.error(PassageFlutterError.TOKEN_ERROR.name, e.message, e.toString())
            }
        }
    }

    // endregion

    // region APP METHODS
    fun getAppInfo(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val appInfo = passage.app.info() ?: throw AppInfoException("Error getting app info")
                val jsonString = Gson().toJson(appInfo)
                result.success(jsonString)
            } catch (e: Exception) {
                result.error(PassageFlutterError.APP_INFO_ERROR.name, e.message, e.toString())
            }
        }
    }

    fun identifierExists(call: MethodCall, result: MethodChannel.Result) {
        val identifier = call.argument<String>("identifier") ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val user = passage.app.userExists(identifier)
                val jsonString = if (user == null) null else Gson().toJson(user)
                result.success(jsonString)
            } catch (e: Exception) {
                result.error(
                    PassageFlutterError.IDENTIFIER_EXISTS_ERROR.name, e.message, e.toString()
                )
            }
        }
    }

    fun createUser(call: MethodCall, result: MethodChannel.Result) {
        val identifier = call.argument<String>("identifier") ?: return invalidArgumentError(result)
        val userMetadata = call.argument<String?>("userMetadata")
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val user = passage.app.createUser(identifier, userMetadata)
                val jsonString = if (user == null) null else Gson().toJson(user)
                result.success(jsonString)
            } catch (e: Exception) {
                result.error(
                    PassageFlutterError.IDENTIFIER_EXISTS_ERROR.name, e.message, e.toString()
                )
            }
        }
    }

    // endregion

    // region USER METHODS

    fun getCurrentUser(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val user = passage.currentUser.userInfo()
                if (user == null) {
                    result.success(null)
                } else {
                    val jsonString = Gson().toJson(user)
                    result.success(jsonString)
                }
            } catch (e: Exception) {
                result.success(null)
            }
        }
    }

    fun signOut(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                passage.currentUser.logout()
                result.success(null)
            } catch (e: Exception) {
                result.success(null)
            }
        }
    }

    fun addPasskey(call: MethodCall, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val user = passage.currentUser.userInfo() ?: throw PassageUserUnauthorizedException(
                    "User is not authorized."
                )
                var options: PasskeyCreationOptions? = null
                call.argument<Map<String, String>>("options")?.let { map ->
                    map["authenticatorAttachment"]?.let { authAttachmentString ->
                        AuthenticatorAttachment.decode(authAttachmentString)
                            ?.let { authenticatorAttachment ->
                                options = PasskeyCreationOptions(authenticatorAttachment)
                            }
                    }
                }
                val credential = passage.currentUser.addPasskey(options)
                val jsonString = Gson().toJson(credential)
                result.success(jsonString)
            } catch (e: Exception) {
                val error = when (e) {
                    is RegisterWithPasskeyCancellationException -> {
                        PassageFlutterError.USER_CANCELLED
                    }

                    is PassageUserUnauthorizedException -> {
                        PassageFlutterError.USER_UNAUTHORIZED
                    }

                    else -> PassageFlutterError.PASSKEY_ERROR
                }
                result.error(error.name, e.message, e.toString())
            }
        }
    }

    fun deletePasskey(call: MethodCall, result: MethodChannel.Result) {
        val passkeyId = call.argument<String>("passkeyId") ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val user = passage.currentUser.userInfo() ?: throw PassageUserUnauthorizedException(
                    "User is not authorized."
                )
                passage.currentUser.deletePasskey(passkeyId)
                result.success(null)
            } catch (e: Exception) {
                val error = when (e) {
                    is PassageUserUnauthorizedException -> {
                        PassageFlutterError.USER_UNAUTHORIZED
                    }

                    else -> PassageFlutterError.PASSKEY_ERROR
                }
                result.error(error.name, e.message, e.toString())
            }
        }
    }

    fun editPasskeyName(call: MethodCall, result: MethodChannel.Result) {
        val passkeyId = call.argument<String>("passkeyId") ?: return invalidArgumentError(result)
        val newPasskeyName =
            call.argument<String>("newPasskeyName") ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val user = passage.currentUser.userInfo() ?: throw PassageUserUnauthorizedException(
                    "User is not authorized."
                )
                val credential = passage.currentUser.editPasskey(passkeyId, newPasskeyName)
                result.success(credential)
            } catch (e: Exception) {
                val error = when (e) {
                    is PassageUserUnauthorizedException -> {
                        PassageFlutterError.USER_UNAUTHORIZED
                    }

                    else -> PassageFlutterError.PASSKEY_ERROR
                }
                result.error(error.name, e.message, e.toString())
            }
        }
    }

    fun changeEmail(call: MethodCall, result: MethodChannel.Result) {
        val newEmail = call.argument<String>("newEmail") ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val user = passage.currentUser.userInfo() ?: throw PassageUserUnauthorizedException(
                    "User is not authorized."
                )
                val magicLinkId = passage.currentUser.changeEmail(newEmail)?.id
                result.success(magicLinkId)
            } catch (e: Exception) {
                val error = when (e) {
                    is PassageUserUnauthorizedException -> {
                        PassageFlutterError.USER_UNAUTHORIZED
                    }

                    else -> PassageFlutterError.CHANGE_EMAIL_ERROR
                }
                result.error(error.name, e.message, e.toString())
            }
        }
    }

    fun changePhone(call: MethodCall, result: MethodChannel.Result) {
        val newPhone = call.argument<String>("newPhone") ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val user = passage.currentUser.userInfo()
                val magicLinkId = passage.currentUser.changePhone(newPhone)?.id
                result.success(magicLinkId)
            } catch (e: Exception) {
                val error = when (e) {
                    is PassageUserUnauthorizedException -> {
                        PassageFlutterError.USER_UNAUTHORIZED
                    }

                    else -> PassageFlutterError.CHANGE_PHONE_ERROR
                }
                result.error(error.name, e.message, e.toString())
            }
        }
    }

    fun passkeys(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val passkeys = passage.currentUser.passkeys()
                val gson =
                    GsonBuilder().setFieldNamingPolicy(FieldNamingPolicy.LOWER_CASE_WITH_UNDERSCORES)
                        .create()

                val passkeyListType = object : TypeToken<List<Passkey>>() {}.type
                val passkeysJson = gson.toJson(passkeys, passkeyListType)

                result.success(passkeysJson) // Pass the serialized list to Flutter
            } catch (e: Exception) {
                val error = when (e) {
                    is PassageUserUnauthorizedException -> {
                        PassageFlutterError.USER_UNAUTHORIZED
                    }

                    is PassageUserNotFoundException -> {
                        PassageFlutterError.USER_NOT_FOUND
                    }

                    is PassageUserInactiveUserException -> {
                        PassageFlutterError.USER_INACTIVE
                    }

                    is PassageUserRequestException -> {
                        PassageFlutterError.USER_REQUEST
                    }

                    else -> PassageFlutterError.USER_SERVER_ERROR
                }
                result.error(error.name, e.message, e.toString())
            }
        }
    }

    fun socialConnections(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val socialConnections =
                    passage.currentUser.socialConnections() // Retrieve the social connections

                // Convert the UserSocialConnections object to JSON
                val gson = Gson()
                val socialConnectionsJson = gson.toJson(socialConnections) // Returns JSON string

                result.success(socialConnectionsJson) // Pass the serialized JSON string to Flutter
            } catch (e: Exception) {
                val error = when (e) {
                    is PassageUserUnauthorizedException -> {
                        PassageFlutterError.USER_UNAUTHORIZED
                    }

                    is PassageUserNotFoundException -> {
                        PassageFlutterError.USER_NOT_FOUND
                    }

                    is PassageUserInactiveUserException -> {
                        PassageFlutterError.USER_INACTIVE
                    }

                    is PassageUserRequestException -> {
                        PassageFlutterError.USER_REQUEST
                    }

                    else -> PassageFlutterError.USER_SERVER_ERROR
                }
                result.error(error.name, e.message, e.toString())

            }
        }
    }


    fun deleteSocialConnection(call: MethodCall, result: MethodChannel.Result) {
        val socialConnectionTypeString =
            call.argument<String>("socialConnectionType") ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val socialConnectionType =
                    SocialConnection.values().firstOrNull { it.value == socialConnectionTypeString }
                        ?: throw IllegalArgumentException("Unknown social connection type")

                passage.currentUser.deleteSocialConnection(socialConnectionType)

                result.success(null)
            } catch (e: Exception) {
                val error = when (e) {
                    is PassageUserUnauthorizedException -> {
                        PassageFlutterError.USER_UNAUTHORIZED
                    }

                    is PassageUserNotFoundException -> {
                        PassageFlutterError.USER_NOT_FOUND
                    }

                    is PassageUserInactiveUserException -> {
                        PassageFlutterError.USER_INACTIVE
                    }

                    is PassageUserRequestException -> {
                        PassageFlutterError.USER_REQUEST
                    }

                    else -> PassageFlutterError.USER_SERVER_ERROR
                }
                result.error(error.name, e.message, e.toString())

            }
        }
    }

    fun metaData(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val metaData = passage.currentUser.metadata()
                val jsonString = Gson().toJson(metaData)
                result.success(jsonString)
            } catch (e: Exception) {
                val error = when (e) {
                    is GetMetadataAppNotFoundException -> {
                        PassageFlutterError.METADATA_APP_NOT_FOUND
                    }

                    is GetMetadataInvalidException -> {
                        PassageFlutterError.METADATA_INVALID
                    }

                    is GetMetadataForbiddenException -> {
                        PassageFlutterError.METADATA_FORBIDDEN
                    }

                    else -> PassageFlutterError.METADATA_SERVER_ERROR
                }
                result.error(error.name, e.message, e.toString())

            }
        }
    }

    fun updateMetaData(call: MethodCall, result: MethodChannel.Result) {
        val metaDataMap = call.argument<Map<String, Any>>("userMetadata") ?: return invalidArgumentError(result)

        CoroutineScope(Dispatchers.IO).launch {
            try {
                if (metaDataMap == null) {
                    result.error("ERROR", "Metadata is null", null)
                    return@launch
                }

                val metaData = Metadata(userMetadata = metaDataMap)

                val updatedMetaData = passage.currentUser.updateMetadata(metaData)

                val jsonString = Gson().toJson(updatedMetaData)

                result.success(jsonString)
            } catch (e: Exception) {
                val error = when (e) {
                    is GetMetadataAppNotFoundException -> {
                        PassageFlutterError.METADATA_APP_NOT_FOUND
                    }

                    is GetMetadataInvalidException -> {
                        PassageFlutterError.METADATA_INVALID
                    }

                    is GetMetadataForbiddenException -> {
                        PassageFlutterError.METADATA_FORBIDDEN
                    }

                    else -> PassageFlutterError.METADATA_SERVER_ERROR
                }
                result.error(error.name, e.message, e.toString())
            }
        }
    }

    // endregion

    // region Hosted Auth 


    fun hostedAuthStart(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                passage.hosted.start()
                result.success(null)
            } catch (e: Exception) {
                val error = PassageFlutterError.START_HOSTED_AUTH_ERROR
                result.error(error.name, e.message, e.toString())
            }
        }
    }


    fun hostedAuthFinish(call: MethodCall, result: MethodChannel.Result) {
        val code = call.argument<String>("code") ?: return invalidArgumentError(result)
        val state = call.argument<String>("state") ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val authResultWithIdToken = passage.hosted.finish(code, state)
                val jsonString = Gson().toJson(authResultWithIdToken.first)
                val map = mapOf(
                    "authResult" to jsonString, "idToken" to authResultWithIdToken.second
                )
                result.success(map)
            } catch (e: Exception) {
                val error = PassageFlutterError.FINISH_HOSTED_AUTH_ERROR
                result.error(error.name, e.message, e.toString())
            }
        }
    }

    // endregion

}
