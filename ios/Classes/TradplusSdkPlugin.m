#import "TradplusSdkPlugin.h"
#import "TPFNativeManager.h"
#import "TPFInterstitialManager.h"
#import "TPFRewardVideoManager.h"
#import "TPFSplashManager.h"
#import "TPFNativeViewFactory.h"
#import "TPFBannerViewFactory.h"
#import "TPFBannerManager.h"
#import "TradplusSdkManager.h"
#import "TPFOfferwallManager.h"

@implementation TradplusSdkPlugin

static FlutterMethodChannel *channel;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar
{
    channel = [FlutterMethodChannel
      methodChannelWithName:@"tradplus_sdk"
            binaryMessenger:[registrar messenger]];
    
    TradplusSdkPlugin* instance = [[TradplusSdkPlugin alloc] init];
    
    [registrar addMethodCallDelegate:instance channel:channel];
    
    TPFNativeViewFactory *nativeFactory = [[TPFNativeViewFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:nativeFactory withId:@"tp_native_view"];
    
    TPFBannerViewFactory *bannerFactory = [[TPFBannerViewFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:bannerFactory withId:@"tp_banner_view"];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result
{
    if([call.method isEqualToString:@"tp_addGlobalAdImpressionListener"])
    {
        [[TradplusSdkManager sharedInstance] addGlobalAdImpressionDelegate];
    }
    else if([call.method hasPrefix:@"tp_"])
    {
        [[TradplusSdkManager sharedInstance] handleMethodCall:call result:result];
    }
    else if([call.method hasPrefix:@"native_"])
    {
        [[TPFNativeManager sharedInstance] handleMethodCall:call result:result];
    }
    else if([call.method hasPrefix:@"interstitial_"])
    {
        [[TPFInterstitialManager sharedInstance] handleMethodCall:call result:result];
    }
    else if([call.method hasPrefix:@"rewardVideo_"])
    {
        [[TPFRewardVideoManager sharedInstance] handleMethodCall:call result:result];
    }
    else if([call.method hasPrefix:@"banner_"])
    {
        [[TPFBannerManager sharedInstance] handleMethodCall:call result:result];
    }
    else if([call.method hasPrefix:@"splash_"])
    {
        [[TPFSplashManager sharedInstance] handleMethodCall:call result:result];
    }
    else if([call.method hasPrefix:@"offerwall_"])
    {
        [[TPFOfferwallManager sharedInstance] handleMethodCall:call result:result];
    }
    else
    {
        result(FlutterMethodNotImplemented);
    }
}



+ (void)callbackWithEventName:(NSString *)name adUnitID:(NSString *)adUnitID adInfo:(NSDictionary *)adInfo error:(NSError *)error exp:(NSDictionary *)exp
{
    NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];
    arguments[@"adUnitID"] = adUnitID;
    if(adInfo != nil)
    {
        arguments[@"adInfo"] = adInfo;
    }
    if(error != nil)
    {
        NSString *message = @"";
        if(error.localizedDescription != nil)
        {
            message = error.localizedDescription;
        }
        arguments[@"adError"] = @{@"code":@(error.code),@"message":message};
    }
    if(exp != nil)
    {
        [arguments addEntriesFromDictionary:exp];
    }
    [channel invokeMethod:name arguments:arguments];
}

+ (void)callbackWithEventName:(NSString *)name adUnitID:(NSString *)adUnitID adInfo:(NSDictionary *)adInfo error:(NSError *)error
{
    [TradplusSdkPlugin callbackWithEventName:name adUnitID:adUnitID adInfo:adInfo error:error exp:nil];
}

@end
