import 'internet_speed_method_channel.dart';
import 'internet_speed_platform_interface.dart';

class InternetSpeed {
  Future<CancelListening> startDownloadTesting(
      {required DoneCallback onDone,
      required ProgressCallback onProgress,
      required ErrorCallback onError,
      int fileSize = 100000,
      String testServer = 'http://ipv4.ikoula.testdebit.info/1M.iso'}) async {
    return await InternetSpeedPlatform.instance.startDownloadTesting(
        onDone: onDone,
        onProgress: onProgress,
        onError: onError,
        fileSize: fileSize,
        testServer: testServer);
  }

  Future<CancelListening> startUploadTesting({
    required DoneCallback onDone,
    required ProgressCallback onProgress,
    required ErrorCallback onError,
    int fileSize = 100000,
    String testServer = 'http://ipv4.ikoula.testdebit.info/',
  }) async {
    return await InternetSpeedPlatform.instance.startUploadTesting(
        onDone: onDone,
        onProgress: onProgress,
        onError: onError,
        fileSize: fileSize,
        testServer: testServer);
  }
}
