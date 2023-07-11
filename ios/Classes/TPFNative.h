//
//  TPFNative.h
//  tradplus_sdk
//
//  Created by xuejun on 2022/7/13.
//

#import <Foundation/Foundation.h>
#import <TradPlusAds/TradPlusAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface TPFNative : NSObject

@property (nonatomic,copy)NSString *adUnitID;
@property (nonatomic,readonly)BOOL isAdReady;

- (void)loadAdWithMaxWaitTime:(NSTimeInterval)maxWaitTime;
- (void)loadAds:(NSInteger)adsCount maxWaitTime:(NSTimeInterval)maxWaitTime;
- (void)openAutoLoadCallback;
- (void)setTemplateRenderSize:(CGSize)size;
- (void)setAdUnitID:(NSString * _Nonnull)adUnitID;
- (void)showWithClassName:(Class)viewClass subview:(UIView *)adView sceneId:(NSString *)sceneId;
- (void)showWithRenderer:(TradPlusNativeRenderer *)renderer subview:(UIView *)adView sceneId:(NSString *)sceneId;
- (TradPlusAdNativeObject *)getReadyNativeObject;
- (void)entryAdScenario:(nullable NSString *)sceneId;
- (void)setCustomMap:(NSDictionary *)dic;
- (void)setLocalParams:(NSDictionary *)dic;
- (void)setCustomAdInfo:(NSDictionary *)customAdInfo;
- (NSInteger)getLoadedCount;
@end

NS_ASSUME_NONNULL_END
