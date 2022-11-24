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
- (void)loadAd;
- (void)setCustomMap:(NSDictionary *)dic;
- (void)showAd;
- (void)showAdWithClassName:(NSString *)className;
- (void)setCustomAdInfo:(NSDictionary *)customAdInfo;
@end

NS_ASSUME_NONNULL_END
