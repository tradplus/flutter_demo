//
//  TPFSplash.h
//  tradplus_sdk
//
//  Created by xuejun on 2022/7/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TPFSplash : NSObject

@property (nonatomic,readonly)BOOL isAdReady;

- (void)setAdUnitID:(NSString * _Nonnull)adUnitID;
- (void)loadAdWithMaxWaitTime:(NSTimeInterval)maxWaitTime;
- (void)openAutoLoadCallback;
- (void)setCustomMap:(NSDictionary *)dic;
- (void)setLocalParams:(NSDictionary *)dic;
- (void)showAd;
- (void)showAdWithClassName:(NSString *)className sceneId:(NSString *)sceneId;
- (void)setCustomAdInfo:(NSDictionary *)customAdInfo;
- (void)entryAdScenario:(NSString *)sceneId;
@end

NS_ASSUME_NONNULL_END
