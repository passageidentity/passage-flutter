package id.passage.passage_flutter

import android.app.Activity
import android.util.Log
import com.google.gson.Gson
import id.passage.android.Passage
import id.passage.android.exceptions.RegisterWithPasskeyCancellationException
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

internal class PassageFlutter(activity: Activity) {

    private val passage = Passage(activity)

    internal fun register(call: MethodCall, result: MethodChannel.Result) {
        val identifier = call.argument<String>("identifier")
            ?: return result.error(
                PassageFlutterError.INVALID_ARGUMENT.name,
                "Invalid identifier.",
                null
            )
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

    // region OTP METHODS

    fun newRegisterOneTimePasscode(call: MethodCall, result: MethodChannel.Result) {
        val identifier = call.argument<String>("identifier")
            ?: return result.error(
                PassageFlutterError.INVALID_ARGUMENT.name,
                "Invalid identifier.",
                null
            )
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
            ?: return result.error(
                PassageFlutterError.INVALID_ARGUMENT.name,
                "Invalid identifier.",
                null
            )
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
            ?: return result.error(
                PassageFlutterError.INVALID_ARGUMENT.name,
                "Invalid OTP",
                null
            )
        val otpId = call.argument<String>("otpId")
            ?: return result.error(
                PassageFlutterError.INVALID_ARGUMENT.name,
                "Invalid OTP id",
                null
            )
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
            ?: return result.error(
                PassageFlutterError.INVALID_ARGUMENT.name,
                "Invalid identifier.",
                null
            )
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
            ?: return result.error(
                PassageFlutterError.INVALID_ARGUMENT.name,
                "Invalid identifier.",
                null
            )
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
            ?: return result.error(
                PassageFlutterError.INVALID_ARGUMENT.name,
                "Invalid magic link",
                null
            )
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
            ?: return result.error(
                PassageFlutterError.INVALID_ARGUMENT.name,
                "Invalid magic link id",
                null
            )
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


}
