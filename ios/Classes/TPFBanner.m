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
@property (nonatomic,assign)BOOL clickToShow;
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

- (void)setBackgroundColorStr:(NSString *)colorStr
{
    UIColor *color = [self colorWithString:colorStr];
    self.banner.backgroundColor = color;
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

- (void)setLocalParams:(NSDictionary *)dic
{
    self.banner.localParams = dic;
    MSLogTrace(@"%s dic:%@", __PRETTY_FUNCTION__,dic);
}

- (void)loadAdWithSceneId:(nullable NSString *)sceneId maxWaitTime:(NSTimeInterval)maxWaitTime
{
    MSLogTrace(@"%s sceneId:%@", __PRETTY_FUNCTION__,sceneId);
    self.sceneId = sceneId;
    [self.banner loadAdWithSceneId:sceneId maxWaitTime:maxWaitTime];
}

- (void)openAutoLoadCallback
{
    MSLogTrace(@"%s", __PRETTY_FUNCTION__);
    [self.banner openAutoLoadCallback];
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

- (nullable UIViewController *)viewControllerForPresentingModalView
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

///AD加载完成 首个广告源加载成功时回调 一次加载流程只会回调一次
- (void)tpBannerAdLoaded:(NSDictionary *)adInfo
{
    if(!self.didLoaded)
    {
        self.didLoaded = YES;
    }
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"loaded"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:adInfo error:nil];
    if(self.clickToShow && !self.banner.autoShow)
    {
        self.clickToShow = NO;
        [self showAd];
    }
}

///AD加载失败
///tpBannerAdOneLayerLoad:didFailWithError：返回三方源的错误信息
- (void)tpBannerAdLoadFailWithError:(NSError *)error
{
    MSLogTrace(@"%s error:%@", __PRETTY_FUNCTION__, error);
    NSString *eventNam = [self eventName:@"loadFailed"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:nil error:error];
}

///AD展现
- (void)tpBannerAdImpression:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"impression"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:adInfo error:nil];
}

///AD展现失败
- (void)tpBannerAdShow:(NSDictionary *)adInfo didFailWithError:(NSError *)error
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"showFailed"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:adInfo error:error];
}

///AD被点击
- (void)tpBannerAdClicked:(NSDictionary *)adInfo
{
    self.clickToShow = YES;
    [self.banner loadAdWithSceneId:self.sceneId];
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"clicked"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:adInfo error:nil];
}

///v7.6.0+新增 开始加载流程
- (void)tpBannerAdStartLoad:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"startLoad"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:adInfo error:nil];
}

///当每个广告源开始加载时会都会回调一次。
///v7.6.0+新增。替代原回调接口：tpBannerAdLoadStart:(NSDictionary *)adInfo;
- (void)tpBannerAdOneLayerStartLoad:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"oneLayerStartLoad"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:adInfo error:nil];
}

///bidding开始
- (void)tpBannerAdBidStart:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"bidStart"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:adInfo error:nil];
}

///bidding结束 error = nil 表示成功
- (void)tpBannerAdBidEnd:(NSDictionary *)adInfo error:(NSError *)error
{
    MSLogTrace(@"%s adInfo:%@ error:%@", __PRETTY_FUNCTION__, adInfo,error);
    NSString *eventNam = [self eventName:@"bidEnd"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:adInfo error:error];
}

///当每个广告源加载成功后会都会回调一次。
- (void)tpBannerAdOneLayerLoaded:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"oneLayerLoaded"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:adInfo error:nil];
}

///当每个广告源加载失败后会都会回调一次，返回三方源的错误信息
- (void)tpBannerAdOneLayerLoad:(NSDictionary *)adInfo didFailWithError:(NSError *)error
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"oneLayerLoadedFail"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:adInfo error:error];
}

///加载流程全部结束
- (void)tpBannerAdAllLoaded:(BOOL)success
{
    MSLogTrace(@"%s success:%@", __PRETTY_FUNCTION__, @(success));
    NSString *eventNam = [self eventName:@"allLoaded"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.banner.unitID adInfo:nil error:nil exp:@{@"success":@(success)}];
}

///三方关闭按钮触发时的回调
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

- (UIColor *)colorWithString:(NSString *)colorStr
{
    if([colorStr isEqualToString:@"clearColor"])
    {
        return [UIColor clearColor];
    }
    colorStr = [colorStr stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if(colorStr.length <= 6)
    {
        return [self colorWithHexString:colorStr alpha:1];
    }
    else if(colorStr.length == 8)
    {
        NSRange range;
        range.location = 0;
        range.length = 2;
        //alpha
        NSString *aString = [colorStr substringToIndex:2];
        unsigned int a;
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
        if(a == 0)
        {
            return [UIColor clearColor];
        }
        else
        {
            NSString *rgbString = [colorStr substringFromIndex:2];
            return [self colorWithHexString:rgbString alpha:((float) a / 255.0f)];
        }
    }
    return [UIColor clearColor];
}

- (UIColor *)colorWithHexString:(NSString *)hexString alpha:(float)alpha
{
    NSRange range;
    range.location = 0;
    range.length = 2;
    if(hexString.length < 6)
    {
        hexString = @"000000";
    }
    //R、G、B
    NSString *rString = [hexString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [hexString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [hexString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}
@end
