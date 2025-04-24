package com.wearetoni.apk_manager

import android.app.Activity
import android.content.pm.PackageManager
import com.wearetoni.apk_manager.impl.ApkUninstaller
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** ApkManagerPlugin */
class ApkManagerPlugin : FlutterPlugin, ActivityAware, AndroidApkManagerApi {
  private var activity: Activity? = null

  // --- Setup ---

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    AndroidApkManagerApi.setUp(flutterPluginBinding.binaryMessenger, this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    AndroidApkManagerApi.setUp(binding.binaryMessenger, null)
  }

  // --- Activity Setup ---

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  // --- Implementations ---

  override fun installApk(path: String, callback: (Result<InstallResultMsg>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun uninstallApk(packageName: String, callback: (Result<Unit>) -> Unit) {
    val act = activity
    if (act == null) {
      callback(Result.failure(Exception("Activity is missing")))
    } else {
      ApkUninstaller(act).uninstallPackage(packageName, callback)
    }
  }

  override fun getPackageNameFromApk(path: String): String? {
    return activity
      ?.packageManager
      ?.getPackageArchiveInfo(path, 0)
      ?.packageName
  }

  override fun getAppInfo(packageName: String): PackageInfoMsg? {
    val manager = activity?.packageManager ?: return null
    return try {
      val appInfo = manager.getPackageInfo(packageName, 0)
      return PackageInfoMsg(
        appInfo.packageName,
        appInfo.versionName,
        appInfo.firstInstallTime,
      )
    } catch (e: PackageManager.NameNotFoundException) {
      null
    }
  }

  override fun launchApp(packageName: String): Boolean {
    val act = activity ?: return false
    try {
      val intent = act.packageManager.getLaunchIntentForPackage(packageName)
      if (intent != null) {
        act.startActivity(intent)
        return true
      }
    } catch (_: Exception) {}
    return false
  }
}
