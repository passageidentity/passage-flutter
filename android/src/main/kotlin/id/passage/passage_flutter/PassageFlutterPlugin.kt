package id.passage.passage_flutter

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull
import id.passage.passage_flutter.PassageFlutter.Companion.invalidArgumentError

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** PassageFlutterPlugin */
class PassageFlutterPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private lateinit var context: Context
  private lateinit var activity: Activity
  private var passageFlutter: PassageFlutter? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "passage_flutter")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
      if (passageFlutter == null) {
          if (call.method == "initialize") {
              val appId = call.argument<String>("appId") ?: return invalidArgumentError(result)
              passageFlutter =  PassageFlutter(activity, appId)
          }
      }

      when (call.method) {
          "initialize" -> {}
          "registerWithPasskey" -> passageFlutter?.registerWithPasskey(call, result)
          "loginWithPasskey" -> passageFlutter?.loginWithPasskey(call, result)
          "deviceSupportsPasskeys" -> passageFlutter?.deviceSupportsPasskeys(result)
          "newRegisterOneTimePasscode" -> passageFlutter?.newRegisterOneTimePasscode(call, result)
          "newLoginOneTimePasscode" -> passageFlutter?.newLoginOneTimePasscode(call, result)
          "oneTimePasscodeActivate" -> passageFlutter?.oneTimePasscodeActivate(call, result)
          "newRegisterMagicLink" -> passageFlutter?.newRegisterMagicLink(call, result)
          "newLoginMagicLink" -> passageFlutter?.newLoginMagicLink(call, result)
          "magicLinkActivate" -> passageFlutter?.magicLinkActivate(call, result)
          "getMagicLinkStatus" -> passageFlutter?.getMagicLinkStatus(call, result)
          "authorizeWith" -> passageFlutter?.authorizeWith(call, result)
          "finishSocialAuthentication" -> passageFlutter?.finishSocialAuthentication(call, result)
          "getValidAuthToken" -> passageFlutter?.getValidAuthToken(result)
          "isAuthTokenValid" -> passageFlutter?.isAuthTokenValid(call, result)
          "refreshAuthToken" -> passageFlutter?.refreshAuthToken(result)
          "getAppInfo" -> passageFlutter?.getAppInfo(result)
          "identifierExists" -> passageFlutter?.identifierExists(call, result)
          "getCurrentUser" -> passageFlutter?.getCurrentUser(result)
          "signOut" -> passageFlutter?.signOut(result)
          "addPasskey" -> passageFlutter?.addPasskey(call, result)
          "deletePasskey" -> passageFlutter?.deletePasskey(call, result)
          "editPasskeyName" -> passageFlutter?.editPasskeyName(call, result)
          "changeEmail" -> passageFlutter?.changeEmail(call, result)
          "changePhone" -> passageFlutter?.changePhone(call, result)
          "hostedAuthStart" -> passageFlutter?.hostedAuthStart(result)
          "hostedAuthFinish" -> passageFlutter?.hostedAuthFinish(call, result)
          "passkeys" -> passageFlutter?.passkeys(result);
          "socialConnections" -> passageFlutter?.socialConnections(result)
          "deleteSocialConnection" -> passageFlutter?.deleteSocialConnection(call, result)
          "metaData" -> passageFlutter?.metaData(result);
          "updateMetaData" -> passageFlutter?.updateMetaData(call, result)
          "createUser" -> passageFlutter?.createUser(call, result)
          else -> {
              result.notImplemented()
          }
      }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
  }

  override fun onDetachedFromActivity() {
  }

}
