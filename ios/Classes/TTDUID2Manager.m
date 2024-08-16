

#import "TTDUID2Manager.h"
#import "TTDUID2ManagerProtocol.h"
#import "TradplusSdkPlugin.h"

@implementation TTDUID2Manager

+(TTDUID2Manager *)sharedInstance
{
    static TTDUID2Manager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TTDUID2Manager alloc] init];
    });
    return manager;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result
{
    if([@"uid2_start" isEqualToString:call.method])
    {
        [self start:call];
    }
    else if([@"uid2_reset" isEqualToString:call.method])
    {
        [self reset];
    }
}

- (void)start:(FlutterMethodCall*)call
{
    Class TTDUID2ManagerAdatper = NSClassFromString(@"TTDUID2ManagerAdatper");
    if(TTDUID2ManagerAdatper == nil)
    {
        return;
    }
    if(![TTDUID2ManagerAdatper respondsToSelector:@selector(sharedInstance)])
    {
        return;
    }
    id <TTDUID2ManagerProtocol>adatper = [TTDUID2ManagerAdatper performSelector:@selector(sharedInstance)];
    if(adatper == nil)
    {
        return;
    }
    if(call.arguments[@"email"])
    {
        adatper.email = call.arguments[@"email"];
    }
    if(call.arguments[@"emailHash"])
    {
        adatper.emailHash = call.arguments[@"emailHash"];
    }
    if(call.arguments[@"phone"])
    {
        adatper.phone = call.arguments[@"phone"];
    }
    if(call.arguments[@"phoneHash"])
    {
        adatper.phoneHash = call.arguments[@"phoneHash"];
    }
    if(call.arguments[@"subscriptionID"])
    {
        adatper.subscriptionID = call.arguments[@"subscriptionID"];
    }
    if(call.arguments[@"serverPublicKey"])
    {
        adatper.serverPublicKey = call.arguments[@"serverPublicKey"];
    }
    if(call.arguments[@"appName"])
    {
        adatper.appName = call.arguments[@"appName"];
    }
    if(call.arguments[@"customURLString"])
    {
        adatper.customURLString = call.arguments[@"customURLString"];
    }
    adatper.isTestMode = [call.arguments[@"isTestMode"] boolValue];
    [adatper startWithCallback:^(NSError * _Nullable error) {
        [TradplusSdkPlugin callbackWithEventName:@"uid2_startFinish" adUnitID:nil adInfo:nil error:error];
    }];
}

- (void)reset
{
    Class TTDUID2ManagerAdatper = NSClassFromString(@"TTDUID2ManagerAdatper");
    if(TTDUID2ManagerAdatper == nil)
    {
        return;
    }
    if(![TTDUID2ManagerAdatper respondsToSelector:@selector(sharedInstance)])
    {
        return;
    }
    id <TTDUID2ManagerProtocol>adatper = [TTDUID2ManagerAdatper performSelector:@selector(sharedInstance)];
    if(adatper == nil)
    {
        return;
    }
    [adatper resetSetting];
}

@end
