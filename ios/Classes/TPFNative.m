//
//  TPFNative.m
//  tradplus_sdk
//
//  Created by xuejun on 2022/7/13.
//

#import "TPFNative.h"
#import <TradPlusAds/TradPlusAds.h>
#import "TradplusSdkPlugin.h"

@interface TPFNative()<TradPlusADNativeDelegate>

@property (nonatomic,strong)TradPlusAdNative *native;
@end

@implementation TPFNative

- (instancetype)init
{
    self = [super init];
    if (self) {
        [TradPlus setLogLevel:MSLogLevelOff];
        self.native = [[TradPlusAdNative alloc] init];
        self.native.delegate = self;
    }
    return self;
}

- (void)setTemplateRenderSize:(CGSize)size
{
    MSLogTrace(@"%s size:%@", __PRETTY_FUNCTION__,@(size));
    [self.native setTemplateRenderSize:size];
}

- (void)setAdUnitID:(NSString * _Nonnull)adUnitID
{
    MSLogTrace(@"%s adUnitID:%@", __PRETTY_FUNCTION__,adUnitID);
    [self.native setAdUnitID:adUnitID];
}

- (void)loadAd
{
    MSLogTrace(@"%s", __PRETTY_FUNCTION__);
    [self.native loadAd];
}

- (void)loadAds:(NSInteger)adsCount
{
    MSLogTrace(@"%s %ld", __PRETTY_FUNCTION__,(long)adsCount);
    [self.native loadAds:adsCount];
}

- (TradPlusAdNativeObject *)getReadyNativeObject
{
    return self.native.getReadyNativeObject;
}

- (void)showWithClassName:(Class)viewClass subview:(UIView *)adView sceneId:(NSString *)sceneId
{
    MSLogTrace(@"%s sceneId:%@", __PRETTY_FUNCTION__,sceneId);
    [self.native showADWithRenderingViewClass:viewClass subview:adView sceneId:sceneId];
}

- (void)showWithRenderer:(TradPlusNativeRenderer *)renderer subview:(UIView *)adView sceneId:(NSString *)sceneId
{
    MSLogTrace(@"%s sceneId:%@", __PRETTY_FUNCTION__,sceneId);
    [self.native showADWithNativeRenderer:renderer subview:adView sceneId:sceneId];
}

- (void)setCustomMap:(NSDictionary *)dic
{
    MSLogTrace(@"%s dic:%@", __PRETTY_FUNCTION__,dic);
    id segmentTag = dic[@"segment_tag"];
    if([segmentTag isKindOfClass:[NSString class]])
    {
        self.native.segmentTag = segmentTag;
    }
    self.native.dicCustomValue = dic;
}

- (void)entryAdScenario:(nullable NSString *)sceneId
{
    MSLogTrace(@"%s sceneId:%@", __PRETTY_FUNCTION__,sceneId);
    [self.native entryAdScenario:sceneId];
}

- (BOOL)isAdReady
{
    MSLogTrace(@"%s", __PRETTY_FUNCTION__);
    return self.native.isAdReady;
}

- (NSInteger)getLoadedCount
{
    MSLogTrace(@"%s", __PRETTY_FUNCTION__);
    return self.native.readyAdCount;
}

- (void)setCustomAdInfo:(NSDictionary *)customAdInfo
{
    MSLogTrace(@"%s", __PRETTY_FUNCTION__);
    self.native.customAdInfo = customAdInfo;
}

- (NSString *)eventName:(NSString *)event
{
    return [NSString stringWithFormat:@"native_%@",event];
}

#pragma mark - TradPlusADNativeDelegate

///AD加载完成 首个广告源加载成功时回调 一次加载流程只会回调一次
- (void)tpNativeAdLoaded:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s %@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"loaded"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.native.unitID adInfo:adInfo error:nil];
}

///AD加载失败
///tpNativeAdOneLayerLoad:didFailWithError：返回三方源的错误信息
- (void)tpNativeAdLoadFailWithError:(NSError *)error
{
    MSLogTrace(@"%s %@", __PRETTY_FUNCTION__, error);
    NSString *eventNam = [self eventName:@"loadFailed"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.native.unitID adInfo:nil error:error];
}

///AD展现
- (void)tpNativeAdImpression:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s %@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"impression"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.native.unitID adInfo:adInfo error:nil];
}

///AD展现失败
- (void)tpNativeAdShow:(NSDictionary *)adInfo didFailWithError:(NSError *)error
{
    MSLogTrace(@"%s %@ %@", __PRETTY_FUNCTION__, adInfo,error);
    NSString *eventNam = [self eventName:@"showFailed"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.native.unitID adInfo:adInfo error:nil];
}

///AD被点击
- (void)tpNativeAdClicked:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s %@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"clicked"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.native.unitID adInfo:adInfo error:nil];
}

///v7.6.0+新增 开始加载流程
- (void)tpNativeAdStartLoad:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s %@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"startLoad"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.native.unitID adInfo:adInfo error:nil];
}

///当每个广告源开始加载时会都会回调一次。
///v7.6.0+新增。替代原回调接口：tpNativeAdLoadStart:(NSDictionary *)adInfo;
- (void)tpNativeAdOneLayerStartLoad:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s %@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"oneLayerStartLoad"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.native.unitID adInfo:adInfo error:nil];
}

///AD被关闭
- (void)tpNativeAdClose:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s %@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"closed"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.native.unitID adInfo:adInfo error:nil];
}

///bidding开始
- (void)tpNativeAdBidStart:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s %@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"bidStart"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.native.unitID adInfo:adInfo error:nil];
}

///bidding结束 error = nil 表示成功
- (void)tpNativeAdBidEnd:(NSDictionary *)adInfo error:(NSError *)error
{
    MSLogTrace(@"%s %@ %@", __PRETTY_FUNCTION__, adInfo,error);
    NSString *eventNam = [self eventName:@"bidEnd"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.native.unitID adInfo:adInfo error:error];
}

///当每个广告源加载成功后会都会回调一次。
- (void)tpNativeAdOneLayerLoaded:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s %@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"oneLayerLoaded"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.native.unitID adInfo:adInfo error:nil];
}

///当每个广告源加载失败后会都会回调一次，返回三方源的错误信息
- (void)tpNativeAdOneLayerLoad:(NSDictionary *)adInfo didFailWithError:(NSError *)error
{
    MSLogTrace(@"%s %@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"oneLayerLoadedFail"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.native.unitID adInfo:adInfo error:error];
}

///加载流程全部结束
- (void)tpNativeAdAllLoaded:(BOOL)success
{
    MSLogTrace(@"%s %@", __PRETTY_FUNCTION__, @(success));
    NSString *eventNam = [self eventName:@"allLoaded"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.native.unitID adInfo:nil error:nil exp:@{@"success":@(success)}];
}

///开始播放 v7.8.0+
- (void)tpNativeAdVideoPlayStart:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s %@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"playStart"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.native.unitID adInfo:adInfo error:nil];
}

///播放结束 v7.8.0+
- (void)tpNativeAdVideoPlayEnd:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s %@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"playEnd"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.native.unitID adInfo:adInfo error:nil];
}

- (void)tpNativeAdIsLoading:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s %@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"isLoading"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.native.unitID adInfo:adInfo error:nil];
}

///视频贴片类型播放完成回调 v6.8.0+
- (void)tpNativePasterDidPlayFinished:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s %@", __PRETTY_FUNCTION__, adInfo);
}
@end
