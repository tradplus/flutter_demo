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

- (void)setAdUnitID:(NSString * _Nonnull)adUnitID isAutoLoad:(BOOL)isAutoLoad
{
    MSLogTrace(@"%s adUnitID:%@ isAutoLoad:%@", __PRETTY_FUNCTION__,adUnitID,@(isAutoLoad));
    [self.rewarded setAdUnitID:adUnitID isAutoLoad:isAutoLoad];
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

- (NSString *)eventName:(NSString *)event
{
    return [NSString stringWithFormat:@"rewardVideo_%@",event];
}

#pragma mark - TradPlusADRewardedDelegate

///AD加载完成 首个广告源加载成功时回调 一次加载流程只会回调一次
- (void)tpRewardedAdLoaded:(NSDictionary *)adInfo
{
    MSLogInfo(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"loaded"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///AD加载失败
///tpRewardedAdOneLayerLoad:didFailWithError：返回三方源的错误信息
- (void)tpRewardedAdLoadFailWithError:(NSError *)error
{
    MSLogInfo(@"%s error:%@", __PRETTY_FUNCTION__, error);
    NSString *eventNam = [self eventName:@"loadFailed"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:nil error:error];
}

///AD展现
- (void)tpRewardedAdImpression:(NSDictionary *)adInfo
{
    MSLogInfo(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"impression"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///AD展现失败
- (void)tpRewardedAdShow:(NSDictionary *)adInfo didFailWithError:(NSError *)error
{
    MSLogInfo(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"showFailed"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:error];
}

///AD被点击
- (void)tpRewardedAdClicked:(NSDictionary *)adInfo
{
    MSLogInfo(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"clicked"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///AD关闭
- (void)tpRewardedAdDismissed:(NSDictionary *)adInfo
{
    MSLogInfo(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"closed"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///完成奖励
- (void)tpRewardedAdReward:(NSDictionary *)adInfo
{
    MSLogInfo(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"rewarded"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///v7.6.0+新增 开始加载流程
- (void)tpRewardedAdStartLoad:(NSDictionary *)adInfo
{
    MSLogInfo(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"startLoad"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///当每个广告源开始加载时会都会回调一次。
///v7.6.0+新增。替代原回调接口：tpRewardedAdLoadStart:(NSDictionary *)adInfo;
- (void)tpRewardedAdOneLayerStartLoad:(NSDictionary *)adInfo
{
    MSLogInfo(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"oneLayerStartLoad"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///bidding开始
- (void)tpRewardedAdBidStart:(NSDictionary *)adInfo
{
    MSLogInfo(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"bidStart"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///bidding结束 error = nil 表示成功
- (void)tpRewardedAdBidEnd:(NSDictionary *)adInfo error:(NSError *)error
{
    MSLogInfo(@"%s adInfo:%@ error:%@", __PRETTY_FUNCTION__, adInfo,error);
    NSString *eventNam = [self eventName:@"bidEnd"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:error];
}

///当每个广告源加载成功后会都会回调一次。
- (void)tpRewardedAdOneLayerLoaded:(NSDictionary *)adInfo
{
    MSLogInfo(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"oneLayerLoaded"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///当每个广告源加载失败后会都会回调一次，返回三方源的错误信息
- (void)tpRewardedAdOneLayerLoad:(NSDictionary *)adInfo didFailWithError:(NSError *)error
{
    MSLogInfo(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"oneLayerLoadedFail"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:error];
}

///加载流程全部结束
- (void)tpRewardedAdAllLoaded:(BOOL)success
{
    MSLogInfo(@"%s success:%@", __PRETTY_FUNCTION__, @(success));
    NSString *eventNam = [self eventName:@"allLoaded"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:nil error:nil exp:@{@"success":@(success)}];
}

///开始播放
- (void)tpRewardedAdPlayStart:(NSDictionary *)adInfo
{
    MSLogInfo(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"playStart"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///播放结束
- (void)tpRewardedAdPlayEnd:(NSDictionary *)adInfo
{
    MSLogInfo(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"playEnd"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

#pragma mark - TradPlusADRewardedPlayAgainDelegate

///AD展现
- (void)tpRewardedAdPlayAgainImpression:(NSDictionary *)adInfo
{
    MSLogInfo(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"playAgain_impression"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///AD展现失败
- (void)tpRewardedAdPlayAgainShow:(NSDictionary *)adInfo didFailWithError:(NSError *)error
{
    MSLogInfo(@"%s adInfo:%@ error:%@", __PRETTY_FUNCTION__, adInfo,error);
    NSString *eventNam = [self eventName:@"playAgain_showFailed"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:error];
}

///AD被点击
- (void)tpRewardedAdPlayAgainClicked:(NSDictionary *)adInfo
{
    MSLogInfo(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"playAgain_clicked"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///完成奖励
- (void)tpRewardedAdPlayAgainReward:(NSDictionary *)adInfo
{
    MSLogInfo(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"playAgain_rewarded"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///开始播放
- (void)tpRewardedAdPlayAgainPlayStart:(NSDictionary *)adInfo
{
    MSLogInfo(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"playAgain_playStart"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}

///播放结束
- (void)tpRewardedAdPlayAgainPlayEnd:(NSDictionary *)adInfo
{
    MSLogInfo(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"playAgain_playEnd"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.rewarded.unitID adInfo:adInfo error:nil];
}
@end
