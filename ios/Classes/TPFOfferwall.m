//
//  TPInterstitial.m
//  tradplus_sdk
//
//  Created by xuejun on 2022/7/19.
//

#import "TPFOfferwall.h"

#import <TradPlusAds/TradPlusAds.h>
#import "TradplusSdkPlugin.h"

@interface TPFOfferwall()<TradPlusADOfferwallDelegate>

@property (nonatomic,strong)TradPlusAdOfferwall *offerwall;
@end

@implementation TPFOfferwall

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.offerwall = [[TradPlusAdOfferwall alloc] init];
        self.offerwall.delegate = self;
    }
    return self;
}

- (void)setAdUnitID:(NSString * _Nonnull)adUnitID
{
    MSLogTrace(@"%s adUnitID:%@", __PRETTY_FUNCTION__,adUnitID);
    [self.offerwall setAdUnitID:adUnitID];
}

- (void)setCustomMap:(NSDictionary *)dic
{
    MSLogTrace(@"%s dic:%@", __PRETTY_FUNCTION__,dic);
    id segmentTag = dic[@"segment_tag"];
    if([segmentTag isKindOfClass:[NSString class]])
    {
        self.offerwall.segmentTag = segmentTag;
    }
    self.offerwall.dicCustomValue = dic;
}

- (void)setLocalParams:(NSDictionary *)dic
{
    self.offerwall.localParams = dic;
    MSLogTrace(@"%s dic:%@", __PRETTY_FUNCTION__,dic);
}

- (void)loadAdWithMaxWaitTime:(NSTimeInterval)maxWaitTime
{
    MSLogTrace(@"%s ", __PRETTY_FUNCTION__);
    [self.offerwall loadAdWithMaxWaitTime:maxWaitTime];
}

- (void)openAutoLoadCallback
{
    MSLogTrace(@"%s ", __PRETTY_FUNCTION__);
    [self.offerwall openAutoLoadCallback];
}

- (void)showAdWithSceneId:(nullable NSString *)sceneId
{
    MSLogTrace(@"%s sceneId:%@", __PRETTY_FUNCTION__,sceneId);
    [self.offerwall showAdWithSceneId:sceneId];
}

- (void)entryAdScenario:(nullable NSString *)sceneId
{
    MSLogTrace(@"%s sceneId:%@", __PRETTY_FUNCTION__,sceneId);
    [self.offerwall entryAdScenario:sceneId];
}

- (BOOL)isAdReady
{
    MSLogTrace(@"%s ", __PRETTY_FUNCTION__);
    return self.offerwall.isAdReady;
}

- (void)getCurrency
{
    MSLogTrace(@"%s ", __PRETTY_FUNCTION__);
    [self.offerwall getCurrencyBalance];
}

- (void)spendWithAmount:(int)amount
{
    MSLogTrace(@"%s amount:%@", __PRETTY_FUNCTION__,@(amount));
    [self.offerwall spendCurrency:amount];
}

- (void)awardWithAmount:(int)amount
{
    MSLogTrace(@"%s amount:%@", __PRETTY_FUNCTION__,@(amount));
    [self.offerwall awardCurrency:amount];
}

- (void)setUserId:(NSString *)userId
{
    MSLogTrace(@"%s userId:%@", __PRETTY_FUNCTION__,userId);
    [self.offerwall setUserId:userId];
}

- (void)setCustomAdInfo:(NSDictionary *)customAdInfo
{
    MSLogTrace(@"%s", __PRETTY_FUNCTION__);
    self.offerwall.customAdInfo = customAdInfo;
}

- (NSString *)eventName:(NSString *)event
{
    return [NSString stringWithFormat:@"offerwall_%@",event];
}

#pragma mark - TradPlusADOfferwallDelegate

///AD加载完成 首个广告源加载成功时回调 一次加载流程只会回调一次
- (void)tpOfferwallAdLoaded:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"loaded"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.offerwall.unitID adInfo:adInfo error:nil];
}

///AD加载失败
///tpOfferwallAdOneLayerLoaded:didFailWithError：返回三方源的错误信息
- (void)tpOfferwallAdLoadFailWithError:(NSError *)error
{
    MSLogTrace(@"%s error:%@", __PRETTY_FUNCTION__, error);
    NSString *eventNam = [self eventName:@"loadFailed"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.offerwall.unitID adInfo:nil error:error];
}

///AD展现
- (void)tpOfferwallAdImpression:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"impression"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.offerwall.unitID adInfo:adInfo error:nil];
}

///AD展现失败
- (void)tpOfferwallAdShow:(NSDictionary *)adInfo didFailWithError:(NSError *)error
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"showFailed"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.offerwall.unitID adInfo:adInfo error:error];
}

///AD被点击
- (void)tpOfferwallAdClicked:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"clicked"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.offerwall.unitID adInfo:adInfo error:nil];
}

///AD关闭
- (void)tpOfferwallAdDismissed:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"closed"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.offerwall.unitID adInfo:adInfo error:nil];
}

///开始加载流程
- (void)tpOfferwallAdStartLoad:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"startLoad"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.offerwall.unitID adInfo:adInfo error:nil];
}

