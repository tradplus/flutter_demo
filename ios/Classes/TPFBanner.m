//
//  TPFBanner.m
//  tradplus_sdk
//
//  Created by xuejun on 2022/7/19.
//

#import "TPFBanner.h"
#import "TradplusSdkPlugin.h"

@interface TPFBanner()<TradPlusADBannerDelegate>

@property (nonatomic,assign)BOOL didLoaded;
@property (nonatomic,copy)NSString *sceneId;
@end

@implementation TPFBanner

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.banner = [[TradPlusAdBanner alloc] init];
        self.banner.delegate = self;
        self.banner.autoShow = NO;
    }
    return self;
}

- (void)setAdUnitID:(NSString * _Nonnull)adUnitID
{
    MSLogTrace(@"%s adUnitID:%@", __PRETTY_FUNCTION__,adUnitID);
    [self.banner setAdUnitID:adUnitID];
}

- (void)setBannerSize:(CGSize)size
{
    CGRect rect = CGRectZero;
    rect.size = size;
    self.banner.frame = rect;
    [self.banner setBannerSize:size];
}

- (void)setBannerContentMode:(NSInteger)mode
{
    self.banner.bannerContentMode = mode;
}

- (void)setCustomMap:(NSDictionary *)dic
{
    MSLogTrace(@"%s dic:%@", __PRETTY_FUNCTION__,dic);
    id segmentTag = dic[@"segment_tag"];
    if([segmentTag isKindOfClass:[NSString class]])
    {
        self.banner.segmentTag = segmentTag;
    }
    self.banner.dicCustomValue = dic;
}

- (void)loadAdWithSceneId:(nullable NSString *)sceneId
{
    MSLogTrace(@"%s sceneId:%@", __PRETTY_FUNCTION__,sceneId);
    self.sceneId = sceneId;
    [self.banner loadAdWithSceneId:sceneId];
}

- (void)entryAdScenario:(nullable NSString *)sceneId
{
    MSLogTrace(@"%s entryAdScenario:%@", __PRETTY_FUNCTION__,sceneId);
    [self.banner entryAdScenario:sceneId];
}

- (BOOL)isAdReady
{
    MSLogTrace(@"%s", __PRETTY_FUNCTION__);
    if(self.didLoaded)
    {
        if(!self.banner.isAutoRefresh)
        {
            return self.banner.isAdReady;
        }
        else
        {
            return YES;
        }
    }
    return NO;
}

- (void)showAd
{
    MSLogTrace(@"%s", __PRETTY_FUNCTION__);
    [self.banner showWithSceneId:self.sceneId];
}

- (void)setCustomAdInfo:(NSDictionary *)customAdInfo
{
    MSLogTrace(@"%s", __PRETTY_FUNCTION__);
    self.banner.customAdInfo = customAdInfo;
}

- (NSString *)eventName:(NSString *)event
{
    return [NSString stringWithFormat:@"banner_%@",event];
}

//#pragma mark - TradPlusADBannerDelegate

///AD???????????? ???????????????????????????????????? ????????????????????????????????????
- (void)tpBannerAdLoaded:(NSDictionary *)adInfo
{
    if(!self.didLoaded)
    {
        self.didLoaded = YES;
    }
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"loaded"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:adInfo error:nil];
}

///AD????????????
///tpBannerAdOneLayerLoad:didFailWithError?????????????????????????????????
- (void)tpBannerAdLoadFailWithError:(NSError *)error
{
    MSLogTrace(@"%s error:%@", __PRETTY_FUNCTION__, error);
    NSString *eventNam = [self eventName:@"loadFailed"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:nil error:error];
}

///AD??????
- (void)tpBannerAdImpression:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"impression"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:adInfo error:nil];
}

///AD????????????
- (void)tpBannerAdShow:(NSDictionary *)adInfo didFailWithError:(NSError *)error
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"showFailed"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:adInfo error:error];
}

///AD?????????
- (void)tpBannerAdClicked:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"clicked"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:adInfo error:nil];
}

///v7.6.0+?????? ??????????????????
- (void)tpBannerAdStartLoad:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"startLoad"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:adInfo error:nil];
}

///?????????????????????????????????????????????????????????
///v7.6.0+?????????????????????????????????tpBannerAdLoadStart:(NSDictionary *)adInfo;
- (void)tpBannerAdOneLayerStartLoad:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"oneLayerStartLoad"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:adInfo error:nil];
}

///bidding??????
- (void)tpBannerAdBidStart:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"bidStart"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:adInfo error:nil];
}

///bidding?????? error = nil ????????????
- (void)tpBannerAdBidEnd:(NSDictionary *)adInfo error:(NSError *)error
{
    MSLogTrace(@"%s adInfo:%@ error:%@", __PRETTY_FUNCTION__, adInfo,error);
    NSString *eventNam = [self eventName:@"bidEnd"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:adInfo error:error];
}

///?????????????????????????????????????????????????????????
- (void)tpBannerAdOneLayerLoaded:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"oneLayerLoaded"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:adInfo error:nil];
}

///???????????????????????????????????????????????????????????????????????????????????????
- (void)tpBannerAdOneLayerLoad:(NSDictionary *)adInfo didFailWithError:(NSError *)error
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"oneLayerLoadedFail"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:adInfo error:error];
}

///????????????????????????
- (void)tpBannerAdAllLoaded:(BOOL)success
{
    MSLogTrace(@"%s success:%@", __PRETTY_FUNCTION__, @(success));
    NSString *eventNam = [self eventName:@"allLoaded"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:nil error:nil exp:@{@"success":@(success)}];
}

///????????????????????????????????????
- (void)tpBannerAdClose:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"closed"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:adInfo error:nil];
}

- (void)tpBannerAdIsLoading:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"isLoading"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:adInfo error:nil];
}
@end
