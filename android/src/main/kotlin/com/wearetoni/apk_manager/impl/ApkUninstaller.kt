package com.wearetoni.apk_manager.impl

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.Uri
import io.flutter.plugin.common.MethodChannel

internal class ApkUninstaller(private val activity: Activity) {
    fun uninstallPackage(packageName: String, result: (Result<Unit>) -> Unit) {
        try {
            val packageUri = Uri.parse("package:$packageName")
            val intent = Intent(Intent.ACTION_DELETE, packageUri)
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK

            registerPackageChangeReceiver(packageName, result)

            activity.startActivity(intent)
        } catch (e: Exception) {
            result(Result.failure(e))
            throw e
        }
    }

    // TODO this currently does not detect if the user cancels the uninstall
    private fun registerPackageChangeReceiver(packageName: String, result: (Result<Unit>) -> Unit) {
        lateinit var packageChangeReceiver: BroadcastReceiver;
        packageChangeReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                if (Intent.ACTION_PACKAGE_REMOVED == intent.action) {
                    val data = intent.data
                    if (data != null && data.schemeSpecificPart == packageName) {
                        result(Result.success(Unit))
                        activity.unregisterReceiver(packageChangeReceiver)
                    }
                }
            }
        }

        val filter = IntentFilter(Intent.ACTION_PACKAGE_REMOVED)
        filter.addDataScheme("package")
        activity.registerReceiver(packageChangeReceiver, filter)
    }
}
