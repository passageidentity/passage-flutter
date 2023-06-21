package id.passage.passage_flutter

import android.app.Activity
import id.passage.android.Passage
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
                result.success(authResult.convertToMap())
            } catch (e: Exception) {
                result.error(PassageFlutterError.REGISTRATION_ERROR.name, e.message, e.toString())
            }
        }
    }

    internal fun login(call: MethodCall, result: MethodChannel.Result) {
        val identifier = call.argument<String>("identifier")
            ?: return result.error(
                PassageFlutterError.INVALID_ARGUMENT.name,
                "Invalid identifier.",
                null
            )
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val authResult = passage.loginWithPasskey(identifier)
                result.success(authResult.convertToMap())
            } catch (e: Exception) {
                result.error(PassageFlutterError.LOGIN_ERROR.name, e.message, e.toString())
            }
        }
    }

}
