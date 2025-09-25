import 'package:apk_manager/src/apk_manager_utils.dart';

class PackageInfo {
  const PackageInfo({
    required this.name,
    required this.versionCode,
    required this.packageName,
    required this.versionName,
    required this.installTime,
    required this.lastUpdateTime,
  });

  final String? name;
  final String packageName;
  final String? versionName;
  final int versionCode;
  final int installTime;
  final int lastUpdateTime;

  static PackageInfo fromJavaObject(PackageInfoMsg info) => PackageInfo(
        name: info.getName()?.toDartString(),
        packageName: info.getPackageName().toDartString(),
        versionName: info.getVersionName()?.toDartString(),
        installTime: info.getInstallTime(),
        versionCode: info.getVersionCode(),
        lastUpdateTime: info.getLastUpdateTime(),
      );
}
