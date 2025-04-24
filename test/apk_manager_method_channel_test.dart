import 'package:apk_manager/src/messages.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apk_manager/src/apk_manager_method_channel.dart';

import 'test_api.g.dart';

class _TestApi implements TestHostAndroidApkManagerApi {
  @override
  PackageInfoMsg? getAppInfo(String packageName) {
    return null;
  }

  @override
  String? getPackageNameFromApk(String path) {
    // TODO: implement getPackageNameFromApk
    throw UnimplementedError();
  }

  @override
  InstallResultMsg installApk(String path) {
    // TODO: implement installApk
    throw UnimplementedError();
  }

  @override
  bool launchApp(String packageName) {
    // TODO: implement launchApp
    throw UnimplementedError();
  }

  @override
  void uninstallApk(String packageName) {
    // TODO: implement uninstallApk
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelApkManager platform = MethodChannelApkManager();

  late _TestApi api;

  setUp(() {
    api = _TestApi();
    TestHostAndroidApkManagerApi.setUp(api);
  });

  test('getAppInfo', () async {
    expect(await platform.getAppInfo("test"), isNull);
  });
}
