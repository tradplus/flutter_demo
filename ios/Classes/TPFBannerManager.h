//
//  TPFInterstitialManager.h
//  tradplus_sdk
//
//  Created by xuejun on 2022/7/19.
//

#import <Flutter/Flutter.h>
#import "TPFBanner.h"

NS_ASSUME_NONNULL_BEGIN

@interface TPFBannerManager : NSObject

+ (TPFBannerManager *)sharedInstance;

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;

- (TPFBanner *)getBannerWithAdUnitID:(NSString *)adUnitID;
@end

NS_ASSUME_NONNULL_END
