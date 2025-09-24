package com.wearetoni.apk_manager.impl

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.Uri
import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine

internal class ApkUninstaller(private val activity: Activity) {
    suspend fun uninstallPackage(packageName: String): Boolean {
        try {
            val packageUri = Uri.parse("package:$packageName")
            val intent = Intent(Intent.ACTION_DELETE, packageUri)
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK

            return suspendCoroutine {
                cont ->
                    registerPackageChangeReceiver(packageName, {result -> cont.resume(result) })
                    activity.startActivity(intent)
            }
        } catch (e: Exception) {
            // result(Result.failure(e))
            throw e
        }
    }

    // TODO this currently does not detect if the user cancels the uninstall
    private fun registerPackageChangeReceiver(packageName: String, result: (Boolean) -> Unit) {
        lateinit var packageChangeReceiver: BroadcastReceiver;
        packageChangeReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                if (Intent.ACTION_PACKAGE_REMOVED == intent.action) {
                    val data = intent.data
                    if (data != null && data.schemeSpecificPart == packageName) {
                        result(true)
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
