#import "InternetSpeedPlugin.h"
#if __has_include(<internet_speed/internet_speed-Swift.h>)
#import <internet_speed/internet_speed-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "internet_speed-Swift.h"
#endif

@implementation InternetSpeedPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftInternetSpeedPlugin registerWithRegistrar:registrar];
}
@end
