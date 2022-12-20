//
//  TPFInterstitialManager.m
//  tradplus_sdk
//
//  Created by xuejun on 2022/7/19.
//

#import "TPFInterstitialManager.h"
#import <TradPlusAds/TradPlusAds.h>

@interface TPFInterstitialManager()

@property (nonatomic,strong)NSMutableDictionary <NSString *,TPFInterstitial *>*interstitialAds;
@end

@implementation TPFInterstitialManager

+ (TPFInterstitialManager *)sharedInstance
{
    static TPFInterstitialManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TPFInterstitialManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.interstitialAds = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result
{
    NSString *adUnitID = call.arguments[@"adUnitID"];
    if([@"interstitial_load" isEqualToString:call.method])
    {
        [self loadAdWithAdUnitID:adUnitID methodCall:call];
    }
    else if([@"interstitial_ready" isEqualToString:call.method])
    {
        [self isAdReadyWithAdUnitID:adUnitID result:result];
    }
    else if([@"interstitial_show" isEqualToString:call.method])
    {
        [self showAdWithAdUnitID:adUnitID methodCall:call];
    }
    else if([@"interstitial_entryAdScenario" isEqualToString:call.method])
    {
        [self entryAdScenarioWithAdUnitID:adUnitID methodCall:call];
    }
    else if([@"interstitial_setCustomAdInfo" isEqualToString:call.method])
    {
        [self setCustomAdInfoWithAdUnitID:adUnitID methodCall:call];
    }
}

- (TPFInterstitial *)getInterstitialWithAdUnitID:(NSString *)adUnitID
{
    if([self.interstitialAds valueForKey:adUnitID])
    {
        return self.interstitialAds[adUnitID];
    }
    return nil;
}

- (void)loadAdWithAdUnitID:(NSString *)adUnitID methodCall:(FlutterMethodCall*)call
{
    TPFInterstitial *interstitial = [self getInterstitialWithAdUnitID:adUnitID];
    if(interstitial == nil)
    {
        
        interstitial = [[TPFInterstitial alloc] init];
        self.interstitialAds[adUnitID] = interstitial;
    }
    [interstitial setAdUnitID:adUnitID];
    NSDictionary *extraMap = call.arguments[@"extraMap"];
    if(extraMap != nil)
    {
        id customMap = extraMap[@"customMap"];
        if(customMap != nil && [customMap isKindOfClass:[NSDictionary class]])
        {
            [interstitial setCustomMap:customMap];
        }
    }
    [interstitial loadAd];
}

- (void)isAdReadyWithAdUnitID:(NSString *)adUnitID result:(FlutterResult)result

{
    BOOL isReady = NO;
    TPFInterstitial *interstitial = [self getInterstitialWithAdUnitID:adUnitID];
    if(interstitial != nil)
    {
        isReady = interstitial.isAdReady;
    }
    else
    {
        MSLogInfo(@"interstitial adUnitID:%@ not initialize",adUnitID);
    }
    result(@(isReady));
}

- (void)showAdWithAdUnitID:(NSString *)adUnitID methodCall:(FlutterMethodCall*)call
{
    TPFInterstitial *interstitial = [self getInterstitialWithAdUnitID:adUnitID];
    NSString *sceneId = call.arguments[@"sceneId"];
    if(interstitial != nil)
    {
        [interstitial showAdWithSceneId:sceneId];
    }
    else
    {
        MSLogInfo(@"interstitial adUnitID:%@ not initialize",adUnitID);
    }
}

- (void)entryAdScenarioWithAdUnitID:(NSString *)adUnitID methodCall:(FlutterMethodCall*)call
{
    TPFInterstitial *interstitial = [self getInterstitialWithAdUnitID:adUnitID];
    NSString *sceneId = call.arguments[@"sceneId"];
    if(interstitial != nil)
    {
        [interstitial entryAdScenario:sceneId];
    }
    else
    {
        MSLogInfo(@"interstitial adUnitID:%@ not initialize",adUnitID);
    }
}

- (void)setCustomAdInfoWithAdUnitID:(NSString *)adUnitID methodCall:(FlutterMethodCall*)call
{
    TPFInterstitial *interstitial = [self getInterstitialWithAdUnitID:adUnitID];
    NSDictionary *customAdInfo = call.arguments[@"customAdInfo"];
    if(interstitial != nil)
    {
        [interstitial setCustomAdInfo:customAdInfo];
    }
    else
    {
        MSLogInfo(@"interstitial adUnitID:%@ not initialize",adUnitID);
    }
}

@end
