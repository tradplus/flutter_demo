//
//  TPFBanner.h
//  tradplus_sdk
//
//  Created by xuejun on 2022/7/19.
//

#import <Foundation/Foundation.h>
#import <TradPlusAds/TradPlusAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface TPFBanner : NSObject

@property (nonatomic,readonly)BOOL isAdReady;

- (void)setAdUnitID:(NSString * _Nonnull)adUnitID;
- (void)loadAdWithSceneId:(nullable NSString *)sceneId maxWaitTime:(NSTimeInterval)maxWaitTime;
- (void)openAutoLoadCallback;
- (void)setBackgroundColorStr:(NSString *)colorStr;
- (void)setCustomMap:(NSDictionary *)dic;
- (void)setLocalParams:(NSDictionary *)dic;
- (void)entryAdScenario:(nullable NSString *)sceneId;
- (void)setBannerSize:(CGSize)size;
- (void)setBannerContentMode:(NSInteger)mode;
- (void)setCustomAdInfo:(NSDictionary *)customAdInfo;
- (void)showAd;

@property (nonatomic,strong)TradPlusAdBanner *banner;
@end

NS_ASSUME_NONNULL_END
