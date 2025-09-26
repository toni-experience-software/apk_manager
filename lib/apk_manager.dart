import 'dart:typed_data';

import 'package:apk_manager/models/models.dart';
import 'package:apk_manager/src/apk_manager_interface.dart';

export 'models/models.dart';

class ApkManager {
  static final _manager = ApkManagerInterface();

  /// Installs an apk file.
  ///
  /// Creates Package Installer session, then displays a dialog to confirm the installation.
  /// After installation process is completed, the session is closed.
  ///
  /// [path] - the path to the apk package file.
  ///
  /// Returns a [ApkInstallResult].
  static Future<ApkInstallResult> installApk({required String path}) async {
    return _manager.installApk(path);
  }

  /// Uninstalls an app.
  ///
  /// [packageName] - the package name of the app.
  ///
  /// Returns true if the uninstallation was successful, false otherwise.
  static Future<bool> uninstallApp(String packageName) async {
    return _manager.uninstallApk(packageName);
  }

  /// Fetches some [PackageInfo] from an apk file.
  ///
  /// [path] - the path to the apk file.
  ///
  /// Returns the [PackageInfo] of the apk file, null if not found.
  static PackageInfo? getAppInfoFromApk(String path) {
    return _manager.getAppInfoFromApk(path);
  }

  /// Fetches some [PackageInfo] about an installed app.
  ///
  /// [packageName] - the package name of the app.
  ///
  /// Returns the [PackageInfo] if the app is installed, null otherwise.
  static PackageInfo? getAppInfo(String packageName) {
    return _manager.getAppInfo(packageName);
  }

  /// Checks if the app is installed on the device.
  ///
  /// [packageName] - the package name of the app.
  ///
  /// Returns true if the app is installed, false otherwise.
  static bool isAppInstalled(String packageName) {
    return getAppInfo(packageName) != null;
  }

  /// Checks if the apk file is installed on the device.
  ///
  /// [apkFilePath] - the path to the apk package file.
  ///
  /// Returns true if the apk file is installed, false otherwise.
  static bool isApkInstalled(String apkFilePath) {
    return switch (getAppInfoFromApk(apkFilePath)) {
      null => false,
      final info => isAppInstalled(info.packageName),
    };
  }

  /// Launches an installed app.
  ///
  /// [packageName] - the package name of the app.
  ///
  /// Returns true if the app was launched successfully, false otherwise.
  static bool launchApp(String packageName) {
    return _manager.launchApp(packageName);
  }

  /// Gets the icon of an installed app.
  ///
  /// [packageName] - the package name of the app.
  ///
  /// Returns the app icon as [Uint8List] if the app is installed and has an icon, null otherwise.
  static Uint8List? getIcon(String packageName) {
    return _manager.getAppIcon(packageName);
  }

  /// Gets the icon from an APK file.
  ///
  /// [path] - the path to the apk file.
  ///
  /// Returns the app icon as [Uint8List] if the APK file has an icon, null otherwise.
  static Uint8List? getIconFromApk(String path) {
    return _manager.getAppIconFromApk(path);
  }
}
