import 'package:apk_manager/models/models.dart';
import 'package:apk_manager/src/apk_manager_platform_interface.dart';

export 'models/models.dart';

class ApkManager {
  static final _manager = ApkManagerPlatform.instance;

  /// Installs an apk file.
  /// 
  /// Creates Package Installer session, then displays a dialog to confirm the installation.
  /// After installation process is completed, the session is closed.
  /// 
  /// [path] - the path to the apk package file.
  /// 
  /// Returns a [ApkInstallResult].
  static Future<ApkInstallResult> installApk({required String path}) async {
    return await _manager.installApk(path);
  }

  /// Uninstalls an app.
  /// 
  /// [packageName] - the package name of the app.
  static Future<void> uninstallApp(String packageName) async {
    return await _manager.uninstallApk(packageName);
  }

  /// Returns the package name of the apk file.
  /// 
  /// [path] - the path to the apk file.
  /// 
  /// Returns the package name of the apk file.
  static Future<String?> getPackageNameFromApk(String path) async {
    return await _manager.getPackageNameFromApk(path);
  }

  /// Fetches some [PackageInfo] about an installed app.
  /// 
  /// [packageName] - the package name of the app.
  /// 
  /// Returns the [PackageInfo] if the app is installed, null otherwise.
  static Future<PackageInfo?> getAppInfo(String packageName) async {
    return await _manager.getAppInfo(packageName);
  }

  /// Checks if the app is installed on the device.
  /// 
  /// [packageName] - the package name of the app.
  /// 
  /// Returns true if the app is installed, false otherwise.
  static Future<bool> isAppInstalled(String packageName) async {
    final info = await getAppInfo(packageName);
    return info != null;
  }

  /// Checks if the apk file is installed on the device.
  /// 
  /// [apkFilePath] - the path to the apk package file.
  /// 
  /// Returns true if the apk file is installed, false otherwise.
  static Future<bool> isApkInstalled(String apkFilePath) async {
    final name = await getPackageNameFromApk(apkFilePath);
    if (name == null) {
      return false;
    } else {
      return await isAppInstalled(name);
    }
  }

  /// Launches an installed app.
  /// 
  /// [packageName] - the package name of the app.
  /// 
  /// Returns true if the app was launched successfully, false otherwise.
  static Future<bool> launchApp(String packageName) async {
    return await _manager.launchApp(packageName);
  }
}
