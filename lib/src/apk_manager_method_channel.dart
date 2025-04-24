import 'package:apk_manager/models/apk_install_result.dart';
import 'package:apk_manager/models/package_info.dart';
import 'package:apk_manager/src/messages.g.dart';

import 'apk_manager_platform_interface.dart';

/// An implementation of [ApkManagerPlatform] that uses pigeon.
class MethodChannelApkManager extends ApkManagerPlatform {
  final AndroidApkManagerApi _api = AndroidApkManagerApi();

  @override
  Future<PackageInfo?> getAppInfo(String packageName) async {
    final res = await _api.getAppInfo(packageName);
    if (res == null) {
      return null;
    } else {
      return PackageInfo.fromMessage(res);
    }
  }

  @override
  Future<String?> getPackageNameFromApk(String path) async {
    return await _api.getPackageNameFromApk(path);
  }

  @override
  Future<ApkInstallResult> installApk(String path) async {
    final res = await _api.installApk(path);
    return ApkInstallResult.fromMessage(res);
  }

  @override
  Future<bool> launchApp(String packageName) async {
    return await _api.launchApp(packageName);
  }

  @override
  Future<void> uninstallApk(String packageName) async {
    return await _api.uninstallApk(packageName);
  }
}
