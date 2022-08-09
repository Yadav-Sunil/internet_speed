import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tuple/tuple.dart';

import 'callbacks_enum.dart';
import 'internet_speed_method_channel.dart';

abstract class InternetSpeedPlatform extends PlatformInterface {
  /// Constructs a InternetSpeedPlatform.
  InternetSpeedPlatform() : super(token: _token);

  static final Object _token = Object();

  static InternetSpeedPlatform _instance = MethodChannelInternetSpeed();

  /// The default instance of [InternetSpeedPlatform] to use.
  ///
  /// Defaults to [MethodChannelInternetSpeed].
  static InternetSpeedPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [InternetSpeedPlatform] when
  /// they register themselves.
  static set instance(InternetSpeedPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<CancelListening> startDownloadTesting(
      {required DoneCallback onDone,
      required ProgressCallback onProgress,
      required ErrorCallback onError,
      required fileSize,
      required String testServer});

  Future<CancelListening> startUploadTesting({
    required DoneCallback onDone,
    required ProgressCallback onProgress,
    required ErrorCallback onError,
    required int fileSize,
    required String testServer,
  });
}
