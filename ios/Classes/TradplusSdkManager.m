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
            [TradplusSdkPlugin callbackWithEventName:@"tp_initFinish" adUnitID:nil adInfo:nil error:nil exp:@{@"success":@(error != nil)}];
        }];
    }
    else
    {
        MSLogInfo(@"not find init appId");
    }
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
