//
//  TPFInterstitialManager.h
//  tradplus_sdk
//
//  Created by xuejun on 2022/7/19.
//

#import <Flutter/Flutter.h>
#import "TPFInterstitial.h"

NS_ASSUME_NONNULL_BEGIN

@interface TPFInterstitialManager : NSObject

+ (TPFInterstitialManager *)sharedInstance;

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;

- (TPFInterstitial *)getInterstitialWithAdUnitID:(NSString *)adUnitID;
@end

NS_ASSUME_NONNULL_END
