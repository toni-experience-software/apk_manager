import 'package:apk_manager/src/messages.g.dart';

class PackageInfo {
  const PackageInfo({
    required this.packageName,
    required this.versionName,
    required this.installTime,
  });

  final String packageName;
  final String? versionName;
  final int installTime;

  static PackageInfo fromMessage(PackageInfoMsg msg) => 
      PackageInfo(
        packageName: msg.packageName,
        versionName: msg.versionName,
        installTime: msg.installTime,
      );
}
