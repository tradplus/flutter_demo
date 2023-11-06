//
//  TradplusSdkManager.m
//  tradplus_sdk
//
//  Created by xuejun on 2022/7/25.
//

#import "TradplusSdkManager.h"
#import <TradPlusAds/TradPlusAds.h>
#import "TradplusSdkPlugin.h"

@interface TradplusSdkManager()<TradPlusAdImpressionDelegate>

@end

@implementation TradplusSdkManager

+(TradplusSdkManager *)sharedInstance
{
    static TradplusSdkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TradplusSdkManager alloc] init];
    });
    return manager;
}

- (void)addGlobalAdImpressionDelegate
{
    [TradPlus sharedInstance].impressionDelegate = self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result
{
    if([@"tp_setCustomMap" isEqualToString:call.method])
    {
        [self setCustomMapWithCall:call];
    }
    else if([@"tp_init" isEqualToString:call.method])
    {
        [self initSDK:call];
    }
    else if([@"tp_version" isEqualToString:call.method])
    {
        [self sdkVersion:result];
    }
    else if([@"tp_isEUTraffic" isEqualToString:call.method])
    {
        [self isEUTraffic:result];
    }
    else if([@"tp_isCalifornia" isEqualToString:call.method])
    {
        [self isCalifornia:result];
    }
    else if([@"tp_setGDPRDataCollection" isEqualToString:call.method])
    {
        [self setGDPRDataCollection:call];
    }
    else if([@"tp_getGDPRDataCollection" isEqualToString:call.method])
    {
        [self getGDPRDataCollection:result];
    }
    else if([@"tp_setCCPADoNotSell" isEqualToString:call.method])
    {
        [self setCCPADoNotSell:call];
    }
    else if([@"tp_getCCPADoNotSell" isEqualToString:call.method])
    {
        [self getCCPADoNotSell:result];
    }
    else if([@"tp_setCOPPAIsAgeRestrictedUser" isEqualToString:call.method])
    {
        [self setCOPPAIsAgeRestrictedUser:call];
    }
    else if([@"tp_getCOPPAIsAgeRestrictedUser" isEqualToString:call.method])
    {
        [self getCOPPAIsAgeRestrictedUser:result];
    }
    else if([@"tp_setLGPDConsent" isEqualToString:call.method])
    {
        [self setLGPDConsent:call];
    }
    else if([@"tp_getLGPDConsent" isEqualToString:call.method])
    {
        [self getLGPDConsent:result];
    }
    else if([@"tp_showGDPRDialog" isEqualToString:call.method])
    {
        [self showGDPRDialog];
    }
    else if([@"tp_setOpenPersonalizedAd" isEqualToString:call.method])
    {
        [self setOpenPersonalizedAd:call];
    }
    else if([@"tp_isOpenPersonalizedAd" isEqualToString:call.method])
    {
        [self isOpenPersonalizedAd:result];
    }
    else if([@"tp_clearCache" isEqualToString:call.method])
    {
        [self clearCacheWithCall:call];
    }
    else if([@"tp_checkCurrentArea" isEqualToString:call.method])
    {
        [self checkCurrentArea];
    }
    else if([@"tp_setSettingDataParam" isEqualToString:call.method])
    {
        [self setSettingDataParam:call];
    }
    else if([@"tp_openTradPlusTool" isEqualToString:call.method])
    {
        [self openTradPlusTool];
    }
}

- (void) openTradPlusTool
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    Class TPMediationHelper = NSClassFromString(@"TPMediationHelper");
    if(TPMediationHelper != nil)
    {
        if([TPMediationHelper respondsToSelector:@selector(open)])
        {
            [TPMediationHelper performSelector:@selector(open)];
        }
    }
    else
    {
        NSLog(@"****************");
        NSLog(@"no find TPMediationHelper SDK");
        NSLog(@"****************");
    }
#pragma clang diagnostic pop
}


- (void)clearCacheWithCall:(FlutterMethodCall*)call
{
    id adUnitId = call.arguments[@"adUnitId"];
    if(adUnitId != nil && [adUnitId isKindOfClass:[NSString class]])
    {
        [TradPlus clearCacheWithPlacementId:adUnitId];
    }
}

