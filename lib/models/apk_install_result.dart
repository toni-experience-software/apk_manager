import 'package:apk_manager/models/apk_install_status.dart';
import 'package:apk_manager/src/messages.g.dart';

class ApkInstallResult {
  const ApkInstallResult({
    required this.packageName,
    required this.status,
  });

  final String? packageName;
  final ApkInstallStatus status;

  static ApkInstallResult fromMessage(InstallResultMsg msg) => 
      ApkInstallResult(
        packageName: msg.packageName,
        status: ApkInstallStatus.byCode(msg.status),
      );
}
