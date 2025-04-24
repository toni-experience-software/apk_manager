import 'package:apk_manager/models/models.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'apk_manager_method_channel.dart';

abstract class ApkManagerPlatform extends PlatformInterface {
  /// Constructs a ApkManagerPlatform.
  ApkManagerPlatform() : super(token: _token);

  static final Object _token = Object();

  static ApkManagerPlatform _instance = MethodChannelApkManager();

  /// The default instance of [ApkManagerPlatform] to use.
  ///
  /// Defaults to [MethodChannelApkManager].
  static ApkManagerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ApkManagerPlatform] when
  /// they register themselves.
  static set instance(ApkManagerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  // --- Methods ---

  Future<ApkInstallResult> installApk(String path);

  Future<void> uninstallApk(String packageName);

  Future<String?> getPackageNameFromApk(String path);

  Future<PackageInfo?> getAppInfo(String packageName);

  Future<bool> launchApp(String packageName);
}
