//
//  TPFRewardVideoManager.h
//  tradplus_sdk
//
//  Created by xuejun on 2022/7/19.
//

#import <Flutter/Flutter.h>
#import "TPFRewardVideo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TPFRewardVideoManager : NSObject

+ (TPFRewardVideoManager *)sharedInstance;

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;

- (TPFRewardVideo *)getRewardVideoWithAdUnitID:(NSString *)adUnitID;
@end

NS_ASSUME_NONNULL_END
