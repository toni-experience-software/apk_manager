import 'package:flutter_test/flutter_test.dart';
import 'package:apk_manager/apk_manager.dart';
import 'package:apk_manager/apk_manager_platform_interface.dart';
import 'package:apk_manager/apk_manager_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockApkManagerPlatform
    with MockPlatformInterfaceMixin
    implements ApkManagerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ApkManagerPlatform initialPlatform = ApkManagerPlatform.instance;

  test('$MethodChannelApkManager is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelApkManager>());
  });

  test('getPlatformVersion', () async {
    ApkManager apkManagerPlugin = ApkManager();
    MockApkManagerPlatform fakePlatform = MockApkManagerPlatform();
    ApkManagerPlatform.instance = fakePlatform;

    expect(await apkManagerPlugin.getPlatformVersion(), '42');
  });
}
