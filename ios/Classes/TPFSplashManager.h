//
//  TPFSplashManager.h
//  tradplus_sdk
//
//  Created by xuejun on 2022/7/19.
//

#import <Flutter/Flutter.h>
#import "TPFSplash.h"

NS_ASSUME_NONNULL_BEGIN

@interface TPFSplashManager : NSObject

+ (TPFSplashManager *)sharedInstance;

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;

- (TPFSplash *)getSplashWithAdUnitID:(NSString *)adUnitID;
@end

NS_ASSUME_NONNULL_END
