package id.passage.passage_flutter

import android.app.Activity
import com.google.gson.Gson
import id.passage.android.Passage
import id.passage.android.PassageToken
import id.passage.android.exceptions.AppInfoException
import id.passage.android.exceptions.PassageUserUnauthorizedException
import id.passage.android.exceptions.RegisterWithPasskeyCancellationException
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

internal class PassageFlutter(private val activity: Activity) {

    private val passage = Passage(activity)

    // region PASSKEY METHODS

    internal fun register(call: MethodCall, result: MethodChannel.Result) {
        val identifier = call.argument<String>("identifier")
            ?: return invalidArgumentError(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val authResult = passage.registerWithPasskey(identifier)
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

    internal fun login(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val authResult = passage.loginWithPasskey("")
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

    // endregion

    // region USER METHODS

    fun getCurrentUser(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val user = passage.getCurrentUser()
                val jsonString = Gson().toJson(user)
                result.success(jsonString)
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

    fun addPasskey(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val user = passage.getCurrentUser() ?: throw PassageUserUnauthorizedException("User is not authorized.")
                val credential = user.addDevicePasskey(activity)
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

    // endregion

    private fun invalidArgumentError(result: MethodChannel.Result) {
        result.error(
            PassageFlutterError.INVALID_ARGUMENT.name,
            "Invalid or missing argument",
            null
        )
    }
}
