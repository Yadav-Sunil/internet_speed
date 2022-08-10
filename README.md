# internet_speed

Upgraded version of [internet_speed_test](https://pub.dev/packages/internet_speed_test).

## Get Started
Internet speed test plugin to integrate it in your app whenever you want.


### Add dependency

```yaml
  internet_speed: ^0.0.4
```

### Example

```dart

import 'package:internet_speed/internet_speed.dart';

  final internetSpeed = InternetSpeed();

  internetSpeed.startDownloadTesting(
     onDone: (double transferRate, SpeedUnit unit) {
        // TODO: Change UI
     },
     onProgress: (double percent, double transferRate, SpeedUnit unit) {
        // TODO: Change UI
     },
     onError: (String errorMessage, String speedTestError) {
        // TODO: Show toast error
     },
   );



  internetSpeed.startUploadTesting(
     onDone: (double transferRate, SpeedUnit unit) {
       print('the transfer rate $transferRate');
       setState(() {
         // TODO: Change UI
       });
     },
     onProgress: (double percent, double transferRate, SpeedUnit unit) {
       print(
           'the transfer rate $transferRate, the percent $percent');
       setState(() {
         // TODO: Change UI
       });
     },
     onError: (String errorMessage, String speedTestError) {
       // TODO: Show toast error
     },
  );

```

### Additional features

You can also configure your test server URL

```dart

import 'package:internet_speed/internet_speed.dart';

  final internetSpeed = internetSpeed();

  internetSpeed.startDownloadTesting(
     onDone: (double transferRate, SpeedUnit unit) {
        // TODO: Change UI
     },
     onProgress: (double percent, double transferRate, SpeedUnit unit) {
        // TODO: Change UI
     },
     onError: (String errorMessage, String speedTestError) {
        // TODO: Show toast error
     },
     testServer: //Your test server URL goes here,
   );



  internetSpeed.startUploadTesting(
     onDone: (double transferRate, SpeedUnit unit) {
       print('the transfer rate $transferRate');
       setState(() {
         // TODO: Change UI
       });
     },
     onProgress: (double percent, double transferRate, SpeedUnit unit) {
       print(
           'the transfer rate $transferRate, the percent $percent');
       setState(() {
         // TODO: Change UI
       });
     },
     onError: (String errorMessage, String speedTestError) {
       // TODO: Show toast error
     },
     testServer: //Your test server URL goes here,
  );

```

If you don't provide a customized server URL we'll be using this URL for downloading
http://ipv4.ikoula.testdebit.info/1M.iso

And this for uploading
http://ipv4.ikoula.testdebit.info/


### Contributors

The major contributor that made this package better for the iOS platform is [Akshat Sharma](https://github.com/aks3800) so a huge shoutout to him!

### Platforms

The package is working on both platforms iOS & Android!

### Shoutout

Shoutout to [JSpeedTest](https://github.com/bertrandmartel/speed-test-lib)


