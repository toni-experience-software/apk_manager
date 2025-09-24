package com.wearetoni.apk_manager

import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import androidx.annotation.Keep
import com.wearetoni.apk_manager.impl.ApkInstaller
import com.wearetoni.apk_manager.impl.ApkUninstaller

@Keep
data class InstallResultMsg (
  val packageName: String? = null,
  val status: Long
)

@Keep
data class PackageInfoMsg (
  val packageName: String,
  val versionName: String? = null,
  val installTime: Long
)

/** ApkManagerPlugin */
@Keep
class ApkManagerPlugin {
  suspend fun installApk(activity: Activity, context: Context, path: String): InstallResultMsg? {
    return ApkInstaller(context, activity).installPackage(path)
  }

  suspend fun uninstallApk(activity: Activity, packageName: String): Boolean {
    return ApkUninstaller(activity).uninstallPackage(packageName)
  }

  fun getPackageNameFromApk(activity: Activity, path: String): String? {
    return activity.packageManager?.getPackageArchiveInfo(path, 0)?.packageName
  }

  fun getAppInfo(activity: Activity, packageName: String): PackageInfoMsg? {
    val manager = activity.packageManager ?: return null
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

  fun launchApp(activity: Activity, packageName: String): Boolean {
    try {
      val intent = activity.packageManager.getLaunchIntentForPackage(packageName)
      if (intent != null) {
        activity.startActivity(intent)
        return true
      }
    } catch (_: Exception) {}
    return false
  }
}
