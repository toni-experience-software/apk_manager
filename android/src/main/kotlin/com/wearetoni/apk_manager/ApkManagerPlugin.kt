package com.wearetoni.apk_manager

import android.app.Activity
import android.content.Context
import android.content.pm.ApplicationInfo
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import androidx.annotation.Keep
import androidx.core.graphics.drawable.toBitmap
import com.wearetoni.apk_manager.impl.ApkInstaller
import com.wearetoni.apk_manager.impl.ApkUninstaller
import java.io.ByteArrayOutputStream

@Keep
data class InstallResultMsg (
  val packageName: String? = null,
  val status: Long
)

@Keep
data class PackageInfoMsg (
  val name: String?,
  val packageName: String,
  val versionName: String?,
  val versionCode: Int,
  val installTime: Long,
  val lastUpdateTime: Long,
) {
  constructor(info: PackageInfo): this(
    info.applicationInfo?.name,
    info.packageName,
    info.versionName,
    info.versionCode,
    info.firstInstallTime,
    info.lastUpdateTime,
  )
}

/** ApkManagerPlugin */
@Keep
class ApkManagerPlugin {
  suspend fun installApk(activity: Activity, context: Context, path: String): InstallResultMsg? {
    return ApkInstaller(context, activity).installPackage(path)
  }

  suspend fun uninstallApk(activity: Activity, packageName: String): Boolean {
    return ApkUninstaller(activity).uninstallPackage(packageName)
  }

  fun getAppInfo(activity: Activity, packageName: String): PackageInfoMsg? {
    val manager = activity.packageManager ?: return null
    return try {
      val info = manager.getPackageInfo(packageName, 0)
      return PackageInfoMsg(info)
    } catch (e: PackageManager.NameNotFoundException) {
      null
    }
  }

  fun getAppInfoFromApk(activity: Activity, path: String): PackageInfoMsg? {
    val info = activity.packageManager?.getPackageArchiveInfo(path, 0) ?: return null
    return PackageInfoMsg(info)
  }

  fun getInstalledApps(activity: Activity): List<PackageInfoMsg>? {
    val manager = activity.packageManager ?: return null
    val apps = manager.getInstalledPackages(0)
    return apps.map { info -> PackageInfoMsg(info) }
  }

  private fun getAppIconFromInfo(manager: PackageManager, info: ApplicationInfo): ByteArray? {
    val bitmap = manager.getApplicationIcon(info).toBitmap()
    val stream = ByteArrayOutputStream()
    bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
    return stream.toByteArray()
  }

  fun getAppIcon(activity: Activity, packageName: String): ByteArray? {
    return try {
      val manager = activity.packageManager ?: return null
      val info = manager.getApplicationInfo(packageName, 0)
      return getAppIconFromInfo(manager, info)
    } catch (e: PackageManager.NameNotFoundException) {
      null
    }
  }

  fun getAppIconFromApk(activity: Activity, path: String): ByteArray? {
    val manager = activity.packageManager ?: return null
    val info = manager.getPackageArchiveInfo(path, 0)?.applicationInfo ?: return null
    return getAppIconFromInfo(manager, info)
  }

  fun launchApp(activity: Activity, packageName: String): Boolean {
    try {
      val manager = activity.packageManager ?: return false
      val intent = manager.getLaunchIntentForPackage(packageName)
      if (intent != null) {
        activity.startActivity(intent)
        return true
      }
    } catch (_: Exception) {}
    return false
  }
}
