import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';

import 'callbacks_enum.dart';
import 'internet_speed_platform_interface.dart';

typedef CancelListening = void Function();
typedef DoneCallback = void Function(double transferRate, SpeedUnit unit);
typedef ProgressCallback = void Function(
  double percent,
  double transferRate,
  SpeedUnit unit,
);
typedef void ErrorCallback(String errorMessage, String speedTestError);

/// An implementation of [InternetSpeedPlatform] that uses method channels.
class MethodChannelInternetSpeed extends InternetSpeedPlatform {
  /// The method channel used to interact with the native platform.
  final methodChannel = const MethodChannel('internet_speed');

  final Map<int, Tuple3<ErrorCallback, ProgressCallback, DoneCallback>>
      _callbacksById = {};

  int downloadRate = 0;
  int uploadRate = 0;
  int downloadSteps = 0;
  int uploadSteps = 0;

  Future<void> _methodCallHandler(MethodCall call) async {
    debugPrint('arguments are ${call.arguments}');
//    debugPrint('arguments type is  ${call.arguments['type']}');
    debugPrint('callbacks are $_callbacksById');
    switch (call.method) {
      case 'callListener':
        if (call.arguments["id"] as int ==
            CallbacksEnum.START_DOWNLOAD_TESTING.index) {
          if (call.arguments['type'] == ListenerEnum.COMPLETE.index) {
            downloadSteps++;
            downloadRate +=
                int.parse((call.arguments['transferRate'] ~/ 1000).toString());
            debugPrint('download steps is $downloadSteps}');
            debugPrint('download steps is $downloadRate}');
            double average = (downloadRate ~/ downloadSteps).toDouble();
            SpeedUnit unit = SpeedUnit.Kbps;
            average /= 1000;
            unit = SpeedUnit.Mbps;
            _callbacksById[call.arguments["id"]]!.item3(average, unit);
            downloadSteps = 0;
            downloadRate = 0;
            _callbacksById.remove(call.arguments["id"]);
          } else if (call.arguments['type'] == ListenerEnum.ERROR.index) {
            debugPrint('onError : ${call.arguments["speedTestError"]}');
            debugPrint('onError : ${call.arguments["errorMessage"]}');
            _callbacksById[call.arguments["id"]]!.item1(
                call.arguments['errorMessage'],
                call.arguments['speedTestError']);
            downloadSteps = 0;
            downloadRate = 0;
            _callbacksById.remove(call.arguments["id"]);
          } else if (call.arguments['type'] == ListenerEnum.PROGRESS.index) {
            double rate = (call.arguments['transferRate'] ~/ 1000).toDouble();
            debugPrint('rate is $rate');
            if (rate != 0) downloadSteps++;
            downloadRate += rate.toInt();
            SpeedUnit unit = SpeedUnit.Kbps;
            rate /= 1000;
            unit = SpeedUnit.Mbps;
            _callbacksById[call.arguments["id"]]!
                .item2(call.arguments['percent'].toDouble(), rate, unit);
          }
        } else if (call.arguments["id"] as int ==
            CallbacksEnum.START_UPLOAD_TESTING.index) {
          if (call.arguments['type'] == ListenerEnum.COMPLETE.index) {
            debugPrint('onComplete : ${call.arguments['transferRate']}');

            uploadSteps++;
            uploadRate +=
                int.parse((call.arguments['transferRate'] ~/ 1000).toString());
            debugPrint('download steps is $uploadSteps}');
            debugPrint('download steps is $uploadRate}');
            double average = (uploadRate ~/ uploadSteps).toDouble();
            SpeedUnit unit = SpeedUnit.Kbps;
            average /= 1000;
            unit = SpeedUnit.Mbps;
            _callbacksById[call.arguments["id"]]!.item3(average, unit);
            uploadSteps = 0;
            uploadRate = 0;
            _callbacksById.remove(call.arguments["id"]);
          } else if (call.arguments['type'] == ListenerEnum.ERROR.index) {
            debugPrint('onError : ${call.arguments["speedTestError"]}');
            debugPrint('onError : ${call.arguments["errorMessage"]}');
            _callbacksById[call.arguments["id"]]!.item1(
                call.arguments['errorMessage'],
                call.arguments['speedTestError']);
          } else if (call.arguments['type'] == ListenerEnum.PROGRESS.index) {
            double rate = (call.arguments['transferRate'] ~/ 1000).toDouble();
            debugPrint('rate is $rate');
            if (rate != 0) uploadSteps++;
            uploadRate += rate.toInt();
            SpeedUnit unit = SpeedUnit.Kbps;
            rate /= 1000.0;
            unit = SpeedUnit.Mbps;
            _callbacksById[call.arguments["id"]]!
                .item2(call.arguments['percent'].toDouble(), rate, unit);
          }
        }
//        _callbacksById[call.arguments["id"]](call.arguments["args"]);
        break;
      default:
        debugPrint(
            'TestFairy: Ignoring invoke from native. This normally shouldn\'t happen.');
    }

    methodChannel.invokeMethod("cancelListening", call.arguments["id"]);
  }

  @override
  Future<CancelListening> startDownloadTesting(
      {required DoneCallback onDone,
      required ProgressCallback onProgress,
      required ErrorCallback onError,
      fileSize = 100000,
      String testServer = 'http://ipv4.ikoula.testdebit.info/1M.iso'}) async {
    return await _startListening(Tuple3(onError, onProgress, onDone),
        CallbacksEnum.START_DOWNLOAD_TESTING, testServer,
        fileSize: fileSize);
  }

  @override
  Future<CancelListening> startUploadTesting({
    required DoneCallback onDone,
    required ProgressCallback onProgress,
    required ErrorCallback onError,
    required int fileSize,
    required String testServer,
  }) async {
    return await _startListening(Tuple3(onError, onProgress, onDone),
        CallbacksEnum.START_UPLOAD_TESTING, testServer,
        fileSize: fileSize);
  }

  Future<CancelListening> _startListening(
      Tuple3<ErrorCallback, ProgressCallback, DoneCallback> callback,
      CallbacksEnum callbacksEnum,
      String testServer,
      {Map<String, dynamic>? args,
      int fileSize = 200000}) async {
    methodChannel.setMethodCallHandler(_methodCallHandler);
    int currentListenerId = callbacksEnum.index;
    debugPrint('test $currentListenerId');
    _callbacksById[currentListenerId] = callback;
    await methodChannel.invokeMethod(
      "startListening",
      {
        'id': currentListenerId,
        'args': args,
        'testServer': testServer,
        'fileSize': fileSize,
      },
    );
    return () {
      methodChannel.invokeMethod("cancelListening", currentListenerId);
      _callbacksById.remove(currentListenerId);
    };
  }
}