- (void)setCustomMapWithCall:(FlutterMethodCall*)call
{
    id customMap = call.arguments[@"customMap"];
    if(customMap != nil && [customMap isKindOfClass:[NSDictionary class]])
    {
        [TradPlus sharedInstance].dicCustomValue = customMap;
    }
}

- (void)initSDK:(FlutterMethodCall*)call
{
    id appId = call.arguments[@"appId"];
    if(appId != nil && [appId isKindOfClass:[NSString class]])
    {
        [TradPlus initSDK:appId completionBlock:^(NSError * _Nonnull error) {
            BOOL success = (error != nil);
            [TradplusSdkPlugin callbackWithEventName:@"tp_initFinish" adUnitID:nil adInfo:nil error:nil exp:@{@"success":@(success)}];
        }];
    }
    else
    {
        MSLogInfo(@"not find init appId");
    }
}

- (void)setSettingDataParam:(FlutterMethodCall*)call
{
    id setting = call.arguments[@"setting"];
    if(![setting isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    NSDictionary *settingDic = setting;
    //交叉推广超时
    if([settingDic valueForKey:@"http_timeout_crosspromotion"])
    {
        NSInteger http_timeout_crosspromotion = [settingDic[@"http_timeout_crosspromotion"] integerValue];
        if(http_timeout_crosspromotion > 0)
        {
            http_timeout_crosspromotion = http_timeout_crosspromotion/1000;
            if(http_timeout_crosspromotion == 0)
                http_timeout_crosspromotion = 1;
            gTPHttpTimeoutCross = http_timeout_crosspromotion;
        }
    }
    //adx超时
    if([settingDic valueForKey:@"http_timeout_adx"])
    {
        NSInteger http_timeout_adx = [settingDic[@"http_timeout_adx"] integerValue];
        if(http_timeout_adx > 0)
        {
            http_timeout_adx = http_timeout_adx/1000;
            if(http_timeout_adx == 0)
                http_timeout_adx = 1;
            gTPHttpTimeoutAdx = http_timeout_adx;
        }
    }
    //配置超时
    if([settingDic valueForKey:@"http_timeout_conf"])
    {
        NSInteger http_timeout_conf = [settingDic[@"http_timeout_conf"] integerValue];
        if(http_timeout_conf > 0)
        {
            http_timeout_conf = http_timeout_conf/1000;
            if(http_timeout_conf == 0)
                http_timeout_conf = 1;
            gTPHttpTimeoutConf = http_timeout_conf;
        }
    }
    //其他网络超时
    if([settingDic valueForKey:@"http_timeout_event"])
    {
        NSInteger http_timeout_event = [settingDic[@"http_timeout_event"] integerValue];
        if(http_timeout_event > 0)
        {
            http_timeout_event = http_timeout_event/1000;
            if(http_timeout_event == 0)
                http_timeout_event = 1;
            gTPHttpTimeoutEvent = http_timeout_event;
        }
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if([settingDic valueForKey:@"autoload_close"])
    {
        id autoload_close = settingDic[@"autoload_close"];
        if([autoload_close isKindOfClass:[NSArray class]])
        {
            dic[@"autoload_close"] = autoload_close;
        }
    }
    [[TradPlus sharedInstance] setSettingDataParam:dic];
}

- (void)sdkVersion:(FlutterResult)result
{
    result([TradPlus getVersion]);
}

- (void)isCalifornia:(FlutterResult)result
{
    result(@(gMsSDKIsCA));
}

- (void)isEUTraffic:(FlutterResult)result
{
    BOOL isEU = ([MSConsentManager sharedManager].isGDPRApplicable == MSBoolYes);
    result(@(isEU));
}

- (void)checkCurrentArea
{
    [TradPlus checkCurrentArea:^(BOOL isUnknown, BOOL isCN, BOOL isCA, BOOL isEU) {
        if(!isUnknown)
        {
            [TradplusSdkPlugin callbackWithEventName:@"tp_currentarea_success" adUnitID:nil adInfo:nil error:nil exp:@{@"iscn":@(isCN),@"iseu":@(isEU),@"isca":@(isCA)}];
        }
        else
        {
            [TradplusSdkPlugin callbackWithEventName:@"tp_currentarea_failed" adUnitID:nil adInfo:nil error:nil];
        }
    }];
}

- (void)setLGPDConsent:(FlutterMethodCall*)call
{
    BOOL canDataCollection = [call.arguments[@"canDataCollection"] boolValue];
    [TradPlus setLGPDIsConsentEnabled:canDataCollection];
}

- (void)getLGPDConsent:(FlutterResult)result
{
    NSInteger callbackState = 2;//未设置
    if([[NSUserDefaults standardUserDefaults] objectForKey:gTPLGPDStorageKey])
    {
        NSInteger lgpdStatus = [[NSUserDefaults standardUserDefaults] integerForKey:gTPLGPDStorageKey];
        if(lgpdStatus == 2)
        {
            callbackState = 0;//允许
        }
        else if(lgpdStatus == 1)
        {
            callbackState = 1;//不允许
        }
    }
    result(@(callbackState));
}

- (void)setGDPRDataCollection:(FlutterMethodCall*)call
{
    BOOL canDataCollection = [call.arguments[@"canDataCollection"] boolValue];
    [TradPlus setGDPRDataCollection:canDataCollection];
}

- (void)getGDPRDataCollection:(FlutterResult)result
{
    NSInteger callbackState = 2;//未设置
    MSConsentStatus state =  [TradPlus getGDPRDataCollection];
    if(state == MSConsentStatusDenied)
    {
        callbackState = 1;//不允许
    }
    else if(state == MSConsentStatusConsented)
    {
        callbackState = 0;//允许
    }
    result(@(callbackState));
}


- (void)setCCPADoNotSell:(FlutterMethodCall*)call
{
    BOOL canDataCollection = [call.arguments[@"canDataCollection"] boolValue];
    [TradPlus setCCPADoNotSell:canDataCollection];
}

- (void)getCCPADoNotSell:(FlutterResult)result
{
    NSInteger callbackState = 2;//未设置
    if([[NSUserDefaults standardUserDefaults] objectForKey:gTPCCPAStorageKey])
    {
        NSInteger ccpaStatus = [[NSUserDefaults standardUserDefaults] integerForKey:gTPCCPAStorageKey];
        if(ccpaStatus == 2)
        {
            callbackState = 0;//允许
        }
        else if(ccpaStatus == 1)
        {
            callbackState = 1;//不允许
        }
    }
    result(@(callbackState));
}

- (void)setCOPPAIsAgeRestrictedUser:(FlutterMethodCall*)call
{
    BOOL isChild = [call.arguments[@"isChild"] boolValue];
    [TradPlus setCOPPAIsAgeRestrictedUser:isChild];
}

- (void)getCOPPAIsAgeRestrictedUser:(FlutterResult)result
{
    NSInteger callbackState = 2;//未设置
    if([[NSUserDefaults standardUserDefaults] objectForKey:gTPCOPPAStorageKey])
    {
        NSInteger ccpaStatus = [[NSUserDefaults standardUserDefaults] integerForKey:gTPCOPPAStorageKey];
        if(ccpaStatus == 2)
        {
            callbackState = 0;//允许
        }
        else if(ccpaStatus == 1)
        {
            callbackState = 1;//不允许
        }
    }
    result(@(callbackState));
}

- (void)setOpenPersonalizedAd:(FlutterMethodCall*)call
{
    BOOL open = [call.arguments[@"open"] boolValue];
    if(open)
    {
        NSLog(@"open true");
    }
    else
    {
        NSLog(@"open false");
    }
    [TradPlus setOpenPersonalizedAd:open];
    open = [TradPlus sharedInstance].isOpenPersonalizedAd;
    if(open)
    {
        NSLog(@"open true");
    }
    else
    {
        NSLog(@"open false");
    }
}

- (void)isOpenPersonalizedAd:(FlutterResult)result
{
    result(@([TradPlus sharedInstance].isOpenPersonalizedAd));
}

- (void)showGDPRDialog
{
    [[MSConsentManager sharedManager] showConsentDialogFromViewController:[MsCommon getTopRootViewController] didShow:nil didDismiss:^{
        [TradplusSdkPlugin callbackWithEventName:@"tp_dialogClosed" adUnitID:nil adInfo:nil error:nil];
    }];
}

#pragma mark - TradPlusAdImpressionDelegate
- (void)tradPlusAdImpression:(NSDictionary *)adInfo
{
    [TradplusSdkPlugin callbackWithEventName:@"tp_globalAdImpression" adUnitID:nil adInfo:adInfo error:nil];
}
@end
