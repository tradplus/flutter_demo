//
//  TPFInterstitial.h
//  tradplus_sdk
//
//  Created by xuejun on 2022/7/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TPFOfferwall : NSObject

@property (nonatomic,readonly)BOOL isAdReady;

- (void)setAdUnitID:(NSString * _Nonnull)adUnitID;
- (void)loadAdWithMaxWaitTime:(NSTimeInterval)maxWaitTime;
- (void)openAutoLoadCallback;
- (void)setCustomMap:(NSDictionary *)dic;
- (void)showAdWithSceneId:(nullable NSString *)sceneId;
- (void)entryAdScenario:(nullable NSString *)sceneId;
- (void)getCurrency;
- (void)spendWithAmount:(int)amount;
- (void)awardWithAmount:(int)amount;
- (void)setUserId:(NSString *)userId;
- (void)setCustomAdInfo:(NSDictionary *)customAdInfo;
- (void)setLocalParams:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
