//
//  TPFNativeManager.h
//  tradplus_sdk
//
//  Created by xuejun on 2022/7/13.
//

#import <Flutter/Flutter.h>
#import "TPFNative.h"

NS_ASSUME_NONNULL_BEGIN

@interface TPFNativeManager : NSObject

+ (TPFNativeManager *)sharedInstance;

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;

- (TPFNative *)getNativeWithAdUnitID:(NSString *)adUnitID;
@end

NS_ASSUME_NONNULL_END
