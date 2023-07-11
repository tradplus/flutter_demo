//
//  TPFInterstitialManager.m
//  tradplus_sdk
//
//  Created by xuejun on 2022/7/19.
//

#import "TPFOfferwallManager.h"
#import <TradPlusAds/TradPlusAds.h>

@interface TPFOfferwallManager()

@property (nonatomic,strong)NSMutableDictionary <NSString *,TPFOfferwall *>*offerwallAds;
@end

@implementation TPFOfferwallManager

+ (TPFOfferwallManager *)sharedInstance
{
    static TPFOfferwallManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TPFOfferwallManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.offerwallAds = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result
{
    NSString *adUnitID = call.arguments[@"adUnitID"];
    if([@"offerwall_load" isEqualToString:call.method])
    {
        [self loadAdWithAdUnitID:adUnitID methodCall:call];
    }
    else if([@"offerwall_ready" isEqualToString:call.method])
    {
        [self isAdReadyWithAdUnitID:adUnitID result:result];
    }
    else if([@"offerwall_show" isEqualToString:call.method])
    {
        [self showAdWithAdUnitID:adUnitID methodCall:call];
    }
    else if([@"offerwall_entryAdScenario" isEqualToString:call.method])
    {
        [self entryAdScenarioWithAdUnitID:adUnitID methodCall:call];
    }
    else if([@"offerwall_currency" isEqualToString:call.method])
    {
        [self getCurrencyWithAdUnitID:adUnitID methodCall:call];
    }
    else if([@"offerwall_spend" isEqualToString:call.method])
    {
        [self spendWithAdUnitID:adUnitID methodCall:call];
    }
    else if([@"offerwall_award" isEqualToString:call.method])
    {
        [self awardWithAdUnitID:adUnitID methodCall:call];
    }
    else if([@"offerwall_setUserId" isEqualToString:call.method])
    {
        [self setUserIdWithAdUnitID:adUnitID methodCall:call];
    }
    else if([@"offerwall_setCustomAdInfo" isEqualToString:call.method])
    {
        [self setCustomAdInfoWithAdUnitID:adUnitID methodCall:call];
    }
}

- (TPFOfferwall *)getOfferwallWithAdUnitID:(NSString *)adUnitID
{
    if([self.offerwallAds valueForKey:adUnitID])
    {
        return self.offerwallAds[adUnitID];
    }
    return nil;
}

- (void)loadAdWithAdUnitID:(NSString *)adUnitID methodCall:(FlutterMethodCall*)call
{
    TPFOfferwall *offerwall = [self getOfferwallWithAdUnitID:adUnitID];
    if(offerwall == nil)
    {
        
        offerwall = [[TPFOfferwall alloc] init];
        self.offerwallAds[adUnitID] = offerwall;
    }
    NSDictionary *extraMap = call.arguments[@"extraMap"];
    CGFloat maxWaitTime = 0;
    if(extraMap != nil)
    {
        id customMap = extraMap[@"customMap"];
        if(customMap != nil && [customMap isKindOfClass:[NSDictionary class]])
        {
            [offerwall setCustomMap:customMap];
        }
        id localParams = extraMap[@"localParams"];
        if(localParams != nil && [localParams isKindOfClass:[NSDictionary class]])
        {
            [offerwall setLocalParams:localParams];
        }
        BOOL openAutoLoadCallback = [extraMap[@"openAutoLoadCallback"] boolValue];
        if(openAutoLoadCallback)
        {
            [offerwall openAutoLoadCallback];
        }
        maxWaitTime = [extraMap[@"maxWaitTime"] floatValue];
    }
    [offerwall setAdUnitID:adUnitID];
    [offerwall loadAdWithMaxWaitTime:maxWaitTime];
}

- (void)isAdReadyWithAdUnitID:(NSString *)adUnitID result:(FlutterResult)result

{
    BOOL isReady = NO;
    TPFOfferwall *offerwall = [self getOfferwallWithAdUnitID:adUnitID];
    if(offerwall != nil)
    {
        isReady = offerwall.isAdReady;
    }
    else
    {
        MSLogInfo(@"offerwall adUnitID:%@ not initialize",adUnitID);
    }
    result(@(isReady));
}

- (void)showAdWithAdUnitID:(NSString *)adUnitID methodCall:(FlutterMethodCall*)call
{
    TPFOfferwall *offerwall = [self getOfferwallWithAdUnitID:adUnitID];
    NSString *sceneId = call.arguments[@"sceneId"];
    if(offerwall != nil)
    {
        [offerwall showAdWithSceneId:sceneId];
    }
    else
    {
        MSLogInfo(@"offerwall adUnitID:%@ not initialize",adUnitID);
    }
}

- (void)entryAdScenarioWithAdUnitID:(NSString *)adUnitID methodCall:(FlutterMethodCall*)call
{
    TPFOfferwall *offerwall = [self getOfferwallWithAdUnitID:adUnitID];
    NSString *sceneId = call.arguments[@"sceneId"];
    if(offerwall != nil)
    {
        [offerwall entryAdScenario:sceneId];
    }
    else
    {
        MSLogInfo(@"offerwall adUnitID:%@ not initialize",adUnitID);
    }
}

- (void)getCurrencyWithAdUnitID:(NSString *)adUnitID methodCall:(FlutterMethodCall*)call
{
    TPFOfferwall *offerwall = [self getOfferwallWithAdUnitID:adUnitID];
    if(offerwall != nil)
    {
        [offerwall getCurrency];
    }
    else
    {
        MSLogInfo(@"offerwall adUnitID:%@ not initialize",adUnitID);
    }
}

- (void)spendWithAdUnitID:(NSString *)adUnitID methodCall:(FlutterMethodCall*)call
{
    TPFOfferwall *offerwall = [self getOfferwallWithAdUnitID:adUnitID];
    int count = [call.arguments[@"count"] intValue];
    if(offerwall != nil)
    {
        [offerwall spendWithAmount:count];
    }
    else
    {
        MSLogInfo(@"offerwall adUnitID:%@ not initialize",adUnitID);
    }
}


- (void)awardWithAdUnitID:(NSString *)adUnitID methodCall:(FlutterMethodCall*)call
{
    TPFOfferwall *offerwall = [self getOfferwallWithAdUnitID:adUnitID];
    int count = [call.arguments[@"count"] intValue];
    if(offerwall != nil)
    {
        [offerwall awardWithAmount:count];
    }
    else
    {
        MSLogInfo(@"offerwall adUnitID:%@ not initialize",adUnitID);
    }
}

- (void)setUserIdWithAdUnitID:(NSString *)adUnitID methodCall:(FlutterMethodCall*)call
{
    TPFOfferwall *offerwall = [self getOfferwallWithAdUnitID:adUnitID];
    NSString *userId = call.arguments[@"userId"];
    if(offerwall != nil)
    {
        [offerwall setUserId:userId];
    }
    else
    {
        MSLogInfo(@"offerwall adUnitID:%@ not initialize",adUnitID);
    }
}

- (void)setCustomAdInfoWithAdUnitID:(NSString *)adUnitID methodCall:(FlutterMethodCall*)call
{
    TPFOfferwall *offerwall = [self getOfferwallWithAdUnitID:adUnitID];
    NSDictionary *customAdInfo = call.arguments[@"customAdInfo"];
    if(offerwall != nil)
    {
        [offerwall setCustomAdInfo:customAdInfo];
    }
    else
    {
        MSLogInfo(@"offerwall adUnitID:%@ not initialize",adUnitID);
    }
}
@end
