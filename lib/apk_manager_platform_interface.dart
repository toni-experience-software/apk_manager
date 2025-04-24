import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'apk_manager_method_channel.dart';

abstract class ApkManagerPlatform extends PlatformInterface {
  /// Constructs a ApkManagerPlatform.
  ApkManagerPlatform() : super(token: _token);

  static final Object _token = Object();

  static ApkManagerPlatform _instance = MethodChannelApkManager();

  /// The default instance of [ApkManagerPlatform] to use.
  ///
  /// Defaults to [MethodChannelApkManager].
  static ApkManagerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ApkManagerPlatform] when
  /// they register themselves.
  static set instance(ApkManagerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
