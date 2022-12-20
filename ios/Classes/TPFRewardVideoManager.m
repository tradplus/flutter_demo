//
//  TPFRewardVideoManager.m
//  tradplus_sdk
//
//  Created by xuejun on 2022/7/19.
//

#import "TPFRewardVideoManager.h"
#import <TradPlusAds/TradPlusAds.h>

@interface TPFRewardVideoManager()

@property (nonatomic,strong)NSMutableDictionary <NSString *,TPFRewardVideo *>*rewardVideoAds;
@end

@implementation TPFRewardVideoManager

+ (TPFRewardVideoManager *)sharedInstance
{
    static TPFRewardVideoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TPFRewardVideoManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rewardVideoAds = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result
{
    NSString *adUnitID = call.arguments[@"adUnitID"];
    if([@"rewardVideo_load" isEqualToString:call.method])
    {
        [self loadAdWithAdUnitID:adUnitID methodCall:call];
    }
    else if([@"rewardVideo_ready" isEqualToString:call.method])
    {
        [self isAdReadyWithAdUnitID:adUnitID result:result];
    }
    else if([@"rewardVideo_show" isEqualToString:call.method])
    {
        [self showAdWithAdUnitID:adUnitID methodCall:call];
    }
    else if([@"rewardVideo_entryAdScenario" isEqualToString:call.method])
    {
        [self entryAdScenarioWithAdUnitID:adUnitID methodCall:call];
    }
    else if([@"rewardVideo_setCustomAdInfo" isEqualToString:call.method])
    {
        [self setCustomAdInfoWithAdUnitID:adUnitID methodCall:call];
    }
}

- (TPFRewardVideo *)getRewardVideoWithAdUnitID:(NSString *)adUnitID
{
    if([self.rewardVideoAds valueForKey:adUnitID])
    {
        return self.rewardVideoAds[adUnitID];
    }
    return nil;
}

- (void)loadAdWithAdUnitID:(NSString *)adUnitID methodCall:(FlutterMethodCall*)call
{
    TPFRewardVideo *rewardVideo = [self getRewardVideoWithAdUnitID:adUnitID];
    if(rewardVideo == nil)
    {
        rewardVideo = [[TPFRewardVideo alloc] init];
        self.rewardVideoAds[adUnitID] = rewardVideo;
    }
    [rewardVideo setAdUnitID:adUnitID];
    NSDictionary *extraMap = call.arguments[@"extraMap"];
    if(extraMap != nil)
    {
        id customMap = extraMap[@"customMap"];
        if(customMap != nil && [customMap isKindOfClass:[NSDictionary class]])
        {
            [rewardVideo setCustomMap:customMap];
        }
    }
    NSString *userId = extraMap[@"userId"];
    NSString *customData = extraMap[@"customData"];
    if(userId != nil)
    {
        [rewardVideo setServerSideVerificationOptionsWithUserID:userId customData:customData];
    }
    [rewardVideo loadAd];
}

- (void)isAdReadyWithAdUnitID:(NSString *)adUnitID result:(FlutterResult)result

{
    BOOL isReady = NO;
    TPFRewardVideo *rewardVideo = [self getRewardVideoWithAdUnitID:adUnitID];
    if(rewardVideo != nil)
    {
        isReady = rewardVideo.isAdReady;
    }
    else
    {
        MSLogInfo(@"rewardVideo adUnitID:%@ not initialize",adUnitID);
    }
    result(@(isReady));
}

- (void)showAdWithAdUnitID:(NSString *)adUnitID methodCall:(FlutterMethodCall*)call
{
    TPFRewardVideo *rewardVideo = [self getRewardVideoWithAdUnitID:adUnitID];
    NSString *sceneId = call.arguments[@"sceneId"];
    if(rewardVideo != nil)
    {
        [rewardVideo showAdWithSceneId:sceneId];
    }
    else
    {
        MSLogInfo(@"rewardVideo adUnitID:%@ not initialize",adUnitID);
    }
}

- (void)entryAdScenarioWithAdUnitID:(NSString *)adUnitID methodCall:(FlutterMethodCall*)call
{
    TPFRewardVideo *rewardVideo = [self getRewardVideoWithAdUnitID:adUnitID];
    NSString *sceneId = call.arguments[@"sceneId"];
    if(rewardVideo != nil)
    {
        [rewardVideo entryAdScenario:sceneId];
    }
    else
    {
        MSLogInfo(@"rewardVideo adUnitID:%@ not initialize",adUnitID);
    }
}

- (void)setCustomAdInfoWithAdUnitID:(NSString *)adUnitID methodCall:(FlutterMethodCall*)call
{
    TPFRewardVideo *rewardVideo = [self getRewardVideoWithAdUnitID:adUnitID];
    NSDictionary *customAdInfo = call.arguments[@"customAdInfo"];
    if(rewardVideo != nil)
    {
        [rewardVideo setCustomAdInfo:customAdInfo];
    }
    else
    {
        MSLogInfo(@"rewardVideo adUnitID:%@ not initialize",adUnitID);
    }
}
@end
