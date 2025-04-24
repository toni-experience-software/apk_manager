import 'package:apk_manager/apk_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apk_manager/src/apk_manager_platform_interface.dart';
import 'package:apk_manager/src/apk_manager_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockApkManagerPlatform
    with MockPlatformInterfaceMixin
    implements ApkManagerPlatform {
  @override
  Future<PackageInfo?> getAppInfo(String packageName) async {
    return null;
  }

  @override
  Future<String?> getPackageNameFromApk(String path) {
    throw UnimplementedError();
  }

  @override
  Future<ApkInstallResult> installApk(String path) {
    throw UnimplementedError();
  }

  @override
  Future<bool> launchApp(String packageName) {
    throw UnimplementedError();
  }

  @override
  Future<void> uninstallApk(String packageName) {
    throw UnimplementedError();
  }
}

void main() {
  final ApkManagerPlatform initialPlatform = ApkManagerPlatform.instance;

  test('$MethodChannelApkManager is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelApkManager>());
  });

  test('getAppInfo', () async {
    MockApkManagerPlatform fakePlatform = MockApkManagerPlatform();
    ApkManagerPlatform.instance = fakePlatform;

    expect(await ApkManager.getAppInfo("test"), isNull);
  });
}
