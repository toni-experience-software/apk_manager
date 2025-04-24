import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/messages.g.dart',
  dartTestOut: 'test/test_api.g.dart',
  kotlinOut:
      'android/src/main/kotlin/com/wearetoni/apk_manager/Messages.g.kt',
  kotlinOptions: KotlinOptions(
    package: 'com.wearetoni.apk_manager',
  ),
  copyrightHeader: 'pigeons/copyright.txt',
  dartPackageName: 'apk_manager',
))

class InstallResultMsg {
  InstallResultMsg({
    required this.packageName,
    required this.status,
  });

  String? packageName;
  int status;
}

class PackageInfoMsg {
  PackageInfoMsg({
    required this.packageName,
    required this.versionName,
    required this.installTime,
  });

  String packageName;
  String? versionName;
  int installTime;
}

@HostApi(dartHostTestHandler: 'TestHostAndroidApkManagerApi')
abstract class AndroidApkManagerApi {
  @async
  InstallResultMsg installApk(String path);

  @async
  void uninstallApk(String packageName);

  String? getPackageNameFromApk(String path);

  PackageInfoMsg? getAppInfo(String packageName);

  bool launchApp(String packageName);
}
