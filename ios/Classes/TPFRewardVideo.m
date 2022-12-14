//
//  TPInterstitial.m
//  tradplus_sdk
//
//  Created by xuejun on 2022/7/19.
//

#import "TPFRewardVideo.h"

#import <TradPlusAds/TradPlusAds.h>
#import "TradplusSdkPlugin.h"

@interface TPFRewardVideo()<TradPlusADRewardedDelegate,TradPlusADRewardedPlayAgainDelegate>

@property (nonatomic,strong)TradPlusAdRewarded *rewarded;
@end

@implementation TPFRewardVideo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rewarded = [[TradPlusAdRewarded alloc] init];
        self.rewarded.delegate = self;
        self.rewarded.playAgainDelegate = self;
    }
    return self;
}

- (void)setAdUnitID:(NSString * _Nonnull)adUnitID
{
    MSLogTrace(@"%s adUnitID:%@", __PRETTY_FUNCTION__,adUnitID);
    [self.rewarded setAdUnitID:adUnitID];
}

- (void)setCustomMap:(NSDictionary *)dic
{
    MSLogTrace(@"%s dic:%@", __PRETTY_FUNCTION__,dic);
    id segmentTag = dic[@"segment_tag"];
    if([segmentTag isKindOfClass:[NSString class]])
    {
        self.rewarded.segmentTag = segmentTag;
    }
    self.rewarded.dicCustomValue = dic;
}

- (void)setServerSideVerificationOptionsWithUserID:(nonnull NSString *)userID customData:(nullable NSString *)customData
{
    MSLogTrace(@"%s ", __PRETTY_FUNCTION__);
    [self.rewarded setServerSideVerificationOptionsWithUserID:userID customData:customData];
}

- (void)loadAd
{
    MSLogTrace(@"%s ", __PRETTY_FUNCTION__);
    [self.rewarded loadAd];
}

- (void)showAdWithSceneId:(nullable NSString *)sceneId
{
    MSLogTrace(@"%s sceneId:%@", __PRETTY_FUNCTION__,sceneId);
    [self.rewarded showAdWithSceneId:sceneId];
}

- (void)entryAdScenario:(nullable NSString *)sceneId
{
    MSLogTrace(@"%s sceneId:%@", __PRETTY_FUNCTION__,sceneId);
    [self.rewarded entryAdScenario:sceneId];
}

- (BOOL)isAdReady
{
    MSLogTrace(@"%s ", __PRETTY_FUNCTION__);
    return self.rewarded.isAdReady;
}

- (void)setCustomAdInfo:(NSDictionary *)customAdInfo
{
    MSLogTrace(@"%s", __PRETTY_FUNCTION__);
    self.rewarded.customAdInfo = customAdInfo;
}

- (NSString *)eventName:(NSString *)event
{
    return [NSString stringWithFormat:@"rewardVideo_%@",event];
}

#pragma mark - TradPlusADRewardedDelegate

///AD???????????? ???????????????????????????????????? ????????????????????????????????????
- (void)tpRewardedAdLoaded:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"loaded"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///AD????????????
///tpRewardedAdOneLayerLoad:didFailWithError?????????????????????????????????
- (void)tpRewardedAdLoadFailWithError:(NSError *)error
{
    MSLogTrace(@"%s error:%@", __PRETTY_FUNCTION__, error);
    NSString *eventNam = [self eventName:@"loadFailed"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:nil error:error];
}

///AD??????
- (void)tpRewardedAdImpression:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"impression"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///AD????????????
- (void)tpRewardedAdShow:(NSDictionary *)adInfo didFailWithError:(NSError *)error
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"showFailed"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:error];
}

///AD?????????
- (void)tpRewardedAdClicked:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"clicked"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///AD??????
- (void)tpRewardedAdDismissed:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"closed"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///????????????
- (void)tpRewardedAdReward:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"rewarded"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///v7.6.0+?????? ??????????????????
- (void)tpRewardedAdStartLoad:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"startLoad"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///?????????????????????????????????????????????????????????
///v7.6.0+?????????????????????????????????tpRewardedAdLoadStart:(NSDictionary *)adInfo;
- (void)tpRewardedAdOneLayerStartLoad:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"oneLayerStartLoad"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///bidding??????
- (void)tpRewardedAdBidStart:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"bidStart"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///bidding?????? error = nil ????????????
- (void)tpRewardedAdBidEnd:(NSDictionary *)adInfo error:(NSError *)error
{
    MSLogTrace(@"%s adInfo:%@ error:%@", __PRETTY_FUNCTION__, adInfo,error);
    NSString *eventNam = [self eventName:@"bidEnd"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:error];
}

///?????????????????????????????????????????????????????????
- (void)tpRewardedAdOneLayerLoaded:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"oneLayerLoaded"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///???????????????????????????????????????????????????????????????????????????????????????
- (void)tpRewardedAdOneLayerLoad:(NSDictionary *)adInfo didFailWithError:(NSError *)error
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"oneLayerLoadedFail"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:error];
}

///????????????????????????
- (void)tpRewardedAdAllLoaded:(BOOL)success
{
    MSLogTrace(@"%s success:%@", __PRETTY_FUNCTION__, @(success));
    NSString *eventNam = [self eventName:@"allLoaded"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:nil error:nil exp:@{@"success":@(success)}];
}

///????????????
- (void)tpRewardedAdPlayStart:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"playStart"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///????????????
- (void)tpRewardedAdPlayEnd:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"playEnd"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

#pragma mark - TradPlusADRewardedPlayAgainDelegate

///AD??????
- (void)tpRewardedAdPlayAgainImpression:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"playAgain_impression"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///AD????????????
- (void)tpRewardedAdPlayAgainShow:(NSDictionary *)adInfo didFailWithError:(NSError *)error
{
    MSLogTrace(@"%s adInfo:%@ error:%@", __PRETTY_FUNCTION__, adInfo,error);
    NSString *eventNam = [self eventName:@"playAgain_showFailed"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:error];
}

///AD?????????
- (void)tpRewardedAdPlayAgainClicked:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"playAgain_clicked"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///????????????
- (void)tpRewardedAdPlayAgainReward:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"playAgain_rewarded"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///????????????
- (void)tpRewardedAdPlayAgainPlayStart:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"playAgain_playStart"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///????????????
- (void)tpRewardedAdPlayAgainPlayEnd:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"playAgain_playEnd"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

- (void)tpRewardedAdIsLoading:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"isLoading"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}
@end
