package id.passage.passage_flutter

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull

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
  private lateinit var passageFlutter: PassageFlutter

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "passage_flutter")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
        "register" -> passageFlutter.register(call, result)
        "login" -> passageFlutter.login(result)
        "newRegisterOneTimePasscode" -> passageFlutter.newRegisterOneTimePasscode(call, result)
        "newLoginOneTimePasscode" -> passageFlutter.newLoginOneTimePasscode(call, result)
        "oneTimePasscodeActivate" -> passageFlutter.oneTimePasscodeActivate(call, result)
        "newRegisterMagicLink" -> passageFlutter.newRegisterMagicLink(call, result)
        "newLoginMagicLink" -> passageFlutter.newLoginMagicLink(call, result)
        "magicLinkActivate" -> passageFlutter.magicLinkActivate(call, result)
        "getMagicLinkStatus" -> passageFlutter.getMagicLinkStatus(call, result)
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
    passageFlutter = PassageFlutter((activity))
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }

}
