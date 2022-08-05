#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <TradPlusAds/TradPlusAds.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (@available(iOS 14.5, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
        }];
     }
    [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
