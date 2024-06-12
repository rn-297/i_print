#import "AdstringoPlugin.h"
#if __has_include(<adstringo_plugin/adstringo_plugin-Swift.h>)
#import <adstringo_plugin/adstringo_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "adstringo_plugin-Swift.h"
#endif

@implementation AdstringoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAdstringoPlugin registerWithRegistrar:registrar];
}
@end
