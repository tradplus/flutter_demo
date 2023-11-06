//
//  TPFInterstitialManager.m
//  tradplus_sdk
//
//  Created by xuejun on 2022/7/19.
//

#import "TPFBannerManager.h"
#import <TradPlusAds/TradPlusAds.h>

@interface TPFBannerManager()

@property (nonatomic,strong)NSMutableDictionary <NSString *,TPFBanner *>*bannerAds;
@end

@implementation TPFBannerManager

+ (TPFBannerManager *)sharedInstance
{
    static TPFBannerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TPFBannerManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bannerAds = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result
{
    NSString *adUnitID = call.arguments[@"adUnitID"];
    if([@"banner_load" isEqualToString:call.method])
    {
        [self loadAdWithAdUnitID:adUnitID methodCall:call];
    }
    else if([@"banner_ready" isEqualToString:call.method])
    {
        [self isAdReadyWithAdUnitID:adUnitID result:result];
    }
    else if([@"banner_entryAdScenario" isEqualToString:call.method])
    {
        [self entryAdScenarioWithAdUnitID:adUnitID methodCall:call];
    }
    else if([@"banner_setCustomAdInfo" isEqualToString:call.method])
    {
        [self setCustomAdInfoWithAdUnitID:adUnitID methodCall:call];
    }
}

- (TPFBanner *)getBannerWithAdUnitID:(NSString *)adUnitID
{
    if([self.bannerAds valueForKey:adUnitID])
    {
        return self.bannerAds[adUnitID];
    }
    return nil;
}

- (void)loadAdWithAdUnitID:(NSString *)adUnitID methodCall:(FlutterMethodCall*)call
{
    TPFBanner *banner = [self getBannerWithAdUnitID:adUnitID];
    if(banner == nil)
    {
        
        banner = [[TPFBanner alloc] init];
        self.bannerAds[adUnitID] = banner;
    }
    NSDictionary *extraMap = call.arguments[@"extraMap"];
    CGFloat maxWaitTime = 0;
    NSString *sceneId = nil;
    if(extraMap != nil)
    {
        CGFloat height = [extraMap[@"height"] floatValue];
        CGFloat width = [extraMap[@"width"] floatValue];
        if(height == 0)
        {
            height = 50;
        }
        if(width == 0)
        {
            width = [UIScreen mainScreen].bounds.size.width;
        }
        [banner setBannerSize:CGSizeMake(width, height)];
        NSInteger contentMode = [extraMap[@"contentMode"] integerValue];
        [banner setBannerContentMode:contentMode];
        id customMap = extraMap[@"customMap"];
        if(customMap != nil && [customMap isKindOfClass:[NSDictionary class]])
        {
            [banner setCustomMap:customMap];
        }
        id localParams = extraMap[@"localParams"];
        if(localParams != nil && [localParams isKindOfClass:[NSDictionary class]])
        {
            [banner setLocalParams:localParams];
        }
        id backgroundColorStr = extraMap[@"backgroundColor"];
        if(backgroundColorStr != nil && [backgroundColorStr isKindOfClass:[NSString class]])
        {
            [banner setBackgroundColorStr:backgroundColorStr];
        }
        BOOL openAutoLoadCallback = [extraMap[@"openAutoLoadCallback"] boolValue];
        if(openAutoLoadCallback)
        {
            [banner openAutoLoadCallback];
        }
        maxWaitTime = [extraMap[@"maxWaitTime"] floatValue];
        sceneId = extraMap[@"sceneId"];
    }
    [banner setAdUnitID:adUnitID];
    [banner loadAdWithSceneId:sceneId maxWaitTime:maxWaitTime];
}

- (void)isAdReadyWithAdUnitID:(NSString *)adUnitID result:(FlutterResult)result

{
    BOOL isReady = NO;
    TPFBanner *banner = [self getBannerWithAdUnitID:adUnitID];
    if(banner != nil)
    {
        isReady = banner.isAdReady;
    }
    else
    {
        MSLogInfo(@"banner adUnitID:%@ not initialize",adUnitID);
    }
    result(@(isReady));
}

- (void)entryAdScenarioWithAdUnitID:(NSString *)adUnitID methodCall:(FlutterMethodCall*)call
{
    TPFBanner *banner = [self getBannerWithAdUnitID:adUnitID];
    NSString *sceneId = call.arguments[@"sceneId"];
    if(banner != nil)
    {
        [banner entryAdScenario:sceneId];
    }
    else
    {
        MSLogInfo(@"banner adUnitID:%@ not initialize",adUnitID);
    }
}

- (void)setCustomAdInfoWithAdUnitID:(NSString *)adUnitID methodCall:(FlutterMethodCall*)call
{
    TPFBanner *banner = [self getBannerWithAdUnitID:adUnitID];
    NSDictionary *customAdInfo = call.arguments[@"customAdInfo"];
    if(banner != nil)
    {
        [banner setCustomAdInfo:customAdInfo];
    }
    else
    {
        MSLogInfo(@"banner adUnitID:%@ not initialize",adUnitID);
    }
}

@end
