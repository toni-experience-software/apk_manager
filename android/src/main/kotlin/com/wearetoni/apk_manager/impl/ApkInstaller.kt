package com.wearetoni.apk_manager.impl

import android.app.Activity
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageInstaller
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.content.ContextCompat
import com.wearetoni.apk_manager.InstallResultMsg
import java.io.FileInputStream
import java.io.IOException

internal class ApkInstaller(private val context: Context, private val activity: Activity) {
    fun installPackage(path: String, result: (Result<InstallResultMsg>) -> Unit) {
        var session: PackageInstaller.Session? = null
        val receiverAction = "PACKAGE_INSTALLED_ACTION.${System.currentTimeMillis()}" // Unique action per install
    
        // Register receiver before commit
        val packageChangeReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                val extras = intent.extras
                if (extras != null) {
                    when (val status = extras.getInt(PackageInstaller.EXTRA_STATUS)) {
                        PackageInstaller.STATUS_PENDING_USER_ACTION -> {
                            var confirmIntent = (extras.get(Intent.EXTRA_INTENT) as Intent)
                            confirmIntent =
                                confirmIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_NEW_TASK)
                            activity.startActivity(confirmIntent)
                        }
                         else -> {
                             val packageName = intent.getStringExtra(PackageInstaller.EXTRA_PACKAGE_NAME)
                             val res = InstallResultMsg(packageName, status.toLong())
                             result(Result.success(res))
                             context.applicationContext.unregisterReceiver(this)
                         }
                    }
                }
            }
        }
        val filter = IntentFilter(receiverAction)
        ContextCompat.registerReceiver(
            context.applicationContext,
            packageChangeReceiver,
            filter,
            ContextCompat.RECEIVER_NOT_EXPORTED
        )
    
        try {
            val packageManager = activity.packageManager
            val packageInstaller = packageManager.packageInstaller
    
            session = createSession(packageInstaller)
            loadAPKFile(path, session)
    
            // Explicit intent for PendingIntent (required for FLAG_MUTABLE on Android 14+)
            val intent = Intent(receiverAction).setPackage(context.packageName)
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                0,
                intent,
                PendingIntent.FLAG_MUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )
            val statusReceiver = pendingIntent.intentSender
            session.commit(statusReceiver)
            session.close()
        } catch (e: IOException) {
            session?.abandon()
            result(Result.failure(RuntimeException("IO exception", e)))
        } catch (e: Exception) {
            session?.abandon()
            result(Result.failure(e))
        }
    }

    private fun createSession(packageInstaller: PackageInstaller): PackageInstaller.Session {
        try {
            val params = PackageInstaller.SessionParams(PackageInstaller.SessionParams.MODE_FULL_INSTALL)

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                params.setInstallReason(PackageManager.INSTALL_REASON_USER)
            }

            val sessionId = packageInstaller.createSession(params)
            return packageInstaller.openSession(sessionId)
        } catch (e: Exception) {
            throw e
        }
    }

    @Throws(IOException::class)
    private fun loadAPKFile(apkPath: String, session: PackageInstaller.Session) {
        session.openWrite("package", 0, -1).use { packageInSession ->
            FileInputStream(apkPath).use { stream ->
                val buffer = ByteArray(16384)
                var n: Int
                var o = 1
                while (stream.read(buffer).also { n = it } >= 0) {
                    packageInSession.write(buffer, 0, n)
                    o++
                }
            }
        }
    }
}