///当每个广告源开始加载时会都会回调一次。
- (void)tpOfferwallAdOneLayerStartLoad:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"oneLayerStartLoad"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.offerwall.unitID adInfo:adInfo error:nil];
}

///当每个广告源加载成功后会都会回调一次。
- (void)tpOfferwallAdOneLayerLoaded:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"oneLayerLoaded"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.offerwall.unitID adInfo:adInfo error:nil];
}

///当每个广告源加载失败后会都会回调一次，返回三方源的错误信息
- (void)tpOfferwallAdOneLayerLoad:(NSDictionary *)adInfo didFailWithError:(NSError *)error
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"oneLayerLoadedFail"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.offerwall.unitID adInfo:adInfo error:error];
}

///加载流程全部结束
- (void)tpOfferwallAdAllLoaded:(BOOL)success
{
    MSLogTrace(@"%s success:%@", __PRETTY_FUNCTION__, @(success));
    NSString *eventNam = [self eventName:@"allLoaded"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.offerwall.unitID adInfo:nil error:nil exp:@{@"success":@(success)}];
}

- (void)tpOfferwallAdIsLoading:(NSDictionary *)adInfo
{
    MSLogTrace(@"%s adInfo:%@", __PRETTY_FUNCTION__, adInfo);
    NSString *eventNam = [self eventName:@"isLoading"];
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.offerwall.unitID adInfo:adInfo error:nil];
}

///userID 设置完成 error = nil 成功
- (void)tpOfferwallSetUserIdFinish:(NSError *)error
{
    MSLogTrace(@"%s error:%@", __PRETTY_FUNCTION__, error);
    NSString *eventNam = [self eventName:@"setUserIdFinish"];
    bool success = (error == nil);
    [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.offerwall.unitID adInfo:nil error:nil exp:@{@"success":@(success)}];
}

///用户当前积分墙积分数量
- (void)tpOfferwallGetCurrencyBalance:(NSDictionary *)response error:(NSError *)error
{
    MSLogTrace(@"%s error:%@", __PRETTY_FUNCTION__, error);
    if(error == nil)
    {
        NSInteger amount = 0;
        if(response[@"amount"])
        {
            amount = [response[@"amount"] integerValue];
        }
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:response];
        [dic removeObjectForKey:@"amount"];
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
        NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *eventNam = [self eventName:@"currency_success"];
        if(msg == nil)
        {
            msg = @"";
        }
        [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.offerwall.unitID adInfo:nil error:nil exp:@{@"amount":@(amount),@"msg":msg}];
    }
    else
    {
        NSData *data = [NSJSONSerialization dataWithJSONObject:response options:0 error:nil];
        NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *eventNam = [self eventName:@"currency_failed"];
        if(msg == nil)
        {
            msg = @"";
        }
        [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.offerwall.unitID adInfo:nil error:nil exp:@{@"msg":msg}];
    }
}

//扣除用户积分墙积分回调
- (void)tpOfferwallSpendCurrency:(NSDictionary *)response error:(NSError *)error
{
    MSLogTrace(@"%s error:%@", __PRETTY_FUNCTION__, error);
    if(error == nil)
    {
        NSInteger amount = 0;
        if(response[@"amount"])
        {
            amount = [response[@"amount"] integerValue];
        }
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:response];
        [dic removeObjectForKey:@"amount"];
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
        NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *eventNam = [self eventName:@"spend_success"];
        if(msg == nil)
        {
            msg = @"";
        }
        [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.offerwall.unitID adInfo:nil error:nil exp:@{@"amount":@(amount),@"msg":msg}];
    }
    else
    {
        NSData *data = [NSJSONSerialization dataWithJSONObject:response options:0 error:nil];
        NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *eventNam = [self eventName:@"spend_failed"];
        if(msg == nil)
        {
            msg = @"";
        }
        [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.offerwall.unitID adInfo:nil error:nil exp:@{@"msg":msg}];
    }
}

//添加用户积分墙积分回调
- (void)tpOfferwallAwardCurrency:(NSDictionary *)response error:(NSError *)error
{
    MSLogTrace(@"%s error:%@", __PRETTY_FUNCTION__, error);
    if(error == nil)
    {
        NSInteger amount = 0;
        if(response[@"amount"])
        {
            amount = [response[@"amount"] integerValue];
        }
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:response];
        [dic removeObjectForKey:@"amount"];
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
        NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if(msg == nil)
        {
            msg = @"";
        }
        NSString *eventNam = [self eventName:@"award_success"];
        [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.offerwall.unitID adInfo:nil error:nil exp:@{@"amount":@(amount),@"msg":msg}];
    }
    else
    {
        NSData *data = [NSJSONSerialization dataWithJSONObject:response options:0 error:nil];
        NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *eventNam = [self eventName:@"award_failed"];
        if(msg == nil)
        {
            msg = @"";
        }
        [TradplusSdkPlugin callbackWithEventName:eventNam adUnitID:self.offerwall.unitID adInfo:nil error:nil exp:@{@"msg":msg}];
    }
}

@end
