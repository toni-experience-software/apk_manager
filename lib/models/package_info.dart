import 'package:apk_manager/src/apk_manager_utils.dart';

class PackageInfo {
  const PackageInfo({
    required this.packageName,
    required this.versionName,
    required this.installTime,
  });

  final String packageName;
  final String? versionName;
  final int installTime;

  static PackageInfo fromJavaObject(PackageInfoMsg msg) => PackageInfo(
        packageName: msg.getPackageName().toDartString(),
        versionName: msg.getVersionName()?.toDartString(),
        installTime: msg.getInstallTime(),
      );
}
