import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'apk_manager_platform_interface.dart';

/// An implementation of [ApkManagerPlatform] that uses method channels.
class MethodChannelApkManager extends ApkManagerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('apk_manager');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
