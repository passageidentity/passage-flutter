package id.passage.passage_flutter

import android.app.Activity
import android.os.Build
import com.google.gson.Gson
import id.passage.android.Passage
import id.passage.android.PassageSocialConnection
import id.passage.android.PassageToken
import id.passage.android.PasskeyCreationOptions
import id.passage.android.exceptions.AppInfoException
import id.passage.android.exceptions.LoginWithPasskeyCancellationException
import id.passage.android.exceptions.OneTimePasscodeActivateExceededAttemptsException
import id.passage.android.exceptions.PassageUserUnauthorizedException
import id.passage.android.exceptions.RegisterWithPasskeyCancellationException
import id.passage.android.model.AuthenticatorAttachment
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

internal class PassageFlutter(private val activity: Activity, appId: String? = null) {

    private val passage: Passage = Passage(activity, appId)

    internal companion object {
        internal fun invalidArgumentError(result: MethodChannel.Result) {
            result.error(
                PassageFlutterError.INVALID_ARGUMENT.name,
                "Invalid or missing argument",
                null
            )
        }
    }

    // region PASSKEY METHODS

    internal fun registerWithPasskey(call: MethodCall, result: MethodChannel.Result) {
        val identifier = call.argument<String>("identifier")
            ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                var options: PasskeyCreationOptions? = null
                call.argument<Map<String, String>>("options")?.let { map ->
                    map["authenticatorAttachment"]?.let { authAttachmentString ->
                        AuthenticatorAttachment.decode(authAttachmentString)?.let { authenticatorAttachment ->
                            options = PasskeyCreationOptions(authenticatorAttachment)
                        }
                    }
                }
                val authResult = passage.registerWithPasskey(identifier, options)
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
                val authResult = passage.loginWithPasskey(identifier)
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
        val identifier = call.argument<String>("identifier")
            ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val otpId = passage.newRegisterOneTimePasscode(identifier).otpId
                result.success(otpId)
            } catch (e: Exception) {
                result.error(PassageFlutterError.OTP_ERROR.name, e.message, e.toString())
            }
        }
    }

    fun newLoginOneTimePasscode(call: MethodCall, result: MethodChannel.Result) {
        val identifier = call.argument<String>("identifier")
            ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val otpId = passage.newLoginOneTimePasscode(identifier).otpId
                result.success(otpId)
            } catch (e: Exception) {
                result.error(PassageFlutterError.OTP_ERROR.name, e.message, e.toString())
            }
        }
    }

    fun oneTimePasscodeActivate(call: MethodCall, result: MethodChannel.Result) {
        val otp = call.argument<String>("otp")
            ?: return invalidArgumentError(result)
        val otpId = call.argument<String>("otpId")
            ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val authResult = passage.oneTimePasscodeActivate(otp, otpId)
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
        val identifier = call.argument<String>("identifier")
            ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val magicLinkId = passage.newRegisterMagicLink(identifier).id
                result.success(magicLinkId)
            } catch (e: Exception) {
                result.error(PassageFlutterError.MAGIC_LINK_ERROR.name, e.message, e.toString())
            }
        }
    }

    fun newLoginMagicLink(call: MethodCall, result: MethodChannel.Result) {
        val identifier = call.argument<String>("identifier")
            ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val magicLinkId = passage.newLoginMagicLink(identifier).id
                result.success(magicLinkId)
            } catch (e: Exception) {
                result.error(PassageFlutterError.MAGIC_LINK_ERROR.name, e.message, e.toString())
            }
        }
    }

    fun magicLinkActivate(call: MethodCall, result: MethodChannel.Result) {
        val magicLink = call.argument<String>("magicLink")
            ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val authResult = passage.magicLinkActivate(magicLink)
                val jsonString = Gson().toJson(authResult)
                result.success(jsonString)
            } catch (e: Exception) {
                result.error(PassageFlutterError.MAGIC_LINK_ERROR.name, e.message, e.toString())
            }
        }
    }

    fun getMagicLinkStatus(call: MethodCall, result: MethodChannel.Result) {
        val magicLinkId = call.argument<String>("magicLinkId")
            ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val authResult = passage.getMagicLinkStatus(magicLinkId)
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
        val connection = call.argument<String>("connection")
            ?: return invalidArgumentError(result)
        val validConnection = PassageSocialConnection.values().firstOrNull { it.value == connection }
            ?: return result.error(PassageFlutterError.SOCIAL_AUTH_ERROR.name, "Invalid connection type", null)
        passage.authorizeWith(validConnection)
        result.success(null)
    }

    fun finishSocialAuthentication(call: MethodCall, result: MethodChannel.Result) {
        val authCode = call.argument<String>("code")
            ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val authResult = passage.finishSocialAuthentication(authCode)
                val jsonString = Gson().toJson(authResult)
                result.success(jsonString)
            } catch (e: Exception) {
                result.error(PassageFlutterError.SOCIAL_AUTH_ERROR.name, e.message, e.toString())
            }
        }
    }

    // endregion

    // region TOKEN METHODS
    fun getAuthToken(result: MethodChannel.Result) {
        val token = passage.tokenStore.authToken
        result.success(token)
    }

    fun isAuthTokenValid(call: MethodCall, result: MethodChannel.Result) {
        val authToken = call.argument<String>("authToken")
            ?: return invalidArgumentError(result)
        val isValid = PassageToken.isAuthTokenValid(authToken)
        result.success(isValid)
    }

    fun refreshAuthToken(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val newToken = passage.tokenStore.getValidAuthToken()
                result.success(newToken)
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
                val appInfo = passage.appInfo() ?: throw AppInfoException("Error getting app info")
                val jsonString = Gson().toJson(appInfo)
                result.success(jsonString)
            } catch (e: Exception) {
                result.error(PassageFlutterError.APP_INFO_ERROR.name, e.message, e.toString())
            }
        }
    }

    fun identifierExists(call: MethodCall, result: MethodChannel.Result) {
        val identifier = call.argument<String>("identifier")
            ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val user = passage.identifierExists(identifier)
                val jsonString = if (user== null) null else Gson().toJson(user)
                result.success(jsonString)
            } catch (e: Exception) {
                result.error(PassageFlutterError.IDENTIFIER_EXISTS_ERROR.name, e.message, e.toString())
            }
        }
    }

    // endregion

    // region USER METHODS

    fun getCurrentUser(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val user = passage.getCurrentUser()
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
                passage.signOutCurrentUser()
                result.success(null)
            } catch (e: Exception) {
                result.success(null)
            }
        }
    }

    fun addPasskey(call: MethodCall, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val user = passage.getCurrentUser()
                    ?: throw PassageUserUnauthorizedException("User is not authorized.")
                var options: PasskeyCreationOptions? = null
                call.argument<Map<String, String>>("options")?.let { map ->
                    map["authenticatorAttachment"]?.let { authAttachmentString ->
                        AuthenticatorAttachment.decode(authAttachmentString)?.let { authenticatorAttachment ->
                            options = PasskeyCreationOptions(authenticatorAttachment)
                        }
                    }
                }
                val credential = user.addDevicePasskey(activity, options)
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
        val passkeyId = call.argument<String>("passkeyId")
            ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val user = passage.getCurrentUser() ?: throw PassageUserUnauthorizedException("User is not authorized.")
                user.deleteDevicePasskey(passkeyId)
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
        val passkeyId = call.argument<String>("passkeyId")
            ?: return invalidArgumentError(result)
        val newPasskeyName = call.argument<String>("newPasskeyName")
            ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val user = passage.getCurrentUser() ?: throw PassageUserUnauthorizedException("User is not authorized.")
                val credential = user.editDevicePasskeyName(passkeyId, newPasskeyName)
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
        val newEmail = call.argument<String>("newEmail")
            ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val user = passage.getCurrentUser() ?: throw PassageUserUnauthorizedException("User is not authorized.")
                val magicLinkId = user.changeEmail(newEmail)?.id
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
        val newPhone = call.argument<String>("newPhone")
            ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val user = passage.getCurrentUser() ?: throw PassageUserUnauthorizedException("User is not authorized.")
                val magicLinkId = user.changePhone(newPhone)?.id
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

    fun overrideBasePath(call: MethodCall, result: MethodChannel.Result) {
        val path = call.argument<String>("path")
            ?: return invalidArgumentError(result)
        passage.overrideBasePath(path)
        result.success(null)
    }

    // endregion

    // region Hosted Auth 


    fun hostedAuthStart(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                passage.hostedAuthStart()
                result.success(null)
            } catch (e: Exception) {
                val error = PassageFlutterError.START_HOSTED_AUTH_ERROR
                result.error(error.name, e.message, e.toString())
            }
        }
    }


    fun hostedAuthFinish(call: MethodCall, result: MethodChannel.Result) {
        val code = call.argument<String>("code")
            ?: return invalidArgumentError(result)
        val state = call.argument<String>("state")
            ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val authResultWithIdToken = passage.hostedAuthFinish(code, state) 
                val jsonString = Gson().toJson(authResultWithIdToken.first)
                val map = mapOf(
                    "authResult" to jsonString,
                    "idToken" to authResultWithIdToken.second
                )
                result.success(map)
            } catch (e: Exception) {
                val error = PassageFlutterError.FINISH_HOSTED_AUTH_ERROR
                result.error(error.name, e.message, e.toString())
            }
        }
    }

    fun hostedLogout(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                passage.hostedLogout()
                result.success(null)
            } catch (e: Exception) {
                val error = PassageFlutterError.LOGOUT_HOSTED_AUTH_ERROR
                result.error(error.name, e.message, e.toString())
            }
        }
    }

    // endregion

}
