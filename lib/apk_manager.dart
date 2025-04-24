
import 'apk_manager_platform_interface.dart';

class ApkManager {
  Future<String?> getPlatformVersion() {
    return ApkManagerPlatform.instance.getPlatformVersion();
  }
}
