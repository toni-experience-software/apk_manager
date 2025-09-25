import 'dart:typed_data';

import 'package:apk_manager/models/models.dart';
import 'package:apk_manager/src/apk_manager_utils.dart';
import 'package:jni/jni.dart';

/// An implementation of [ApkManagerInterface] that uses pigeon.
class ApkManagerInterface {
  JObject activity = JObject.fromReference(Jni.getCurrentActivity());
  JObject context = JObject.fromReference(Jni.getCachedApplicationContext());

  PackageInfo? getAppInfo(String packageName) {
    final res =
        ApkManagerPlugin().getAppInfo(activity, packageName.toJString());
    if (res == null) {
      return null;
    } else {
      return PackageInfo.fromJavaObject(res);
    }
  }

  String? getPackageNameFromApk(String path) {
    return ApkManagerPlugin()
        .getPackageNameFromApk(activity, path.toJString())
        ?.toDartString();
  }

  Future<ApkInstallResult> installApk(String path) async {
    final res = await ApkManagerPlugin().installApk(
      activity,
      context,
      path.toJString(),
    );
    if (res == null) {
      return ApkInstallResult(
        packageName: null,
        status: ApkInstallStatus.failure,
      );
    } else {
      return ApkInstallResult.fromMessage(res);
    }
  }

  bool launchApp(String packageName) {
    return ApkManagerPlugin().launchApp(activity, packageName.toJString());
  }

  Future<bool> uninstallApk(String packageName) async {
    final res = await ApkManagerPlugin()
        .uninstallApk(activity, packageName.toJString());
    return res.booleanValue();
  }

  Uint8List? getAppIcon(String packageName) {
    final array = ApkManagerPlugin().getAppIcon(
      activity,
      packageName.toJString(),
    );
    return switch (array) {
      null => null,
      final array => Uint8List.fromList(array.toList()),
    };
  }

  Uint8List? getAppIconFromApk(String path) {
    final array = ApkManagerPlugin().getAppIconFromApk(
      activity,
      path.toJString(),
    );
    return switch (array) {
      null => null,
      final array => Uint8List.fromList(array.toList()),
    };
  }
}
